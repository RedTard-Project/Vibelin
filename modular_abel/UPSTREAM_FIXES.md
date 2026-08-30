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
