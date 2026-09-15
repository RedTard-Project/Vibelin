# localization

Interface language (RU/EN) and the Russian translation layer for **tgui chat**.

## Why chat needs its own mechanism

tgui *interfaces* are containers: they pass `data["lang"] = ui_lang_code(user?.client)`
and the frontend switches on it (`MapVote.strings.ts`, `PreferencesMenu.strings.ts`,
`tgui/packages/tgui/i18n.ts`). Chat has nothing of the kind.

`SSchat` hands the panel `{html: "<span class='danger'>Peter slashed Ivan!</span>"}`
(`code/controllers/subsystem/chat.dm`) and the renderer does
`node.innerHTML = message.html` (`tgui/packages/tgui-panel/chat/renderer.tsx`).
The payload is one pre-rendered HTML blob — no keys, no structure, nothing to swap.
The string was already assembled by `visible_message()` (`code/modules/mob/mob.dm`)
long before it reached the subsystem.

So the translation is a **dictionary applied to rendered text**, and it runs
**on the client**. The server always sends English and pays nothing; each player's
own machine translates only the messages they actually received. The renderer
already walks every message's text nodes with a regex for highlighting and
linkifying, so one more pass over the same nodes is marginal.

Anything the dictionary does not cover is returned untouched, which is what
leaves untranslated content in English instead of blanking it out.

## Delivery

The dictionary is a plain browser asset (`/datum/asset/json/chat_localization`),
so it rides whatever `SSassets` is configured for and nothing here has to know
which: the default transport serves it over BYOND, and with
`ASSET_TRANSPORT=webroot` the file is dropped in the CDN webroot and the panel is
handed an http(s) URL — the same path graphics assets take. The panel is given the
resolved URL directly in the `localization/config` message and fetches it, so no
asset-mapping lookup is involved.

`window.send_asset()` is still called, because under the default transport that is
what puts the file in the client's cache in the first place.

## Layout

- `_localization.dm` — include list, the `LANGUAGE_*` / `UI_LANG_CODE_*` defines,
  the language preference, `ui_lang_code()` and the RU/EN toggle verb.
- `code/chat/chat_asset.dm` — parses `strings/` at registration and publishes the
  result as the asset. A missing file, a line without a separator or a noun with
  the wrong number of forms is skipped with a `stack_trace` and the rest still
  loads, so one bad line can never stop the round from booting.
- `code/chat/declension_prefs.dm` — the five case preferences, saved per character
  slot.
- `code/chat/declension_registry.dm` — `GLOB.chat_declensions`, filled on spawn
  from `apply_prefs_to()` and pushed to every open panel as a delta.
- `code/chat/panel_hooks.dm` — sends the asset, the language and the declension map
  on the panel's `"ready"` handshake. Deliberately **not** hooked on
  `initialize()`: that proc is `set waitfor = FALSE` and returns at its first
  sleep, which would race the window being up.
- `strings/nouns.txt` — closed-set nouns (the body parts `parse_zone()` can
  return), declined up front.
- `strings/items.txt` — item and scenery names, same format, merged into the same
  table. Entries carry **no** article: the panel strips a leading `a`/`an`/`the`
  before looking a capture up, because DM writes items both bare and through
  `\a` / `\the`.
- `strings/fragments.txt` — whole text nodes matched exactly: combat, status,
  refusals, items, the wound crit messages.
- `strings/speech.txt` — speech verbs and emotes, merged into the same exact-match
  table. Both arrive as their own text node because the speaker's name is wrapped
  in its own tag (`say_quote()` in `code/game/say.dm`, and
  `msg = "<b>[user]</b> " + msg` in `code/datums/emotes.dm`), so the player's own
  words sit in a separate span and are never touched.
- `strings/medical.txt` — surgery, organs, senses, pain, disease.
- `strings/world.txt` — farming, cooking, crafting and magic.
- `strings/status.txt` — the examine wrapper, the hunger/thirst/injury alerts,
  status-effect descriptions and the descriptions of basic materials.
- `strings/descriptions.txt` — item `desc` text, **keyed by type path**, not by
  English, and resolved server-side (see below). Translated for register rather
  than word by word: the source writes its own archaisms — `nite` for night,
  `dae` for day — and the Russian mirrors them (`нощь`, `днесь`) instead of
  smoothing them out. Proper nouns (Psydon, Zaladin, Ravox, Noc) stay as they are.
- `code/chat/descriptions.dm` — loads that file into `GLOB.examine_descriptions`
  and overrides `get_examine_desc()`.
- `code/chat/description_composites.dm` — the atoms whose desc is assembled at
  runtime and so cannot be keyed by type alone (see below).
- `code/dreams/` — the dream pool (see below).
- `strings/patterns.txt` — interpolated messages, tried in order after an
  exact-match miss.

Frontend: `tgui/packages/tgui-panel/localization/` (engine, handlers, types and
`translate.test.ts`).

## How a message is translated

Attack lines are not one string. `next_attack_msg` is a **list** of appended
fragments (`code/datums/wounds/_wound.dm`,
`code/modules/mob/living/carbon/human/species.dm`), so the rendered message is
`[variable head]` + `[fixed tails]` and the spans put each part in its own text
node. The engine therefore translates **per text node**, not per message — the
combinatorial space of whole messages is unbounded, the fragment space is small.

For each text node:

1. Edge whitespace is held back (fragments carry their own padding, e.g.
   `" Armor stops the damage."`), so dictionary entries stay clean.
2. Exact lookup in `fragments` — an O(1) hit, which is where most traffic lands.
3. Otherwise `patterns` in order; the first match expands its template.
4. No match — the original text is returned unchanged.

Results are cached per source string. The cache is dropped whenever the language,
the dictionary or the declension map changes, so a name rendered before its
declensions arrived is not stuck in its undeclined form.

### The strings format

Every strings file is plain text, one entry per line, `key = value`, split on the
**first** ` = ` (spaces included). `#` starts a comment, blank lines are ignored,
and whitespace around both sides is trimmed.

There is exactly **one escape**: `\n` becomes a line break, on either side. A line
is the record separator, so a real newline is the one thing the format cannot hold
otherwise, and 153 of the game's 5800 `desc` strings contain one. Nothing else is
escaped — quotes and backslashes are written as they are.

They are deliberately **not** JSON. A regex a translator will plausibly need
tomorrow — `^(.+?) takes (\d+) damage!$` — is invalid inside a JSON string unless
every backslash is doubled, and one missed escape or one trailing comma makes the
whole file fail to parse. Because the loader degrades quietly, that failure would
surface as "chat is still English" with no error anyone sees. Plain text needs no
escaping at all, tolerates a stray separator on one line without taking the other
thousand with it, and can carry comments.

The separator is safe inside regexes: `(?=…)` and `(?<=…)` are written without
spaces, so ` = ` never occurs in one.

### Template syntax

`$1`, `$2`, … are the pattern's captures. `$2|acc` declines capture 2, looking it
up first in `nouns.txt`, then in the per-character declension map, and falling back
to the raw capture if neither has that case. Cases: `nom gen dat acc ins pre`.

```
^(.+?) bites (.+?)'s (.+?)!$ = $1 кусает $3|acc $2|gen!
```

→ `Sir Aldric bites Ivan's throat!` → `Sir Aldric кусает горло Ивана!`

### Pattern order is load-bearing

Patterns are tried in file order and the first match wins, so **a specific pattern
must be written above the generic one it overlaps**. `^(.+?) slashed (.+?)!$`
placed first happily matches `I'm slashed by Sir Aldric!` and renders
`I'm рубит by Sir Aldric!`. The reflexive and passive forms are therefore grouped
at the top of `patterns.txt`, above the per-verb block.

## Declensions

Russian needs cases that a rendered English string cannot supply: `[user] bites
[C]'s [parse_zone(...)]` wants an accusative body part and a genitive name.

- **Body parts** are a closed set (`parse_zone()` in `code/__HELPERS/medical.dm`),
  so they are declined in `strings/nouns.txt` once.
- **Character names** cannot be declined automatically, so players fill them in
  themselves in the **Склонения** column of the character menu — five optional
  fields. Anything left blank falls back to the nominative, which is the same
  result as not filling the form in at all.

`reject_bad_name()` must never be used on these fields: it walks bytes and accepts
only ASCII, so it strips Cyrillic to nothing. `handle_link` uses
`browser_input_text(..., encode = FALSE)`; the base text preference already strips
HTML on deserialize.

Items and mob names are **not** covered — they are open-ended, and an undeclined
noun there renders in the nominative.

## Scope

`strings/` currently holds 606 chat fragments, 184 patterns, 134 nouns and 3251
type-keyed descriptions, mined out of
the source with the highest-traffic lines first: the speech verbs and the emote
list (the most frequent text in the game), the wound crit messages (which fire on
every critical hit), attack and defence lines, wrestling, status effects, refusals
and hints, item and storage messages, then surgery, farming, cooking, crafting and
magic. Growing it is content work: add lines, no code changes.

**Descriptions are finished.** Every atom in `code/` that declares a non-empty
`desc` a player can examine is translated, plus the runtime-composed ones listed
under Examine. What is still English there is deliberate and enumerated in that
section: abstract parents and coder/mapper error markers, the admin countdown's
song quote, and two descs the game keeps no var to rebuild. Re-check after an
upstream sync — a new type is a new key, and nothing fails until someone examines
it.

**Item names are the remaining gap.** The source carries roughly 5000; `items.txt`
covers about 120, chosen for how often they appear in chat rather than for
coverage. A name with no entry renders in English inside an otherwise Russian
sentence; that is ugly but harmless, and it is the honest failure mode rather than
a machine-translated guess at a fantasy proper noun. Note that names are a chat
concern, not an examine one — the examine header's name comes from `get_examine_name()`
and is not routed through this module at all, so a translated desc under an English
name is expected.

**A chat fragment's key must match the source byte for byte**, or the entry is dead
and nothing complains. `modular_chat_localization` catches a fragment that maps to
itself, but it cannot know a key was mistyped, so check new batches against the
source before committing them. Descriptions do not have this problem — their keys
are types, and the unit test resolves every one.

## Examine

`get_examine_string()` (`code/game/atom/atom_examine.dm`) builds
`That's \a <b>[name]</b>`, so the wrapper and the name are separate text nodes:
the wrapper is translated from `status.txt` and the name stays English unless it is
in `items.txt`.

The **description takes a different route from everything else here.** It is keyed
by type path and swapped on the server, in an override of
`/atom/get_examine_desc(mob/user)`, because that proc already receives the user and
so can answer per-client without touching `desc` itself.

Two reasons it is not text-keyed like the rest:

- **A text key dies silently.** Reword an English desc upstream and the translation
  stops matching, with nothing to notice it. A type either exists or it does not,
  and `modular_examine_descriptions` runs every key through `text2path()`, so a
  renamed type fails the test instead of quietly reverting to English.
- **A type is unambiguous.** The same English sentence can be shared by unrelated
  items; type paths keep them apart.

The cost argument that keeps chat on the client does not apply: examine is a
player-initiated action, not a per-tick broadcast, so one assoc lookup is nothing.
Descriptions are therefore **not** shipped in the browser dictionary at all, which
also keeps it smaller.

When a desc is declared on a `/datum` rather than an atom — blueprint recipes do
this — it never reaches `get_examine_desc()` and does not belong in this file. Ten
such entries were dropped when the file was converted; they had been dead as text
keys too, and moving to type keys is what exposed them.

A desc written across several source lines with a trailing `\` is still a plain
type-level desc and lives in `descriptions.txt` like any other; the file itself has
no line-continuation syntax, so the whole sentence goes on one line and `\n` (the
format's only escape) is used where upstream had one.

### Descriptions the game builds at runtime

`code/chat/description_composites.dm` holds the handful of atoms whose `desc` is
assembled at `Initialize()` or on use, from a var the type path cannot carry: the
themed starter spellbooks (tier text plus a per-form flavour line), herb bushes,
ration wrappers, slapcraft assemblies and wild plants. Each one overrides
`get_examine_desc()` and rebuilds the Russian from the same runtime var, then falls
through to `..()` — and so to the ordinary type lookup — when that var is unset.

`examine_description_for_type()` in that file walks up the type tree. **Only these
procs may use it.** The generic hook stays on an exact-type lookup on purpose: a
subtype whose desc genuinely differs would otherwise inherit its parent's Russian
text instead of falling back to its own English, which is the one failure this
whole design exists to avoid.

Two composed descs are left in English because the game keeps no var to rebuild
them from: the claim sign's `Click to save your current design to slot [n]` (the
slot is a proc local) and the topping sentence appended to a griddlecake (which
leaves no trace but an overlay). Both would need an upstream edit to fix.

Abstract parents and mapper/coder error markers — `You shouldn't be seeing this`,
`yell at coderbus`, the merge-conflict marker — are deliberately left English so a
bug report stays legible to whoever reads it.

## Dreams

Upstream's dreams could not be translated, so they were replaced rather than
localised. Three reasons, all in `code/modules/flufftext/Dreaming.dm`:

- **They never fired.** The body of `handle_dreams()` is commented out upstream,
  so the proc was called every sleeping tick and did nothing.
- **The content is stock /tg/.** `strings/dreamstrings.txt` is spaceman flavour —
  crewmember, security officer, ID card, toolbox — in a medieval fantasy game.
- **It is a generator, not text.** Dreams were stitched from 43 templates × 374
  adjectives × 134 adverbs × 928 `-ing` verbs × 631 verbs. Russian adjectives
  agree with their noun's gender, number and case, and `%A%` (a/an) has no Russian
  equivalent, so a word-by-word generator cannot produce a grammatical sentence.

`code/dreams/` replaces it with **one datum per dream**, each carrying both
language versions itself. The key is the type — Russian text is never matched
against English text, the same rule `descriptions.txt` follows.

`fragments_for()` always returns a **copy**: `dream_sequence()` consumes the list
it is handed with `Cut()`, so returning the datum's own beats would blank that
dream out for the rest of the round. `modular_dreams` checks that, along with both
languages being present and pacing to the same number of beats.

A beat is printed as `... <beat> ...`, so beats carry no trailing punctuation.

## What is deliberately not translated

Chat carries the player's own words, and those must never be rewritten. The dictionary
cannot tell them apart structurally: `say_quote()` wraps the speech verb and the
player's text in sibling spans with the *same* classes, both inside
`<span class='message'>`, so a blanket "skip `.message`" guard would kill the speech
verbs along with the risk.

What keeps this safe is that every entry is a distinctive whole game sentence, which
a player is very unlikely to type verbatim. That property is load-bearing, so:

- **Never add a bare-noun fallback.** Declining a text node just because it equals a
  noun key would mangle a player who types "sword". Nouns stay reachable only through
  `$N|case` inside a pattern, where the surrounding text proves it is a game message.
- **Avoid one- or two-word fragments** for the same reason. The examine wrapper
  (`That's a`) is the deliberate exception: it is punctuation-free, position-bound and
  worth the negligible risk.

Two things to get right when adding entries, both of which have already caused
real bugs here:

- **Order.** See above — specific before generic.
- **Gender.** A Russian adjective or past participle agrees with its noun, and the
  captured noun can be any of the three genders. `$1|nom — вывихнуто` renders
  "левая рука — вывихнуто". Use an impersonal verb plus the accusative
  (`Вывихнуло $1|acc!`) or rephrase around a plain verb, which agree with nothing.
- **Words English conflates.** `items.txt` is merged first and `nouns.txt` second,
  so the closed body-part set wins a collision. There is exactly one today:
  **chest** is "грудь", never "сундук", because the body part appears 250 times in
  the source against 4 containers. The rare container line therefore reads wrong.
  That is a deliberate trade — the alternative puts "надрез в сундуке" in every
  surgery — and the unit test prints a notice whenever a new collision appears, so
  the next one is a decision rather than a surprise.
Admin channels, OOC and adminPM are worth leaving in English — filter on
`message.type` (`code/__DEFINES/chat.dm`) if that becomes desirable.

Server-side logs stay English, which keeps admin log-reading unchanged. The chat
log the player exports from the panel is translated.

## Upstream touch points

There is no override mechanism in TypeScript, so two upstream tgui files carry a
hook and must be re-applied on re-sync:

- `tgui/packages/tgui-panel/chat/renderer.tsx` — one import plus
  `translateNode(node)` after the payload is written into the node.
- `tgui/packages/tgui-panel/events/listeners.ts` — registers
  `localization/config` and `localization/declensions`.

`tgui/packages/tgui/interfaces/PreferencesMenu.tsx` is fork-authored, not upstream.
Everything else lives in this module.

## Tests

- `modular_abel/tests/_tests.dm` — `modular_chat_localization` validates the
  dictionary (every section non-empty, no template referencing a capture its
  pattern does not have, no unknown case keys) and `modular_declension_prefs`
  checks the preferences cover each case exactly once.
- `tgui/packages/tgui-panel/localization/translate.test.ts` — engine behaviour:
  exact hits, padding, declension, fallback for an unknown name, passthrough, the
  English path, a malformed pattern, and cache invalidation when declensions
  arrive late.
