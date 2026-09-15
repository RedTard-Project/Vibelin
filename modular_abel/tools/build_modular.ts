import fs from 'node:fs';
import path from 'node:path';
import { DreamDaemon, DreamMaker } from '../../tools/build/lib/byond';
import {
  MODULAR_RUNTIME_CONFIG_DIR,
  prepareRuntimeConfig,
} from './runtime_config.ts';

const UPSTREAM_DME = 'vanderlin.dme';
const MODULAR_DME = 'vanderlin.modular_abel.dme';
const MODULAR_DMB = 'vanderlin.modular_abel.dmb';
const MODULAR_RSC = 'vanderlin.modular_abel.rsc';
const FINAL_DMB = 'vanderlin.dmb';
const FINAL_RSC = 'vanderlin.rsc';
const END_INCLUDE = '// END_INCLUDE';

type BuildOptions = {
  target: string;
  defines: string[];
  dmVersion: string | null;
  warningsAsErrors: boolean;
  ignoreWarningCodes: string[];
  port: string;
  rawArgs: string[];
  parameterArgs: string[];
};

async function main() {
  const options = parseArgs(process.argv.slice(2));

  switch (options.target) {
    case 'dm':
      await compileModularDme(options);
      prepareRuntimeConfig();
      logCompleted(options.target);
      return;
    case 'build':
      await runUpstreamTarget('tgui', options.parameterArgs);
      await compileModularDme(options);
      prepareRuntimeConfig();
      logCompleted(options.target);
      return;
    case 'server':
      await runUpstreamTarget('tgui', options.parameterArgs);
      await compileModularDme(options);
      prepareRuntimeConfig();
      console.log('modular_abel: build completed successfully; starting DreamDaemon.');
      await DreamDaemon(
        {
          dmbFile: FINAL_DMB,
          namedDmVersion: options.dmVersion,
        },
        options.port,
        '-trusted',
        '-params',
        `config-directory=${MODULAR_RUNTIME_CONFIG_DIR}`,
      );
      logCompleted(options.target);
      return;
    case 'tgs':
      await prepareTgsBuild(options);
      logCompleted(options.target);
      return;
    case 'clean':
    case 'clean-all':
      cleanupModularArtifacts();
      await runUpstreamTarget(options.target);
      logCompleted(options.target);
      return;
    default:
      console.warn(
        `modular_abel: target "${options.target}" is passed through to upstream build without modular DME injection.`,
      );
      await runUpstreamBuild(options.rawArgs);
      logCompleted(options.target);
      return;
  }
}

function logCompleted(target: string) {
  console.log(`modular_abel: target "${target}" completed successfully.`);
}

function parseArgs(args: string[]): BuildOptions {
  let target = 'build';
  let targetSet = false;
  const defines: string[] = [];
  const ignoreWarningCodes: string[] = ['unused_var'];
  let dmVersion: string | null = null;
  let warningsAsErrors = false;
  let port = '1337';
  let targetIndex: number | null = null;

  for (let i = 0; i < args.length; i++) {
    const arg = args[i];
    const next = () => {
      const value = args[++i];
      if (!value) {
        throw new Error(`Missing value for ${arg}`);
      }
      return value;
    };

    if (arg === '--define' || arg === '-D') {
      defines.push(next());
    } else if (arg.startsWith('-D') && arg.length > 2) {
      defines.push(arg.slice(2));
    } else if (arg === '--dm-version') {
      dmVersion = next();
    } else if (arg === '--warning' || arg === '-W') {
      warningsAsErrors ||= next() === 'error';
    } else if (arg.startsWith('-W') && arg.length > 2) {
      warningsAsErrors ||= arg.slice(2) === 'error';
    } else if (arg === '--no-warning' || arg === '-I') {
      ignoreWarningCodes.push(next());
    } else if (arg.startsWith('-I') && arg.length > 2) {
      ignoreWarningCodes.push(arg.slice(2));
    } else if (arg === '--port' || arg === '-p') {
      port = next();
    } else if (!arg.startsWith('-') && !targetSet) {
      target = arg;
      targetSet = true;
      targetIndex = i;
    }
  }

  const parameterArgs =
    targetIndex === null
      ? args
      : args.filter((_, index) => index !== targetIndex);

  return {
    target,
    defines,
    dmVersion,
    warningsAsErrors,
    ignoreWarningCodes,
    port,
    rawArgs: args,
    parameterArgs,
  };
}

async function compileModularDme(options: BuildOptions) {
  if (options.defines.includes('ALL_MAPS')) {
    writeTemplatesInclude();
  }

  writeModularDme();
  try {
    await DreamMaker(MODULAR_DME, {
      defines: ['CBT', ...options.defines],
      warningsAsErrors: options.warningsAsErrors,
      ignoreWarningCodes: options.ignoreWarningCodes,
      namedDmVersion: options.dmVersion,
    });
    fs.copyFileSync(MODULAR_DMB, FINAL_DMB);
    fs.copyFileSync(MODULAR_RSC, FINAL_RSC);
  } finally {
    removeIfExists(MODULAR_DME);
    removeIfExists(MODULAR_DMB);
    removeIfExists(MODULAR_RSC);
  }
}

function writeModularDme() {
  const dme = fs.readFileSync(UPSTREAM_DME, 'utf-8');
  fs.writeFileSync(MODULAR_DME, withModularIncludes(dme));
}

async function prepareTgsBuild(options: BuildOptions) {
  if (process.env.CBT_BUILD_MODE !== 'TGS') {
    throw new Error(
      'The tgs target mutates the disposable TGS checkout and requires CBT_BUILD_MODE=TGS.',
    );
  }

  await runUpstreamBuild(options.parameterArgs);
  writeModularDmeInPlace();
  prepareRuntimeConfig({
    outputDir: 'config',
    allowInPlace: true,
  });
}

function writeModularDmeInPlace() {
  const dme = fs.readFileSync(UPSTREAM_DME, 'utf-8');
  fs.writeFileSync(UPSTREAM_DME, withModularIncludes(dme));
}

function withModularIncludes(dme: string): string {
  const includeLines = ['#include "modular_abel\\_module.dm"'];
  const missingLines = includeLines.filter((line) => !dme.includes(line));
  if (missingLines.length === 0) {
    return dme;
  }

  if (!dme.includes(END_INCLUDE)) {
    throw new Error(`${UPSTREAM_DME} does not contain ${END_INCLUDE}`);
  }

  return dme.replace(END_INCLUDE, [...missingLines, END_INCLUDE].join('\n'));
}

function writeTemplatesInclude() {
  const folders = [
    ...findDmmFiles('_maps/kalypso'),
    ...findDmmFiles('_maps/matthios_tomb'),
    ...findDmmFiles('_maps/templates'),
  ];
  const content = `${folders
    .map((file) => file.replace(/\\/g, '/').replace('_maps/', ''))
    .map((file) => `#include "${file}"`)
    .join('\n')}\n`;

  fs.writeFileSync('_maps/templates.dm', content);
}

function findDmmFiles(root: string): string[] {
  if (!fs.existsSync(root)) {
    return [];
  }

  const files: string[] = [];
  const pending = [root];

  while (pending.length > 0) {
    const current = pending.pop();
    if (!current) {
      continue;
    }

    for (const entry of fs.readdirSync(current, { withFileTypes: true })) {
      const fullPath = path.join(current, entry.name);
      if (entry.isDirectory()) {
        pending.push(fullPath);
      } else if (entry.isFile() && entry.name.endsWith('.dmm')) {
        files.push(fullPath);
      }
    }
  }

  return files.sort();
}

async function runUpstreamTarget(target: string, args: string[] = []) {
  await runUpstreamBuild([target, ...args]);
}

async function runUpstreamBuild(args: string[]) {
  const command =
    process.platform === 'win32'
      ? ['cmd.exe', '/c', 'tools\\build\\build.bat', ...args]
      : ['sh', 'tools/build/build.sh', ...args];
  const proc = Bun.spawn(command, {
    stdin: 'inherit',
    stdout: 'inherit',
    stderr: 'inherit',
  });
  const code = await proc.exited;
  if (code !== 0) {
    throw new Error(`upstream build exited with code ${code}`);
  }
}

function cleanupModularArtifacts() {
  removeIfExists(MODULAR_DME);
  removeIfExists(MODULAR_DMB);
  removeIfExists(MODULAR_RSC);
}

function removeIfExists(filePath: string) {
  try {
    fs.unlinkSync(filePath);
  } catch (error) {
    if (!error || typeof error !== 'object' || !('code' in error)) {
      throw error;
    }
    if (error.code !== 'ENOENT') {
      throw error;
    }
  }
}

if (import.meta.main) {
  try {
    await main();
  } catch (error) {
    console.error(error);
    process.exit(1);
  }
}
