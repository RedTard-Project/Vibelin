# ceramics — fired clay vessels

Ported from `C:\RedTardProject\Azure-Peak-Fork` (`Azure-Peak/Azure-Peak`), added upstream
after Vibelin PR #5 (2026-07-30). Sources:

- `code/game/objects/items/rogueitems/ceramics.dm` — the vessels
- `code/modules/roguetown/roguecrafting/ceramics.dm` — the wheel recipes

## What is ported

Five vessels and their pottery-wheel recipes:

| Vessel | Clay | Difficulty | Volume |
| --- | --- | --- | --- |
| skinny ceramic vase | 2 | 1 | 35 |
| ceramic bamana pot | 3 | 2 | 130 |
| tall ceramic vase | 3 | 2 | 160 |
| standing ceramic vase | 3 | 3 | 100 |
| ceramic amphora | 4 | 3 | 200 |

## Adaptations made during the port

- **Two systems, not one.** Azure's ceramics is two-stage: a wheel recipe produces an unfired
  `/obj/item/natural/clay` subtype, and a kiln fires it into the finished vessel. Vanderlin
  already has its own pottery wheel (`code/datums/pottery_recipes/`, driven by
  `/obj/structure/pottery_lathe`) which hands back the finished piece directly. Only the
  fired halves are ported; the recipes are `/datum/pottery_recipe` entries.
- **Clay cost becomes throwing steps.** Vanderlin's wheel consumes one `recipe_steps` entry
  per unit of clay, each with its own time in `step_to_time`, so Azure's `reqs` count maps
  onto that many steps.
- **Difficulty rescaled.** Azure grades these `craftdiff` 1–5. Vanderlin feeds difficulty
  into `success_chance = 25 * ((skill - difficulty) + 1)` and its own recipes sit at 0–1, so
  the Azure spread is compressed to 1–3. A literal 5 would be unthrowable below master skill.
- **Glazing dropped.** `glaze_bonus_pct` / `GLAZE_BONUS_PCT` belong to Azure's glazing
  mechanic, which has no Vanderlin equivalent.
- **Sellprices** follow the surrounding Vanderlin containers, scaled by size. **These are
  invented balance numbers, not ported ones** — Azure leaves them unset.

## Not ported

- **Clay mug** — Vanderlin already has `/datum/pottery_recipe/mug`.
- **Clay box** — fires into a porcelain storage container Vanderlin has no equivalent for;
  it would need the container ported first.
- **Clay carafe** — Azure fires it into `/obj/item/reagent_containers/glass/carafe/porcelain`,
  which does not exist here. Vanderlin's `/datum/pottery_recipe/decanter` covers the same niche.
- Azure's glass-blowing branch of the same file (`ceramics/glass`), which needs its smelter
  and blowrod.

## Assets

`icons/ceramics.dmi` holds the five fired-vessel sprites extracted from Azure's
`icons/roguetown/items/cooking.dmi`; Vanderlin's own `cooking.dmi` carries none of them.
