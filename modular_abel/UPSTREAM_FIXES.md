# Upstream fixes and re-sync obligations

Every modular override of upstream behaviour, and every place where deleting or "tidying"
modular code silently breaks something. The code itself carries no comments — this file is the
record. Check it before an upstream merge.

## `upstream_fixes.dm`

Same-type redefinition **chains** in BYOND: the modular proc's `..()` runs the upstream body.
That is why some of these guard around `..()` instead of simply calling it.

| Override | Upstream defect | Remove when |
| --- | --- | --- |
| `/obj/structure/vine/Crossed` | Types the crosser as `/mob` and reads `crosser.m_intent`, but non-mob movers (the wandering `/obj/item/reagent_containers/food/snacks/smallrat`) cross vines and runtime on the undefined var. Reimplemented with an `ismob()` guard; it replicates `/atom/movable/Crossed` (`COMSIG_MOVABLE_CROSSED`) and `/obj/structure/Crossed` (climb offset) itself, because the same-type redefinition bypasses the upstream `..()` chain. | upstream guards the crosser type |
| moondust reagent | Animates `affected_mob.client` with no null-check (`powder.dm:241`); a clientless NPC metabolizing it crashes `"invalid object type 0:0"`. Calling `..()` unconditionally would still run the crashing animate, so clients take the upstream path via `..()` and clientless mobs get a faithful re-implementation that skips only the `animate()`. The `..()` reference keeps `SHOULD_CALL_PARENT` satisfied. | upstream null-checks the client |
| `/datum/tgui/open()` payload | Null-checks `user.client` at the top, then yields (`send_assets`) before `get_payload()` re-reads `user.client.prefs` (`tgui.dm:260`). If the client vanishes during that yield — e.g. `AGGRESSIVE_CHANGELOG` force-opening the Changelog for a guest mid-login — `get_payload` crashes `"Cannot read null.prefs"`. The override guards the client read; `..()` still builds the real payload while the client is valid, and the orphaned UI is reaped by the tgui process loop. | upstream re-checks after the yield |
| Four outfits (`mercenary/fencer`, `adventurer/heartfeltlord`, `heartfelt_lord`, `rockhill/mayor`) | They hand out abstract clothing types, so every mob wearing them throws `"Abstract type (...) initialised!"` on spawn — both `/obj/item/clothing/head/helmet` and `/obj/item/clothing/shoes/boots` declare themselves `abstract_type`. Repointed at concrete subtypes matching what each outfit already wears; the fencer's own boots already existed, its assignment just never got updated past the "placeholder until i can fix the boots" note. | upstream points them at concrete types |
| `/datum/outfit/skeleton/pre_equip` | Same bug in a runtime roll rather than a static var: the headgear switch has the bare abstract helmet on roll 9 of 9. Patched after the parent runs, so the switch itself is left alone. | as above |
| `/datum/mind/Destroy` | `/datum/mind/New` sets `soulOwner = src` and `Destroy` never clears it, so every mind hard-deletes. The override nulls the self-reference. | upstream clears it |
| `/datum/browser/build_page` | The page template in `code/datums/browser/_browser.dm` declares `charset=ISO-8859-1`, while every other browse() page in the codebase declares UTF-8. BYOND sends the page as UTF-8, so the embedded browser decodes it as Latin-1 and every non-ASCII string in a browse popup renders as mojibake - the declension prompts (`browser_input_text`, title `СКЛОНЕНИЯ`) came out as `Ð¡ÐºÐ»...`. The override chains through `..()` and rewrites only that one charset token, so the rest of the template stays upstream's and a template change cannot silently break the fix (it degrades to a no-op instead). | upstream declares UTF-8 |
| `/datum/browser/modal/input_text/New` | Every single-line `browser_input_text()` window is hardcoded to 350x125 (`code/datums/browser/modal/input/input_text.dm`), which fits a short English prompt and nothing else: the declension prompts wrap to three lines, and the 1rem textarea and the button row are crushed into what is left. The override wraps `New()`, lets upstream build the whole window, then resizes it from the prompt's own length - the body of the proc is never copied, so upstream may change the markup freely. | upstream sizes the window from its content |

## Unit-test overrides

Three upstream tests assert things about content, and each one is widened from a modular
`Run()` rather than by editing the test. All three live in `upstream_fixes.dm`.

`craftable_clothes` demands that every `/obj/item/clothing` subtype have a recipe. Donation
cosmetics have none by design: they are bought with triumphs, or morphed out of a base item
with an elixir. The override answers that **semantically instead of by name**:

```
excluded_paths |= loadout_granted_items()
excluded_paths |= morph_elixir_results()
```

`loadout_granted_items()` (`loadout_panel/_loadout_panel.dm`) walks `GLOB.loadout_items` and
returns every `item_path` the shop or the panel can hand out. `morph_elixir_results()`
(`morph_elixirs/_morph_elixirs.dm`) instantiates every `/obj/item/enchantingkit` subtype and
collects every value in its `target_items`, plus `result_item`. It caches into
`GLOB.morph_elixir_results` on first call rather than filling it with `GLOBAL_LIST_INIT`,
because a global list initialiser runs before `SSatoms` and would be creating objects during
world init to answer a question nothing asks until a unit test runs.

This is deliberate, and the reason is maintenance: **a name list would have to be edited on
every port, and would silently keep excluding an item after it left the shop.** With the rule
stated this way, selling an item exempts it and un-selling it makes the test demand a recipe
again — nobody has to remember. The two GLOB name lists above it
(`modular_craftable_clothes_exclusions`, `..._subtree_exclusions`) stay for the older modular
content that is genuinely mapped-in, spawner-only or antag-only.

`turf_coverage` gets moonstone added; `item_detail_sanity` and `missing_clothing_sprites` are
not overridden at all — content is fixed to satisfy them, which is what
`tools/check_modular_content.py` checks before a push.

## `map_pool/` and `map_vote/`

Overrides that live in their own modules rather than in `upstream_fixes.dm`, because each
is part of a feature rather than a bug fix. Full reasoning in
`modular_abel/map_pool/README.md` and `modular_abel/map_vote/README.md`.

| Override | What it does to upstream | Re-sync obligation |
| --- | --- | --- |
| `/datum/controller/subsystem/ticker/checkreqroles()` | **Full-body override, does not call `..()`.** Drops the `JOB_MONARCH` requirement entirely (every map can start without a Duke/King) and adds the empty-server gate upstream never had. `start_immediately` short-circuits both, which is what keeps unit tests and admin "Start Now" working. | If upstream changes what `checkreqroles()` is responsible for — anything beyond the ruler check and `job_change_locked` — mirror it here, because none of the upstream body runs. |
| `/datum/controller/subsystem/job/SetupOccupations()` | Chains `..()`, then zeroes positions and clears `JOB_NEW_PLAYER_JOINABLE` on jobs claimed by a *different* map's `map_adjustment.exclusive_jobs`. Must stay after `..()`: upstream's last act is `map_adjustment.job_change()`, which is what gives the active map's jobs their slots. | none while upstream keeps calling `job_change()` from `SetupOccupations` |
| `/datum/map_config/LoadConfig()` | Chains `..()`, then re-reads the same JSON for `category` and `blurb`. Costs one extra `file2text` per map per boot; the alternative is editing upstream's parser. | if upstream starts parsing `category` itself, delete the override |
| `/datum/controller/subsystem/vote/initiate_vote()`, `reset()`, `interface()` | All chain `..()`. `interface()` is the only behavioural change: for `mode == "map"` it drops the client from `SSvote.voting`, closes the legacy `vote` browser window and opens the tgui panel instead, so a map vote does not show two UIs. Every other vote type takes the upstream path untouched. | none |

`SSvote`'s `norulervote` mode, and the `/datum/controller/subsystem/vote/result()` override
above that clears `SSticker.voting` after it, are now **dead code**: `checkreqroles()` no
longer initiates that vote. Both are left in place deliberately — an admin can still start
it by hand, and removing the `result()` override would silently strand `SSticker.voting` if
they did.

## `erp/.../genitals.dm`

`/datum/sprite_accessory/testicles/is_visible()` dereferenced `owner` bare
(`owner.getorganslot(ORGAN_SLOT_PENIS)`) while every sibling override in the file guards
with `istype(H)` and hands a null owner to `is_human_part_visible()`, which null-checks.
The overlay pipeline calls `is_visible()` with a null owner during organ removal —
`Organ/Remove` -> `update_body_parts` -> `get_limb_icon` -> `get_bodypart_overlay` ->
`get_appearance` -> `is_visible` — so every species change in the character preview threw
`Cannot execute null.getorganslot()` and abandoned that overlay pass midway. Now `owner?.`.
Seen five times in the 2026-09-15 round log, all from the character-setup dummy.

The file also holds the modular additions to the upstream unit-test exclusion lists — see the
`upstream_fixes.dm` section of `modular_abel/README.md`.

## `cyrillic_say_fix.dm`

Upstream `capitalize()` is byte-based (`uppertext(copytext(t, 1, 2)) + copytext(t, 2)`): on a
UTF-8 multi-byte first character it grabs one byte, uppercases nothing and reassembles the
original — a harmless no-op for Cyrillic. `capitalize_utf8()` does the real character-aware
capitalization.

- The **wrapper** overrides let the parent run every speech transform plus its byte-based
  `capitalize()` (a no-op on Cyrillic, idempotent on ASCII), then re-capitalize UTF-8-aware.
- `/mob/dead/observer/profane/say` is a **full-body override and cannot be wrapped**: the
  parent proc transforms the message mid-body *and* emits the `visible_message` itself, so
  calling `..()` would double-send the say. Source is
  `code/modules/mob/dead/observer/observer_say.dm`. Two changes vs upstream, both on the
  message line: `capitalize()` → `capitalize_utf8()`, and `copytext()` → `copytext_char()`
  (byte-based `MAX_MESSAGE_LEN` truncation can split a multi-byte character and corrupt the
  tail).

**Re-sync obligation:** if upstream changes that proc, mirror the change here.

## `dun_world` types that the generated map depends on

Deleting any of these compiles fine and breaks the map at load, with no compile-time signal:

- `/turf/open/rebound` (`dun_world/abyssor/turfs.dm`) — the Twilight Axis `.dmm` places this
  turf path directly.
- `/area/rogue/indoors/inq/chapel` and `/area/rogue/indoors/inq/embassy` (`dun_world/areas.dm`)
  — an area path that does not compile makes `reader.dm` place the model's turf as the area,
  and every tile using it runtimes on load.
- `/obj/structure/lever/bookcase` and the other dun_world secret-door props
  (`dun_world/compat.dm`) — without these types `new` returns null on mapload and their
  `redstone_id` map var leaks onto the underlying turf.

## `races/taur/legs.dm`

The attach/detach logic lives on the bodypart's `on_adding`/`on_removal`, not on
`/mob/living/carbon/human/add_bodypart` and `remove_bodypart`. Do not move it back: upstream
marks both `SHOULD_NOT_OVERRIDE(TRUE)` and dreamchecker rejects the build for it. The mob-side
halves stay as procs on `/mob/living/carbon/human` deliberately — the prebuckle signal has to
be registered with the human as the registrant, or `PROC_REF` resolves against the bodypart and
the handler never fires.

## `telemetry/_telemetry.dm`

Temporary instrumentation for the tgui optimisation pass, and the only place where upstream
files carry modular edits: three `TOPIC-CENSUS TEMP` call sites in
`code/modules/client/client_procs.dm` (lines 53, 80, 95). Everything else in the module hooks
tgui by same-type redefinition and chains through `..()`, so no upstream body is copied.

`GLOB.topic_census_debug`, `GLOB.tgui_census_debug` and `GLOB.tgui_census_payload_bytes` all
default to `TRUE` and can be switched off live. Remove the module and the three call sites once
the optimisation pass is finished. See `modular_abel/telemetry/README.md`.

## `tgui/packages/tgui-panel/modular_chat/`

Chat-embedded components are a two-sided protocol (`tgui/docs/chat-embedded-components.md`
upstream): DM emits `<span data-component="Name" data-prop="…">`, and the renderer instantiates
only names listed in `TGUI_CHAT_COMPONENTS`, passing only attributes listed in
`TGUI_CHAT_ATTRIBUTES_TO_PROPS`.

`span_tooltip_dangerous_html()` (`code/__DEFINES/chat/span.dm:203`, from the Examine Highlights
port, `5dce59367`) emits `data-component="TooltipHTML"` with the tip as an HTML string in
`data-html`. That commit touched 13 DM files and no tgui file, so the name was never registered
and the attribute was never mapped: every item examine both lost its tooltip and posted a
~1.7 KB `type=log` Topic back to the server. All 13 `OVER-SEC` lines in the 2026-09-20 round log
are that relay, and 30 of the 36 limiter-counted topics in the busiest second of the round.

**This module touches no upstream tgui file.** Registering the name properly would mean adding it
to the two `const` maps, which live in `chat/renderer.tsx` itself. A fork module cannot reach them
without the import cycle `renderer -> localization/translate -> modular_chat -> renderer`, and the
rspack build **rejects circular dependencies outright** (verified: `ERROR ... Circular dependency
detected`), so that route does not exist.

What does exist: the renderer writes the message HTML into a node, calls the fork's
`translateNode()`, and *only then* scans for `[data-component]`. Rewriting the node in that window
reaches the same end state with no upstream file involved. `rewriteModularChatComponents()` renames
`TooltipHTML` to the `Tooltip` upstream does register and flattens `data-html` into `data-content`.

| File | Owner | Role |
| --- | --- | --- |
| `tgui/packages/tgui-panel/modular_chat/rewrite.ts` | fork | the rewrite, plus `rewrite.test.ts` |
| `tgui/packages/tgui-panel/localization/translate.ts` | fork | calls it from `translateNode()`, **above** the `isActive()` guard so it runs for EN players too |
| `tgui/packages/tgui-panel/chat/renderer.tsx` | upstream | **unchanged** |

Two consequences worth knowing before touching either file:

- The call sits in the localization module because that is the only fork-owned function the
  renderer already calls per message. It is not localization work; if `translateNode()` is ever
  removed or its `isActive()` guard moved above the call, the tooltips silently go back to
  flooding the server.
- `Tooltip` takes `content` as a plain string, so the tip loses its markup: the `<br>` that
  `carbon/examine.dm` puts between the description and the explanation becomes a visible
  ` — ` separator. Accepted — the alternative was a themed tooltip that does not render at all.

## `character_setup/` preview controls

`ByondMapView.tsx` is fork-authored (like `PreferencesMenu.tsx`), so it is not an upstream touch
point — but it replaced `tgui-core`'s `ByondUi` and inherited only part of its contract. `ByondUi`
clears the control on unmount **and** on `beforeunload`; the replacement kept only the unmount
path, and React unmount does not run when a tgui window is destroyed outright rather than
suspended. Combined with `clear_map()` never touching the skin element, three chargen preview
maps survived `ui_close` still parented to the pooled `tgui-window-1` and painted over the next
interface opened in it. Both halves are covered now —
`character_setup_release_control()` DM-side and the restored `beforeunload`/`pagehide` release
client-side. Full reasoning in `modular_abel/character_setup/README.md`.

**Re-sync obligation:** if `ByondMapView` is ever dropped back to stock `ByondUi`, pass
`phonehome={false}` with it — DM owns the control lifecycle here, and stock `ByondUi` sends a
`renderByondUi` Topic on every internal render. The current component sends none.
