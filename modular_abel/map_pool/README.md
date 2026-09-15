# map_pool — map categories, the roundstart gate and map-exclusive jobs

Three things that used to be tangled together, now one module. The code carries no
comments; this file is the record.

## Twilight Axis is no longer force-loaded

`modular_abel/dun_world/force_load.dm` overrode `SSmapping/PreInit()` and pinned
`config` to `dun_world` on every boot, regardless of `config/maps.txt`, the map vote or
map rotation. It is gone. Twilight Axis is now an ordinary entry in the pool
(`_maps/dun_world.json`, `map dun_world` in `config/maps.txt`).

That file also re-did the map-adjustment lookup upstream `PreInit()` already performs
(`code/controllers/subsystem/mapping.dm`, the `#ifndef FORCE_RANDOM_WORLD_GEN` block), so
deleting it loses nothing. `dun_world/world_presize.dm` is already conditional on
`config.map_path`, so it is correct for a rotating pool as-is.

**Two config changes came with it**, because they only became load-bearing once the force
was gone:

- `minimal_test` (the tiny `map_files/debug` map) held `default` in `config/maps.txt`. The
  default map is what `SSmapping/Initialize()` falls back to when `next_map.json` is
  missing or unreadable — so without the force, a cold boot would have landed on the debug
  map. It is now `disabled` and `vanderlin` is `default`.
- `dun_world` was already `votable`; it now also carries an explicit `voteweight 1`.

## Categories

`/datum/map_config` gains `map_category` and `map_blurb`, read from the map's own JSON by
a `LoadConfig()` override that chains `..()` and re-reads the file for the two extra keys.
Parsing them in the override rather than in upstream `LoadConfig` keeps the whole feature
modular; the cost is one extra `file2text` per map at config load, once per boot.

A map with no `category` key is `MAP_CATEGORY_STANDARD` (`"Maps"`). Twilight Axis declares
`MAP_CATEGORY_OLD_BETA` (`"Old Maps - Beta test"`).

`GLOB.map_pool_category_order` fixes the display order; `map_pool_ordered_categories()`
returns only the categories actually present, known ones first, unknown ones appended so a
new category string in a map JSON shows up without a code change.

## The roundstart gate

`/datum/controller/subsystem/ticker/checkreqroles()` is a **full-body override** — it does
not call `..()`, so the upstream body never runs. Both of its jobs are deliberate:

- **No map requires a ruler any more.** Upstream refused to start the round unless a player
  had readied as `JOB_MONARCH` (the "Duke" on Twilight Axis, "King" on Vanderlin), and after
  five failed attempts it opened a `norulervote`. Every map can now start without one.
- **The round will not start on an empty server.** Upstream had no player check at all.
  Two config entries gate it, both defaulting to 1 and both settable in
  `config/game_options.txt`:
  `MAP_POOL_MIN_CONNECTED_PLAYERS` and `MAP_POOL_MIN_READY_PLAYERS`.

`start_immediately` short-circuits both checks, which is what keeps CI and the admin
"Start Now" button working — it is set by `HandleTestRun()` (`code/game/world.dm`),
`low_memory_force_start()` and `code/modules/admin/admin.dm`.

Two consequences worth knowing:

- `SSticker.vote_started` now stays `FALSE` for the whole round, because nothing initiates a
  `norulervote` any more. `antag_retainer.dm` reads it: a round that runs 10 minutes without
  a living lord will now reliably raise `OMEN_NOLORD`. That is the intended reading of a
  realm with no ruler, not a regression.
- `SSvote`'s `norulervote` mode and the `upstream_fixes.dm` override that clears
  `SSticker.voting` after it are now dead code. Left in place: they cost nothing and an
  admin can still start that vote by hand.

## Map-exclusive jobs

`/datum/map_adjustment` gains `exclusive_jobs`. A map adjustment lists the job types that
only make sense on its own map; `SSjob/SetupOccupations()` chains `..()` and then strips
every job claimed by some *other* map's adjustment — positions to zero and
`JOB_NEW_PLAYER_JOINABLE` cleared, so they leave `joinable_occupations` and stop appearing
in the job-preference list.

This is what kept the eighteen `dun_world_*` jobs (plus `/datum/job/wretch` and
`/datum/job/painter`) out of the occupation list on Vanderlin and every other map. They
inherit `JOB_NEW_PLAYER_JOINABLE` from their parents — `merchant`, `monk`, `vagrant`,
`minor_noble` and so on — so declaring `total_positions = 0` was never enough to hide them;
it only made them unpickable.

Ordering matters and is load-bearing: upstream `SetupOccupations()` calls
`map_adjustment.job_change()` as its last act, which is where `slot_adjust` hands the
dun_world jobs their real position counts. The strip runs after that, so on Twilight Axis
they keep their slots and everywhere else they are zeroed again.

To scope a job to a map, add its type to that map's `exclusive_jobs` — nothing else. A job
claimed by the active map is never stripped, even if another adjustment also lists it.

One caveat on `/datum/job/painter`: it already gates itself with `ABYSSOR_CULT_ENABLED` in
`special_job_check()`, which only blocks *assignment*, not listing — hence the entry in
Twilight Axis's `exclusive_jobs`. If a future map turns on `"abyssor_cult": true` in its
JSON, that map's own adjustment has to list `/datum/job/painter` too, or the Painter will
be stripped there.

A verification pass worth repeating after adding jobs: every `/datum/job/...` declared in
`dun_world/jobs.dm` and `dun_world/abyssor/job.dm` should appear in
`dun_world/map_adjustment.dm`'s `exclusive_jobs`. As of this change that is 18 of 18, with
no strays in either direction.
