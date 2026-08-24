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

## Interface themes

`tgui_theme.dm` owns the theme picker. `GLOB.tgui_themes` is the single source of truth — DM
validates against it, and the picker in `PreferencesMenu.tsx` renders whatever the server sends
in `data["tgui_themes"]`, so the two lists cannot drift.

Only two themes ship: **Grim** (`tgui/packages/tgui/styles/themes/grim.scss`) and **Vibelin**
(`vibelin.scss`, the same structure with a gold-on-black palette). Both are loaded from
`tgui/packages/tgui/styles/main.scss`.

The picker used to offer eleven more (Default, Paper, Neutral, Retro, Hackerman, Syndicate,
Wizard, Malfunction, Cardtable, Abductor, NtOS, Admin) and every one of them broke the window.
Those classes come from `tgui-core`, and they only set the handful of variables upstream /tg/'s
components need — `.theme-hackerman:root` defines nine, and none of them are `--color-text`,
`--button-background-default`, `--section-separator-color`, `--titlebar-text` or
`--font-family`, all of which this fork's Grim-derived components require. Selecting one left
those variables unset and the UI fell back to raw defaults. "Default" was worse still: it sent
`nanotrasen`, and no `.theme-nanotrasen` class exists in the bundle at all.

So a new theme has to be a complete one: copy `vibelin.scss`, set every variable it sets, load
it from `main.scss`, and add it to `GLOB.tgui_themes`. Adding a bare `tgui-core` theme name to
that list will reproduce the original bug.

`sanitize_tgui_theme()` falls anything unknown back to `TGUI_THEME_DEFAULT`, both when the
savefile loads and when the client sends a theme, so an old save holding `hackerman` heals
itself on next login and a crafted href cannot set an arbitrary class.

The theme also reaches **every** tgui window now, not just this one. Upstream
`/datum/tgui/get_payload` hardcodes `"theme" = "grim"` (`code/modules/tgui/tgui.dm:262`);
`tgui_theme.dm` overrides `get_payload` and rewrites `config.window.theme` from the player's
preference after `..()` runs. That is a second same-type redefinition of the same proc — the
telemetry module also chains one — which BYOND resolves by running them in include order,
outermost last.

Rebuild the bundle after touching any `.scss`: `bun run tgui:build` from `tgui/`.
