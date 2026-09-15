# map_vote — the map vote as its own tgui panel

A small tgui window (`MapVote`, 420x560) in front of the existing `SSvote` map vote. The
code carries no comments; this file is the record.

## Why a front-end and not a replacement

`SSvote` already owns everything that is hard to get right: vote power (admins +5, living
humans +3, court roles +5, antags with `increase_votepwr` +3), the non-voter default-map
fill, tie-breaking, the vote delay, and `SSmapping.changemap()` + `map_voted`. None of that
is reimplemented. `/datum/map_vote_panel` reads `SSvote.choices`, `SSvote.voted` and
`SSvote.time_remaining`, and its only write is `SSvote.submit_vote(index)`.

`submit_vote()` reads `usr`, not an argument. That is safe here because `ui_act()` is only
ever reached through `/datum/tgui/Topic()`, where `usr` is the sending client's mob — the
same path the old browser panel used. The `usr?.client` guard in the `vote` branch is there
so a malformed Topic cannot runtime inside `SSvote`.

`SSvote.choices` is an assoc list of name to votes, and `submit_vote` takes a **1-based
index into it**, not a name. `live_entries()` walks `1 to length(choices)` and ships that
index; the interface echoes it straight back.

## Three hooks, all chaining

In `vote_hooks.dm`, all same-type redefinitions that call `..()`:

- `initiate_vote()` — after a successful `"map"` vote starts, opens the panel for every
  client. This is the whole point: players get the panel, not a chat link.
- `reset()` — closes the panel. Note `initiate_vote()` calls `reset()` itself before setting
  up the new vote, so a fresh map vote closes and reopens; that is harmless and keeps a
  stale panel from surviving a cancel.
- `interface()` — the old browser panel is left alone for every other vote type, but for
  `"map"` it drops the client out of `SSvote.voting` (which stops `SSvote/fire()` re-pushing
  the browser popup once a second), closes the `vote` window and opens the tgui panel
  instead. Without this, a map vote would show two competing UIs.

## Outside a vote

The panel is also the map pool browser: with no vote running it lists every map in
`global.config.maplist` grouped by `map_category`, showing the blurb, the player-count
window from `config/maps.txt`, which map is running and which is queued next. Categories
and blurbs come from `modular_abel/map_pool`.

`Start vote` is shown to anyone when `ALLOW_VOTE_MAP` is on, and always to admins — the
same permission check `SSvote.Topic()` applies. `Cancel` is admin-only.

Reachable at any time from **OOC -> Map Vote** (`/mob/verb/map_vote_panel`).

## Interface

`tgui/packages/tgui/interfaces/MapVote.tsx` with `MapVote.strings.ts` beside it, following
`PreferencesMenu`'s convention: a `RU` dictionary and a `tp()` wrapper, with `data["lang"]`
supplied by `ui_lang_code()` from `modular_abel/localization`. Russian is the default, so a
string missing from the dictionary shows in English — add it there, not in the `.tsx`.
