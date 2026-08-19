# facemasks — padded, leather and chainmaille face masks

Ported from `C:\RedTardProject\Azure-Peak-Fork` (`Azure-Peak/Azure-Peak`), added upstream
after Vibelin PR #5. Source: `code/modules/clothing/rogueclothes/mask.dm`.

Batch 2 of the clothing port.

## What is ported

Six masks: padded cloth, padded leather, and iron/steel chainmaille each with a fluted
variant. Vanderlin's `/obj/item/clothing/face/facemask` family was all rigid metal and carved
stone; this fills in the soft and maille end of it.

## Adaptations made during the port

- **Path.** Azure's `/obj/item/clothing/mask/rogue/facemask/*` is `/obj/item/clothing/face/facemask/*` here.
- **Armour.** Azure sets `armor = ARMOR_PADDED` inline with `ARMOR_INT_MASK_*` integrity
  constants. Vanderlin uses `armor_type = /datum/armor/...` datums and plain numbers, and has
  none of those constants, so padded/leather ride `/datum/armor/mask/padded`, maille rides
  `/datum/armor/mask/metal`. Integrity follows the surrounding Vanderlin masks (iron sits at 100).
- **Recipes added, which Azure does not have** — soft masks are sewn, maille masks forged from
  the matching ingot plus cloth. Required by `craftable_clothes`; costs are invented.

## Not ported from this batch, and why

- **Spectacles (`fancy`, `fancy_dark`) and the turban** — Vanderlin already has all three.
- **Eight snouted/visored helmets** — `bascinet/pigface`, `heavy/banneret`,
  `heavy/knight/armet` and `sallet/visored` do not exist in Vanderlin at all, so these
  variants have no parent to hang off. Porting them means porting those four helmet families
  first, which are older Azure content rather than anything new since PR #5.
- **`heavy/nochelm/snouted` and `heavy/volfplate/psydonic`** do have parents here and are
  straightforward; they are held back to keep this batch to one coherent group.
- **Flavoured rollies (apple, menthaapple)** — belong with the smoking content rather than clothing.

## Not in the loadout

These are not reskins — each mask carries its own `armor_type`, `max_integrity` and
`prevent_crits`, so handing them out from the donator panel would be handing out gear. They
stay craft-only: soft masks are sewn, maille masks are forged. See
`modular_abel/loadout_panel/README.md` for the rule.

## Assets

| File | From | States |
| --- | --- | --- |
| `icons/masks_world.dmi` | Azure `icons/roguetown/clothing/masks.dmi` | 6 |
| `icons/masks_onmob.dmi` | Azure `icons/roguetown/clothing/onmob/masks.dmi` | 6 |

