import type { Cases, CaseKey, CompiledPattern, Dictionary, Lang } from './types';

const EDGES_REGEX = /^(\s*)([\s\S]*?)(\s*)$/;
const TOKEN_REGEX = /\$(\d+)(?:\|(nom|gen|dat|acc|ins|pre))?/g;
const ARTICLE_REGEX = /^(?:the|an|a)\s+/i;
const CACHE_LIMIT = 4000;

let lang: Lang = 'ru';
let nouns: Record<string, Cases> = {};
let fragments: Record<string, string> = {};
let patterns: CompiledPattern[] = [];
let declensions: Record<string, Cases> = {};
let cache = new Map<string, string>();
let loaded = false;

function resetCache(): void {
  cache = new Map();
}

export function setLang(next: Lang): void {
  if (next === lang) return;
  lang = next;
  resetCache();
}

export function getLang(): Lang {
  return lang;
}

export function loadDictionary(data: Dictionary): void {
  nouns = data?.nouns ?? {};
  fragments = data?.fragments ?? {};
  patterns = [];

  for (const entry of data?.patterns ?? []) {
    try {
      patterns.push({ re: new RegExp(entry.re), ru: entry.ru });
    } catch {
      // One malformed pattern must not take the whole dictionary down with it.
    }
  }

  loaded = true;
  resetCache();
}

export function loadDeclensions(payload: Record<string, Cases>): void {
  for (const name in payload) {
    declensions[name] = payload[name];
  }
  resetCache();
}

export function resetDeclensions(): void {
  declensions = {};
  resetCache();
}

export function isActive(): boolean {
  return loaded && lang === 'ru';
}

function lookup(value: string): Cases | undefined {
  return nouns[value] ?? declensions[value];
}

function decline(value: string, caseKey: CaseKey): string {
  // DM writes items both bare and through \a / \the, so the same sword arrives
  // as "sword", "a sword" or "the sword". Russian has no articles either way.
  let entry = lookup(value);
  if (!entry) {
    const bare = value.replace(ARTICLE_REGEX, '');
    if (bare !== value) {
      entry = lookup(bare);
    }
    if (!entry) {
      const lowered = bare.charAt(0).toLowerCase() + bare.slice(1);
      entry = lookup(lowered);
    }
  }
  if (!entry) {
    return value;
  }
  return entry[caseKey] ?? value;
}

function expand(template: string, match: RegExpMatchArray): string {
  return template.replace(
    TOKEN_REGEX,
    (whole, index: string, caseKey?: string) => {
      const captured = match[Number(index)];
      if (captured === undefined) {
        return whole;
      }
      if (!caseKey) {
        return captured;
      }
      return decline(captured, caseKey as CaseKey);
    },
  );
}

function translateCore(core: string): string | null {
  const exact = fragments[core];
  if (exact !== undefined) {
    return exact;
  }

  for (const pattern of patterns) {
    const match = core.match(pattern.re);
    if (match) {
      return expand(pattern.ru, match);
    }
  }

  return null;
}

export function translateText(text: string): string {
  if (!isActive() || !text.trim()) {
    return text;
  }

  const hit = cache.get(text);
  if (hit !== undefined) {
    return hit;
  }

  // Attack lines are assembled from fragments that carry their own padding, so
  // the edges are held back and the dictionary only ever sees trimmed text.
  const edges = text.match(EDGES_REGEX);
  const before = edges ? edges[1] : '';
  const core = edges ? edges[2] : text;
  const after = edges ? edges[3] : '';

  const translated = translateCore(core);
  const result = translated === null ? text : before + translated + after;

  if (cache.size >= CACHE_LIMIT) {
    resetCache();
  }
  cache.set(text, result);

  return result;
}

export function translateNode(node: Node): void {
  if (!isActive()) {
    return;
  }

  const children = node.childNodes;
  for (let i = 0; i < children.length; i++) {
    const child = children[i];
    if (child.nodeType === Node.TEXT_NODE) {
      const text = child.textContent;
      if (!text) continue;
      const translated = translateText(text);
      if (translated !== text) {
        child.textContent = translated;
      }
    } else {
      translateNode(child);
    }
  }
}
