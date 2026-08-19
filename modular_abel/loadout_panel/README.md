# loadout_panel — the donator loadout panel

The "Лодаут" window players reach from the character menu (`donor_loadout` topic in
`modular_abel/character_setup/.../character_menu.dm`). It is a slot-limited free-pick panel:
picks are saved to the character savefile and handed out from the round's stash
(right-click a statue or a tree), not paid for with triumphs.

It is deliberately **not** the upstream triumph shop (`code/datums/shop/`), which has its own
window and its own currency. The two are independent.

## Files

| File | Holds |
| --- | --- |
| `_defines.dm` | tab names and the per-tier slot counts |
| `config.dm` | the `BOOSTYURL` config entry behind the "Поддержать сервер" button |
| `prefs.dm` | `/datum/preferences` state, slot sizing, savefile persistence |
| `access.dm` | `panel_donator` and `panel_block_reason()` — the single availability check |
| `panel.dm` | the `/datum/loadout_panel` tgui datum |
| `apply.dm` | handing the picks to the round's stash |
| `spritesheet.dm` | the 128x128 batched icon sheet the window renders from |

The tgui side is `tgui/packages/tgui/interfaces/LoadoutPanel.tsx`.

## Slots

`get_panel_loadout_size()` reads `client.patreon.access_rank`:

| Rank | Slots |
| --- | --- |
| none | `LOADOUT_PANEL_SLOTS_BASE` (3) |
| T1 `ACCESS_THANKS_RANK` | 7 |
| T2 `ACCESS_ASSISTANT_RANK` | 11 |
| T3 `ACCESS_COMMAND_RANK` | 17 |
| T4 `ACCESS_TRAITOR_RANK` | 21 |
| T5 `ACCESS_NUKIE_RANK` | 27 |

The window's tier tooltips are rendered from `slotTiers` in `ui_static_data`, so the numbers
live in `_defines.dm` only and cannot drift between the two sides.

## Availability

`panel_block_reason(client)` is the only place that decides whether a client may take an item,
and both the tile rendering and the `add` action call it. Adding a new restriction means
editing that one proc. It rejects, in order: `LOADOUT_FLAG_NO_EQUIP`,
`LOADOUT_FLAG_GIVEAWAY_ONLY`, `LOADOUT_FLAG_PATREON_LOCKED` without donator status, and an
unmet `required_award`.

## Tabs

`build_categories()` emits, in order:

1. **Всё** — every equippable item.
2. **Донат** — everything with `panel_donator = TRUE`, whatever its `ui_category`.
3. **Azure Content** — `LOADOUT_PANEL_CATEGORY_AZURE`, the wearables ported from Azure-Peak.
4. Every other `ui_category` (the upstream ones: Shirts, Pants, Armor, Hats, …).

To put a modular item in the Azure tab, declare its loadout datum in that module's own
`loadout.dm` with `ui_category = LOADOUT_PANEL_CATEGORY_AZURE` and include the file from the
module's `_<module>.dm`. `loadout_panel/_loadout_panel.dm` is included before those modules in
`modular_abel/_module.dm`, so the define is always in scope.

## Persistence

`panel_loadout_items` is a list of type-path strings on `/datum/preferences`. It loads through
the upstream `_load_appearence(savefile)` hook (no second savefile handle) and saves in a
`save_character()` override. `clean_panel_loadout()` runs when the window is opened — not on
character load — so a donator whose patreon data has not finished loading does not get their
loadout wiped.
