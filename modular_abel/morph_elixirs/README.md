# morph_elixirs — armour reskins, sold as morphing elixirs

Six armour skins ported from Ratwood 2.0 and Azure Peak, plus one cloak. The armour is **not**
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
