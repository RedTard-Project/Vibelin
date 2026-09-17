# rmh_wardrobe — cosmetics ported from Rivermist Hollow

Seven garments and seven loadout entries, from the `modular_rmh` overlay of the
Rivermist-Hollow-Vanderlin fork: choker, emerald choker, duchess' veil, nun's coif, nun's
habit, maid dress, alchemist's gloves.

They sit in their own panel tab, `LOADOUT_PANEL_CATEGORY_RMH` ("Rivermist Content"), beside the
Azure and Twilight ones.

## Why this batch exists

These are the ten states `compare_clothing_sprites.py` returned with the **`shop`** verdict —
the only donor checked so far that has a `/datum/loadout_item` type at all, so the only one
that can answer "which of these does that fork already sell?". Somebody over there had already
decided each of them was worth putting in a shop, which makes the list far shorter to review
than 500 `wired` rows.

**Three of the ten were already here** and the tool said so up front: the bell collar, the
leather collar and the sophisticated jacket all exist in this codebase under the same paths
(`already_here` in `port_clothing.py`'s output). Nothing was ported twice.

## Adaptations

- **Names.** The donor's nun set is named to be a joke about itself; the garments are the same
  cloth either way, so they are filed here as a coif and a habit and left to speak for
  themselves.
- **Sleeves** come from two separate helper sheets on the donor side
  (`vladegeg/onmob/helpers/maid_sleeves.dmi` and `onmob/nun_robes_sleeves.dmi`), merged into one
  sheet here.
- **Costs and sellprices are invented**, on the same scale as the other two wardrobes: 50 for a
  band at the throat, 125 for the stone in it.

## Art

| Sheet | Cells | Sources |
| --- | --- | --- |
| `rmh_wardrobe_world.dmi` | 32x32, 9 states | `choker.dmi`, `licensed-infraredbaron/head.dmi`, `nun_robes.dmi`, `thaumgloves.dmi`, `vladegeg/maid.dmi` |
| `rmh_wardrobe_onmob.dmi` | 32x32, 18 states | the `onmob` siblings of those |
| `rmh_wardrobe_sleeves.dmi` | 32x32, 12 states | `maid_sleeves.dmi`, `nun_robes_sleeves.dmi` |

**The maid dress and the habit carry no base worn state** — only `_m` and `_f` cells, which is
how the donor draws gendered garments and how the renderer expects to find them. The module's
verification script was taught that shape here: a worn sheet satisfies `icon_state` if it holds
the state itself *or* its `_m`/`_f` pair. A garment with neither is still a broken port.
