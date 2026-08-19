# telemetry — instrumentation for the TGUI optimisation pass

Temporary measurement, not a feature. Everything here exists to answer "which interface is
expensive, how often, and why" before and during a tgui optimisation pass. It should come out
once that pass is finished.

Two censuses, two log files, both under the round's log directory.

## Toggles

All live globals, so they can be flipped mid-round from VV without a rebuild.

| Global | Default | What it costs when on |
| --- | --- | --- |
| `GLOB.topic_census_debug` | `TRUE` | one log line per `client/Topic()` plus a per-minute summary |
| `GLOB.tgui_census_debug` | `TRUE` | counters and `TICK_USAGE` timing around every payload build, process tick and act |
| `GLOB.tgui_census_payload_bytes` | `TRUE` | **an extra `json_encode` of every payload, plus one of `static_data` and an md5 on full updates** — this roughly doubles payload serialisation cost. Turn it off first if the instrumentation itself distorts the numbers. |
| `GLOB.tgui_census_slow_call_ms` | `5` | threshold in ms for an immediate `*** SLOW` line; `0` disables |

## `topic_census.log`

Every `client/Topic()` call, classified (`act/<action>`, `renderByondUi/<target>`, `log`,
`legacy:<src>/<proc>`, `src:<type>`, `raw`), with the per-second and per-minute counters that
the topic limiter uses, whether the client is exempt, whether it is over either limit, and a
truncated raw href. A `=== MINUTE SUMMARY ===` line per client aggregates the classes, and
`*** DROPPED ***` records what the limiter actually threw away.

This is the census that already found the topic storm. It is also the **one place where
upstream files carry modular edits** — three call sites in `code/modules/client/client_procs.dm`
(lines 53, 80, 95) marked `TOPIC-CENSUS TEMP`. They come out with this module.

## `tgui_census.log`

Hooked by same-type redefinition (all chaining through `..()`, no upstream body copied):

| Hook | Records |
| --- | --- |
| `/datum/tgui/get_payload` | payload count, build time (avg/max), full vs partial, encoded byte size (avg/max), `static_data` byte size, and repeated-static detection |
| `/datum/tgui/send_full_update` / `send_update` | how many updates were full (re-sends static data) vs partial |
| `/datum/tgui/process` | process ticks and their cost |
| `/datum/tgui/on_act_message` | act count and duration per interface, broken down by action name |
| `/datum/tgui/open` / `close` | window lifecycle, plus a `*** SHORT-LIVED` line for a window closed under 2 seconds after opening (churn — a window opened and immediately replaced) |

A `===== MINUTE SUMMARY =====` block is written every minute with one line per interface and
one per client, then the window resets. `*** SLOW` lines are written immediately.

### What to read first

- **`static_repeats`** — a full update whose `static_data` is byte-identical to the previous
  one for the same window. Every repeat is a wasted re-send; the fix is usually
  `SStgui.update_uis()` where `send_update()` would do, or static data that should be data.
- **`full` vs `partial`** — full updates call both `ui_static_data()` and `ui_data()`. An
  interface that is mostly `full` is paying for static data on every tick.
- **`bytes avg` / `bytes max`** — payload size is what actually crosses to the client.
- **`full_avg` vs `avg`** — the gap between them is roughly what `ui_static_data()` costs.
- **`process` count** — how often `SStgui` touched this interface at all; an interface with a
  high process count and no updates is autoupdating for nothing.

## Report verb

`TGUI Census Report` under `Debug.Telemetry`, gated on `R_DEBUG`. Dumps the current window to
chat and flushes it to the log. The verb is visible in every client's panel because it is
declared as `/client/verb/`; that is acceptable for temporary instrumentation and goes away
with the module.

## Tests

`/datum/unit_test/modular_telemetry` in `modular_abel/tests/_tests.dm` checks that every
counter `tgui_census_format()` prints actually exists in the record (a missing key would print
`null` into the log and go unnoticed), that formatting keeps the interface and its actions,
that a flush resets the window, and that `topic_census_classify()` still classifies tgui, act,
legacy and empty hrefs correctly.
