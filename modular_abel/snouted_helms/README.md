# snouted_helms — snouted helmet variants

Sprites ported from `C:\RedTardProject\Azure-Peak-Fork` (`Azure-Peak/Azure-Peak`), added
upstream after Vibelin PR #5.

## The approach

Azure hangs its snouted helmets off four helmet families Vanderlin does not have —
`bascinet/pigface`, `heavy/banneret`, `heavy/knight/armet` and `sallet/visored`. Rather than
import four whole helmet lines for the sake of their variants, these are declared as
**variants of the helmets Vanderlin already stocks**: a snout is a variation on what is in the
armoury, not a new piece of kit.

| Azure path | Ported as |
| --- | --- |
| `bascinet/pigface/roundface/snouted` (+ iron) | `helmet/bascinet/snouted` (+ `/iron`) |
| `sallet/visored/snouted` (+ iron) | `helmet/sallet/snouted` (+ `/iron`) |
| `heavy/knight/armet/snouted` (+ iron) | `helmet/visored/snouted` (+ `/iron`) |
| `heavy/nochelm/snouted` | `helmet/heavy/nochelm/snouted` (parent already here) |
| `heavy/volfplate/psydonic` | `helmet/heavy/volfplate/psydonic` (parent already here) |

## Not ported

- **Banneret sallet** — its `capsallet_s` sprite does not exist in Azure's own sheets.
- **Banneret bascinet** — same family, no Vanderlin parent and nothing gained by inventing one.

## Recipes

Added because `craftable_clothes` requires them and because a snouted helm is the same forging
job with the face plate drawn out: each costs its parent's material plus one extra ingot for
the muzzle, one `craftdiff` step above the plain version. The psydonic volfplate instead
follows its own family's existing pattern (`volfplate_puritan`: steel + steel, craftdiff 4).
**The costs are invented, not ported.**

## Assets

| File | From | States |
| --- | --- | --- |
| `icons/helms_world.dmi` | Azure `icons/roguetown/clothing/head.dmi` | 8 |
| `icons/helms_onmob.dmi` | Azure `icons/roguetown/clothing/onmob/head.dmi` | 7 |
| `icons/helms_tall.dmi` | Azure `icons/roguetown/clothing/onmob/32x40/head.dmi` | 1 |

The psydonic helm uses the tall 32x40 mob sheet, as its parent family does.

## Material lines

Azure's iron variants were originally declared under the steel parents, so a "snouted iron
sallet" carried steel armour, a steel sell price and smelted into steel. Each variant now hangs
off the helmet whose material it claims:

| Variant | Parent |
| --- | --- |
| `bascinet/snouted` | `bascinet` (steel) |
| `bascinet/snouted/iron` | `bascinet`, with iron `smeltresult`/`sellprice` — Vanderlin has no plain iron bascinet |
| `sallet/snouted` | `sallet` (steel) |
| `sallet/iron/snouted` | `sallet/iron` |
| `visored/knight/snouted` | `visored/knight` (steel) |
| `visored/knight/iron/snouted` | `visored/knight/iron` |
| `heavy/nochelm/snouted` | `heavy/nochelm` |
| `heavy/volfplate/psydonic` | `heavy/volfplate` |

`/obj/item/clothing/head/helmet/visored` is `abstract_type`, so the armets moved onto
`visored/knight` — the closed helm they are a variation of. That parent uses the 64x64 onmob
sheet, so both snouted armets reset `worn_x_dimension`/`worn_y_dimension` and `bloody_icon`
back to the 32x32 set our own sheet uses.

## Loadout

These are pure reskins of helmets the game already has, so they are **not** free loadout picks.
`loadout.dm` entries hand out `/obj/item/enchantingkit` morphing elixirs instead: the player
brings the helmet, the elixir changes its look. Five kits cover the seven mappings above; the
iron snouted bascinet has no plain iron counterpart to morph from, so it stays anvil-only.

`/datum/unit_test/modular_morphing_elixir` enforces that every mapping targets a type the
result inherits from, and that the swap changes no armour value. See
`modular_abel/loadout_panel/README.md`.
