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

Only two themes ship: **Vibelin** (`tgui/packages/tgui/styles/themes/vibelin.scss`, the house
theme and the default) and **Grim** (`grim.scss`, the red-on-black original it was derived
from). Both are loaded from `tgui/packages/tgui/styles/main.scss`.

`TGUI_THEME_DEFAULT` is `vibelin`, and it is the fallback in all four places a theme can come
from: `sanitize_tgui_theme()`, the `get_payload` override, `PreferencesMenu.tsx`'s prop, and
`Layout.tsx`'s default prop — that last one used to be `nanotrasen`, a class with no stylesheet
anywhere in the bundle.

`character_setup_tgui_theme` is `null` until the player actually picks something, and every
read resolves through `sanitize_tgui_theme()`. Nothing stores the default, so "no choice made"
stays representable and the default can be changed later without touching a single savefile.

One caveat for savefiles written before 2026-08-24: `client/New()` calls `save_preferences()`
on every non-admin login, and the old code defaulted the var to `"grim"`, so those files hold a
literal `grim` that nobody chose. Those players keep Grim until they pick something. There is no
way to tell that apart from a real choice after the fact — moving them across would need a
deliberate one-time reset.

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
`/datum/unit_test/modular_tgui_themes` holds that contract: the default must be a listed theme,
every entry must have a label, and unknown or null input must fall back.

No modular interface pins its own theme any more: `EroticRolePlayPanel.tsx` used to hardcode
`theme="grim"` and now inherits, and `LoadoutPanel.tsx` never set one. They all follow the
player's choice.

The theme also reaches **every** tgui window now, not just this one. Upstream
`/datum/tgui/get_payload` hardcodes `"theme" = "grim"` (`code/modules/tgui/tgui.dm:262`);
`tgui_theme.dm` overrides `get_payload` and rewrites `config.window.theme` from the player's
preference after `..()` runs. That is a second same-type redefinition of the same proc — the
telemetry module also chains one — which BYOND resolves by running them in include order,
outermost last.

Rebuild the bundle after touching any `.scss`: `bun run tgui:build` from `tgui/`.

## Text size and spacing

The same `Interface Theme` panel carries two per-player readability knobs, font size and line
spacing, stored as `character_setup_tgui_font_size` / `character_setup_tgui_line_height` on
`/datum/preferences` and clamped by `sanitize_tgui_font_size()` / `sanitize_tgui_line_height()`
in `tgui_theme.dm`.

Both are **null until the player picks something**, exactly like the theme var, and null means
"whatever the theme says". The `get_payload` override only adds `font_size` / `line_height` to
the window config block when they are set, `Layout.tsx` only writes them onto
`document.documentElement` when they arrive and *removes* them otherwise - so a player who never
touches the control sees the same CSS as before the feature existed. The reset button sends the
action with no value at all, which the sanitizers read back as null.

The two knobs reach the document by different routes, because the stylesheets are not symmetric:

- **font size** is written as the `--font-size` custom property, because `reset.scss` already
  reads `font-size: var(--font-size, 12px)` for `html, body`. An inline custom property on
  `documentElement` outranks the `.theme-x:root` declaration, so the player's value wins over
  the theme's `14px`.
- **line spacing** is written as a real `line-height` property, because **nothing in the bundle
  reads `--line-height`** - both themes declare it and no rule consumes it. Wiring that dead
  variable up instead would have switched every window to `170%` for everyone, which is not what
  the interface looks like today. `TGUI_LINE_HEIGHT_DEFAULT` is therefore `120`, the browser's
  own `normal`, and it is only the stepper's starting point - it is never applied on its own.

`TGUI_FONT_SIZE_DEFAULT` (14) mirrors `--font-size` in `vibelin.scss` / `grim.scss` and is also
only a starting point; if a theme ever changes its font size, change it here too or the first
click will jump. The bounds are sent to the frontend by `tgui_text_bounds()` rather than
duplicated in `PreferencesMenu.tsx`, for the same reason the loadout slot tiers are sent: the
numbers live in the defines only.

Because the payload override runs for **every** tgui window and not just the character menu,
these two settings apply to the whole interface, exactly like the theme does.

## The preview map controls (the black rectangle, and the doll sitting on top of the UI)

The three previews are real BYOND **map controls** parented to the tgui window, not images:
`character_setup_ensure_view()` creates three `/atom/movable/screen/map_view`s, and the
interface asks BYOND to create a child control over each box. A child control is a native
window drawn *over* the browser, so wherever it is placed, it wins.

`tgui-core`'s `ByondUi` measures its box **once, on mount**, and after that only re-places
the control on a `window resize` event — its effect's dependency array is empty, so a
changed `zoom` never re-places it either. Mount happens while the window is still laying
out (a `PreferencesMenu` payload is 130-140 KB and the tgui assets are still arriving), so
the rectangle it reads is the pre-layout one: the control lands at roughly `0,0` at close
to half the window's width and never moves, because nothing resizes the window afterwards.
That is both reports — "a black square covers about half the tgui window" (the control's
`background-color` is `#0d0d0d`) and "everything piles onto the doll" (the same control
covering the nav column and the Looking Glass).

The 2026-09-15 round log has both the healthy and the broken geometry:
`[GEOMETRY] main=486x593 ... front=0x0 side=0x0` immediately after open, and
`[CTRL] ... MAP id=character_setup_main_..._map ... pos=399,192; size=607x740` once it had
settled.

`PreferencesMenu.tsx` used to paper over this by dispatching synthetic `resize` events at
200 ms, 600 ms and 1500 ms. If the layout settled after the last one, the control stayed
wrong for the life of the window.

`interfaces/_common/ByondMapView.tsx` replaces `ByondUi` for all three. It:

- re-places on a `ResizeObserver` over both its own box and `document.body`, on `resize`,
  on capture-phase `scroll`, on `load` and on `visibilitychange`, plus a retry ladder out
  to 3.2 s for the asset-load window;
- re-places when `params` change (so a new `zoom` actually arrives) without tearing the
  control down — control creation and destruction are keyed on the control id alone, in a
  separate effect, so a zoom change never unparents and recreates the map;
- keeps the control `is-visible=false` until the same non-zero rectangle has been read
  twice in a row. A control that has never had a real rectangle is never shown, which is
  what stops the stray black rectangle from being painted at all.

The synthetic-resize effect is gone. The `previewBoxPx` measurement effect stays — it is
what feeds `previewZoom`, and is a different concern.

The Looking Glass column is `basis="260px"` (it was `520px`). The doll box inside it is
still `82%` wide at a `0.82/1` aspect ratio, so halving the column halves the doll on both
axes as asked.

Rebuild the bundle after touching any of this: `bun run tgui:build` from `tgui/`.

## The preview controls outlive the menu (black rectangles over other interfaces)

Reported as "TGUI artifacts": three black rectangles painted over an unrelated interface — in
the field report, a `SpellBook` window. They are the chargen preview maps.

A `map_view` is two things with two owners. DM owns the **content** — the
`/atom/movable/screen/map_view` object registered on the client by `register_map_obj()`. The
frontend owns the **control** — the BYOND skin element `ByondMapView` creates with
`winset(id, {parent: <window>, type: 'map', …})`. `clear_map()`
(`code/_onclick/hud/map_popups.dm`) only unregisters screen objects; it never touches the skin
element.

So `character_setup_teardown_view()` used to destroy the content and leave three controls
parented to the window, `is-visible=true`, at their last geometry. The round log shows that
state immediately before a teardown:

```
[CTRL] post_display MAP id=character_setup_main_…_map  winget=parent=tgui-window-1;…;pos=301,156;size=321x391;is-visible=true
[CTRL] post_display MAP id=character_setup_front_…_map winget=parent=tgui-window-1;…;pos=7,797;size=119x119;is-visible=true
[CTRL] post_display MAP id=character_setup_side_…_map  winget=parent=tgui-window-1;…;pos=133,797;size=119x119;is-visible=true
[LIFECYCLE] ui_close user=…
[VIEW] teardown map=character_setup_main_…_map user=…
```

tgui windows are pooled, so `tgui-window-1` goes to the next interface with those three
controls still attached — and a BYOND child control composites *over* the WebView, so whatever
is drawn underneath is simply not visible. One tall rectangle plus two small squares side by
side near the bottom left, which is what the report shows.

Two things were missing, and both are now in place:

- **`character_setup_release_control()`** winsets `is-visible=false;parent=` for each view
  before `hide_from()`. DM decides when the preview dies and knows the control ids, so DM
  releases them; this runs whatever the client does.
- **`ByondMapView` releases on `beforeunload`/`pagehide`.** `tgui-core`'s `ByondUi` clears the
  control on unmount *and* on `beforeunload`; the local replacement kept only the unmount path.
  React unmount does not run when the window is destroyed outright (`browse(null)`) rather than
  suspended, which is exactly the case the unmount path cannot cover.

Neither half is redundant: the DM half covers a client that never processes the teardown, the
frontend half covers a menu closed without DM's `ui_close` having run first.

## Payload split and op timing

`ui_data()` was 53 KB per partial payload with `static=0`, resent on every update — 423 payloads
and 23.3 MB in one round for two clients (`modular_abel/telemetry/README.md`). The heavy blocks
were already memoised in `character_setup_ui_heavy_cache`, so they were not being *rebuilt*; they
were being re-serialised and re-sent. Caching the build is the wrong axis: what costs is the wire,
and the framework mechanism for that is `ui_static_data()` plus an explicit `update_static_data()`
push.

Moved to `ui_static_data()`, all keyed by the existing `character_setup_static_sig`
(`species-gender`) that `update_menu_data()` already pushes on:

- `age_options` and `age_tooltips` — the tooltip text is the expensive half, and it is derived
  from `pref_species.possible_ages`.
- `ancestry_options` — `pref_species.get_skin_list()`.
- `tgui_themes` — a constant list that was being rebuilt and resent on every update.

`age_index`, `display_age` and `age_max` stay in `ui_data()` because they track the current
selection; `age_count` replaces the length of the list that no longer travels with them.

**No frontend change was needed.** `backendStateAtom` (`tgui/packages/tgui/events/store.ts`)
composes `data` as `{...gameDataAtom, ...gameStaticDataAtom}`, so a key reads the same from
`useBackend().data` whichever side sends it. The corollary is that a key must live in exactly one
of the two — static wins the merge, so a key left in both is silently dead weight in `ui_data`.

Still in `ui_data()` and still the largest single block: **`features`**. It cannot move wholesale
because it interleaves catalog and selection — `choice_options`/`accessory_options` are static per
species, while `choice_value`, `accessory_value`, `enabled` and `colors` change on every pick. The
split is to lift the two option lists into a static `feature_options` map keyed by customizer type
and have `PreferencesMenu.tsx` read `featureOptions[feature.key]` at the four call sites that use
them today. Not done here: it needs a live client to verify, and none was available.

`character_setup_log_op()` measured with `world.timeofday`, which is deciseconds — so every
op in the round log read `took=0ds` and the 43 ms the tgui census attributes to `act/pref` was
invisible to it. It now uses `TICK_USAGE_REAL`/`TICK_USAGE_TO_MS` like the telemetry module and
reports milliseconds. This is the prerequisite for the hover-cost work, not the work itself: where
those 43 ms actually go is still unmeasured, and the next round's log is what should decide it.
