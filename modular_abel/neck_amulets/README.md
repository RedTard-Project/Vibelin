# neck_amulets — gold and silver carved gem amulets

Ported from `C:\RedTardProject\Azure-Peak-Fork` (`Azure-Peak/Azure-Peak`), added upstream
after Vibelin PR #5. Source: `code/modules/clothing/rogueclothes/neck.dm`.

Batch 1 of the clothing port.

## What is ported

16 amulets — the same eight stones in a silver and a gold setting — plus a fur scarf that
lived in the same file.

Vanderlin already carries the plain stone amulets (`/obj/item/clothing/neck/jadeamulet` and
friends, `icon_state` `"amulet_*"`) and the bare metal ones (`goldamulet`, `silveramulet`).
These are the precious-metal *settings* of those stones, which it did not have.

They keep Azure's dual-slot behaviour: wearable on the neck or the wrist, with the worn
overlay swapping to the wrist sheet.

## Adaptations made during the port

- **Path.** Azure's `/obj/item/clothing/neck/roguetown/carved/*` becomes
  `/obj/item/clothing/neck/carved/*` — Vanderlin dropped the `roguetown` segment from
  clothing paths.
- **Gem names follow Vanderlin, not Azure.** Azure calls them jade / cerulite / coral;
  here they are joapstone, ceruleabaster and heartstone, so these read as the same materials
  as the amulets already in game.
- **Slot swap simplified.** Azure's `mob_can_equip` override checks `SLOT_WRISTS` and also
  reassigns `sleeved`. Vanderlin uses `ITEM_SLOT_WRISTS`, and these are neck/wrist trinkets
  with no sleeve component, so only `mob_overlay_icon` is swapped.
- **Dropped Azure-only vars:** `no_loot_taint`, `experimental_onhip`, `anvilrepair`,
  `possible_item_intents` — none exist here.
- **Recipes added, which Azure does not have.** Azure ships these as pure loot. Vanderlin
  makes every other amulet craftable and its `craftable_clothes` unit test enforces that
  every garment has a recipe, so rather than take an exemption they get anvil recipes in the
  same shape as the existing valuables: a precious ingot plus the matching cut gem. The fur
  scarf is a sewing recipe. **The recipe costs are invented, not ported.**
- **Sellprices** (90 silver / 140 gold) sit above the plain stone amulets' 60. Also invented.

## Assets

Three sheets extracted from Azure, none of whose states Vanderlin carries:

| File | From | States |
| --- | --- | --- |
| `icons/amulets_world.dmi` | `icons/roguetown/clothing/neck.dmi` | 17 |
| `icons/amulets_onmob.dmi` | `icons/roguetown/clothing/onmob/neck.dmi` | 18 |
| `icons/amulets_wrists.dmi` | `icons/roguetown/clothing/onmob/wrists.dmi` | 31 |

## Loadout

`loadout.dm` registers these in the donator loadout panel under the **Azure Content** tab (`ui_category = LOADOUT_PANEL_CATEGORY_AZURE`) — 17 entries (the 16 settings plus the fur scarf). See `modular_abel/loadout_panel/README.md`.
