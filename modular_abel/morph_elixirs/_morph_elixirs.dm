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
