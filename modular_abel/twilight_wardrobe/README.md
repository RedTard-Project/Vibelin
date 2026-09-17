# twilight_wardrobe — donator cosmetics ported from Twilight Axis

20 purely cosmetic garments and 20 loadout entries, sourced from the Twilight Axis fork's own
overlay (`modular_twilight_axis/icons/...`). Like `azure_wardrobe`, one entry feeds both the
triumph shop and the free loadout panel, because both read `GLOB.loadout_items`.

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
