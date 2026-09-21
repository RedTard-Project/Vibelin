# character_setup — the modular character menu

Replaces the upstream character-setup browser window with a modular one
(`code/modules/client/preferences/character_menu.dm` in this folder), plus the smallclothes
system and the modular preference hooks.

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
preference after `..()` runs. That is a same-type redefinition of the same proc, which BYOND
resolves by running every definition in include order, outermost last.

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
and 23.3 MB in one round for two clients, measured with the tgui census that instrumented the
optimisation pass and has since been removed. The heavy blocks
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

**`features`** was the largest single block and could not move wholesale, because it interleaves
catalog and selection: `choice_options`/`accessory_options` are fixed for a species, while
`choice_value`, `accessory_value`, `enabled` and `colors` change on every pick. It is now split:

- `character_setup_build_feature_options()` (`features_tgui.dm`) builds both catalogs and they ride
  in `ui_static_data()` as `feature_choice_options` and `feature_accessory_options`.
- `character_setup_build_features_data()` keeps only what a pick changes.

The two catalogs are keyed differently and it matters. Choices are keyed by **customizer type**;
accessories by **customizer-choice type**, because `character_setup_accessory_types()` is asked of
the *selected* choice — a customizer offering Hair and Bald has a different accessory list per
variant, so keying by customizer would serve the wrong list the moment the variant changed. The
catalogs are therefore built for every choice, not just the selected one.

`PreferencesMenu.tsx` reads `data.feature_accessory_options?.[feature.choice_value]` and gates it on
`feature.accessory_value` being present. That gate is not cosmetic: the backend only fills
`accessory_value` when the entry actually has an accessory, and the style grid only used to appear
in that case — without the gate it would start appearing for features that never showed one.

`character_setup_static_sig` gained **`erp_enabled`** (`character_setup_build_static_sig()`, the one
place it is now built). The option catalogs run through `customizer.is_allowed(src)` and
`choice.character_setup_accessory_types(src)`, both of which take the preferences datum and can
therefore be filtered by the ERP flag on some subtypes. Toggling ERP is rare, so the cost is one
extra full update and the reward is that a whole class of stale-catalog bug cannot happen.

The instrumentation this module carried while that work was done — a per-op disk logger behind
`GLOB.character_setup_debug`, 57 call sites deep — has been removed along with the tgui census.
One lesson from it is worth keeping: it timed with `world.timeofday`, which is deciseconds, so
every op read `took=0ds` and the 43 ms that `act/pref` actually cost was invisible. Sub-tick work
in DM needs `TICK_USAGE_REAL`/`TICK_USAGE_TO_MS`; anything coarser reports zero and hides the
thing you are looking for.

## The third tier: a constant catalog

The static split above fixed the wrong half first. `ui_static_data()` is per player and is resent
whenever `character_setup_static_sig` changes — and that signature is
`species-gender-erp`. So every time a player clicked a different species, the server rebuilt and
resent the full list of 33 species with their descriptions, tags and stat sheets: a block that
cannot change when the species changes.

/tg/ does not have this problem because its chargen has three tiers, not two
(`code/modules/client/preferences.dm` + `preferences/assets.dm`):

| tier | scope | how often |
|---|---|---|
| `compile_constant_data()` → `/datum/asset/json/preferences` | whole server | generated once, then browser-cached |
| `ui_static_data()` | one player | on open, and on an explicit `update_static_data()` |
| `ui_data()` | one player | every update |

This fork inherited `compile_constant_data()` on the preference base types and **never called it** —
the producer arrived at port time, the consumer (`/datum/asset/json/preferences` and the
`preference_middleware` system) did not. Five overrides sat dead.

`modular_abel/character_setup/code/modules/asset_cache/chargen_catalog.dm` is that missing tier,
built for this fork's shape rather than copied. The difference that matters: /tg/'s constant data
really is constant, because /tg/ has no per-player language. Ours has two, so the catalog carries
an axis /tg/'s does not.

What is genuinely invariant, and what is not:

| block | varies by | where it lives now |
|---|---|---|
| background options, tgui themes, age tooltips | nothing | catalog |
| species name, description, language, ancestry label, ages, tags, warning | **language** | catalog, under `en` / `ru` |
| species stat modifiers | **gender** | catalog, under `stats.male` / `stats.female` |
| species `available` / `lock_reason` | the player's unlocks | `ui_static_data()` |
| ancestry options, age options, feature catalogs | the selected species | `ui_static_data()` |

So the catalog holds every species once, with two language slices and two stat sheets, and
`ui_static_data()` keeps a map of 33 `{available, lock_reason}` pairs. Changing species now resends
that map and the species-dependent catalogs, and nothing else.

Making that possible needed the translation layer to answer for a language rather than for a
client. `chargen_tr_*()` funnelled everything through `chargen_sheet_active(target)`, so each
resolver in `modular_abel/localization/code/chat/chargen_sheet.dm` grew a `_for(ru, …)` core and
the client-taking proc became a one-line wrapper. Nothing at the call sites changed.

The same lift applies on the DM side: the builders that never touched `src` became global procs,
and the four that only needed `parent` for its language take `ru` instead. What stayed a
`/datum/preferences/proc/` is exactly what is genuinely per player —
`character_setup_species_lock_reason()` and `character_setup_species_availability()`.

Two things to know before touching this:

- **`generate()` runs at `SSassets` init, with no player in scope.** `/datum/asset/New()` calls
  `register()` immediately and `SSassets.Initialize()` constructs every non-abstract asset, so a
  builder that reaches for a preferences datum fails at roundstart rather than at first open.
  `modular_chargen_catalog` in `modular_abel/tests/_tests.dm` generates the catalog and asserts
  every roundstart species has both language slices and both stat sheets, which is what that
  failure would look like.
- **The frontend must wait for the asset mapping.** `resolveAsset()` returns the bare filename
  until the `asset/mappings` message lands, so fetching on mount would 404 and leave the species
  list permanently empty. `PreferencesMenu.catalog.ts` polls `loadedMappings` for the real url
  first, then fetches with retries, and the picker distinguishes loading from failure from
  no-match rather than showing one silent empty box for all three.

### The thumbnail map is gone

`ui_static_data()` used to ship `thumbs`: one entry per accessory, mapping its type path to its
spritesheet CSS class. The class is `sanitize_css_class_name(path)`
(`code/modules/asset_cache/asset_list.dm`), i.e. the path with everything non-alphanumeric
stripped — **a pure function of the key it was stored under**. 435 entries, ~80 KB per full
update, carrying no information the frontend did not already hold in `option.value`.

`spriteClassFor()` in `PreferencesMenu.components.tsx` applies the same rule client-side. The one
thing the map really encoded was *which grids show thumbnails at all*, and that is a property of
the grid, not of the data: accessory grids do, choice grids do not. `OptionGrid` now takes an
explicit `spriteThumbs` prop, passed only at the accessory call site. If the DM rule ever changes,
change it in both places — the mirror is noted in the helper's comment.

The dead `option.thumb` / `data:`-URL branch went with it: no DM code has ever set that field.

### The preview bbox is cached

`character_setup_measure_art()` flattens the whole dummy through
`character_setup_get_flat_icon()` for one reason — to read its content bounding box, so the map
zoom and offsets can be computed. The 2026-09-20 round ran it **345 times against 297 renders**
(a second, perpendicular measurement runs whenever the render is not `main_only`).

It is now memoised per direction behind `character_setup_measure_signature()`, which lists
everything that can change the doll's silhouette: species, gender, the preview job, the clothes
and underwear toggles, the hovered accessory, and every customizer entry's choice, accessory and
disabled flag. **Accessory colours are deliberately excluded** — `accessory_colors` are opaque
hex, so a colour change cannot add or remove a pixel, and including them would throw the cache
away on every click of the colour picker.

The invariant to preserve: the signature must be a *superset* of what feeds the flatten. Adding a
preview-only toggle that changes the doll's outline without extending the signature will produce
a subtly mis-sized preview with no error anywhere.
