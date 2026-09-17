# morph_elixirs — armour reskins, sold as morphing elixirs

Thirty-six armour skins and six weapon skins ported from Ratwood 2.0 and Azure Peak, plus two cloaks. The armour is **not**
sold as items. Each skin is declared as a subtype of the Vibelin armour it reskins, and the
shop sells an `/obj/item/enchantingkit` that turns the real armour into it — the player still
has to own, or forge, the piece being morphed.

That is the rule this module exists to obey, the same one `modular_abel/snouted_helms` follows:
a reskin of something mechanical goes through an elixir, never into the wardrobe. Selling the
cuirass outright would be selling armour; selling the elixir sells the look.

## What is in it

| Elixir | Morphs | Into | From |
| --- | --- | --- | --- |
| Cataphract Half-Plate | `armor/plate` | `armor/plate/cataphract` | Ratwood `modular_deserttown` |
| Artificed Half-Plate | `armor/plate` | `armor/plate/artificer` | Ratwood |
| Heartfelt Brigandine | `armor/brigandine` | `armor/brigandine/heartfelt` | Ratwood |
| Apostolic Cuirass | `armor/cuirass` | `armor/cuirass/apostle` | Azure Peak |
| Low Cut Gambeson | `armor/gambeson` | `armor/gambeson/cropped` | Azure Peak |
| Bronze Wristguards | `wrists/bracers` | `wrists/bracers/bronze` | Ratwood |

The cataphract's cloak is a plain garment and is sold as one, in the `Cloaks` tab: a cloak
carries no armour, so there is nothing for an elixir to protect.

## The contract

`/datum/unit_test/modular_morphing_elixir` checks every kit in the game, and these were written
against it:

- **every result inherits from its target.** `armor/plate/cataphract` is a subtype of
  `armor/plate`, so the morph cannot change `armor_type`, coverage, integrity, `sellprice` or
  smelt result — it only replaces the sprite vars. That is what makes the skin fair.
- **no reskin sets an armour var.** Each declares `name`, `desc`, `icon`, `mob_overlay_icon`,
  `icon_state`, `item_state` and nothing else.
- **targets are listed child-first.** The test fails a kit that lists a parent before one of
  its own subtypes, because the parent would claim the match and the subtype could never fire.
  These kits each target one type, so the ordering is trivially satisfied; it stops mattering
  only until someone adds a second line.

Two kits target `armor/plate` and that is deliberate — a player picks which look they want, and
the two elixirs are separate purchases.

## Art

| Sheet | Cells | Sources |
| --- | --- | --- |
| `morph_elixirs_world.dmi` | 32x32, 9 states | Ratwood `modular_deserttown/.../armor.dmi` and `cloaks.dmi`, `icons/roguetown/clothing/armor.dmi`, `wrists.dmi`; Azure `icons/clothing/donor_clothes.dmi` |
| `morph_elixirs_onmob.dmi` | 32x32, 47 states | the `onmob` siblings of all five |

## Not taken from Ratwood

Ratwood's blacksteel bucket helm looked like a candidate and is **already in this codebase**
(`/obj/item/clothing/head/helmet/blacksteel/bucket`, `code/modules/clothing/head/helmets/misc.dm`).
It is a fair warning about that checkout: it shares most of its lineage with Vanderlin, so the
first question about any Ratwood candidate is whether we already have it, not whether it is
nice. `port_clothing.py` answers that with its `already_here` flag.

## The two sets

Ten of the sixteen are **complete armour sets**, ported piece by piece so a player can buy the
whole look one elixir at a time. That is the point of doing sets: each piece morphs its own
slot, and half a set is a perfectly reasonable thing to own.

**Oathmarked** (Ratwood `special/blkknight.dmi`) — plate, helm, sabatons, plus the blacksteel
gauntlets and chausses that belong with it:

| Elixir | Morphs | Into |
| --- | --- | --- |
| Oathmarked Plate | `armor/plate/full` | `plate/full/oathmarked` |
| Oathmarked Helm | `head/helmet/heavy` | `helmet/heavy/oathmarked` |
| Oathmarked Sabatons | `shoes/boots/armor` | `boots/armor/oathmarked` |
| Blacksteel Gauntlets | `gloves/plate` | `gloves/plate/blacksteel` |
| Blacksteel Chausses | `pants/platelegs` | `platelegs/blacksteel` |

**Baothan** (Ratwood `special/baotha.dmi`) — cuirass, helm of desire, bracers, leg-plates and
the leather straps:

| Elixir | Morphs | Into |
| --- | --- | --- |
| Baothan Cuirass | `armor/plate` | `plate/baotha` |
| Helm of Desire | `head/helmet/heavy` | `helmet/heavy/baotha` |
| Baothan Bracers | `wrists/bracers` | `bracers/baotha` |
| Baothan Leg-Plates | `pants/platelegs` | `platelegs/baotha` |
| Baothan Straps | `armor/leather` | `leather/baotha` |

Two things about the mappings are deliberate and easy to get wrong when adding to them:

- **Every reskin is a *direct* subtype of the piece it morphs from.** The baothan straps are
  `armor/leather/baotha`, not `armor/leather/studded/baotha`, even though the donor files them
  under studded — going through `studded` would drag its armour values along and the morph
  would change how much the wearer is protected. Direct subtype, no intermediate, no stat
  drift.
- **Two elixirs can share a target.** `head/helmet/heavy` is morphed by both the oathmarked
  helm and the helm of desire, and `pants/platelegs` by both leg pieces. That is fine: they are
  separate purchases, and the unit test only forbids listing a parent *before* its own subtype
  inside one kit.

The helm of desire uses a 32x48 worn sheet (`morph_elixirs_onmob48.dmi`) — the donor's file is
named `baotha64.dmi` but its cells are 32x48, so the sheet here is named after what is actually
in it.

## Two more sets, and one that is off limits

**Arbiter** (Ratwood `special/overseer/overseer.dmi`) — nine pieces, the whole inquisitorial
uniform: gloves and vice-arbiter's gloves, sackcloth hood, heavy gambeson, faceless mask and
its vice-arbiter twin, leather trousers, undershirt and brigandine.

Three of those nine morph from garments that carry no armour at all — the hood, the trousers
and the shirt. Strictly, the elixir rule does not require it for those. They are elixirs anyway
so the set stays one thing a player collects in one place, and because a uniform that arrives
half through the wardrobe and half through elixirs is a worse experience than a consistent one.

**Cataphract and janissary** (Ratwood `modular_deserttown`) — the cataphract helm finishes the
set whose cuirass and cloak were already here, and the janissary hauberk, helm and cape come
across together. The cape carries no armour, so it is sold as a plain cloak.

The cataphract helm needed a **fourth sheet**, `morph_elixirs_world48.dmi`: its inventory icon
is 32x48 in the donor, not 32x32, and `dmi_merge.py` will not mix cell sizes in one sheet.

### Not ported: `licensed-infraredbaron`

Ratwood's `icons/roguetown/clothing/licensed-infraredbaron/` holds a city watch set and eight
newkeep noble uniforms, and it ships a `LICENSE.md` saying the assets are licensed privately
between a client and the artist, may not be redistributed or modified, and are for use solely
within that project. None of it is ported and none of it should be. See
`modular_abel/rmh_wardrobe/README.md` — one piece from the same artist's folder in another
checkout did get ported before anyone read that file, and had to be taken back out.

## The apostolic series and the named helms

Eight more from Azure's `donor_clothes.dmi`: apostolic plate and bascinet, the grandmaster's
aventailed bascinet and the habited one, the holy astratan bascinet, the avantyne barbute, the
fencing brigandine and the archaic ceremonial cuirass.

Several of these are **named donator rewards on the donor side**, and the people they were made
for are credited here on purpose:

| Piece | Named for |
| --- | --- |
| Grandmaster's Bascinet, Habited Bascinet, Archaic Ceremonial Cuirass | `dasfox` |
| Holy Astratan Bascinet | `spartanbobby` |
| Avantyne Barbute | `dakken` |

The type paths here are named after what the thing *is* rather than who it was made for, because
a path is a filing decision and `armor/cuirass/archaic` is where the next maintainer will look
for it. The handles live in this table instead: these sprites exist because those players paid
for them and an artist drew them, and that should be written down somewhere that survives the
port. If a piece ever needs to stay *attached* to a person in game, that is what `required_award`
is for, not the path.

Four of the eight morph from `head/helmet/bascinet` — the order's helm, the grandmaster's, the
habited one and the astratan. Four separate kits, four separate purchases, one shared base.

## Weapons

Six weapon skins, in two series Azure ships as sets rather than one-offs:

| Elixir | Morphs | Into |
| --- | --- | --- |
| Autumned Elvish Longsword | `weapon/sword/long` | `sword/long/autumn_elvish` |
| Autumned Elvish Dagger | `weapon/knife/dagger` | `knife/dagger/autumn_elvish` |
| Autumned Elvish Bardiche | `weapon/polearm/halberd/bardiche` | `bardiche/autumn_elvish` |
| Decrepit Greatshield | `weapon/shield/tower` | `shield/tower/decrepit` |
| Decrepit Hoplon Shield | `weapon/shield/heater` | `shield/heater/decrepit` |
| Decrepit Pitchfork | `weapon/pitchfork` | `pitchfork/decrepit` |

The elixir contract holds exactly as it does for armour, and it is what makes a weapon skin
sellable at all: the reskin is a direct subtype, so `force`, `force_wielded`, `wlength`,
wound classes and everything else about how the thing hits stay the parent's. Only the sprite
vars are replaced. The unit test already covered this — it checks `ispath(target_type, /obj/item)`,
not `/obj/item/clothing`.

**They are filed in the `Held Item` shop tab**, not `Armor`.

**What the elixir does not change: the in-hand sprite.** Vanderlin draws a held weapon from
`lefthand_file`/`righthand_file`, and none of the donor's variants override those — in Azure
they inherit the base weapon's in-hand art too. So the blade changes on the ground, in the
inventory and in the shop card, and the hand still holds the silhouette of the base weapon.
Porting the in-hand art as well would mean pulling cells out of `icons/mob/inhands/weapons/`
and is a separate job; nothing here pretends otherwise.

### Two candidates left behind

The decrepit flamberge and the decrepit thresher have no home in this fork: there is no
greatsword type here (the largest blade is `sword/long`), and the nearest thing to a thresher
is `weapon/flail`. Hanging a flamberge sprite on a longsword or a thresher on a flail would
make the elixir a lie about what the player is holding, so both are left for whoever adds
those weapon families.

## Art

| Sheet | Cells | Sources |
| --- | --- | --- |
| `morph_elixirs_weapons64.dmi` | 64x64, 2 states | Azure `weapons/swords64.dmi`, `polearms64.dmi` |
| `morph_elixirs_weapons32.dmi` | 32x32, 4 states | Azure `weapons/daggers32.dmi`, `shields32.dmi`, `tools.dmi` |
