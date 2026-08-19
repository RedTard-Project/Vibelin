# character_setup — the modular character menu

Replaces the upstream character-setup browser window with a modular one
(`code/modules/client/preferences/character_menu.dm` in this folder), plus the smallclothes
system, the topic census instrumentation and the modular preference hooks.

## Topic routing

`process_link()` handles the menu's own hrefs and then **must** fall through to `. = ..()`.
Job priority, antag toggles, body markings, descriptors, customizers and `role_settings` are
all core browser-prefs owned by the upstream handler; an early `return TRUE` for an unhandled
key swallows them with no error and no runtime — which is how job priority and antag toggles
silently stopped applying once before. The upstream handler only `CRASH`es on a genuinely
invalid key, so falling through is safe.

## Preference persistence

The smallclothes module loads through the upstream `_load_appearence(savefile)` hook and saves
in a `save_character()` override. Three other modules do the same (`erp`, `races/taur`,
`loadout_panel`), so one character save currently opens the savefile several times over.

## Topic census

The topic census moved out of this module into `modular_abel/telemetry/`, together with the new
tgui census. Its three call sites in `code/modules/client/client_procs.dm` are unchanged — the
procs it calls are global, so only the file location moved.
