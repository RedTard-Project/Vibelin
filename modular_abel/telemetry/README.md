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

## Findings — round `Halberd28-18.31.44` (2026-09-20)

~3.5 hours, never more than two clients online. Everything below is **per client**, so every
number scales roughly linearly with the player count.

### `topic_census.log` — 2084 Topic calls

| class | calls | share |
| --- | ---: | ---: |
| `ping` (`wid=browseroutput`) | 1419 | 68% |
| `act/pref/character_setup_*` | ~330 | 16% |
| `Send-Tabs` (`wid=statbrowser`) | 97 | 5% |
| `log fatal=0` (chat renderer errors) | 34 | 2% |

**The `sec=`/`min=` counters in this log are not the limiter's counters.** `log_topic_census`
increments before it evaluates the exemption, so an exempt call (statbrowser, admin holder,
`/datum/native_say`) still advances the number printed on the line. Split the log on `EXEMPT`
before comparing anything to `SECOND_TOPIC_LIMIT`/`MINUTE_TOPIC_LIMIT`.

Once split, the two limits have entirely different causes:

- **Per-second.** Every `OVER-SEC` line in the round — all 13 — is `<log fatal=0>`, the
  `TooltipHTML` chat-renderer flood (below). The busiest second of the whole round
  (`19:06:26`, one second after that client's first topic) is 36 limiter-counted calls, **30 of
  them that flood**; the rest are `ready`, `visible`, `telemetry`, two `get_month` and one ping.
  Nothing else in the round ever crossed a per-second limit — not chargen, not hover, not
  `Send-Tabs`.
- **Per-minute.** The busiest minute is 91 calls and it is genuine chargen:
  `hover=40 | customizer=24 | ping=20 | rotate=6`. Against a stock `MINUTE_TOPIC_LIMIT` of 100
  that leaves 9 calls of headroom.

So the per-second pressure was a bug and the per-minute pressure is the interface's real cost.
`Send-Tabs` never mattered to either: `window_id == "statbrowser"` is exempt, so its 36-call
login burst is server CPU and log volume only.

The chat keepalive is the floor: `PING_QUEUE_SIZE` pings on a 3 s cycle is a flat 20 calls per
minute per client, and `browseroutput` is **not** in the limiter's exemption list
(`code/modules/client/client_procs.dm:63` exempts only `holder`, `statbrowser` and
`/datum/native_say`), so 20% of the stock budget is spent before the player acts at all.

`Send-Tabs` is one Topic call **per tab**: `SendTabsToByond()` in `html/statbrowser.js` loops
the tab list and the DM side does `panel_tabs |= payload["tab"]` one name at a time. 36 calls
in the login minute, with the same tab names repeated across several bursts.

### `tgui_census.log` — 34 MB of payload JSON for two clients

| interface | payloads | total bytes | acts | slow acts |
| --- | ---: | ---: | ---: | ---: |
| `PreferencesMenu` | 423 | 23.3 MB | 407 | 368 |
| `JobPreferences` | 100 | 5.6 MB | 1 | 101 |
| `TriumphShop` | 11 | 2.7 MB | 0 | 11 |
| `SpellBook` | 28 | 2.0 MB | 0 | 0 |
| `LoadoutPanel` | 394 | 0.5 MB | 9 | 8 |

Two independent causes, both visible in the same worst minute
(`payloads=83 ... bytes avg=53170 ... acts=83 (avg=43.36 max=65.4) slow=75`):

**Static catalogues travelling in `ui_data()`.** A `PreferencesMenu` *partial* payload is
53 KB with `static=0`. The bulk of it — `features` (every accessory of the species),
`age_tooltips`, `faith_options`, `ancestry_options`, `tgui_themes` — is already memoised in
`character_setup_ui_heavy_cache`, so it is not rebuilt, but it is re-serialised and re-sent on
every single update. The same shape appears elsewhere: `SpellBook` walks
`subtypesof(/datum/action/cooldown/spell)` inside `ui_data()` (72 KB a payload),
`TriumphShop` has no `ui_static_data()` at all (244 KB a payload), `JobPreferences` rebuilds
`job_states` for every job on each update (56 KB a payload, 101 of 101 payloads slow).

**Hover driving the update.** `character_setup_hover` used to return `TRUE` from `ui_act()`,
and `/datum/tgui/on_act_message` turns a truthy `ui_act()` into `SStgui.update_uis()` — so
moving the mouse across the accessory list forced a full 53 KB payload per hover, up to 41
times a minute. The act itself costs ~43 ms because `character_setup_update_view()` →
`character_setup_render_body()` runs synchronously in the caller's tick (`set waitfor = FALSE`
never yields, as `render_body` does not sleep), so 66 hover/customizer acts in one minute is
**2.8 s of server tick for one player**.

### Other things the round surfaced

- `chatRenderer Error: unknown chat component "TooltipHTML"`, 34 times, ~1.8 KB of Topic
  payload each. `span_tooltip_dangerous_html` (`code/__DEFINES/chat/span.dm:203`) emits
  `data-component="TooltipHTML"`, but `TGUI_CHAT_COMPONENTS` only had `Tooltip` and
  `TGUI_CHAT_ATTRIBUTES_TO_PROPS` had no `html` entry. Every item examine both lost its
  tooltip and posted an error back to the server.
- `/datum/tgui_panel was unable to be GC'd -- (ref count of 3)` in `dd.log` — a chat-panel
  reload leaks the old panel datum.
- `invalid key lobby_music in menu, please set it to a savefile key!` ×4, from
  `/datum/preferences/proc/process_link` reached through `ui_act("pref")`.
