# twilight_wardrobe — donator cosmetics ported from Twilight Axis

54 purely cosmetic garments and 54 loadout entries, sourced from the Twilight Axis fork's own
overlay (`modular_twilight_axis/icons/...`). Like `azure_wardrobe`, one entry feeds both the
triumph shop and the free loadout panel, because both read `GLOB.loadout_items`. They sit in
their own panel tab, `LOADOUT_PANEL_CATEGORY_TWILIGHT` ("Twilight Content"), defined next to
the Azure one in `loadout_panel/_loadout_panel.dm`; `build_categories()` pins All, Донат and
Azure and then emits every other `ui_category` on its own, so a new tab needed no panel code.

Selected the same way: `C:\Axis\ai-skills\scripts\compare_clothing_sprites.py` against that
checkout, keeping `wired` candidates that carry a worn sheet and live in the fork's own
modular overlay rather than in inherited upstream art.

## What is ported

**The helmkleinod set — 14 helmet crests** (chaperon, castle, dragon, afreet, feathers, fish,
bloodied star, horns, lion, Astrata's eye, gilded skull, sun, swan, windmill). They share one
abstract parent, `/obj/item/clothing/head/helmkleinod`, which owns the sheets, the
head+mask slot flags and the null coverage; each subtype is a name, a description and a state.

**Six others:** old antlers, bishop's hood, bishop's mask, silk hood, elven shortcloak, desert
cloak.

## Adaptations made during the port

- **`onhelm` has no equivalent here.** Twilight files its crests under
  `/obj/item/clothing/head/roguetown/onhelm/tw_d_*`, a branch Vibelin does not have. They hang
  off `/obj/item/clothing/head` through the new abstract parent instead, in the head+mask slot
  the Azure helmet decorations already use.
- **The bishop mask is a `/obj/item/clothing/face`**, not Twilight's
  `/obj/item/clothing/mask/rogue/ragmask/*`, for the same reason the Azure masks are: the
  nearest Vibelin mask type carries armour, and these are cosmetics.
- **Descriptions are rewritten.** Twilight's helmkleinod descriptions are good but written in
  a heavier register, and the noble hood's is in Russian; DM descriptions in this fork are
  English and the translation layer lives in `modular_abel/localization/`.
- **Sellprices and triumph costs are invented.** A plain crest is 50 triumphs, the three showy
  ones (dragon, afreet, bloodied star, gilded skull) are 75, the cloaks and the silk hood 100.

## Art

Three sheets merged with `modular_abel/tools/dmi_merge.py` from five donor sheets, using the
`state -> state` form so the per-species cells came along:

| Sheet | Cells | Sources |
| --- | --- | --- |
| `twilight_wardrobe_world.dmi` | 32x32, 29 states | `onhelm.dmi`, `head.dmi`, `masks.dmi`, `kazengun_n_burger.dmi`, `cloaks.dmi` |
| `twilight_wardrobe_onmob.dmi` | 32x32, 21 states | the `onmob/` siblings of the above |
| `twilight_wardrobe_onmob48.dmi` | 32x48, 16 states | `onmob/32х48/onhelm.dmi`, `onmob/head_48.dmi` |

The crests and the antlers are 32x48 worn art, which is why they are on their own sheet —
`dmi_merge.py` refuses to mix cell sizes, and mixing them would silently misalign every cell.
Note that the donor's directory is spelled `32х48` with a **Cyrillic х**; the path only
resolves if that character is preserved.

## Rules this module follows

Cosmetic only — no `armor_type`, no coverage, nothing mechanical. Mechanical content goes
through a morphing elixir instead, per `modular_abel/snouted_helms/README.md`.

## Batch 2

18 more entries, mostly the eastern and Etruscan wardrobe the fork keeps in its own overlay:
desert hood (the partner to the desert cloak), rice hat, elven veil, wanderer's hat,
conquistador mask, etruscan doublet, gasa, hakama, haori, kamishimo, kazengun jacket, four
kazengun masks (half, kitsune, oni, ogre), hammerhold hat, leopard pelt cloak and the
inquisitorial bandolier.

A fourth and fifth sheet joined the module for these: `twilight_wardrobe_onmob64.dmi` (the
gasa's 64x64 worn art) and a sleeves sheet for the four shirts.

**Three things were dropped during this batch, each for a stated reason:**

- **the etruscan poncho and the noviciate robe.** Their art is not Twilight's own — both live
  in the Azure-inherited `icons/clothing/donor_clothes.dmi` — and the fork's copy of the worn
  sheet carries only `_f` cells for them, no base state. A garment with no male worn sprite is
  half an item; if they are wanted, take them from Azure-Peak, which has the full set.
- **the hakama's sleeves.** Its `sleeved` points at the upstream `helpers/sleeves_pants.dmi`,
  which has no `hakama` cells at all in this checkout, so the var is left unset and the
  trousers inherit their parent's leg rendering.

Everything here still hangs off a cosmetic Vibelin parent; the kazengun masks are
`/obj/item/clothing/face`, not the armoured facemask type, for the reason the first batch's
masks are.

## Batch 3

14 more entries. Four more eastern travelling hats join the gasa on the 64x64 worn sheet
(roningasa, sandogasa, torioigasa, tengai), together with the war scholar's pashmina, the
mask of thorns, the blessed blindfold, the yoroihitatare, the Eoran robe in blue and rose,
the elven suit, and the hammerhold shirt, cape and shoes.

**Four candidates were cut during this batch**, each after looking at the art rather than
the name:

- **the stargazer robe, its hood and the armoured owl mask.** Their `icon` resolves to the
  *worn* sheet (`clothing/onmob/stargazer_outfit.dmi`) because no ancestor sets an inventory
  sheet. Porting them would mean shipping a garment whose inventory sprite is a mob overlay.
- **the sage's big hat** (`donor_clothes_46x32.dmi`, 46x32 cells) and **the nightmare tears
  crown** (`nightmare_set.dmi`, 32x48 *world* cells). Both would need a fourth and fifth
  world sheet at their own cell size; `dmi_merge.py` will not mix sizes and neither will
  BYOND.
- **the golden and silver confessor masks.** `inquisition_overseer.dmi` is not at the path
  their types name in this checkout, so there is nothing to merge from.

The sheets now hold 71 world states, 136 worn, 23 at 32x48, 5 at 64x64 and 98 sleeve cells.

## Batch 4

Two: the commandant's cloak and the Eoran tabard.

Three more were looked at and left: the closed confessor hood and the ascension cloak both
resolve their `icon` to something that is not a sheet in this checkout (a directory, and a
path under `code/`), and the Grenzelhoftian mages vest is Azure-inherited art with the same
`_f`-only worn cells that cost the poncho and the noviciate robe their place in batch 2.

Sheets: 73 world, 142 worn, 23 at 32x48, 5 at 64x64, 98 sleeve cells.
