# abyssor — Abyssor dream-cult content pack

Ported from `C:\RedTardProject\Azure-Peak-Fork` (`Azure-Peak/Azure-Peak`), where it lives as
`code/modules/roguetown/roguemachine/abyssorcult/` plus the Painter job, the Abyssal
language and the abyssal cave areas.

Everything here compiles on every map but is **inert unless the running map opts in**.

## The per-map switch

`map_config.dm` adds `/datum/map_config/var/abyssor_cult`, read out of the map's own
`_maps/*.json`. It defaults to `FALSE`, so Vanderlin and every other stock map are
untouched. Only `_maps/dun_world.json` sets `"abyssor_cult": true`.

Use `ABYSSOR_CULT_ENABLED` (from `_defines.dm`) for any new runtime gate.

Two independent gates keep the Painter off other maps:

1. `/datum/job/painter` ships with `total_positions = 0` / `spawn_positions = 0`, and only
   Twilight Axis re-opens it via `slot_adjust` in `modular_abel/dun_world/map_adjustment.dm`.
2. `special_job_check()` returns `FALSE` when `ABYSSOR_CULT_ENABLED` is false, so an admin
   re-opening slots on a non-opted-in map still cannot spawn one.

The machines and materials need no gate of their own: they exist only where the Twilight
Axis `.dmm` places them.

## What is ported

| File | Contents |
| --- | --- |
| `_defines.dm` | `ABYSSOR_CULT_ENABLED`, `CTAG_PAINTER`, `JDO_PAINTER`, `TRAIT_INFUSION` |
| `map_config.dm` | the per-map `abyssor_cult` switch |
| `turfs.dm` | `/turf/open/rebound` (the undercurrent that throws you back) |
| `materials.dm` | all dream materials, parchments and the six dream seeds |
| `pylon.dm` | `/obj/structure/dream_pylon`, the tethered infusion buff and its six flavours |
| `equipment.dm` | rainfall / sea / sylveric robes and the quicksilver hood |
| `pool.dm` | `/obj/structure/roguemachine/dream_pool` and its animated gate |
| `language.dm` | `/datum/language/abyssal` |
| `loot.dm` | the six dream-material loot tables and their map spawners |
| `job.dm` | the Painter job, its attribute sheets, outfit and start landmark |

The abyssal grotto areas live in `modular_abel/dun_world/areas.dm`, and
`/obj/item/key/walls` in `modular_abel/dun_world/keys.dm`, alongside their neighbours.

## Adaptations made during the port

Azure and Vanderlin have diverged; these are the deliberate differences, not oversights.

- **Buff stats.** Azure's `STATKEY_INT`/`STATKEY_PER`/`STATKEY_LCK`/`STATKEY_STR`/`STATKEY_SPD`
  become Vanderlin's `STAT_INTELLIGENCE` / `STAT_PERCEPTION` / `STAT_FORTUNE` /
  `STAT_STRENGTH` / `STAT_SPEED` attribute paths.
- **Stealth infusion.** Azure grants `TRAIT_AZURENATIVE` (immunity to hostile flora).
  Vanderlin has no such trait, so the seed of stealth grants
  `TRAIT_MANEATER_IMMUNITY` + `TRAIT_FLOWERFIELD_IMMUNITY`, which is what that trait
  actually did and matches the alert's flavour text.
- **Clothing paths.** Vanderlin dropped the `roguetown` path segment from clothing years
  ago. The robes and hood are declared at `/obj/item/clothing/shirt/robe/...` and
  `/obj/item/clothing/head/roguehood/...`; the Azure paths are pointed at them from
  `modular_abel/dun_world/config/map.json`, matching how the other patron robes are handled.
- **Loot spawners.** Azure's `/obj/effect/spawner/lootdrop` takes an inline weighted list.
  Vanderlin moved to `/datum/loot_table` datums consumed by
  `/obj/effect/spawner/map_spawner/loot`, so the tables are declared that way.
- **Painter statline.** Azure's `subclass_stats` / `subclass_skills` lists become a
  `/datum/attribute_holder/sheet/job/painter` pair (adult + old).
- **Painter traits.** `TRAIT_WATERBREATHING` is Vanderlin's `TRAIT_NODROWN`.
  `TRAIT_RITUALIST` is dropped: it gates Azure's chalk-circle ritual system, which
  Vanderlin does not have.
- **Chat span.** Azure styles Abyssal with its own `SPAN_ABYSS` chat class. Vanderlin's
  chat CSS lives in upstream tgui, so the language borrows the already-styled
  `SPAN_DEEPSPEAK` rather than editing upstream stylesheets.

## Not ported yet

Two subsystems need genuine reimplementation rather than a port, and are deliberately left
out. Both are inert rather than broken — nothing references them.

1. **Vision quests, abyssal rituals and dream visions**
   (Azure `dream_quests.dm`, `dream_quests_t2.dm`, `dream_quests_t3.dm`,
   `dream_rituals.dm`, `dream_ritual_datums.dm`, `dream_visions.dm`, `dream_ui.dm`,
   `dream_rune.dm` — roughly 2 000 lines).
   Their entry points are two Azure `/datum/tgui_module` windows. Vanderlin has no
   `/datum/tgui_module` base at all, so this needs a real tgui interface written against
   `SStgui` plus a new `.tsx`, not a copy.
   Consequence: `/obj/structure/roguemachine/ritual_rune` is the one remaining path the
   Twilight Axis `.dmm` asks for that the compile does not provide, so those rune tiles do
   not spawn. The pool's gate still opens and closes; it just has no ritual chain behind it.

2. **Paint miracles and paint weapons**
   (Azure `code/modules/spells/roguetown/acolyte/abyssor/` — `paint_infusion` aside,
   roughly 1 100 lines).
   Azure's spells declare `primary_resource_type` / `primary_resource_cost` /
   `devotion_cost` / `charge_required` / `invocations`; Vanderlin's magic rework replaced
   all of those with `spell_type` / `spell_cost` / `spell_tier` / a single `invocation`.
   `/datum/special_intent/ground_smash/paint_line` additionally needs Vanderlin's
   `apply_hit(mob/living/user, obj/item/parent, turf/target)` signature rather than
   Azure's `apply_hit(turf/T)`.
   Consequence: `/obj/effect/spawner/lootdrop/roguetown/random_paint_staff` is repointed at
   the generic magic loot pool in `map.json`.

## Assets

`icons/` and `sound/` hold the Azure sprites and audio this pack needs. `combat_acolyte.ogg`
and `whale.ogg` were copied because Vanderlin does not carry them; the rest of the audio
(`lever.ogg`, `slip.ogg`, `cosmic_expansion.ogg`, `teleport_diss.ogg`) already exists
upstream and is referenced from there.
