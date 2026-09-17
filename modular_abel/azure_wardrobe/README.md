# azure_wardrobe — donator cosmetics ported from Azure Peak

15 purely cosmetic garments and 15 loadout entries, sourced from `Azure-Peak/Azure-Peak`
(`icons/clothing/donor_clothes.dmi` and its `onmob` siblings — that fork's own donor sheet).
The tgui side is the shared loadout panel and the triumph shop; both read
`GLOB.loadout_items`, so one entry fills both windows.

Selected with `C:\Axis\ai-skills\scripts\compare_clothing_sprites.py`, which listed every
clothing state Azure has and Vibelin does not, with a verdict per state. Only `wired`
candidates (a DM type in the donor declares the state) that also carry a worn sheet were
considered.

## What is ported

| Item | Slot | Notes |
| --- | --- | --- |
| archwyzard's hat | head | 64x64 worn sheet, two-tone via `detail_tag` |
| beaked mask, brass beak mask, jade halfmask | face | |
| halo | head+mask | rides `HALO_LAYER`, covers nothing |
| crestplume, striped orle, oathkeeper's orle, gazelle skull | head+mask | helmet decorations |
| ornate coronet, encrusted tiara | head | |
| greatcoat | cloak | sleeved, two-tone via `detail_tag` |
| doublet | shirt | sleeved |
| feathered shroud + feathered hood | cloak / hooded | subtypes of the raincloak pair |

## Adaptations made during the port

- **Parents.** Azure files clothing under `/obj/item/clothing/<slot>/roguetown/...`; Vanderlin
  dropped that segment and flattened the head tree, so each item hangs off the nearest
  existing Vibelin type instead of its Azure parent. The masks are the case that matters:
  Azure's `/obj/item/clothing/mask/rogue/facemask/*` maps onto
  `/obj/item/clothing/face/facemask` here, but **that type carries iron-mask armour,
  `prevent_crits` and an FOV block**. Cosmetics must not hand out armour, so they hang off
  the bare `/obj/item/clothing/face` instead.
- **`alternate_worn_layer` is not carried over.** The donor gives the helmet decorations
  `8.9`; layer numbers are not comparable between the two forks, so they are left at their
  parent's layer. If a plume renders under a helmet in game, that var is the place to look.
- **Descriptions are rewritten, not copied.** Azure's are multi-line and carry its own
  setting's proper nouns (Etrusca, the Tailor Society); these say the same thing in this
  fork's voice and in one line.
- **Sellprices and triumph costs are invented.** 25 for a helmet trinket, 150 for a shroud;
  nothing in Azure priced any of it.

## Art

`icons/` holds four sheets merged out of the donor with `modular_abel/tools/dmi_merge.py`,
using the `state -> state` form so every per-species, per-sex and per-side cell came along:

| Sheet | Cells | Source |
| --- | --- | --- |
| `azure_wardrobe_world.dmi` | 32x32, 18 states | `icons/clothing/donor_clothes.dmi` |
| `azure_wardrobe_onmob.dmi` | 32x32, 27 states | `icons/clothing/onmob/donor_clothes.dmi` |
| `azure_wardrobe_onmob64.dmi` | 64x64, 3 states | `icons/clothing/onmob/donor_clothes64.dmi` |
| `azure_wardrobe_sleeves.dmi` | 32x32, 28 states | `icons/clothing/onmob/donor_sleeves_armor.dmi` |

The `_detail` states in the world and 64 sheets are what `detail_tag` reads; deleting them
silently drops the second colour.

**One candidate was dropped:** Azure's dyeable shaded hat has a worn sprite and no inventory
sprite at all — `dshadedhat` exists only in `onmob/donor_clothes.dmi`. It cannot be ported
until someone draws the item icon.

## Rules this module follows

Everything here is cosmetic: no `armor_type`, no `prevent_crits`, no coverage. That is the
module's whole scope — mechanical content belongs in a morphing elixir, the way
`modular_abel/snouted_helms/README.md` describes, not in a shop garment.
