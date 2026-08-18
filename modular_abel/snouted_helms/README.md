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
