# azure_wardrobe — donator cosmetics ported from Azure Peak

61 purely cosmetic garments and 61 loadout entries, sourced from `Azure-Peak/Azure-Peak`
(its own donor sheet plus the shared neck, mask, cloak and mercmedal sheets).
The tgui side is the shared loadout panel and the triumph shop; both read
`GLOB.loadout_items`, so one entry fills both windows.

Selected with `C:\Axis\ai-skills\scripts\compare_sprites.py`, which listed every
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

## Batch 2

19 more entries, from Azure's shared sheets rather than its donor sheet.

**The gilded Ten.** Vibelin already ships wooden (`psycross/divine/*`) and silver
(`psycross/silver/divine/*`) amulets for every god of the pantheon, and a bare
`psycross/gold`, but no gold per-god set. Azure has one, so all ten are ported under a new
`psycross/gold/divine` parent that mirrors the silver tree exactly; the descriptions are
Vibelin's own lines for each god, not Azure's, because the same amulet should read the same
whatever it is cast in.

They are named **"Gilded Amulet of X"** in the shop, not "Golden", because upstream already
ships a loadout entry called *Golden Amulet of Xylix* whose own comment says
`//Pranked! it is wood`. Two shop rows with one name is exactly what
`modular_loadout_panel` fails on.

**The rest:** porcelain amulet, three mercenary medals (northmanne's idol, guardian's
seedpouch, laughing volf medal), bronze and iron spectacles, duelist's goggles, the autumneer
cloak and a dupatta.

**Not ported, deliberately:** Azure's tinted fancy spectacles (`glassesb_dark`) — Vibelin
already has `/obj/item/clothing/face/spectacles/fancy_dark` — and its gold mask, which is
`/obj/item/clothing/face/facemask/goldmask` here already.

Batch 2 art comes from `neck.dmi`, `mercmedals.dmi`, `masks.dmi` and `cloaks.dmi` plus their
`onmob` siblings; the sheets in `icons/` were re-merged from a combined spec, so they now
carry both batches (45 / 94 / 3 / 69 states).

## Batch 3

22 more entries, in three groups.

**The cleric wardrobe.** Astratan, justice (Ravox) and necran cloaks, the undivided devotee
tabard and the psyalter's stole — the tabards a cleric of each faith wears in Azure, and
which Vibelin had no cosmetic equivalent of. All five hang off types this fork already has
(`cloak/templar`, `cloak/psyaltrist`), so they are subtypes rather than new branches.

**Travelling cloaks and work wear:** ranger cloak and its undyed grey twin, scout cloak,
blacksmith's leather apron, frilled housekeeper's apron.

**The bronze tier and the rest of the amulets.** Bronze psycross, the reformist psycross,
bronze and iron inverted psycrosses under `psycross/zizo`, and bronze amulets of Astrata,
Noc and Malum under a `psycross/bronze/divine` parent built the same way the gilded one was.
Azure only draws bronze for those three gods, so the bronze tier is deliberately partial
where the gilded one is complete. Plus steel spectacles, steel duelist's goggles, the
giltsilk mask, the desert rider's sash and the underdweller's broken compass.

Sheets were re-merged from a spec covering all three batches: 73 world states, 221 worn,
3 at 64x64 and 153 sleeve cells.

## Batch 4

Five stragglers, and the end of what Azure has left in complete cosmetic form: the bared
toga, the Hand's cloak and halfmask, the saccharine veil and the helmetless visor.

**The short jupon was cut.** `surcoat_short` has its inventory sprite in `cloaks.dmi` but its
worn cells in `onmob/detailed/tabards.dmi`, which is a different sheet from the one the rest
of this batch merges; adding it would have meant a fourth source for one garment. It is worth
picking up whenever someone does another cloak pass.

Sheets: 81 world, 250 worn, 3 at 64x64, 165 sleeve cells.

## Credit where the donor named someone

Two of these were named donator rewards on Azure's side, and the handles are kept here for the
same reason `modular_abel/morph_elixirs/README.md` keeps its table: the sprite exists because
somebody paid for it and somebody drew it.

| Piece | Named for |
| --- | --- |
| Encrusted Tiara | `eekasqueak` |
| Ornate Coronet | `drd` |
