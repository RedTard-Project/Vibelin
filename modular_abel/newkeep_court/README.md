# newkeep_court — the court and city watch, by infrared_baron

Twelve pieces: the city watch armour, helmet and cape, and eight uniforms of the newkeep court
— councillor, duke, duchess, the crown's Hand, heir, heiress, magos and steward — plus the
duchess' veil. Ten of them are armour and are sold as morphing elixirs; the cape and the veil
carry no armour and are sold as garments.

They sit in their own panel tab, `LOADOUT_PANEL_CATEGORY_NEWKEEP` ("Newkeep Court").

## Credit

**Art by [infrared_baron]. Commissioned by [colonelwehweh].** It reached this fork through the
Ratwood 2.0 checkout, `icons/roguetown/clothing/licensed-infraredbaron/`, where the same
sprites also sit in the Rivermist-Hollow-Vanderlin fork's `modular_rmh` overlay.

This wardrobe exists because those two people paid for it and drew it. That is the reason the
whole module is kept in one folder with the credit at the top of its readme rather than
scattered through the other wardrobes: if these sprites are going to be worn on this server,
the people behind them should be named where anyone touching the files will see it.

## The licence on the source folder, stated plainly

The source folder ships its own `LICENSE.md`:

> All the items in this folder and its subdirectories are licensed under a proprietary
> agreement between client: [colonelwehweh] and artist: [infrared_baron]. Redistribution,
> reproduction, or modification of these assets is prohibited without express permission from
> both licensors. These assets are for use solely within this project and may not be extracted
> or repurposed for other projects or commercial use.

Both donor forks' own READMEs say assets are CC-BY-SA 3.0 *"unless otherwise indicated"*, and
that file is the indication, so the repository licence does not cover these sprites the way it
covers the rest.

**Porting them here was a deliberate decision by this fork's maintainer, made with the above in
front of them, and the risk is theirs.** It is written down here so that whoever reads this
file next does not have to rediscover it, and so that the credit above is not mistaken for a
licence. If either licensor objects, the module is self-contained: delete the folder, drop the
`#include` from `modular_abel/_module.dm` and the tab disappears with it.

## Structure

| Elixir | Morphs | Into |
| --- | --- | --- |
| City Watch Armour | `armor/plate` | `plate/citywatch` |
| City Watch Helmet | `head/helmet` | `helmet/citywatch` |
| Councillorial Uniform | `armor/leather` | `leather/councillor` |
| Ducal Uniform | `armor/leather` | `leather/duke` |
| Duchess' Dress | `armor/leather` | `leather/duchess` |
| Hand's Jacket | `armor/leather` | `leather/hand` |
| Heir's Uniform | `armor/leather` | `leather/heir` |
| Heiress' Uniform | `armor/leather` | `leather/heiress` |
| Magos' Robes | `armor/leather` | `leather/magos` |
| Steward's Vest | `armor/leather` | `leather/steward` |

Eight of the ten morph from `armor/leather`, which is exactly what the donor files them under —
a court uniform in this setting is a leather coat with better tailoring, and the elixir contract
means none of them changes what that coat stops.

## A bug inherited from the source

`onmob/armor.dmi` holds the citywatch helmet's female worn cell under the name
**`ctiywatch_helmet_f`** — the donor's own typo. The renderer asks for `citywatch_helmet_f` and
will not find it, so a female character wearing the helmet gets the male sprite. The typo is
reproduced here rather than silently corrected, because renaming a cell in a sheet we did not
draw is a modification, and because the fix belongs upstream where the art lives.

## Art

| Sheet | Cells | Sources |
| --- | --- | --- |
| `newkeep_court_world.dmi` | 32x32, 12 states | `licensed-infraredbaron/armor.dmi`, `head.dmi`, `cloaks.dmi` |
| `newkeep_court_onmob.dmi` | 32x32, 50 states | their `onmob/` siblings |

No sleeve cells exist in any of the source sheets, so nothing here sets `sleeved`; every piece
inherits its parent's sleeve behaviour. Costs are invented, on the scale used by the other
modules.
