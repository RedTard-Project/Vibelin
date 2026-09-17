/obj/item/clothing/armor/plate/cataphract
	name = "cataphract half-plate"
	desc = "Steel half-plate in the eastern cataphract pattern, scaled at the shoulder and banded down the flank."
	icon = 'modular_abel/morph_elixirs/icons/morph_elixirs_world.dmi'
	mob_overlay_icon = 'modular_abel/morph_elixirs/icons/morph_elixirs_onmob.dmi'
	icon_state = "cataphract"
	item_state = "cataphract"

/obj/item/clothing/armor/plate/artificer
	name = "artificed half-plate"
	desc = "Steel half-plate worked over with fluting and fitted brass, by a smith with more time than sense."
	icon = 'modular_abel/morph_elixirs/icons/morph_elixirs_world.dmi'
	mob_overlay_icon = 'modular_abel/morph_elixirs/icons/morph_elixirs_onmob.dmi'
	icon_state = "artificerplate"
	item_state = "artificerplate"

/obj/item/clothing/armor/brigandine/heartfelt
	name = "heartfelt brigandine"
	desc = "A brigandine faced in dyed cloth and pinned in neat rows, cut for a household that wants its colours seen."
	icon = 'modular_abel/morph_elixirs/icons/morph_elixirs_world.dmi'
	mob_overlay_icon = 'modular_abel/morph_elixirs/icons/morph_elixirs_onmob.dmi'
	icon_state = "brigandine2"
	item_state = "brigandine2"

/obj/item/clothing/armor/cuirass/apostle
	name = "apostolic cuirass"
	desc = "A fluted cuirass chased with the marks of a knightly order, polished to the point of being a nuisance."
	icon = 'modular_abel/morph_elixirs/icons/morph_elixirs_world.dmi'
	mob_overlay_icon = 'modular_abel/morph_elixirs/icons/morph_elixirs_onmob.dmi'
	icon_state = "apostlecuirass"
	item_state = "apostlecuirass"

/obj/item/clothing/armor/gambeson/cropped
	name = "low cut gambeson"
	desc = "A padded gambeson cut short at the waist and open at the collar. Cooler, and considerably less modest."
	icon = 'modular_abel/morph_elixirs/icons/morph_elixirs_world.dmi'
	mob_overlay_icon = 'modular_abel/morph_elixirs/icons/morph_elixirs_onmob.dmi'
	icon_state = "cropgambeson"
	item_state = "cropgambeson"

/obj/item/clothing/wrists/bracers/bronze
	name = "bronze wristguards"
	desc = "Bronze guards strapped over the forearm, green at the edges where the polish gave up."
	icon = 'modular_abel/morph_elixirs/icons/morph_elixirs_world.dmi'
	mob_overlay_icon = 'modular_abel/morph_elixirs/icons/morph_elixirs_onmob.dmi'
	icon_state = "bronzebracers"
	item_state = "bronzebracers"

/obj/item/clothing/cloak/catcloak
	name = "cataphract's cloak"
	desc = "A long riding cloak of the eastern heavy horse, cut to fall over a saddle rather than a pair of boots."
	icon = 'modular_abel/morph_elixirs/icons/morph_elixirs_world.dmi'
	mob_overlay_icon = 'modular_abel/morph_elixirs/icons/morph_elixirs_onmob.dmi'
	icon_state = "catcloak"
	sellprice = 70

/obj/item/enchantingkit/cataphract
	name = "morphing elixir of the cataphract"
	desc = "A small container of special morphing dust, tuned to beat a suit of half-plate into the cataphract pattern."
	target_items = list(
		/obj/item/clothing/armor/plate = /obj/item/clothing/armor/plate/cataphract,
	)

/obj/item/enchantingkit/artificerplate
	name = "morphing elixir of the artificer"
	desc = "A small container of special morphing dust, tuned to flute and gild a suit of half-plate."
	target_items = list(
		/obj/item/clothing/armor/plate = /obj/item/clothing/armor/plate/artificer,
	)

/obj/item/enchantingkit/heartfeltbrigandine
	name = "morphing elixir of the heartfelt brigandine"
	desc = "A small container of special morphing dust, tuned to face a brigandine in household colours."
	target_items = list(
		/obj/item/clothing/armor/brigandine = /obj/item/clothing/armor/brigandine/heartfelt,
	)

/obj/item/enchantingkit/apostlecuirass
	name = "morphing elixir of the apostolic cuirass"
	desc = "A small container of special morphing dust, tuned to chase a cuirass with the marks of a knightly order."
	target_items = list(
		/obj/item/clothing/armor/cuirass = /obj/item/clothing/armor/cuirass/apostle,
	)

/obj/item/enchantingkit/croppedgambeson
	name = "morphing elixir of the low cut gambeson"
	desc = "A small container of special morphing dust, tuned to crop a gambeson at the waist and open its collar."
	target_items = list(
		/obj/item/clothing/armor/gambeson = /obj/item/clothing/armor/gambeson/cropped,
	)

/obj/item/enchantingkit/bronzebracers
	name = "morphing elixir of the bronze wristguards"
	desc = "A small container of special morphing dust, tuned to recast a pair of bracers in bronze."
	target_items = list(
		/obj/item/clothing/wrists/bracers = /obj/item/clothing/wrists/bracers/bronze,
	)

/obj/item/clothing/armor/plate/full/oathmarked
	name = "oathmarked plate"
	desc = "Full plate blackened in the forge and struck with an oath along the breast. The oath is not explained."
	icon = 'modular_abel/morph_elixirs/icons/morph_elixirs_world.dmi'
	mob_overlay_icon = 'modular_abel/morph_elixirs/icons/morph_elixirs_onmob.dmi'
	icon_state = "bplate"
	item_state = "bplate"

/obj/item/clothing/head/helmet/heavy/oathmarked
	name = "oathmarked helm"
	desc = "A closed helm of the same blackened make, its visor cut in a single narrow line."
	icon = 'modular_abel/morph_elixirs/icons/morph_elixirs_world.dmi'
	mob_overlay_icon = 'modular_abel/morph_elixirs/icons/morph_elixirs_onmob.dmi'
	icon_state = "bplatehelm_nv"
	item_state = "bplatehelm_nv"

/obj/item/clothing/shoes/boots/armor/oathmarked
	name = "oathmarked sabatons"
	desc = "Blackened sabatons, articulated at the toe and loud on any floor worth walking across."
	icon = 'modular_abel/morph_elixirs/icons/morph_elixirs_world.dmi'
	mob_overlay_icon = 'modular_abel/morph_elixirs/icons/morph_elixirs_onmob.dmi'
	icon_state = "bplateboots"
	item_state = "bplateboots"

/obj/item/clothing/gloves/plate/blacksteel
	name = "blacksteel gauntlets"
	desc = "Plate gauntlets in blacksteel, fingered and fitted close enough to keep a grip on a wet hilt."
	icon = 'modular_abel/morph_elixirs/icons/morph_elixirs_world.dmi'
	mob_overlay_icon = 'modular_abel/morph_elixirs/icons/morph_elixirs_onmob.dmi'
	icon_state = "bplategloves"
	item_state = "bplategloves"

/obj/item/clothing/pants/platelegs/blacksteel
	name = "blacksteel chausses"
	desc = "Blackened leg harness, banded at the thigh and hinged at the knee."
	icon = 'modular_abel/morph_elixirs/icons/morph_elixirs_world.dmi'
	mob_overlay_icon = 'modular_abel/morph_elixirs/icons/morph_elixirs_onmob.dmi'
	icon_state = "bplatelegs"
	item_state = "bplatelegs"

/obj/item/clothing/armor/plate/baotha
	name = "baothan cuirass"
	desc = "A cuirass beaten into curves it does not need, in the manner of the Lady of Desire's own."
	icon = 'modular_abel/morph_elixirs/icons/morph_elixirs_world.dmi'
	mob_overlay_icon = 'modular_abel/morph_elixirs/icons/morph_elixirs_onmob.dmi'
	icon_state = "baothachest"
	item_state = "baothachest"

/obj/item/clothing/head/helmet/heavy/baotha
	name = "helm of desire"
	desc = "A tall helm crowned in worked metal. It is meant to be looked at, and it makes certain of it."
	icon = 'modular_abel/morph_elixirs/icons/morph_elixirs_world.dmi'
	mob_overlay_icon = 'modular_abel/morph_elixirs/icons/morph_elixirs_onmob48.dmi'
	icon_state = "baothahelmet"
	item_state = "baothahelmet"

/obj/item/clothing/wrists/bracers/baotha
	name = "baothan bracers"
	desc = "Bracers chased with the same indulgent scrollwork as the rest of the set."
	icon = 'modular_abel/morph_elixirs/icons/morph_elixirs_world.dmi'
	mob_overlay_icon = 'modular_abel/morph_elixirs/icons/morph_elixirs_onmob.dmi'
	icon_state = "baothabracers"
	item_state = "baothabracers"

/obj/item/clothing/pants/platelegs/baotha
	name = "baothan leg-plates"
	desc = "Leg plates cut high and shaped to flatter, which is a strange thing to ask of leg plates."
	icon = 'modular_abel/morph_elixirs/icons/morph_elixirs_world.dmi'
	mob_overlay_icon = 'modular_abel/morph_elixirs/icons/morph_elixirs_onmob.dmi'
	icon_state = "baotha_legs"
	item_state = "baotha_legs"

/obj/item/clothing/armor/leather/baotha
	name = "baothan straps"
	desc = "Cured leather cut into bands and buckled across the chest. It covers what the cuirass would, and little else."
	icon = 'modular_abel/morph_elixirs/icons/morph_elixirs_world.dmi'
	mob_overlay_icon = 'modular_abel/morph_elixirs/icons/morph_elixirs_onmob.dmi'
	icon_state = "baothashirt"
	item_state = "baothashirt"

/obj/item/enchantingkit/oathmarkedplate
	name = "morphing elixir of the oathmarked plate"
	desc = "A small container of special morphing dust, tuned to blacken a suit of full plate and strike it with an oath."
	target_items = list(
		/obj/item/clothing/armor/plate/full = /obj/item/clothing/armor/plate/full/oathmarked,
	)

/obj/item/enchantingkit/oathmarkedhelm
	name = "morphing elixir of the oathmarked helm"
	desc = "A small container of special morphing dust, tuned to blacken a heavy helm and narrow its visor."
	target_items = list(
		/obj/item/clothing/head/helmet/heavy = /obj/item/clothing/head/helmet/heavy/oathmarked,
	)

/obj/item/enchantingkit/oathmarkedboots
	name = "morphing elixir of the oathmarked sabatons"
	desc = "A small container of special morphing dust, tuned to blacken a pair of armoured boots."
	target_items = list(
		/obj/item/clothing/shoes/boots/armor = /obj/item/clothing/shoes/boots/armor/oathmarked,
	)

/obj/item/enchantingkit/blacksteelgauntlets
	name = "morphing elixir of the blacksteel gauntlets"
	desc = "A small container of special morphing dust, tuned to recast a pair of plate gauntlets in blacksteel."
	target_items = list(
		/obj/item/clothing/gloves/plate = /obj/item/clothing/gloves/plate/blacksteel,
	)

/obj/item/enchantingkit/blacksteelchausses
	name = "morphing elixir of the blacksteel chausses"
	desc = "A small container of special morphing dust, tuned to blacken and band a leg harness."
	target_items = list(
		/obj/item/clothing/pants/platelegs = /obj/item/clothing/pants/platelegs/blacksteel,
	)

/obj/item/enchantingkit/baothacuirass
	name = "morphing elixir of the baothan cuirass"
	desc = "A small container of special morphing dust, tuned to beat a cuirass into the Lady of Desire's own lines."
	target_items = list(
		/obj/item/clothing/armor/plate = /obj/item/clothing/armor/plate/baotha,
	)

/obj/item/enchantingkit/baothahelm
	name = "morphing elixir of the helm of desire"
	desc = "A small container of special morphing dust, tuned to crown a heavy helm in worked metal."
	target_items = list(
		/obj/item/clothing/head/helmet/heavy = /obj/item/clothing/head/helmet/heavy/baotha,
	)

/obj/item/enchantingkit/baothabracers
	name = "morphing elixir of the baothan bracers"
	desc = "A small container of special morphing dust, tuned to chase a pair of bracers with indulgent scrollwork."
	target_items = list(
		/obj/item/clothing/wrists/bracers = /obj/item/clothing/wrists/bracers/baotha,
	)

/obj/item/enchantingkit/baothalegs
	name = "morphing elixir of the baothan leg-plates"
	desc = "A small container of special morphing dust, tuned to cut a leg harness high and shape it to flatter."
	target_items = list(
		/obj/item/clothing/pants/platelegs = /obj/item/clothing/pants/platelegs/baotha,
	)

/obj/item/enchantingkit/baothastraps
	name = "morphing elixir of the baothan straps"
	desc = "A small container of special morphing dust, tuned to cut a leather cuirass down into buckled bands."
	target_items = list(
		/obj/item/clothing/armor/leather = /obj/item/clothing/armor/leather/baotha,
	)

/obj/item/clothing/gloves/leather/arbiter
	name = "arbiter's gloves"
	desc = "Stiff leather gloves stamped at the cuff with the seal of an office nobody enjoys meeting."
	icon = 'modular_abel/morph_elixirs/icons/morph_elixirs_world.dmi'
	mob_overlay_icon = 'modular_abel/morph_elixirs/icons/morph_elixirs_onmob.dmi'
	icon_state = "overseergloves"
	item_state = "overseergloves"

/obj/item/clothing/gloves/leather/arbiter_vice
	name = "vice-arbiter's gloves"
	desc = "The same gloves, trimmed in silver instead of iron. One rank down, and twice as pleased about it."
	icon = 'modular_abel/morph_elixirs/icons/morph_elixirs_world.dmi'
	mob_overlay_icon = 'modular_abel/morph_elixirs/icons/morph_elixirs_onmob.dmi'
	icon_state = "viceseergloves"
	item_state = "viceseergloves"

/obj/item/clothing/face/sack/arbiter
	name = "arbiter's hood"
	desc = "A drawn sackcloth hood with two cut eyeholes. The anonymity is the uniform."
	icon = 'modular_abel/morph_elixirs/icons/morph_elixirs_world.dmi'
	mob_overlay_icon = 'modular_abel/morph_elixirs/icons/morph_elixirs_onmob.dmi'
	icon_state = "overseerhood"
	item_state = "overseerhood"

/obj/item/clothing/armor/gambeson/heavy/arbiter
	name = "arbiter's gambeson"
	desc = "A heavy padded gambeson in inquisitorial black, quilted in tight rows across the chest."
	icon = 'modular_abel/morph_elixirs/icons/morph_elixirs_world.dmi'
	mob_overlay_icon = 'modular_abel/morph_elixirs/icons/morph_elixirs_onmob.dmi'
	icon_state = "overseerjacket"
	item_state = "overseerjacket"

/obj/item/clothing/head/helmet/arbiter
	name = "arbiter's mask"
	desc = "A faceless iron mask worn over the hood. Whatever expression is behind it is not the point."
	icon = 'modular_abel/morph_elixirs/icons/morph_elixirs_world.dmi'
	mob_overlay_icon = 'modular_abel/morph_elixirs/icons/morph_elixirs_onmob.dmi'
	icon_state = "overseermask"
	item_state = "overseermask"

/obj/item/clothing/head/helmet/arbiter_vice
	name = "vice-arbiter's mask"
	desc = "The same blank iron face, chased in silver at the brow."
	icon = 'modular_abel/morph_elixirs/icons/morph_elixirs_world.dmi'
	mob_overlay_icon = 'modular_abel/morph_elixirs/icons/morph_elixirs_onmob.dmi'
	icon_state = "viceseermask"
	item_state = "viceseermask"

/obj/item/clothing/pants/trou/leather/arbiter
	name = "arbiter's trousers"
	desc = "Heavy leather trousers cut for long walks to places people would rather you did not reach."
	icon = 'modular_abel/morph_elixirs/icons/morph_elixirs_world.dmi'
	mob_overlay_icon = 'modular_abel/morph_elixirs/icons/morph_elixirs_onmob.dmi'
	icon_state = "overseerpants"
	item_state = "overseerpants"

/obj/item/clothing/shirt/undershirt/arbiter
	name = "arbiter's shirt"
	desc = "A plain dark shirt worn under the rest of it, and the only comfortable part of the uniform."
	icon = 'modular_abel/morph_elixirs/icons/morph_elixirs_world.dmi'
	mob_overlay_icon = 'modular_abel/morph_elixirs/icons/morph_elixirs_onmob.dmi'
	icon_state = "overseershirt"
	item_state = "overseershirt"

/obj/item/clothing/armor/brigandine/arbiter
	name = "arbiter's brigandine"
	desc = "A brigandine faced in black cloth over scales, pinned in rows and deliberately unadorned."
	icon = 'modular_abel/morph_elixirs/icons/morph_elixirs_world.dmi'
	mob_overlay_icon = 'modular_abel/morph_elixirs/icons/morph_elixirs_onmob.dmi'
	icon_state = "viceseercoat"
	item_state = "viceseercoat"

/obj/item/clothing/head/helmet/heavy/cataphract
	name = "cataphract's helm"
	desc = "A tall eastern helm with a mail aventail falling to the shoulder, made to be seen above a horse."
	icon = 'modular_abel/morph_elixirs/icons/morph_elixirs_world48.dmi'
	mob_overlay_icon = 'modular_abel/morph_elixirs/icons/morph_elixirs_onmob48.dmi'
	icon_state = "cathelm"
	item_state = "cathelm"

/obj/item/clothing/armor/chainmail/hauberk/janissary
	name = "janissary hauberk"
	desc = "A long mail hauberk in the janissary pattern, split for the saddle and trimmed at the hem."
	icon = 'modular_abel/morph_elixirs/icons/morph_elixirs_world.dmi'
	mob_overlay_icon = 'modular_abel/morph_elixirs/icons/morph_elixirs_onmob.dmi'
	icon_state = "mamaluke"
	item_state = "mamaluke"

/obj/item/clothing/head/helmet/janissary
	name = "janissary helm"
	desc = "A conical helm wrapped at the base, its nasal bar drawn down to a point."
	icon = 'modular_abel/morph_elixirs/icons/morph_elixirs_world.dmi'
	mob_overlay_icon = 'modular_abel/morph_elixirs/icons/morph_elixirs_onmob.dmi'
	icon_state = "mamhelm"
	item_state = "mamhelm"

/obj/item/clothing/cloak/janissary
	name = "janissary cape"
	desc = "A short cape of the household troops, cut square and worn off one shoulder."
	icon = 'modular_abel/morph_elixirs/icons/morph_elixirs_world.dmi'
	mob_overlay_icon = 'modular_abel/morph_elixirs/icons/morph_elixirs_onmob.dmi'
	icon_state = "jan"
	sellprice = 70

/obj/item/enchantingkit/arbitergloves
	name = "morphing elixir of the arbiter's gloves"
	desc = "A small container of special morphing dust, tuned to stamp a pair of leather gloves with an arbiter's seal."
	target_items = list(
		/obj/item/clothing/gloves/leather = /obj/item/clothing/gloves/leather/arbiter,
	)

/obj/item/enchantingkit/viceabritergloves
	name = "morphing elixir of the vice-arbiter's gloves"
	desc = "A small container of special morphing dust, tuned to trim a pair of leather gloves in a vice-arbiter's silver."
	target_items = list(
		/obj/item/clothing/gloves/leather = /obj/item/clothing/gloves/leather/arbiter_vice,
	)

/obj/item/enchantingkit/arbiterhood
	name = "morphing elixir of the arbiter's hood"
	desc = "A small container of special morphing dust, tuned to cut a sack hood down to an arbiter's pattern."
	target_items = list(
		/obj/item/clothing/face/sack = /obj/item/clothing/face/sack/arbiter,
	)

/obj/item/enchantingkit/arbitergambeson
	name = "morphing elixir of the arbiter's gambeson"
	desc = "A small container of special morphing dust, tuned to quilt a heavy gambeson in inquisitorial black."
	target_items = list(
		/obj/item/clothing/armor/gambeson/heavy = /obj/item/clothing/armor/gambeson/heavy/arbiter,
	)

/obj/item/enchantingkit/arbitermask
	name = "morphing elixir of the arbiter's mask"
	desc = "A small container of special morphing dust, tuned to beat a helmet into a faceless arbiter's mask."
	target_items = list(
		/obj/item/clothing/head/helmet = /obj/item/clothing/head/helmet/arbiter,
	)

/obj/item/enchantingkit/vicearbitermask
	name = "morphing elixir of the vice-arbiter's mask"
	desc = "A small container of special morphing dust, tuned to chase an arbiter's mask in a vice-arbiter's silver."
	target_items = list(
		/obj/item/clothing/head/helmet = /obj/item/clothing/head/helmet/arbiter_vice,
	)

/obj/item/enchantingkit/arbiterpants
	name = "morphing elixir of the arbiter's trousers"
	desc = "A small container of special morphing dust, tuned to cut a pair of leather trousers to an arbiter's uniform."
	target_items = list(
		/obj/item/clothing/pants/trou/leather = /obj/item/clothing/pants/trou/leather/arbiter,
	)

/obj/item/enchantingkit/arbitershirt
	name = "morphing elixir of the arbiter's shirt"
	desc = "A small container of special morphing dust, tuned to dye an undershirt to the arbiter's black."
	target_items = list(
		/obj/item/clothing/shirt/undershirt = /obj/item/clothing/shirt/undershirt/arbiter,
	)

/obj/item/enchantingkit/arbiterbrigandine
	name = "morphing elixir of the arbiter's brigandine"
	desc = "A small container of special morphing dust, tuned to face a brigandine in black cloth over its scales."
	target_items = list(
		/obj/item/clothing/armor/brigandine = /obj/item/clothing/armor/brigandine/arbiter,
	)

/obj/item/enchantingkit/cataphracthelm
	name = "morphing elixir of the cataphract's helm"
	desc = "A small container of special morphing dust, tuned to draw a heavy helm up and hang it with an aventail."
	target_items = list(
		/obj/item/clothing/head/helmet/heavy = /obj/item/clothing/head/helmet/heavy/cataphract,
	)

/obj/item/enchantingkit/janissaryhauberk
	name = "morphing elixir of the janissary hauberk"
	desc = "A small container of special morphing dust, tuned to split and trim a mail hauberk for the saddle."
	target_items = list(
		/obj/item/clothing/armor/chainmail/hauberk = /obj/item/clothing/armor/chainmail/hauberk/janissary,
	)

/obj/item/enchantingkit/janissaryhelm
	name = "morphing elixir of the janissary helm"
	desc = "A small container of special morphing dust, tuned to draw a helmet into a conical janissary shape."
	target_items = list(
		/obj/item/clothing/head/helmet = /obj/item/clothing/head/helmet/janissary,
	)

/obj/item/clothing/armor/plate/full/apostle
	name = "apostolic plate"
	desc = "Full plate chased with the marks of a knightly order, kept bright by someone whose whole day it is."
	icon = 'modular_abel/morph_elixirs/icons/morph_elixirs_world.dmi'
	mob_overlay_icon = 'modular_abel/morph_elixirs/icons/morph_elixirs_onmob.dmi'
	icon_state = "apostleplate"
	item_state = "apostleplate"

/obj/item/clothing/head/helmet/bascinet/apostle
	name = "apostolic bascinet"
	desc = "A heavy bascinet of the order, its brow banded and its visor drawn to a blunt point."
	icon = 'modular_abel/morph_elixirs/icons/morph_elixirs_world.dmi'
	mob_overlay_icon = 'modular_abel/morph_elixirs/icons/morph_elixirs_onmob.dmi'
	icon_state = "apostleburgeonet"
	item_state = "apostleburgeonet"

/obj/item/clothing/head/helmet/bascinet/grandmaster
	name = "grandmaster's bascinet"
	desc = "The same helm with an aventail falling to the collar, worn by whoever the order answers to."
	icon = 'modular_abel/morph_elixirs/icons/morph_elixirs_world.dmi'
	mob_overlay_icon = 'modular_abel/morph_elixirs/icons/morph_elixirs_onmob.dmi'
	icon_state = "dasfox_apostleburgeonet"
	item_state = "dasfox_apostleburgeonet"

/obj/item/clothing/head/helmet/bascinet/habit
	name = "habited bascinet"
	desc = "A bascinet worn under a cloth habit, so the steel is only obvious once it matters."
	icon = 'modular_abel/morph_elixirs/icons/morph_elixirs_world.dmi'
	mob_overlay_icon = 'modular_abel/morph_elixirs/icons/morph_elixirs_onmob.dmi'
	icon_state = "dasfox_habitburgeonet"
	item_state = "dasfox_habitburgeonet"

/obj/item/clothing/head/helmet/bascinet/astratan
	name = "holy astratan bascinet"
	desc = "A bascinet gilded at the brow with the Sun Queen's rays, polished past the point of practicality."
	icon = 'modular_abel/morph_elixirs/icons/morph_elixirs_world.dmi'
	mob_overlay_icon = 'modular_abel/morph_elixirs/icons/morph_elixirs_onmob.dmi'
	icon_state = "astrata_impressed"
	item_state = "astrata_impressed"

/obj/item/clothing/head/helmet/bascinet/avantyne
	name = "avantyne barbute"
	desc = "A hounskull barbute of avantyne make, its snout long and its eye slits unkind."
	icon = 'modular_abel/morph_elixirs/icons/morph_elixirs_world.dmi'
	mob_overlay_icon = 'modular_abel/morph_elixirs/icons/morph_elixirs_onmob.dmi'
	icon_state = "dakken_zizbarb"
	item_state = "dakken_zizbarb"

/obj/item/clothing/armor/brigandine/fencer
	name = "fencing brigandine"
	desc = "A light brigandine cut close at the waist, made to let a duellist bend where a duellist bends."
	icon = 'modular_abel/morph_elixirs/icons/morph_elixirs_world.dmi'
	mob_overlay_icon = 'modular_abel/morph_elixirs/icons/morph_elixirs_onmob.dmi'
	icon_state = "fencerbrig"
	item_state = "fencerbrig"

/obj/item/clothing/armor/cuirass/archaic
	name = "archaic ceremonial cuirass"
	desc = "A fluted cuirass in a pattern two centuries out of fashion, kept for the occasions that demand it."
	icon = 'modular_abel/morph_elixirs/icons/morph_elixirs_world.dmi'
	mob_overlay_icon = 'modular_abel/morph_elixirs/icons/morph_elixirs_onmob.dmi'
	icon_state = "archaiccuirass"
	item_state = "archaiccuirass"

/obj/item/enchantingkit/apostleplate
	name = "morphing elixir of the apostolic plate"
	desc = "A small container of special morphing dust, tuned to chase a suit of full plate with a knightly order's marks."
	target_items = list(
		/obj/item/clothing/armor/plate/full = /obj/item/clothing/armor/plate/full/apostle,
	)

/obj/item/enchantingkit/apostlebascinet
	name = "morphing elixir of the apostolic bascinet"
	desc = "A small container of special morphing dust, tuned to band a bascinet's brow in the order's pattern."
	target_items = list(
		/obj/item/clothing/head/helmet/bascinet = /obj/item/clothing/head/helmet/bascinet/apostle,
	)

/obj/item/enchantingkit/grandmasterbascinet
	name = "morphing elixir of the grandmaster's bascinet"
	desc = "A small container of special morphing dust, tuned to hang a bascinet with a grandmaster's aventail."
	target_items = list(
		/obj/item/clothing/head/helmet/bascinet = /obj/item/clothing/head/helmet/bascinet/grandmaster,
	)

/obj/item/enchantingkit/habitbascinet
	name = "morphing elixir of the habited bascinet"
	desc = "A small container of special morphing dust, tuned to dress a bascinet under a cloth habit."
	target_items = list(
		/obj/item/clothing/head/helmet/bascinet = /obj/item/clothing/head/helmet/bascinet/habit,
	)

/obj/item/enchantingkit/astratanbascinet
	name = "morphing elixir of the holy astratan bascinet"
	desc = "A small container of special morphing dust, tuned to gild a bascinet with the Sun Queen's rays."
	target_items = list(
		/obj/item/clothing/head/helmet/bascinet = /obj/item/clothing/head/helmet/bascinet/astratan,
	)

/obj/item/enchantingkit/avantynebarbute
	name = "morphing elixir of the avantyne barbute"
	desc = "A small container of special morphing dust, tuned to draw a bascinet out into a hounskull barbute."
	target_items = list(
		/obj/item/clothing/head/helmet/bascinet = /obj/item/clothing/head/helmet/bascinet/avantyne,
	)

/obj/item/enchantingkit/fencerbrigandine
	name = "morphing elixir of the fencing brigandine"
	desc = "A small container of special morphing dust, tuned to cut a brigandine close at the waist for a duellist."
	target_items = list(
		/obj/item/clothing/armor/brigandine = /obj/item/clothing/armor/brigandine/fencer,
	)

/obj/item/enchantingkit/archaiccuirass
	name = "morphing elixir of the archaic ceremonial cuirass"
	desc = "A small container of special morphing dust, tuned to flute a cuirass in a two-century-old pattern."
	target_items = list(
		/obj/item/clothing/armor/cuirass = /obj/item/clothing/armor/cuirass/archaic,
	)

/obj/item/weapon/sword/long/autumn_elvish
	name = "autumned elvish longsword"
	desc = "An elven longsword whose fuller is chased in red and gold, as if the blade had been left out through a turning wood."
	icon = 'modular_abel/morph_elixirs/icons/morph_elixirs_weapons64.dmi'
	icon_state = "aelflongsword"

/obj/item/weapon/knife/dagger/autumn_elvish
	name = "autumned elvish dagger"
	desc = "A slim elven dagger in the same autumn pattern, worn where a longsword would be impolite."
	icon = 'modular_abel/morph_elixirs/icons/morph_elixirs_weapons32.dmi'
	icon_state = "aelfdagger"

/obj/item/weapon/polearm/halberd/bardiche/autumn_elvish
	name = "autumned elvish bardiche"
	desc = "A bardiche with an elven crescent head, its edge lacquered the colour of late leaves."
	icon = 'modular_abel/morph_elixirs/icons/morph_elixirs_weapons64.dmi'
	icon_state = "aebardiche"

/obj/item/weapon/shield/tower/decrepit
	name = "decrepit greatshield"
	desc = "A tall shield of ancient alloy, green at the rim and dented by arguments nobody alive remembers."
	icon = 'modular_abel/morph_elixirs/icons/morph_elixirs_weapons32.dmi'
	icon_state = "ancientgreatshield"

/obj/item/weapon/shield/heater/decrepit
	name = "decrepit hoplon shield"
	desc = "A round shield of old bronze, its face worn back to the blank metal under whatever was painted there."
	icon = 'modular_abel/morph_elixirs/icons/morph_elixirs_weapons32.dmi'
	icon_state = "ancientlegionshield"

/obj/item/weapon/pitchfork/decrepit
	name = "decrepit pitchfork"
	desc = "A pitchfork of ancient alloy. Whoever made it did not expect it to outlast the farm."
	icon = 'modular_abel/morph_elixirs/icons/morph_elixirs_weapons32.dmi'
	icon_state = "apitchfork"

/obj/item/enchantingkit/autumnlongsword
	name = "morphing elixir of the autumned elvish longsword"
	desc = "A small container of special morphing dust, tuned to chase a longsword's fuller in elven red and gold."
	target_items = list(
		/obj/item/weapon/sword/long = /obj/item/weapon/sword/long/autumn_elvish,
	)

/obj/item/enchantingkit/autumndagger
	name = "morphing elixir of the autumned elvish dagger"
	desc = "A small container of special morphing dust, tuned to chase a dagger in the elven autumn pattern."
	target_items = list(
		/obj/item/weapon/knife/dagger = /obj/item/weapon/knife/dagger/autumn_elvish,
	)

/obj/item/enchantingkit/autumnbardiche
	name = "morphing elixir of the autumned elvish bardiche"
	desc = "A small container of special morphing dust, tuned to draw a bardiche's head into an elven crescent."
	target_items = list(
		/obj/item/weapon/polearm/halberd/bardiche = /obj/item/weapon/polearm/halberd/bardiche/autumn_elvish,
	)

/obj/item/enchantingkit/decrepitgreatshield
	name = "morphing elixir of the decrepit greatshield"
	desc = "A small container of special morphing dust, tuned to age a tower shield into ancient dented alloy."
	target_items = list(
		/obj/item/weapon/shield/tower = /obj/item/weapon/shield/tower/decrepit,
	)

/obj/item/enchantingkit/decrepithoplon
	name = "morphing elixir of the decrepit hoplon shield"
	desc = "A small container of special morphing dust, tuned to wear a heater shield back to blank old bronze."
	target_items = list(
		/obj/item/weapon/shield/heater = /obj/item/weapon/shield/heater/decrepit,
	)

/obj/item/enchantingkit/decrepitpitchfork
	name = "morphing elixir of the decrepit pitchfork"
	desc = "A small container of special morphing dust, tuned to recast a pitchfork in ancient alloy."
	target_items = list(
		/obj/item/weapon/pitchfork = /obj/item/weapon/pitchfork/decrepit,
	)

/datum/loadout_item/morph_elixir
	abstract_type = /datum/loadout_item/morph_elixir
	ui_category = "Armor"

/datum/loadout_item/morph_elixir/cataphract
	name = "Morphing Elixir: Cataphract Half-Plate"
	item_path = /obj/item/enchantingkit/cataphract
	triumph_cost_permanent = 200

/datum/loadout_item/morph_elixir/artificerplate
	name = "Morphing Elixir: Artificed Half-Plate"
	item_path = /obj/item/enchantingkit/artificerplate
	triumph_cost_permanent = 200

/datum/loadout_item/morph_elixir/heartfeltbrigandine
	name = "Morphing Elixir: Heartfelt Brigandine"
	item_path = /obj/item/enchantingkit/heartfeltbrigandine
	triumph_cost_permanent = 150

/datum/loadout_item/morph_elixir/apostlecuirass
	name = "Morphing Elixir: Apostolic Cuirass"
	item_path = /obj/item/enchantingkit/apostlecuirass
	triumph_cost_permanent = 175

/datum/loadout_item/morph_elixir/croppedgambeson
	name = "Morphing Elixir: Low Cut Gambeson"
	item_path = /obj/item/enchantingkit/croppedgambeson
	triumph_cost_permanent = 125

/datum/loadout_item/morph_elixir/bronzebracers
	name = "Morphing Elixir: Bronze Wristguards"
	item_path = /obj/item/enchantingkit/bronzebracers
	triumph_cost_permanent = 100

/datum/loadout_item/morph_elixir/catcloak
	name = "Cataphract's Cloak"
	item_path = /obj/item/clothing/cloak/catcloak
	ui_category = "Cloaks"
	triumph_cost_permanent = 125

/datum/loadout_item/morph_elixir/oathmarkedplate
	name = "Morphing Elixir: Oathmarked Plate"
	item_path = /obj/item/enchantingkit/oathmarkedplate
	triumph_cost_permanent = 250

/datum/loadout_item/morph_elixir/oathmarkedhelm
	name = "Morphing Elixir: Oathmarked Helm"
	item_path = /obj/item/enchantingkit/oathmarkedhelm
	triumph_cost_permanent = 175

/datum/loadout_item/morph_elixir/oathmarkedboots
	name = "Morphing Elixir: Oathmarked Sabatons"
	item_path = /obj/item/enchantingkit/oathmarkedboots
	triumph_cost_permanent = 125

/datum/loadout_item/morph_elixir/blacksteelgauntlets
	name = "Morphing Elixir: Blacksteel Gauntlets"
	item_path = /obj/item/enchantingkit/blacksteelgauntlets
	triumph_cost_permanent = 125

/datum/loadout_item/morph_elixir/blacksteelchausses
	name = "Morphing Elixir: Blacksteel Chausses"
	item_path = /obj/item/enchantingkit/blacksteelchausses
	triumph_cost_permanent = 150

/datum/loadout_item/morph_elixir/baothacuirass
	name = "Morphing Elixir: Baothan Cuirass"
	item_path = /obj/item/enchantingkit/baothacuirass
	triumph_cost_permanent = 200

/datum/loadout_item/morph_elixir/baothahelm
	name = "Morphing Elixir: Helm of Desire"
	item_path = /obj/item/enchantingkit/baothahelm
	triumph_cost_permanent = 175

/datum/loadout_item/morph_elixir/baothabracers
	name = "Morphing Elixir: Baothan Bracers"
	item_path = /obj/item/enchantingkit/baothabracers
	triumph_cost_permanent = 100

/datum/loadout_item/morph_elixir/baothalegs
	name = "Morphing Elixir: Baothan Leg-Plates"
	item_path = /obj/item/enchantingkit/baothalegs
	triumph_cost_permanent = 150

/datum/loadout_item/morph_elixir/baothastraps
	name = "Morphing Elixir: Baothan Straps"
	item_path = /obj/item/enchantingkit/baothastraps
	triumph_cost_permanent = 125

/datum/loadout_item/morph_elixir/arbitergloves
	name = "Morphing Elixir: Arbiter's Gloves"
	item_path = /obj/item/enchantingkit/arbitergloves
	triumph_cost_permanent = 100

/datum/loadout_item/morph_elixir/viceabritergloves
	name = "Morphing Elixir: Vice-Arbiter's Gloves"
	item_path = /obj/item/enchantingkit/viceabritergloves
	triumph_cost_permanent = 100

/datum/loadout_item/morph_elixir/arbiterhood
	name = "Morphing Elixir: Arbiter's Hood"
	item_path = /obj/item/enchantingkit/arbiterhood
	triumph_cost_permanent = 75

/datum/loadout_item/morph_elixir/arbitergambeson
	name = "Morphing Elixir: Arbiter's Gambeson"
	item_path = /obj/item/enchantingkit/arbitergambeson
	triumph_cost_permanent = 175

/datum/loadout_item/morph_elixir/arbitermask
	name = "Morphing Elixir: Arbiter's Mask"
	item_path = /obj/item/enchantingkit/arbitermask
	triumph_cost_permanent = 150

/datum/loadout_item/morph_elixir/vicearbitermask
	name = "Morphing Elixir: Vice-Arbiter's Mask"
	item_path = /obj/item/enchantingkit/vicearbitermask
	triumph_cost_permanent = 150

/datum/loadout_item/morph_elixir/arbiterpants
	name = "Morphing Elixir: Arbiter's Trousers"
	item_path = /obj/item/enchantingkit/arbiterpants
	triumph_cost_permanent = 100

/datum/loadout_item/morph_elixir/arbitershirt
	name = "Morphing Elixir: Arbiter's Shirt"
	item_path = /obj/item/enchantingkit/arbitershirt
	triumph_cost_permanent = 75

/datum/loadout_item/morph_elixir/arbiterbrigandine
	name = "Morphing Elixir: Arbiter's Brigandine"
	item_path = /obj/item/enchantingkit/arbiterbrigandine
	triumph_cost_permanent = 175

/datum/loadout_item/morph_elixir/cataphracthelm
	name = "Morphing Elixir: Cataphract's Helm"
	item_path = /obj/item/enchantingkit/cataphracthelm
	triumph_cost_permanent = 175

/datum/loadout_item/morph_elixir/janissaryhauberk
	name = "Morphing Elixir: Janissary Hauberk"
	item_path = /obj/item/enchantingkit/janissaryhauberk
	triumph_cost_permanent = 175

/datum/loadout_item/morph_elixir/janissaryhelm
	name = "Morphing Elixir: Janissary Helm"
	item_path = /obj/item/enchantingkit/janissaryhelm
	triumph_cost_permanent = 150

/datum/loadout_item/morph_elixir/janissary_cape
	name = "Janissary Cape"
	item_path = /obj/item/clothing/cloak/janissary
	ui_category = "Cloaks"
	triumph_cost_permanent = 100

/datum/loadout_item/morph_elixir/apostleplate
	name = "Morphing Elixir: Apostolic Plate"
	item_path = /obj/item/enchantingkit/apostleplate
	triumph_cost_permanent = 250

/datum/loadout_item/morph_elixir/apostlebascinet
	name = "Morphing Elixir: Apostolic Bascinet"
	item_path = /obj/item/enchantingkit/apostlebascinet
	triumph_cost_permanent = 150

/datum/loadout_item/morph_elixir/grandmasterbascinet
	name = "Morphing Elixir: Grandmaster's Bascinet"
	item_path = /obj/item/enchantingkit/grandmasterbascinet
	triumph_cost_permanent = 175

/datum/loadout_item/morph_elixir/habitbascinet
	name = "Morphing Elixir: Habited Bascinet"
	item_path = /obj/item/enchantingkit/habitbascinet
	triumph_cost_permanent = 150

/datum/loadout_item/morph_elixir/astratanbascinet
	name = "Morphing Elixir: Holy Astratan Bascinet"
	item_path = /obj/item/enchantingkit/astratanbascinet
	triumph_cost_permanent = 175

/datum/loadout_item/morph_elixir/avantynebarbute
	name = "Morphing Elixir: Avantyne Barbute"
	item_path = /obj/item/enchantingkit/avantynebarbute
	triumph_cost_permanent = 175

/datum/loadout_item/morph_elixir/fencerbrigandine
	name = "Morphing Elixir: Fencing Brigandine"
	item_path = /obj/item/enchantingkit/fencerbrigandine
	triumph_cost_permanent = 150

/datum/loadout_item/morph_elixir/archaiccuirass
	name = "Morphing Elixir: Archaic Ceremonial Cuirass"
	item_path = /obj/item/enchantingkit/archaiccuirass
	triumph_cost_permanent = 175

/datum/loadout_item/morph_elixir/autumnlongsword
	name = "Morphing Elixir: Autumned Elvish Longsword"
	item_path = /obj/item/enchantingkit/autumnlongsword
	ui_category = "Held Item"
	triumph_cost_permanent = 200

/datum/loadout_item/morph_elixir/autumndagger
	name = "Morphing Elixir: Autumned Elvish Dagger"
	item_path = /obj/item/enchantingkit/autumndagger
	ui_category = "Held Item"
	triumph_cost_permanent = 125

/datum/loadout_item/morph_elixir/autumnbardiche
	name = "Morphing Elixir: Autumned Elvish Bardiche"
	item_path = /obj/item/enchantingkit/autumnbardiche
	ui_category = "Held Item"
	triumph_cost_permanent = 200

/datum/loadout_item/morph_elixir/decrepitgreatshield
	name = "Morphing Elixir: Decrepit Greatshield"
	item_path = /obj/item/enchantingkit/decrepitgreatshield
	ui_category = "Held Item"
	triumph_cost_permanent = 150

/datum/loadout_item/morph_elixir/decrepithoplon
	name = "Morphing Elixir: Decrepit Hoplon Shield"
	item_path = /obj/item/enchantingkit/decrepithoplon
	ui_category = "Held Item"
	triumph_cost_permanent = 150

/datum/loadout_item/morph_elixir/decrepitpitchfork
	name = "Morphing Elixir: Decrepit Pitchfork"
	item_path = /obj/item/enchantingkit/decrepitpitchfork
	ui_category = "Held Item"
	triumph_cost_permanent = 100
