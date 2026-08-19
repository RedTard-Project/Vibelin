# loadout_panel — the donator loadout panel

The "Лодаут" window players reach from the character menu (`donor_loadout` topic in
`modular_abel/character_setup/.../character_menu.dm`). It is a slot-limited free-pick panel:
picks are saved to the character savefile and handed out from the round's stash
(right-click a statue or a tree), not paid for with triumphs.

It is deliberately **not** the upstream triumph shop (`code/datums/shop/`), which has its own
window and its own currency. The two are independent but read the same `GLOB.loadout_items`.

Everything lives in `_loadout_panel.dm`; the tgui side is
`tgui/packages/tgui/interfaces/LoadoutPanel.tsx`.

## The key contract

`GLOB.loadout_items` (`code/datums/loadouts/_base_loadout_item.dm`) is keyed by the
**`/datum/loadout_item` subtype path**, not by the item the entry grants. Everything the panel
sends to the frontend, stores in `panel_loadout_items`, and files into the spritesheet uses
that key:

| Place | Value |
| --- | --- |
| `build_item_entry` → `"path"` | `"[loadout_datum_path]"` |
| `build_item_entry` → `"iconClass"` | `sanitize_css_class_name("[loadout_datum_path]")` |
| `create_spritesheets` → `insert_icon` id | `sanitize_css_class_name("[loadout_datum_path]")` |
| `panel_loadout_items` entries | `"[loadout_datum_path]"` |

Emitting the granted item's path instead makes every `add`/`remove` a silent no-op, because
`GLOB.loadout_items[text2path(...)]` then never resolves. That was the case from the panel's
first commit until it was found by `/datum/unit_test/modular_loadout_roundtrip`, which asserts
exactly this invariant — keep it green.

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

The window's tier tooltips render from `slotTiers` in `ui_static_data`, so the numbers live in
the defines only and cannot drift between the two sides.

**`access_rank` is not trustworthy.** `/datum/patreon_data/New` returns early when
`SSdbcore.IsConnected()` is false, leaving `access_rank` at 0 while `owned_rank` is set to
`NUKIE_RANK` — so on a DB-less round every client reads as a donator with 3 slots. Nothing may
delete saved picks on the strength of that number. `clean_panel_loadout()` therefore removes
only entries whose loadout datum no longer resolves; a loadout that is over the current limit
is left alone, warned about, and capped at spawn by `apply_panel_loadout()`.

## Availability

`panel_block_reason(client)` is the only place that decides whether a client may take an item,
and both the tile rendering and the `add` action call it. Adding a restriction means editing
that one proc. It rejects, in order: `LOADOUT_FLAG_NO_EQUIP`, `LOADOUT_FLAG_GIVEAWAY_ONLY`,
`LOADOUT_FLAG_PATREON_LOCKED` without donator status, and an unmet `required_award` (an absent
client counts as unmet).

## Tabs

`build_categories()` emits, in order:

1. **Всё** — every equippable item.
2. **Донат** — everything with `panel_donator = TRUE`, whatever its `ui_category`.
3. **Azure Content** — `LOADOUT_PANEL_CATEGORY_AZURE`, the cosmetics ported from Azure-Peak.
4. Every other `ui_category` (the upstream ones: Shirts, Pants, Armor, Hats, …).

To put a modular item in the Azure tab, declare its loadout datum in that module's own file
with `ui_category = LOADOUT_PANEL_CATEGORY_AZURE`. `loadout_panel/_loadout_panel.dm` is
included before those modules in `modular_abel/_module.dm`, so the define is always in scope.

Anything mechanical belongs there as a morphing elixir rather than as the item itself — see
`modular_abel/snouted_helms/README.md`.

## Persistence

`panel_loadout_items` is a list of type-path strings on `/datum/preferences`. It loads through
the upstream `_load_appearence(savefile)` hook (no second savefile handle) and saves in a
`save_character()` override, which the panel calls only when an action actually changed the
list.

## Tests

`modular_abel/tests/_tests.dm` covers this module: `modular_loadout_roundtrip` (the key
contract above), `modular_loadout_panel` (abstract targets, duplicate names, spritesheet id
collisions, missing icons, a non-empty Azure tab), `modular_loadout_slots` (the tier table
matches the defines and increases), and `modular_stash_naming` (duplicate picks get distinct
stash entries).
