import fs from 'node:fs';
import path from 'node:path';
import { spawnSync } from 'node:child_process';

type MapSourceConfig = {
  repository?: string;
  ref?: string;
  path?: string;
  url: string;
};

type ExtraMapConfig = {
  name?: string;
  source: MapSourceConfig;
  output: {
    path: string;
  };
};

type DunWorldMapConfig = {
  source: MapSourceConfig;
  output?: {
    path?: string;
  };
  extra_maps?: ExtraMapConfig[];
  replacements?: Record<string, string>;
};

export const DUN_WORLD_GENERATED_MAP =
  '_maps/map_files/dun_world/dun_world_new.dmm';

const CONFIG_PATH = 'modular_abel/dun_world/config/map.json';
const DOWNLOAD_TIMEOUT_MS = 120000;

const REMOVED_VAR_PATTERNS = [
  /^(?:broadcaster_tag|gid|keycontrol|location_tag|mailtag|scom_tag|specific_location)\s*=\s*".*"$/,
  /^(?:lockdifficulty|lock_strength|mammonsiphoned|obj_integrity|order)\s*=\s*-?\d+(?:\.\d+)?$/,
  /^(?:keylock|masterkey|smooth)\s*=\s*[01]$/,
];

const TURF_REMOVED_VAR_PATTERN = /^(?:icon|icon_state)\s*=/;

const CLOSED_TURF_REMOVED_PATHS = [
  '/obj/structure/door',
  '/obj/structure/stairs',
  '/obj/structure/window',
];

// CLASS FIX: Azure's dun_world bakes roaming hostile creatures (foxes, draggers, wolves,
// trolls, haunts, ...) across the whole map. Loaded as Vanderlin's live map they wander out
// and swarm the town/surface for no apparent reason. Vanderlin's surface danger is meant to
// come from the runtime ambush/event systems, not baked-in mobs. So during generation, drop
// EVERY placed roaming hostile (path-prefix match, so all current/future types are covered)
// from any tile whose area is NOT part of the underground dungeon network. Bosses are kept
// (intended set-piece encounters), and the dungeon stays populated. Paths here are
// post-replacement (Vanderlin) paths, since path replacement runs before this pass.
const ROAMING_HOSTILE_PREFIX = '/mob/living/simple_animal/hostile/';
const ROAMING_HOSTILE_KEEP_PREFIX = '/mob/living/simple_animal/hostile/boss/';
const MONSTER_AREA_PATTERN = /\/(?:under|cave)(?:\/|$)/;

export async function prepareDunWorldMap() {
  const config = readConfig();
  const replacements = config.replacements || {};
  validateReplacementTargets(replacements);
  await generateMap({
    name: 'Twilight Axis',
    source: config.source,
    outputPath: config.output?.path || DUN_WORLD_GENERATED_MAP,
    replacements,
  });

  for (const extraMap of config.extra_maps || []) {
    await generateMap({
      name: extraMap.name || extraMap.output.path,
      source: extraMap.source,
      outputPath: extraMap.output.path,
      replacements,
    });
  }
}

function readConfig(): DunWorldMapConfig {
  const configText = fs.readFileSync(CONFIG_PATH, 'utf-8');
  const config = JSON.parse(configText) as DunWorldMapConfig;

  if (!config.source?.url) {
    throw new Error(`${CONFIG_PATH} must define source.url`);
  }
  for (const extraMap of config.extra_maps || []) {
    if (!extraMap.source?.url) {
      throw new Error(`${CONFIG_PATH} extra_maps entries must define source.url`);
    }
    if (!extraMap.output?.path) {
      throw new Error(
        `${CONFIG_PATH} extra_maps entries must define output.path`,
      );
    }
  }

  return config;
}

async function generateMap(options: {
  name: string;
  source: MapSourceConfig;
  outputPath: string;
  replacements: Record<string, string>;
}) {
  const sourceText = await loadSourceText(options.source, options.name);
  const structurallyAdjustedText =
    applySourcePathStructuralAdjustments(sourceText);
  const explicit = applyPathReplacements(
    structurallyAdjustedText,
    options.replacements,
  );
  const subtype = applySubtypeReplacements(explicit.text, options.replacements);
  const replacementCount =
    explicit.replacementCount + subtype.replacementCount;
  const configuredReplacementCount = explicit.configuredReplacementCount;
  const adjustedText = applyDmmVarAdjustments(subtype.text);

  validateMapPaths(adjustedText, options.name);

  fs.mkdirSync(path.dirname(options.outputPath), { recursive: true });
  const temporaryOutputPath = `${options.outputPath}.tmp`;
  fs.writeFileSync(temporaryOutputPath, adjustedText);
  fs.renameSync(temporaryOutputPath, options.outputPath);

  if (configuredReplacementCount === 0) {
    console.log(
      `modular_abel: no ${options.name} path replacements configured yet; generated map is currently a raw copy.`,
    );
    return;
  }

  const subtypeNote = subtype.replacementCount
    ? ` (${subtype.replacementCount} resolved as subtypes of a mapped parent)`
    : '';
  console.log(
    `modular_abel: generated ${options.outputPath} with ${replacementCount} path replacements${subtypeNote}.`,
  );
}

async function loadSourceText(
  source: MapSourceConfig,
  mapName: string,
): Promise<string> {
  console.log(`modular_abel: downloading ${mapName} source map from ${source.url}.`);
  return downloadText(source.url);
}

async function downloadText(url: string): Promise<string> {
  const controller = new AbortController();
  const timeout = setTimeout(() => controller.abort(), DOWNLOAD_TIMEOUT_MS);

  try {
    const response = await fetch(url, { signal: controller.signal });
    if (!response.ok) {
      throw new Error(`Failed to download ${url}: HTTP ${response.status}`);
    }
    return await response.text();
  } catch (error) {
    console.log(
      `modular_abel: Bun download failed (${String(error)}); retrying the same URL with curl.`,
    );
    return downloadTextWithCurl(url);
  } finally {
    clearTimeout(timeout);
  }
}

function downloadTextWithCurl(url: string): string {
  const downloadDirectory = 'tmp/modular_abel';
  const downloadPath = path.join(downloadDirectory, path.basename(url));

  fs.mkdirSync(downloadDirectory, { recursive: true });

  const result = spawnSync(
    process.platform === 'win32' ? 'curl.exe' : 'curl',
    ['-L', '--fail', '--silent', '--show-error', '--output', downloadPath, url],
    { encoding: 'utf-8' },
  );

  if (result.status !== 0) {
    throw new Error(
      `curl failed to download ${url}: ${result.stderr || result.stdout}`,
    );
  }

  return fs.readFileSync(downloadPath, 'utf-8');
}

function applyPathReplacements(
  sourceText: string,
  replacements: Record<string, string>,
) {
  const entries = sortedReplacementEntries(replacements);

  let text = sourceText;
  let replacementCount = 0;

  for (const [from, to] of entries) {
    const pattern = new RegExp(`${escapeRegExp(from)}(?![A-Za-z0-9_/])`, 'g');
    const occurrences = countPatternOccurrences(text, pattern);
    if (occurrences === 0) {
      continue;
    }
    replacementCount += occurrences;
    text = text.replace(pattern, to);
  }

  return {
    text,
    replacementCount,
    configuredReplacementCount: entries.length,
  };
}

function sortedReplacementEntries(replacements: Record<string, string>) {
  return Object.entries(replacements)
    .filter(([from, to]) => from.length > 0 && to.length > 0)
    .sort(([left], [right]) => right.length - left.length);
}

function validateReplacementTargets(replacements: Record<string, string>) {
  const declared = declaredTypePaths();
  const stale = sortedReplacementEntries(replacements)
    .filter(([, to]) => !declared.has(to))
    .map(([from, to]) => `${from} -> ${to}`)
    .sort();

  if (stale.length === 0) {
    return;
  }

  console.warn(
    `modular_abel: WARNING - ${CONFIG_PATH} has ${stale.length} replacement(s) pointing at a type that no longer exists. Upstream most likely renamed or deleted it, so the mapped content will not spawn. Retarget them at a current type or port the missing one into modular_abel:\n  ${stale.join('\n  ')}`,
  );
}

function applySubtypeReplacements(
  sourceText: string,
  replacements: Record<string, string>,
) {
  const declared = declaredTypePaths();
  const entries = sortedReplacementEntries(replacements);
  const resolved = new Map<string, string | null>();

  const resolvePath = (sourcePath: string): string | null => {
    const cached = resolved.get(sourcePath);
    if (cached !== undefined) {
      return cached;
    }

    let result: string | null = null;
    if (!declared.has(sourcePath)) {
      for (const [from, to] of entries) {
        if (!sourcePath.startsWith(`${from}/`)) {
          continue;
        }
        const candidate = `${to}${sourcePath.slice(from.length)}`;
        if (declared.has(candidate)) {
          result = candidate;
          break;
        }
      }
    }

    resolved.set(sourcePath, result);
    return result;
  };

  let replacementCount = 0;
  const text = sourceText
    .split(/\r?\n/)
    .map((line) => {
      const match = line.match(/^(\/[A-Za-z0-9_/]+)[,{)]/);
      if (!match) {
        return line;
      }
      const replacement = resolvePath(match[1]);
      if (!replacement) {
        return line;
      }
      replacementCount += 1;
      return `${replacement}${line.slice(match[1].length)}`;
    })
    .join('\n');

  return { text, replacementCount };
}

function applySourcePathStructuralAdjustments(sourceText: string): string {
  const directionalPaths: Record<string, { basePath: string; dir: number }> = {
    '/obj/structure/fluff/railing/border/north': {
      basePath: '/obj/structure/fluff/railing/border',
      dir: 1,
    },
    '/obj/structure/fluff/railing/border/east': {
      basePath: '/obj/structure/fluff/railing/border',
      dir: 4,
    },
    '/obj/structure/fluff/railing/border/west': {
      basePath: '/obj/structure/fluff/railing/border',
      dir: 8,
    },
    '/obj/structure/fluff/railing/corner': {
      basePath: '/obj/structure/fluff/railing/corner/dun_world',
      dir: 9,
    },
    '/obj/structure/fluff/railing/corner/north_east': {
      basePath: '/obj/structure/fluff/railing/corner/dun_world',
      dir: 5,
    },
    '/obj/structure/fluff/railing/corner/south_east': {
      basePath: '/obj/structure/fluff/railing/corner/dun_world',
      dir: 6,
    },
    '/obj/structure/fluff/railing/corner/south_west': {
      basePath: '/obj/structure/fluff/railing/corner/dun_world',
      dir: 10,
    },
    '/obj/structure/fluff/railing/wood/north': {
      basePath: '/obj/structure/fluff/railing/wood',
      dir: 1,
    },
    '/obj/structure/fluff/railing/wood/east': {
      basePath: '/obj/structure/fluff/railing/wood',
      dir: 4,
    },
    '/obj/structure/fluff/railing/wood/west': {
      basePath: '/obj/structure/fluff/railing/wood',
      dir: 8,
    },
    '/turf/closed/wall/mineral/rogue/decostone/end/north': {
      basePath: '/turf/closed/wall/mineral/rogue/decostone/end',
      dir: 1,
    },
    '/turf/closed/wall/mineral/rogue/decostone/end/east': {
      basePath: '/turf/closed/wall/mineral/rogue/decostone/end',
      dir: 4,
    },
    '/turf/closed/wall/mineral/rogue/decostone/end/west': {
      basePath: '/turf/closed/wall/mineral/rogue/decostone/end',
      dir: 8,
    },
    '/turf/closed/wall/mineral/rogue/decostone/long/east_west': {
      basePath: '/turf/closed/wall/mineral/rogue/decostone/long',
      dir: 1,
    },
    '/turf/closed/wall/mineral/rogue/wooddark/end/north': {
      basePath: '/turf/closed/wall/mineral/rogue/wooddark/end',
      dir: 1,
    },
    '/turf/closed/wall/mineral/rogue/wooddark/end/east': {
      basePath: '/turf/closed/wall/mineral/rogue/wooddark/end',
      dir: 4,
    },
    '/turf/closed/wall/mineral/rogue/wooddark/end/west': {
      basePath: '/turf/closed/wall/mineral/rogue/wooddark/end',
      dir: 8,
    },
  };

  const adjustedText = sourceText
    .split(/\r?\n/)
    .flatMap((line) => {
      const match = line.match(/^(\s*)(\/[\w/]+)([,{])$/);
      if (!match) {
        return line;
      }

      const [, indent, sourcePath, terminator] = match;
      const adjustment = directionalPaths[sourcePath];
      if (!adjustment) {
        return line;
      }

      if (terminator === '{') {
        return [
          `${indent}${adjustment.basePath}{`,
          `${indent}\tdir = ${adjustment.dir};`,
        ];
      }

      return [
        `${indent}${adjustment.basePath}{`,
        `${indent}\tdir = ${adjustment.dir}`,
        `${indent}\t},`,
      ];
    })
    .join('\n');

  return injectRequiredMapItems(adjustedText);
}

// Vanderlin's required_map_items unit test demands one each of the economy
// stockpile structures on every non-exempt map; Azure's source map has no
// equivalent, so place them on the (unique, station-level) titan tile.
function injectRequiredMapItems(text: string): string {
  const requiredItems = [
    '/obj/structure/stockpile_storage',
    '/obj/structure/stockpile_storage/food',
    '/obj/structure/stockpile_storage/metal',
  ]
    .map((path) => `${path}{\n\tstorage_id = "dun_world_inert"\n\t},`)
    .join('\n');

  return text.replace(
    /(\/obj\/structure\/roguemachine\/titan\{[^}]*\},)/,
    `$1\n${requiredItems}`,
  );
}

type PopEntry = {
  path: string;
  vars: string[][];
};

function applyDmmVarAdjustments(sourceText: string): string {
  const lines = sourceText.split(/\r?\n/);
  const output: string[] = [];
  let index = 0;

  while (index < lines.length) {
    const line = lines[index];
    if (!/^"[^"]*" = \($/.test(line)) {
      output.push(line);
      index += 1;
      continue;
    }

    const [entries, nextIndex] = parsePopEntries(lines, index + 1);
    index = nextIndex;
    output.push(line, ...emitPopEntries(adjustPopEntries(entries)));
  }

  return output.join('\n');
}

function parsePopEntries(
  lines: string[],
  startIndex: number,
): [PopEntry[], number] {
  const entries: PopEntry[] = [];
  let index = startIndex;
  let popClosed = false;

  while (!popClosed) {
    const entryLine = lines[index];
    if (entryLine === undefined) {
      throw new Error('Unterminated prototype pop in source map.');
    }
    index += 1;

    if (entryLine.endsWith('{')) {
      const entry: PopEntry = { path: entryLine.slice(0, -1), vars: [] };
      while (true) {
        const varLine = lines[index];
        if (varLine === undefined) {
          throw new Error(`Unterminated var block for ${entry.path}.`);
        }
        index += 1;

        const blockClose = varLine.match(/^\s*\}([,)])$/);
        if (blockClose) {
          popClosed = blockClose[1] === ')';
          break;
        }

        const varLines = [varLine];
        while (isInsideMultilineString(varLines)) {
          const continuation = lines[index];
          if (continuation === undefined) {
            throw new Error(`Unterminated multiline string for ${entry.path}.`);
          }
          index += 1;
          varLines.push(continuation);
        }

        const lastLine = varLines[varLines.length - 1];
        varLines[varLines.length - 1] = lastLine.replace(/;$/, '');
        entry.vars.push(varLines);
      }
      entries.push(entry);
    } else {
      popClosed = entryLine.endsWith(')');
      entries.push({ path: entryLine.slice(0, -1), vars: [] });
    }
  }

  return [entries, index];
}

function isInsideMultilineString(varLines: string[]): boolean {
  const text = varLines.join('\n');
  const opens = text.split('{"').length - 1;
  const closes = text.split('"}').length - 1;
  return opens > closes;
}

function normalizeDunWorldLockid(lockid: string): string {
  if (/^manor_knight/.test(lockid) || /^guest_knight/.test(lockid) || lockid === 'knight') return 'at_arms';
  if (/^squire_room/.test(lockid)) return 'at_arms';
  if (lockid === 'captain_bedroom' || lockid === 'sergeant' || lockid === 'armory') return 'garrison';
  if (/^manor_councillor/.test(lockid) || /^servant_room/.test(lockid)) return 'manor';
  if (lockid === 'heir' || lockid === 'heir1' || lockid === 'heir2' || lockid === 'royal' || lockid === 'baroness') return 'manor';
  if (/^church_bedroom/.test(lockid) || lockid === 'zhurch') return 'church';
  if (/^merc_bunk/.test(lockid) || lockid === 'merc') return 'mercenary';
  if (lockid === 'bath1' || lockid === 'bath2' || lockid === 'bath3') return 'bathhouse';
  if (lockid === 'crafterguild' || lockid === 'craftermaster' || lockid === 'townie_smith_extra') return 'artificer';
  if (lockid === 'towner_blacksmith') return 'blacksmith';
  if (/^stable_master/.test(lockid) || lockid === 'stablemaster' || lockid === 'keeper' || lockid === 'keeper2' || lockid === 'farm') return 'soilson';
  if (/^stall/.test(lockid) || lockid === 'shop') return 'merchant';
  if (lockid === 'warden') return 'dungeon';
  if (/^room/.test(lockid) || /^fancy/.test(lockid) || /^locker/.test(lockid)) return 'tavern';
  return lockid;
}

function isDunWorldBedroomLockid(lockid: string): boolean {
  if (/^manor_knight/.test(lockid)) return true;
  if (/^guest_knight/.test(lockid)) return true;
  if (/^squire_room/.test(lockid)) return true;
  if (/^manor_councillor/.test(lockid)) return true;
  if (/^servant_room/.test(lockid)) return true;
  if (/^church_bedroom/.test(lockid)) return true;
  if (/^merc_bunk/.test(lockid)) return true;
  if (/^stable_master/.test(lockid)) return true;
  if (/^room/.test(lockid) || /^fancy/.test(lockid) || /^locker/.test(lockid)) return true;
  return [
    'captain_bedroom',
    'stablemaster',
    'keeper',
    'keeper2',
    'heir',
    'heir1',
    'heir2',
    'royal',
    'baroness',
  ].includes(lockid);
}

function extractLockid(varText: string): string | null {
  const quoted = varText.match(/^lockid\s*=\s*"([^"]+)"$/);
  if (quoted) return quoted[1];
  const listed = varText.match(/^lockid\s*=\s*list\(\s*"([^"]+)"\s*\)$/);
  if (listed) return listed[1];
  return null;
}

function adjustPopEntries(entries: PopEntry[]): PopEntry[] {
  const hasClosedTurf = entries.some(
    (entry) =>
      entry.path === '/turf/closed' || entry.path.startsWith('/turf/closed/'),
  );

  const areaEntry = entries.find((entry) => entry.path.startsWith('/area/'));
  const isMonsterArea = areaEntry
    ? MONSTER_AREA_PATTERN.test(areaEntry.path)
    : false;

  const adjusted: PopEntry[] = [];
  const seenContraptions = new Set<string>();
  for (const entry of entries) {
    if (
      hasClosedTurf &&
      CLOSED_TURF_REMOVED_PATHS.some(
        (banned) =>
          entry.path === banned || entry.path.startsWith(`${banned}/`),
      )
    ) {
      continue;
    }

    if (
      !isMonsterArea &&
      entry.path.startsWith(ROAMING_HOSTILE_PREFIX) &&
      !entry.path.startsWith(ROAMING_HOSTILE_KEEP_PREFIX)
    ) {
      continue;
    }

    // rotation_contraption/Initialize() stacks same-type pieces sharing a tile,
    // qdel'ing the extras before their Initialize runs; Azure stacks many per
    // tile, which trips the create_and_destroy unit test. The stack merges to a
    // single sprite anyway, so keep one of each exact type per tile.
    if (entry.path.startsWith('/obj/item/rotation_contraption')) {
      if (seenContraptions.has(entry.path)) {
        continue;
      }
      seenContraptions.add(entry.path);
    }

    const isTurf = entry.path.startsWith('/turf/');
    const isDoor = entry.path.startsWith('/obj/structure/door');
    const isDeadbolt =
      entry.path.includes('deadbolt') || entry.path.includes('/weak/bolt');

    let lockidValue: string | null = null;
    for (const varLines of entry.vars) {
      const lid = extractLockid(varLines[0].trim());
      if (lid && !(isDoor && isDunWorldBedroomLockid(lid))) {
        lockidValue = lid;
        break;
      }
    }

    const vars = entry.vars.flatMap((varLines) => {
      const varText = varLines[0].trim();

      const lid = extractLockid(varText);
      if (lid !== null) {
        if (isDeadbolt) {
          return [];
        }
        if (isDoor && isDunWorldBedroomLockid(lid)) {
          return [];
        }
        return [[`\tlockids = list("${normalizeDunWorldLockid(lid)}")`]];
      }

      const lockedMatch = varText.match(/^locked\s*=\s*([01])$/);
      if (lockedMatch) {
        if (lockedMatch[1] !== '1') {
          return [];
        }
        if (isDeadbolt) {
          return [];
        }
        const lockPath =
          isDoor && !lockidValue
            ? '/datum/lock/locked'
            : '/datum/lock/key/locked';
        return [[`\tlock = ${lockPath}`]];
      }

      if (REMOVED_VAR_PATTERNS.some((pattern) => pattern.test(varText))) {
        return [];
      }

      if (isTurf && TURF_REMOVED_VAR_PATTERN.test(varText)) {
        return [];
      }

      return [varLines];
    });

    adjusted.push({ path: entry.path, vars });
  }

  return adjusted;
}

function emitPopEntries(entries: PopEntry[]): string[] {
  const lines: string[] = [];

  entries.forEach((entry, entryIndex) => {
    const terminator = entryIndex === entries.length - 1 ? ')' : ',';

    if (entry.vars.length === 0) {
      lines.push(`${entry.path}${terminator}`);
      return;
    }

    lines.push(`${entry.path}{`);
    entry.vars.forEach((varLines, varIndex) => {
      const emitted = [...varLines];
      if (varIndex < entry.vars.length - 1) {
        emitted[emitted.length - 1] = `${emitted[emitted.length - 1]};`;
      }
      lines.push(...emitted);
    });
    lines.push(`\t}${terminator}`);
  });

  return lines;
}

let declaredTypePathsCache: Set<string> | null = null;

function declaredTypePaths(): Set<string> {
  if (declaredTypePathsCache) {
    return declaredTypePathsCache;
  }
  const declared = new Set<string>();
  const roots = ['code', 'modular_abel'];
  for (const root of roots) {
    if (!fs.existsSync(root)) {
      throw new Error(
        `type scanner can't find ./${root} - run this script from the repository root, not from ${process.cwd()}.`,
      );
    }
  }
  const walk = (dir: string) => {
    for (const entry of fs.readdirSync(dir, { withFileTypes: true })) {
      const fullPath = path.join(dir, entry.name);
      if (entry.isDirectory()) {
        walk(fullPath);
      } else if (entry.name.endsWith('.dm')) {
        const content = fs.readFileSync(fullPath, 'utf-8');
        for (const match of content.matchAll(/^(\/[A-Za-z0-9_/]+)/gm)) {
          const parts = match[1].split('/');
          for (let i = 2; i <= parts.length; i++) {
            declared.add(parts.slice(0, i).join('/'));
          }
        }
      }
    }
  };
  for (const root of roots) {
    walk(root);
  }
  if (declared.size < 10000) {
    throw new Error(
      `type scanner only found ${declared.size} declared type paths (expected ~55000) - the scanner is broken, not the map.`,
    );
  }
  declaredTypePathsCache = declared;
  return declared;
}

function validateMapPaths(mapText: string, mapName: string) {
  const declared = declaredTypePaths();
  const missing = new Set<string>();
  for (const line of mapText.split('\n')) {
    if (line.startsWith('(')) {
      break; // model section over, grid data begins
    }
    const match = line.match(/^(\/[A-Za-z0-9_/]+)[,{)]/);
    if (match && !declared.has(match[1])) {
      missing.add(match[1]);
    }
  }
  if (missing.size === 0) {
    return;
  }
  const fatal = [...missing].filter(
    (p) => p.startsWith('/area/') || p.startsWith('/turf/'),
  );
  const dropped = [...missing].filter((p) => !fatal.includes(p));
  if (dropped.length > 0) {
    console.warn(
      `modular_abel: WARNING - ${mapName} uses ${dropped.length} object path(s) missing from the compile (content will silently not spawn):\n  ${dropped.join('\n  ')}`,
    );
  }
  if (fatal.length > 0) {
    throw new Error(
      `${mapName} uses area/turf path(s) missing from the compile - this corrupts every tile using them ("bad loc" runtimes + missing turfs). Port these types (see modular_abel/dun_world/areas.dm) or fix the replacement table:\n  ${fatal.join('\n  ')}`,
    );
  }
}

function countPatternOccurrences(text: string, pattern: RegExp): number {
  let count = 0;

  for (const _match of text.matchAll(pattern)) {
    count += 1;
  }

  return count;
}

function escapeRegExp(text: string): string {
  return text.replace(/[.*+?^${}()|[\]\\]/g, '\\$&');
}

if (import.meta.main) {
  try {
    await prepareDunWorldMap();
  } catch (error) {
    const reason = error instanceof Error ? error.message : String(error);
    console.error('');
    console.error('============================================================');
    console.error(' MAP GENERATION FAILED - the generated .dmm was NOT updated');
    console.error('============================================================');
    console.error(reason);
    console.error('============================================================');
    process.exit(1);
  }
}
