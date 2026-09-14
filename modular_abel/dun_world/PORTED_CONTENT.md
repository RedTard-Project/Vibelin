# dun_world — Azure content ported for the Twilight Axis map

The Twilight Axis `.dmm` is downloaded from Azure-Peak at build time and rewritten
through `config/map.json`. Whenever Azure places an object Vanderlin has no type for,
the build prints a `missing from the compile` warning and that content silently does
not spawn.

This file records the 2026-09-14 pass that cleared that warning list down from 15
paths to 1. Source for every port is the local Azure checkout
(`Azure-Peak/Azure-Peak`, `main`).

## Retargeted, not ported

These already existed in Vanderlin under a different path, so they are only
`config/map.json` entries. Three of them had gone stale because upstream renamed the
*target*, which is what the "replacement points at a type that no longer exists"
warning was reporting.

| Azure path | Vanderlin type | Why |
| --- | --- | --- |
| `head/roguetown/helmet/heavy/zizo` | `head/helmet/heavy/inhumen/zizo` | repathed by upstream #7770 |
| `neck/roguetown/luckcharm/mercmedal/blackoak` | `neck/mercmedal/redwood` | #7736 renamed the Black Oak Guardian to Redwood Mercenary; same seedpouch item |
| `closet/crate/roguecloset/crafted` | `closet/crate/crafted_closet` | #7160 folded the `/crafted` subtype into its parent and repointed the carpentry recipe there |
| `blood/splatter/walls` | `blood/wallsplatter` | same decal, different name |
| `clothing/mask/rogue/sack` | `clothing/face/sack` | Vanderlin keeps masks under `face/`; matches the existing `sack/psy` mapping |
| `psicross/astrata/wood` | `psycross/wooden_divine/astrata` | the type already existed in `items.dm`; only the map entry was missing |
| `snacks/rogue/meat/humanoid` | `snacks/meat/steak/human` | direct equivalent |
| `snacks/rogue/meat_rotten` | `snacks/rotten/meat` | literally what Vanderlin meat rots into (`become_rot_type`) |

## Ported

| Type | Lives in | Notes |
| --- | --- | --- |
| `/obj/machinery/anvil/bronze` | `machines.dm` | cosmetic tier of the existing anvil |
| `/obj/item/scrap` | `items.dm` | uses the upstream `scrap` sprite, which Vanderlin already ships |
| `/obj/item/ration_lootbox` | `items.dm` | loot table rebuilt from Vanderlin foods |
| `snacks/cooked/smoked_z` | `food.dm` | Azure's "foul jerky bundle" |
| `snacks/cooked/smoked_meat`, `snacks/cooked/smoked_fish` | `food.dm` | new, needed to give the smoker an output |
| `/obj/machinery/light/fueled/smoker` + `/wheeled` | `machines.dm` | the cooking machine |

## Adaptations made during the port

Azure and Vanderlin have diverged; these are deliberate differences, not oversights.

- **Bronze anvil durability.** Azure's bronze anvil is `max_integrity = 400` against a
  base anvil of `500` — 80% of a normal anvil. Vanderlin's base anvil is `2000`, so the
  port uses `1600` to keep the *ratio* rather than shipping an anvil five times more
  fragile than every other one.
- **Scrap and repair kits.** Azure's scrap feeds its metal repair kits. Vanderlin has the
  same `/obj/item/repair_kit/metal` but refills it from iron/steel/steel-slag ingots, and
  `METAL_REPAIR` is `#undef`'d at the bottom of its own file, so it cannot be read from
  here. `items.dm` therefore prefixes `attempt_refill()` with an `istype(src,
  /obj/item/repair_kit/metal)` check and defers to `..()` for everything else — upstream's
  proc body is not copied, so the override survives a re-sync.
- **Ration lootbox contents.** Only 2 of Azure's 47 loot entries exist here — its whole
  `Neu_Food` snack tree (`rogue/raisins`, `fish/*`, `grown/fruit/*`) is shaped differently.
  The table is rebuilt from 38 real Vanderlin foods covering the same spread (sweets,
  dried fruit, fresh fruit, fish, cured meat, cheese, produce, bread). Poisoned and toxic
  variants are deliberately excluded.
- **Right-click.** Azure's `attack_right(mob/user)` is Vanderlin's
  `attack_self_secondary(mob/user, list/modifiers)`.
- **Jerky nutrition.** Azure's `NUTRITION_HALF_MEAL` is 6; Vanderlin's `SNACK_DECENT` is
  also 6, so the value carries over exactly under the local define.
- **Smoker parent.** Azure's `/obj/machinery/light/rogue` is Vanderlin's
  `/obj/machinery/light/fueled`. That base lights itself in `Initialize()` and burns fuel,
  so the smoker sets `fueluse = 0` and calls `seton(FALSE)` after the parent call.
- **Smoker and `GLOB.fires_list`.** The fueled-light base registers itself as a fire.
  The smoker emits no light (its `update()` is a no-op, as in Azure) and its fire is shut
  inside a box, so it removes itself from the list — otherwise the `lightsout` omen would
  snuff a closed smoker and vampire code would read it as an open flame.
- **Icon updates.** Azure overrides the legacy `update_icon()`. Vanderlin's
  `update_icon(updates)` is a dispatcher, so the port splits it into `update_icon_state()`
  and `update_overlays()` and calls `update_appearance()`. This also removes Azure's manual
  `need_underlay_update` / `cut_overlays()` bookkeeping — the dispatcher manages overlays.
- **Click coordinates.** Azure reads `params2list(params)["icon-x"]`. Vanderlin already
  hands `attackby`/`attack_hand` a `list/modifiers`, so the port uses
  `LAZYACCESS(modifiers, ICON_X)` and treats a missing coordinate as "not the door".
- **`contents` assignment.** Azure's `finish_batch()` rebuilds `contents` by assigning a
  new list to it. The port creates the smoked result inside `src` and `qdel`s the input
  instead, which is the same outcome without writing to `contents` directly.
- **Cooking skill.** Azure's `get_cooktime_divisor()` has no Vanderlin equivalent; progress
  is scaled with `GET_MOB_SKILL_VALUE_OLD(user, /datum/attribute/skill/craft/cooking)`, and
  the experience grant uses the local
  `GET_MOB_ATTRIBUTE_VALUE(user, STAT_INTELLIGENCE)` idiom.
- **`smoked_type`.** Vanderlin food has no smoking system, so `food.dm` adds the var to
  `/obj/item/reagent_containers/food/snacks` and wires it on the `meat` and `fish` families.
  Smoked output keeps `SHELFLIFE_EXTREME`, which is the point of smoking food.
- **`roundstart_forbid`** does not exist here and is dropped.

## Still not ported

`/obj/structure/roguemachine/ritual_rune` — the only path the Twilight Axis map still
asks for that the compile does not provide. It is the entry point to Azure's vision-quest
and ritual chain (~2 000 lines across `dream_quests*.dm`, `dream_rituals*.dm`,
`dream_visions.dm`, `dream_ui.dm`, `dream_rune.dm`) whose UI is built on Azure's
`/datum/tgui_module`, a base Vanderlin does not have. That needs a real tgui interface
written against `SStgui` plus a new `.tsx`, not a port. See `abyssor/README.md`, which
records the same decision for the rest of that subsystem.

## Assets

`icons/forge.dmi` (`broanvil`), `icons/cooked_meat.dmi` (`meat_smoked`, `meat_smoked_z`,
`salmon_smoked`) and `icons/smoker.dmi` (all ten smoker states) were extracted from the
Azure checkout with `modular_abel/tools/dmi_extract.py`. `/obj/item/scrap` needs no new
sprite — Vanderlin already ships the `scrap` state in `icons/roguetown/items/misc.dmi`.
