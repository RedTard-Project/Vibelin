# modular_abel

This module owns the Twilight Axis map import pipeline and the ERP/character menu
content from PR #1. `modular_abel/_module.dm` is the single module entry point
included from `vanderlin.dme`; it pulls in `erp/_erp.dm` (ERP system) and the
Twilight Axis support files.

Layout:

- `_module.dm` — single entry point: includes `erp/_erp.dm` (ERP system),
  `dun_world/_dun_world.dm` (the Twilight Axis map import), and `upstream_fixes.dm`.
- `dun_world/` — everything for the Twilight Axis import in one place: the support
  `.dm` files (`areas`, `compat`, `furniture`, `items`, `jobs`, `keys`, `mapgen`,
  `mobs`, `structures`, `map_adjustment`), plus
  `dun_world/config/` (`map.json` replacement table, `maps_fragment.txt`),
  `dun_world/icons/` (ported Azure sprites) and `dun_world/abyssor/` (the Abyssor
  dream-cult content pack — see `dun_world/abyssor/README.md`).
  `dun_world/_dun_world.dm` is the sub-include list.
- `erp/` — everything for the ERP system in one place: `erp/_erp.dm` (the
  include list), `erp/code/` (the ERP/sexcon/organ/sprite-accessory sources),
  `erp/icons/` and `erp/sound/` (ERP assets), and `erp/_parked_twilight/`
  (unported Twilight reference material).
- `woodcarving/` — carved wooden trinkets and their recipes, ported from Azure-Peak
  after PR #5. See `woodcarving/README.md`.
- `ceramics/` — fired clay vessels and their pottery-wheel recipes, ported from
  Azure-Peak after PR #5. See `ceramics/README.md`.
- `neck_amulets/` — gold and silver carved gem amulets, ported from Azure-Peak after
  PR #5 (batch 1 of the clothing port). See `neck_amulets/README.md`.
- `facemasks/` — padded, leather and chainmaille face masks, ported from Azure-Peak
  after PR #5 (batch 2 of the clothing port). See `facemasks/README.md`.
- `garments/` — dresses, robes, a winter coat, a toga and a formal skirt with their
  sewing recipes, ported from Azure-Peak after PR #5 (batch 3). See `garments/README.md`.
- `snouted_helms/` — snouted helmet variants of existing Vanderlin helmets, sprites from
  Azure-Peak after PR #5. See `snouted_helms/README.md`.
- `tools/` — map generation and QA scripts.

- Source map: `Azure-Peak/Azure-Peak:_maps/map_files/dun_world/dun_world.dmm`
- Build output: `_maps/map_files/dun_world/dun_world_new.dmm`
- Extra source z-level: `Azure-Peak/Azure-Peak:_maps/map_files/otherz/wretch_coast.dmm`
- Extra build output: `_maps/map_files/otherz/wretch_coast_new.dmm`
- Replacement config: `modular_abel/dun_world/config/map.json`

Run `modular_abel/prepare_map.cmd` on Windows or `modular_abel/prepare_map.sh`
on Linux to download the raw upstream maps by URL and apply path replacements.
The normal path does not depend on a local `C:\Axis\Azure-Peak` checkout.

Run `modular_abel/build.cmd <target>` or `modular_abel/build.sh <target>` to
prepare the map and compile through a temporary downstream DME without modifying
the upstream `vanderlin.dme` or `tools/build/build.ts`. For example:
`modular_abel/build.cmd dm`.

For a root-level one-button build, use `BUILD_MODULAR_ABEL.cmd` on Windows or
`BUILD_MODULAR_ABEL.sh` on Linux. These launchers call the modular wrapper and
leave the upstream `BUILD.cmd` unchanged.

The modular wrapper injects only `modular_abel/_module.dm` into
`vanderlin.modular_abel.dme`, compiles that temporary DME, and copies the
resulting build artifacts to the normal `vanderlin.dmb`/`vanderlin.rsc` names.
The generated maps are NOT compiled into the DME — like every other playable
map they are loaded at runtime by `SSmapping` from `_maps/dun_world.json`.
Compiling a playable map into the DME pre-creates its z-levels at world start,
which trips the `DEFAULT_MAP_TRAITS` vs `world.maxz` warning in
`zlevel_manager.dm` and double-loads the map. Targets `dm`, `build`, and
`server` use the modular DME. Other upstream targets are passed through without
DME injection.

`_maps/dun_world.json` is the downstream map config for the generated map. It is
now part of the upstream CI map matrix (no `exclude_from_ci`), so Integration
Tests boot the Twilight Axis map on every push.

The Abyssor dream-cult content (`dun_world/abyssor/`) is gated per map by the
`abyssor_cult` key in the map's `_maps/*.json`. It defaults to `FALSE`, so the stock maps
are unaffected; only `_maps/dun_world.json` sets `"abyssor_cult": true`. See
`modular_abel/dun_world/abyssor/README.md` for what is ported, what was adapted, and the
two subsystems still outstanding.

Twilight Axis (`dun_world`) is hardcoded as the boot map by the modular
`dun_world/force_load.dm` mapping override. It remains listed as a votable map
in `config/maps.txt` alongside the stock maps.
`modular_abel/dun_world/config/maps_fragment.txt` is also appended to
the generated runtime config overlay for launch paths that rely on
`config-directory=tmp/modular_abel/config`. Targets `dm`, `build`, and `server`
refresh this runtime config overlay; `server` also passes it to DreamDaemon.

For CI, run `modular_abel/ci/pre_build.sh` or
`modular_abel/ci/pre_build.cmd` before modular compile steps. The script prepares
the generated map and the downstream runtime config overlay.

For TGS, point the instance `.tgs.yml` at the modular precompile scripts instead
of the upstream precompile scripts:

```yaml
linux_scripts:
  PreCompile.sh: modular_abel/tgs_scripts/PreCompile.sh
  WatchdogLaunch.sh: tools/tgs_scripts/WatchdogLaunch.sh
  InstallDeps.sh: tools/tgs_scripts/InstallDeps.sh
windows_scripts:
  PreCompile.bat: modular_abel/tgs_scripts/PreCompile.bat
```

The modular TGS precompile script runs `modular_abel/prepare_map.*`, runs the
upstream TGS build target, injects the module into the disposable TGS
`vanderlin.dme`, and appends the map rotation block to that disposable
checkout's `config/maps.txt`. The generated maps load at runtime from
`_maps/dun_world.json`, not from the DME.

The replacement table is populated with Twilight Axis path -> Vanderlin path pairs.
Some entries still intentionally fall back to broader parent types where no
local analogue has been confirmed yet.

Twilight Axis content ports live in dedicated module files so the replacement
table can target faithful types instead of broad parents (sprites under
`modular_abel/icons/dun_world/`):

- `dun_world_furniture.dm` — tables, chairs, wall-decor, decostone walls.
- `dun_world_structures.dm` — canopies, pillows, hookah, potter's wheel,
  statues (aasimar/abyssor/psybloody/female/zizo), the far-travel tile,
  carriage, one-way barriers, bathhouse/dungeon travel tiles, SILVER/BRASS/
  WRETCH (Vile Vheslie)/potion vendors, and the AzureSand floor.
- `dun_world_items.dm` — hair dye cream, dye brush, armour brush, fake crown,
  the Mad Duke's rapier.
- `dun_world_mobs.dm` — the Archlich boss, its summon ability, death visual,
  key, and the lich barrier.
- `dun_world_compat.dm` — fueled-light variants (lit floor candles, wall
  fireplace with our warmth mechanics).

The modular `SSmapping/PreInit()` override in `dun_world/force_load.dm`
force-loads Twilight Axis from `_maps/dun_world.json`. Unit tests and random world
generation retain their own map selection paths. The override is also disabled
for `LOWMEMORYMODE`, `NO_DUNGEON`, and `ABSOLUTE_MINIMUM_MODE` builds.

`modular_abel/upstream_fixes.dm` keeps upstream files untouched by overriding
them from the module: the mercenary stabard color fallback (upstream
`clothing_color2hex` returns null for several deprecated color names) and the
`turf_coverage` unit test blacklist extended with the dun_world turfs. The test
override replaces the upstream `Run()` body, so re-sync it when the upstream
blacklist changes.

Map QA helpers (run from the repo root with `tools/bootstrap/python`):

- `modular_abel/tools/check_map_paths.py <map.dmm>...` verifies every typepath
  in the generated maps resolves against `code/` + `modular_abel/` declarations
  (bad paths compile fine but crash the runtime maploader).
- `modular_abel/tools/run_maplint.py` runs the `tools/maplint` lints over the
  generated maps (works around Windows BOM/locale issues in the upstream
  runner).
- `modular_abel/tools/dmi_states.py a.dmi [b.dmi]` prints DMI icon states, or
  with two files shows the states present only in the second one.

TODO:
- Bathhouse drug merchant at roughly (57,56,1) does not appear: `bathvend` and
  `vendor/bathhouse` are mapped, so the source tile likely holds a different
  Azure type. Needs the exact source type to add a remap.
- `headeater`/`stockpile` wall machines render through walls (their sprite is
  pixel-offset up onto the wall tile and visible from both sides). Needs an
  in-game look to decide a directional-render or placement fix.
- Continue the fidelity pass for broad fallback replacements in
  `modular_abel/dun_world/config/map.json`. Remaining visible-structure
  leftovers worth faithful ports: `ritualcircle/*` (base missing),
  `mini_flagpole/*`, `turf_decal/trimline/yellow`, `standingbell`/`boatbell`,
  `bars/shop`, `leyline/*`, `chimeric_calyx_spawner`, `dungeontool/mover`,
  `roguerune/god/psydon`, `mudcrab`, and Azure-only heart canisters. Most other
  fallbacks are loot/clutter inside containers where the generic parent is
  visually fine. Wretch Coast also has broad fallbacks for vampire/inhumen
  areas, keys, ritual circles, Azure-only clothing, and old rogue tools.
- Done so far in the visual pass: deity psycrosses (baotha/graggar/matthios/
  necra/zizocross stone+golden), `littlebanners/*`, herringbone floor decals,
  and the golden astrata cross + statue now use the original Azure sprites
  (under `dun_world/icons/`) instead of generic fallbacks.
- Turf `icon_state` var edits from the Azure maps are stripped during
  generation (maplint bans them); re-add the intended looks through dedicated
  dun_world turf subtypes where they matter.
- Spawn coverage: Vanderlin city jobs without a matching
  `/obj/effect/landmark/start/<job>` on the generated map fall through to the
  last-resort spawn (often a wretch landmark). Audit the job roster against the
  remapped landmark set and either add landmark remap rules or curate the job
  roster for Twilight Axis.
- `/turf/closed/mineral/rogue/bedrock` resolves to Vanderlin's
  `/turf/closed/mineral/bedrock`; if the Azure rocky look matters, port the
  `rockyashbed` sprite to a dedicated dun_world subtype.
