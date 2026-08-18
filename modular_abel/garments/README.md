# garments — dresses, robes, a winter coat, a toga and a formal skirt

Ported from `C:\RedTardProject\Azure-Peak-Fork` (`Azure-Peak/Azure-Peak`), added upstream
after Vibelin PR #5. Sources: Azure's rogueclothes `shirts.dm`, `robes.dm`, `cloaks.dm` and
`pants/skirt.dm`, plus the sewing half of `roguecrafting`.

Batch 3 of the clothing port. It also absorbs batch 4 (sewing recipes), since those recipes
exist to make exactly these garments.

## What is ported

11 garments and a sewing recipe for each: blue / green / tavern dresses, a nightgown, the
leopard bathrobe and its open variant, lunar and magician's robes, a winter coat, a toga and
a formal skirt.

## Adaptations made during the port

- **Paths.** Azure's `/obj/item/clothing/suit/roguetown/shirt/*` is `/obj/item/clothing/shirt/*`
  here, and its `/obj/item/clothing/under/roguetown/skirt/*` lives under
  `/obj/item/clothing/pants/skirt/*` — Vanderlin files skirts with trousers.
- **Recipe framework.** Azure's `/datum/crafting_recipe/roguetown/sewing/*` (reqs/result)
  becomes `/datum/repeatable_crafting_recipe/sewing/*` — needle in hand, click the cloth.
  Difficulty uses Vanderlin's 0–6 scale, not Azure's `SKILL_LEVEL_*` constants.
- **Cloth costs** follow Azure where it states them and the neighbouring Vanderlin sewing
  recipes otherwise. **Costs and sellprices are invented, not ported.**
- **Gowns carry no sleeves.** The four dresses have no sleeve state in any Azure sheet, so
  they set no `sleeved` and inherit the parent's sleeve status. Only the robes, the coat and
  the bathrobe needed sleeve sprites.

## Bugs found in the Azure source

- `/obj/item/clothing/cloak/tabard/toga/dress/alt` ("bared toga") declares
  `icon_state = "toga_f_alt"`, but no such state exists in Azure's `cloaks.dmi` or its onmob
  sheet. The item renders broken upstream, so the plain toga is ported and the bared variant
  is left out rather than shipped as a missing sprite.

## Not ported from this batch, and why

- **Courtesan dress and blouse** — Vanderlin already has both.
- **`cloak/tabard/psydontabard/white` and its alt** — `/obj/item/clothing/cloak/tabard/psydontabard`
  does not exist here, so they have no parent. Same blocker as the batch-2 helmets.

## Assets

| File | From | States |
| --- | --- | --- |
| `icons/garments_world.dmi` | Azure `shirts.dmi`, `armor.dmi`, `cloaks.dmi`, `pants.dmi` | 11 |
| `icons/garments_onmob.dmi` | the matching Azure `onmob/` sheets | 11 |
| `icons/garments_sleeves.dmi` | Azure `onmob/helpers/sleeves_shirts.dmi`, `sleeves_armor.dmi` | 5 |
