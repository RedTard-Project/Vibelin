# woodcarving — carved wooden trinkets

Ported from `C:\RedTardProject\Azure-Peak-Fork` (`Azure-Peak/Azure-Peak`), added upstream
after Vibelin PR #5 (2026-07-30). Sources:

- `code/game/objects/items/rogueitems/wood_items.dm` — the `/obj/item/carvedwood` family
- `code/game/objects/items/rogueitems/waterskin.dm` — the wooden bottle
- `code/modules/roguetown/roguecrafting/crafting/woodcarving.dm` — the recipes

Vanderlin's own carving system (`code/modules/crafting/quality_of_crafting/carving.dm`)
covers gemstones only — amber, coral, joapstone, onyxa, opal, rose, shell, turquoise — so
nothing here overlaps with existing content.

## Contents

27 carved wooden items plus a wooden bottle, and 28 recipes to make them. You hold a knife,
click a stick or a small log, and pick the piece.

| Stock | Tier | Pieces |
| --- | --- | --- |
| stick | novice (`craftdiff 0`) | marble, spire, display stand, comb, cameo, prism |
| stick | apprentice (`craftdiff 1`) | figurine, elf figurine, wildkin figurine, fish, frog, duck, saiga, zigtray, heart |
| stick | journeyman (`craftdiff 2`) | sun, moon |
| small log | apprentice (`craftdiff 1`) | box, vase, game board, plinth |
| small log | journeyman (`craftdiff 2`) | pillar, vessel, fancy vase |
| small log | expert (`craftdiff 3`) | shrine, bust, beaver statuette, bottle |

## Adaptations made during the port

- **Recipe framework.** Azure uses `/datum/crafting_recipe/roguetown` with
  `reqs` / `tools` / `result`. Vanderlin uses `/datum/repeatable_crafting_recipe` with
  `requirements` / `tool_usage` / `starting_atom` / `attacked_atom` / `output`. The recipes
  are re-expressed accordingly, following the gemstone carving recipes as the model — the
  knife is both `starting_atom` and the entry in `tool_usage`, exactly as the jade recipes do.
- **Difficulty scale.** Azure's `craftdiff` holds a `SKILL_LEVEL_*` constant (10/20/30/40).
  Vanderlin's `craftdiff` is a small integer where each point costs 25% craft chance, and the
  gemstone recipes grade themselves 0–2. The four Azure tiers map one-for-one onto 0/1/2/3.
- **Dropped item vars.** `has_item_quality`, `is_carved` and `was_crafted` belong to Azure's
  item-quality system and have no equivalent here.
- **Tool path.** Azure's `/obj/item/rogueweapon/huntingknife` is Vanderlin's
  `/obj/item/weapon/knife` (`subtypes_allowed` is on, so any knife works).
- **Sellprices.** Azure leaves these at 0, which makes them worthless to the merchant
  economy. They are priced here following the `/obj/item/carvedgem` convention, scaled well
  below stone — 2–4 for whittled trinkets up to 18–20 for an expert bust. **These are
  invented balance numbers, not ported ones**; adjust freely.

## Bugs found in the Azure source, fixed here

- `/obj/item/carvedwood/shrine` declares `icon_state = "shrine_wood"`, but the sprite in
  Azure's own `carvedwood.dmi` is stored as `wood_shrine`. The item renders broken upstream.
  Corrected to `wood_shrine`.

## Assets

`icons/carvedwood.dmi` is Azure's `icons/roguetown/items/carvedwood.dmi` with `bottle_wood`
and `bottle_wood_cork` merged in from its `icons/roguetown/items/cooking.dmi`, since
Vanderlin's `cooking.dmi` does not carry those states.
