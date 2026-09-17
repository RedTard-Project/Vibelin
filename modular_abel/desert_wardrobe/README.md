# desert_wardrobe — the eastern and desert wardrobe from Ratwood

Fourteen purely cosmetic garments and fourteen loadout entries, out of the `modular_deserttown`
overlay of the Ratwood 2.0 fork. They sit in their own panel tab,
`LOADOUT_PANEL_CATEGORY_DESERT` ("Desert Content").

## What is ported

| | |
| --- | --- |
| Head | tagelmust, fancy purple turban, zybantine magos hat |
| Robes | bisht, grey bisht, purple bisht, guild bisht |
| Dress | thawb, gold-trimmed thawb |
| Legs | sirwal |
| Silk | green and red silk bras, green and red silk veils |

Two of these slot straight into types this fork already has: `/obj/item/clothing/head/turban`
and `/obj/item/clothing/shirt/exoticsilkbra` both exist here, so the purple turban and the two
bras are colour variants rather than new branches. The veils get a small abstract parent,
`/obj/item/clothing/face/exoticsilk`, so the two of them share their sheets in one place.

## None of these carry sleeves, and that is not an oversight

Every robe in the donor sets `sleeved` to one of the shared helper sheets —
`icons/roguetown/clothing/onmob/helpers/sleeves_armor.dmi`, `sleeves_shirts.dmi`,
`sleeves_pants.dmi` — and **not one of those sheets holds a cell for any of these garments**.
Nor does any sheet in `modular_deserttown/icons/clothing/onmob/`: they carry the base state and
its `_f`, `_dwarf` and `_f_dwarf` variants, and no `l_`/`r_` sleeve cells at all.

So the var is left unset here and each garment inherits its parent's sleeve behaviour. Setting
`sleeved` to a sheet with no matching cells is how a garment ends up rendering with invisible
arms; the same thing cost the hakama its `sleeved` in `twilight_wardrobe`, for the same reason.

## Art

| Sheet | Cells | Sources |
| --- | --- | --- |
| `desert_wardrobe_world.dmi` | 32x32, 14 states | `easternclothes.dmi`, `head.dmi`, `armor.dmi`, `shirts.dmi`, `pants.dmi`, `masks.dmi` |
| `desert_wardrobe_onmob.dmi` | 32x32, 47 states | the `onmob` siblings of those |
| `desert_wardrobe_onmob48.dmi` | 32x48, 1 state | `onmob/head32x48.dmi`, for the magos hat |

The worn sheet carries 47 states for 14 garments because the `state -> state` merge form brings
each garment's `_f`, `_dwarf` and `_f_dwarf` cells across with it. Those are what the renderer
actually asks for on a female or a dwarven character; dropping them would leave those players
looking at nothing.

## Provenance

Ratwood's own overlay, under that repository's normal licence — **not** the
`licensed-infraredbaron` folder, which is proprietary and is documented in
`modular_abel/rmh_wardrobe/README.md`. Costs and sellprices are invented, on the same scale as
the other wardrobes.
