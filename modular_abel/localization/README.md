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
- `strings/items.txt` — item and creature names, same format, merged into the same
  table. Entries carry **no** article: the panel strips a leading `a`/`an`/`the`
  before looking a capture up, because DM writes items both bare and through
  `\a` / `\the`. Most of the file is **generated** (see Scope); the hand-written
  block at the top of the file wins any collision.
- `strings/traits.txt` — the character sheet, **keyed by code identity and
  resolved server-side** like `descriptions.txt`, not shipped to the panel. See
  below.
- `code/chat/trait_sheet.dm` — loads that file and overrides the sheet's
  right-click branch for Russian players.
- `strings/fragments.txt` — whole text nodes matched exactly: combat, status,
  refusals, items, the wound crit messages.
- `strings/speech.txt` — speech verbs and emotes, merged into the same exact-match
  table. Both arrive as their own text node because the speaker's name is wrapped
  in its own tag (`say_quote()` in `code/game/say.dm`, and
  `msg = "<b>[user]</b> " + msg` in `code/datums/emotes.dm`), so the player's own
  words sit in a separate span and are never touched.
- `strings/honorifics.txt` — titles the server glues onto a name in the same
  string. Declined like nouns, but published as their own table: the panel is
  allowed to split a capture on these and on nothing else.
- `strings/medical.txt` — surgery, organs, senses, pain, disease, the self-examine
  readout, and the injury stage names. The stage block is **generated** by a
  script from a noun table and an adjective table, not written by hand: 280 names
  x singular/plural is exactly where one silent gender disagreement hides.
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

The attack line has four shapes, built in `species.dm` (unarmed) and
`item_attack.dm` (weapon), and their order in the file is not negotiable:

1. `[user] [verb] [target] in the [zone] with [item]!`
2. `[user] [verb] [target] in the [zone]!`
3. `[user] [verb] [target] with [item]!`
4. `[user] [verb] [target]!`

Each later shape is a prefix of the earlier one, so a lazy `(.+?)` in shape 4 will
happily swallow `Ivan in the chest with the sword` as the target name. Shapes 3
and 4 also have to sit **below** the possessive wrestling patterns
(`X bites Y's throat!`, `X smashes Y's head into the wall!`) for the same reason —
`test3.mjs` caught exactly that regression when they were first written too high.

`me` is declined in `nouns.txt` alongside the body parts. It is not a noun, but it
lands in the same `$2|acc` / `$2|dat` slot as a target's name, which is much
cheaper than a second pattern per verb for the first-person copy of every line.

The verb itself cannot be a capture: the template language interpolates captures
verbatim and has no verb table, so each Russian verb needs its own pattern with an
alternation of the English verbs that map onto it. That is why the block is long.
The alternations put multi-word verbs first — `chops at` before `chops`,
`viciously bites` before `bites` — because regex alternation takes the first
branch that matches and the short one would leave ` at` dangling in the output.

**Group a verb by the intent it comes from, not by how it reads.** `jabs` and
`clocks` sit in `list("punches", "jabs", "clocks")` on the unarmed punch intent,
so a fist that "jabs" must not render as пронзает; `arcs` ships with `sweeps` on a
sword intent and is an arc of the blade, not lightning; `cracks` and `canes` are
whip intents. Check `attack_verb` at the source before deciding.

Shape 4 — `[user] [verb] [target]!`, no location and no weapon — is
indistinguishable from ordinary prose: `^(.+?) stings (.+?)!$` matches
"The pain stings a little!" just as happily as a real sting. So that block sits at
the very bottom of `patterns.txt`, every other pattern gets first refusal, and any
fixed string it would still capture is given an exact fragment, because fragments
are checked before patterns. `scripts` note: the collision list is regenerated by
walking the source for literals and testing them against those patterns, which is
how the seventeen currently in `fragments.txt` were found.

## Declensions

Russian needs cases that a rendered English string cannot supply: `[user] bites
[C]'s [parse_zone(...)]` wants an accusative body part and a genitive name.

- **Body parts** are a closed set (`parse_zone()` in `code/__HELPERS/medical.dm`),
  so they are declined in `strings/nouns.txt` once.
- **Titles** are glued onto the name by the server in the same string
  (`"[honorary] [real_name]"` in `get_face_name()`), so `Lady Herald Vicente`
  arrives as one capture while the player's declensions are keyed on `Vicente`
  alone. The engine therefore splits a leading title off, declines it from
  `honorifics.txt`, declines the remainder normally and rejoins the two. Splitting
  is restricted to that table on purpose: allowing it over the whole noun table
  would turn `sword of truth` into `меч of truth`. A title is still translated when
  the name behind it has no declensions.
- **Character names** cannot be declined automatically, so players fill them in
  themselves in the **Склонения** column of the character menu — five optional
  fields. Anything left blank falls back to the nominative, which is the same
  result as not filling the form in at all.

`reject_bad_name()` must never be used on these fields: it walks bytes and accepts
only ASCII, so it strips Cyrillic to nothing. `handle_link` uses
`browser_input_text(..., encode = FALSE)`; the base text preference already strips
HTML on deserialize.

The five fields are `PREF_CHARACTER` preferences that carry **`should_apply = FALSE`** and
`should_update_preview = FALSE`. Both matter. `/datum/preferences/apply_prefs_to()` walks every
`PREF_CHARACTER` preference and calls `apply_to_human()` on it, and the base implementation of
that proc is a `CRASH("not implemented")` - so without the flag each of the five threw a runtime
every time a character was applied to a mob (found on a live test, 2026-09-17). A declension is
chat metadata read by `read_declensions()`; there is nothing to put on the mob, and
`should_apply` is exactly the "preference we don't natively apply" switch the base provides
(`selected_accent` uses it for the same reason). The preview flag is the cheaper half: a case
ending cannot change a sprite, so rebuilding the doll on every keystroke-sized save was pure
cost.

The input window itself is widened by a modular override in `modular_abel/upstream_fixes.dm` -
upstream sizes every single-line `browser_input_text` at 350x125, which is enough for a short
English prompt and not for `Родительный падеж — кого? чего? (например: Ивана Петрова)`.

Items and mob names are **not** covered — they are open-ended, and an undeclined
noun there renders in the nominative.

## Scope

`strings/` currently holds 1682 chat fragments, 497 patterns, 2822 names and body
parts, 54 honorifics, 3242 type-keyed descriptions and 198 character-sheet
entries, mined out of
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

**Item and creature names are generated.** 2752 of the 3459 names on `/obj/item`
and `/mob` (80%) are covered. A name is `<modifiers> <head noun>` and Russian
makes every modifier agree with the head, so writing thousands of them by hand is
a guarantee of a silent disagreement somewhere in the middle. Instead:

- `morph.py` derives the six cases from a nominative plus a gender/animacy tag.
  It has its own self-test, and it **raises** on a paradigm it does not handle
  rather than guessing.
- `gen_names.py` holds a head-noun table (Russian nominative, gender, animacy,
  and explicit forms for plural-only nouns like `сапоги`) and a modifier table
  (one Russian adjective each). A name whose head or any modifier is unknown is
  **skipped**, not approximated, and reported so the tables can grow.
- A head can be qualified by type path, because English is ambiguous where
  Russian is not: `plate` is a dish under `/obj/item/plate` and armour under
  `/obj/item/clothing/armor/plate`.

The generator grew four shapes beyond "modifier + head" as the tail got flatter:

- **`X of Y`** — Russian says it with the genitive and no preposition, so the
  tail is declined once and rides along fixed: `amulet of Dendor` →
  `амулет Дендора`.
- **roman numerals and dice notation** (`Tier II`, `d20`) pass through every case
  untouched, because they are not words.
- **a trailing parenthetical** of any length (`Book (Apocrypha & Grimoires)`) is
  a label, translated once and kept in place.
- **whole-phrase names** — a book title is a sentence, not a phrase with a head,
  so those are entered outright.

The fork's invented nouns **are** translated, by transliteration: that is the
community's own treatment (the wiki writes даэ, Псайдон, Грензельхофт), so it
follows a convention rather than inventing one.

What is left in English is deliberate and is the same rule as the abstract
descriptions: names that exist to tell a coder something is wrong — `???`,
`placeholder`, `coders`, `mappers`, `(null_reference_exception)`, `base`,
`template`. A bug report has to stay legible to whoever reads it.

Names are a chat concern, not an examine one: the examine header's name comes from
`get_examine_name()` and is not routed through this module, so a translated desc
under an English name is expected.

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

**A commented-out type looks exactly like a declared one to a line-based parser.**
Nine keys got into the file this way — the seven `psycross/gronn*` talismans, a
book template and a garlic that all sit inside `/* */` blocks — and each one
printed a `stack_trace` on first examine. `modular_examine_descriptions` is what
catches this, because `text2path()` returns null for a type that was never
compiled; any offline mining or checking script must strip block comments before
it believes a `/type/path` line.

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

### Gender you cannot know at write time

A pattern that captures a body part cannot use an adjective or a past-tense verb,
because Russian makes both agree with a gender the template author never sees:
`$1|nom сломан` reads correctly for `нос` and wrong for `левая рука`, and nothing
in the dictionary can tell which arrives. Two phrasings sidestep it entirely and
are used throughout the limb and organ lines:

- an **impersonal verb** with the part in the accusative — `Вывихнуло $1|acc.`
  works for `нос`, `левую руку` and `ухо` alike;
- the **present tense, third person**, which does not inflect for gender at all —
  `Не слушается $1|nom.`, `$1|nom не чувствует прикосновений.`

`translate.test.ts` pins this with a feminine and a neuter part through the same
pattern, so a future rewrite into an adjective fails instead of reading wrong on
one part in twenty.

### Terminology

The fork's invented words are not translated from scratch: the Russian-speaking
community around the Vanderlin-derived forks has settled renderings, and the
wiki at `wiki.twilight-fortress-axis.ru` is where they are written down. Two of
them were corrections to what was here, not preferences:

- **`arcyne` is `аркана` as a noun and `арканный` as an adjective.** `аркановый`
  was a coinage of mine that nobody else says. 64 lines changed.
- **`dwarf` and `gnome` are different races and the codebase has both.**
  Rendering each as `гном` collapsed them; the established split is Дворфы and
  Гномы. 29 description entries were repointed to `дворф*` — each one checked
  against its own English desc first, so the four that genuinely say *gnome*
  (the homunculus, the silver statue, the growth vat, the alchemy book) stayed.

Also aligned: `аасимар` (not `ассимар`), `венардин` for the venard.

Also switched to the wiki's spelling where it has one: **даэ** for `dae`
(indeclinable, and used that way on four wiki pages), **Ксайликс** for Xylix,
**Грензельхофт** for Grenzelhoft.

`nite` keeps **нощь**: the wiki has no spelling for it — neither `нощь` nor
`найт` returns a hit — and the source is using an archaic spelling of an ordinary
word, which the archaism mirrors. Revisit if the community settles on one.

**The wiki is the reference for the fork's invented words.** Do not coin a new
Russian term for one without checking there first; two of the three corrections
above were terms invented here that nobody else says.

### The character sheet

The sheet's right-click block is built by one upstream branch that interpolates
the English straight into the message:

```dm
to_chat(L, "[X] - <span class='info'>[GLOB.roguetraits[X]]</span>")
```

Keying that by text would need two independent keys per trait — `Webwalker -` for
the name and `I can move freely between webs.` for the description — and reword
either one upstream and the translation silently stops matching. So the sheet
follows the same rule as the descriptions: **the key is what the thing is, not
what it says.**

`strings/traits.txt` carries three key shapes, all resolved server-side:

```
Webwalker            = Паутинник | Я свободно хожу по паутине.
/datum/quirk/vice/mute = Я совсем не могу говорить...
/datum/language/elvish = Эльфийский
```

A trait's name is what its `TRAIT_*` define expands to, which is its identity in
code the same way a type path is an atom's; quirks and languages are real datums
and get real paths. `modular_trait_sheet` resolves every key — a trait name has to
be in `GLOB.roguetraits`, a path has to be a quirk or a language — so a rename
fails the test instead of going quiet.

`/atom/movable/screen/skills/Click()` is overridden to reproduce that one branch
in Russian and defers to `..()` for every other click and for English players.
Only the block's frame (`I have no special traits.`, the encumbrance words) stays
in the client dictionary, because it belongs to no trait and has nothing to key on.

### The examine screens

Three blocks a player reads constantly are assembled from many small nodes rather
than one sentence, so each piece is translated separately:

- **Item properties** (the `{?}` button, `get_inspect_entries()` in
  `code/game/objects/items.dm`) — every `<b>LABEL:</b>` ends a text node, so the
  labels are fragments while `PROPERTIES OF [name]` is a pattern. `Stamina Drain: 20`
  and `Max Range: IV` are the exception: label and value share one node, so those
  are patterns too.
- **SPECIAL** (`get_examine()` in `code/modules/combat/_special_intent.dm`) — the
  label, the ability name and the description are three nodes; all thirteen
  specials are in `fragments.txt`.
- **Self-examine** (`check_for_injuries()`) — when a player examines themselves the
  subject is always the literal `I am`, so those lines are fragments; the
  third-person copy is a pattern. The limb label `☼ Head:` is a pattern that
  declines the body part, and the injury words behind it come from the generated
  stage block.

The counters in front of an injury (`pair of`, `several`, `ton of`) are their own
node and cannot govern the case of the noun that follows, which is what Russian
would need. They are rendered as `2 ×`, `3-5 ×` and `6+ ×` instead — grammatically
inert, and the ranges are the ones in the source's own `switch`, so nothing is lost.

`bloody` is prepended to an item's name by `/datum/component/decal/blood`, which
would force an adjective to agree with a noun the component never sees. The
modular override in `description_composites.dm` moves the marker behind the name
(`рапира в крови`), which reads the same for every gender.

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

## Chargen sheet (`strings/chargen.txt`)

Species, faith and patron strings for the character-setup menu. Server-resolved and absent from
the browser dictionary for the same reason `traits.txt` is: the keys are **type paths**, not
English text, so an upstream reword cannot silently orphan a translation.

```
/тип/путь        = <имя> | <описание>
/тип/путь:поле   = <текст>
```

A type path cannot contain `:`, which is what makes the field suffix unambiguous. The fields are
the ones the patron card renders: `domain`, `boons`, `sins`, `flaws`, `worshippers`.

`chargen_tr_name()`, `chargen_tr_desc()` and `chargen_tr_field()` take the client and fall back
to the English value whenever the player is on EN or the key is absent, so a **partially filled
file is a valid state** — untranslated entries simply stay English. That is deliberate: the file
ships mostly empty and is filled incrementally.

Each resolver is a one-line wrapper over a `_for(ru, …)` core: `chargen_tr_name()` is
`chargen_tr_name_for(chargen_sheet_active(target), …)`. The split exists because the chargen
species catalog is generated once per server as a browser asset, with **both** languages in it,
long before any client is in scope — see *The third tier* in
`modular_abel/character_setup/README.md`. Anything that resolves for a player keeps using the
client-taking form; anything that has to answer for a language it was handed uses `_for`.

Faiths and patrons still resolve per player, in `character_setup_faith_options()` and
`character_setup_patron_options_for_faith()` (`modular_abel/character_setup/`), so their
translated strings reach `ui_static_data` and `ui_data` without the frontend knowing.

Filling the file is copy-paste rather than transcription: the **Chargen Sheet: Missing Keys**
verb (`Debug.Telemetry`, `R_DEBUG`) writes every species, faith and patron the sheet does not
cover into `chargen_sheet.log`, already in this file's line format with the English on the right.

`/datum/unit_test/modular_chargen_sheet` resolves every key through `text2path()`, rejects a key
that is not a species, faith or patron, rejects a field name the UI does not render or a patron
field set on a non-patron, and requires the `" | "` separator on every name/description line.

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
  `modular_examine_descriptions` resolves every description key through
  `text2path()`; this is the only thing that catches a type that exists in the
  source but only inside a `/* */` block.
  `modular_description_composites` covers the runtime-composed descriptions: a
  themed spellbook form with no Russian flavour line, or a tier missing from
  `descriptions.txt`, fails here rather than examining as half-English.
- `tgui/packages/tgui-panel/localization/translate.test.ts` — engine behaviour:
  exact hits, padding, declension, fallback for an unknown name, passthrough, the
  English path, a malformed pattern, and cache invalidation when declensions
  arrive late. It also pins the attack-shape ordering — the with-weapon form
  beating the bare one, the hit location staying out of the target capture,
  `chops at` beating `chops`, `draws X from Y` beating `draws X`, `kg` beating
  `g` — and the possessive wrestling patterns surviving underneath them.
