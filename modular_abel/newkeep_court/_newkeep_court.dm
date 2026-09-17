/obj/item/clothing/armor/plate/citywatch
	name = "city watch armour"
	desc = "Scaled plate in the watch's colours, issued to whoever is expected to be recognised at a distance."
	icon = 'modular_abel/newkeep_court/icons/newkeep_court_world.dmi'
	mob_overlay_icon = 'modular_abel/newkeep_court/icons/newkeep_court_onmob.dmi'
	icon_state = "citywatch"
	item_state = "citywatch"

/obj/item/clothing/head/helmet/citywatch
	name = "city watch helmet"
	desc = "An open-faced helm with a broad brim, stamped with the watch's mark above the brow."
	icon = 'modular_abel/newkeep_court/icons/newkeep_court_world.dmi'
	mob_overlay_icon = 'modular_abel/newkeep_court/icons/newkeep_court_onmob.dmi'
	icon_state = "citywatch_helmet"
	item_state = "citywatch_helmet"

/obj/item/clothing/armor/leather/councillor
	name = "councillorial uniform"
	desc = "A sober leather-backed coat of the council's cut, worn by people who decide things in rooms."
	icon = 'modular_abel/newkeep_court/icons/newkeep_court_world.dmi'
	mob_overlay_icon = 'modular_abel/newkeep_court/icons/newkeep_court_onmob.dmi'
	icon_state = "councillor"
	item_state = "councillor"

/obj/item/clothing/armor/leather/duke
	name = "ducal uniform"
	desc = "A duke's coat, padded at the shoulder and embroidered where the light will catch it."
	icon = 'modular_abel/newkeep_court/icons/newkeep_court_world.dmi'
	mob_overlay_icon = 'modular_abel/newkeep_court/icons/newkeep_court_onmob.dmi'
	icon_state = "duke"
	item_state = "duke"

/obj/item/clothing/armor/leather/duchess
	name = "duchess' dress"
	desc = "A dress cut over a leather bodice, formal enough for court and sturdy enough to leave it quickly."
	icon = 'modular_abel/newkeep_court/icons/newkeep_court_world.dmi'
	mob_overlay_icon = 'modular_abel/newkeep_court/icons/newkeep_court_onmob.dmi'
	icon_state = "duchess"
	item_state = "duchess"

/obj/item/clothing/armor/leather/hand
	name = "Hand's jacket"
	desc = "The jacket of the crown's Hand: dark, plain and cut to be forgotten a moment after it leaves a room."
	icon = 'modular_abel/newkeep_court/icons/newkeep_court_world.dmi'
	mob_overlay_icon = 'modular_abel/newkeep_court/icons/newkeep_court_onmob.dmi'
	icon_state = "hand"
	item_state = "hand"

/obj/item/clothing/armor/leather/heir
	name = "heir's uniform"
	desc = "A young lord's uniform, tailored a size ahead of the shoulders it currently sits on."
	icon = 'modular_abel/newkeep_court/icons/newkeep_court_world.dmi'
	mob_overlay_icon = 'modular_abel/newkeep_court/icons/newkeep_court_onmob.dmi'
	icon_state = "heir"
	item_state = "heir"

/obj/item/clothing/armor/leather/heiress
	name = "heiress' uniform"
	desc = "A young lady's court uniform, cut with the same optimism about the shoulders."
	icon = 'modular_abel/newkeep_court/icons/newkeep_court_world.dmi'
	mob_overlay_icon = 'modular_abel/newkeep_court/icons/newkeep_court_onmob.dmi'
	icon_state = "heiress"
	item_state = "heiress"

/obj/item/clothing/armor/leather/magos
	name = "magos' robes"
	desc = "Layered robes over a leather under-coat, worn by a court magos who expects to be asked to explain something."
	icon = 'modular_abel/newkeep_court/icons/newkeep_court_world.dmi'
	mob_overlay_icon = 'modular_abel/newkeep_court/icons/newkeep_court_onmob.dmi'
	icon_state = "magos"
	item_state = "magos"

/obj/item/clothing/armor/leather/steward
	name = "steward's vest"
	desc = "A steward's vest with deep pockets, each of them holding a list of somebody else's obligations."
	icon = 'modular_abel/newkeep_court/icons/newkeep_court_world.dmi'
	mob_overlay_icon = 'modular_abel/newkeep_court/icons/newkeep_court_onmob.dmi'
	icon_state = "steward"
	item_state = "steward"

/obj/item/clothing/cloak/citywatch
	name = "city watch cape"
	desc = "A short cape in the watch's colours, worn pinned at the shoulder over the armour."
	icon = 'modular_abel/newkeep_court/icons/newkeep_court_world.dmi'
	mob_overlay_icon = 'modular_abel/newkeep_court/icons/newkeep_court_onmob.dmi'
	icon_state = "citywatch_cape"
	sellprice = 100

/obj/item/clothing/head/duchess_hood
	name = "duchess' veil"
	desc = "A veiled headdress of the sort worn to funerals one is glad to be attending."
	icon = 'modular_abel/newkeep_court/icons/newkeep_court_world.dmi'
	mob_overlay_icon = 'modular_abel/newkeep_court/icons/newkeep_court_onmob.dmi'
	icon_state = "duchess_hood"
	sellprice = 100

/obj/item/enchantingkit/citywatcharmour
	name = "morphing elixir of the city watch armour"
	desc = "A small container of special morphing dust, tuned to scale a suit of plate into the watch's pattern."
	target_items = list(
		/obj/item/clothing/armor/plate = /obj/item/clothing/armor/plate/citywatch,
	)

/obj/item/enchantingkit/citywatchhelm
	name = "morphing elixir of the city watch helmet"
	desc = "A small container of special morphing dust, tuned to broaden a helmet's brim and stamp it with the watch's mark."
	target_items = list(
		/obj/item/clothing/head/helmet = /obj/item/clothing/head/helmet/citywatch,
	)

/obj/item/enchantingkit/councillor
	name = "morphing elixir of the councillorial uniform"
	desc = "A small container of special morphing dust, tuned to cut a leather coat to the council's sober pattern."
	target_items = list(
		/obj/item/clothing/armor/leather = /obj/item/clothing/armor/leather/councillor,
	)

/obj/item/enchantingkit/duke
	name = "morphing elixir of the ducal uniform"
	desc = "A small container of special morphing dust, tuned to pad and embroider a leather coat into a duke's."
	target_items = list(
		/obj/item/clothing/armor/leather = /obj/item/clothing/armor/leather/duke,
	)

/obj/item/enchantingkit/duchess
	name = "morphing elixir of the duchess' dress"
	desc = "A small container of special morphing dust, tuned to build a court dress over a leather bodice."
	target_items = list(
		/obj/item/clothing/armor/leather = /obj/item/clothing/armor/leather/duchess,
	)

/obj/item/enchantingkit/hand
	name = "morphing elixir of the hand's jacket"
	desc = "A small container of special morphing dust, tuned to cut a leather coat down to the Hand's plain jacket."
	target_items = list(
		/obj/item/clothing/armor/leather = /obj/item/clothing/armor/leather/hand,
	)

/obj/item/enchantingkit/heir
	name = "morphing elixir of the heir's uniform"
	desc = "A small container of special morphing dust, tuned to tailor a leather coat into an heir's uniform."
	target_items = list(
		/obj/item/clothing/armor/leather = /obj/item/clothing/armor/leather/heir,
	)

/obj/item/enchantingkit/heiress
	name = "morphing elixir of the heiress' uniform"
	desc = "A small container of special morphing dust, tuned to tailor a leather coat into an heiress' uniform."
	target_items = list(
		/obj/item/clothing/armor/leather = /obj/item/clothing/armor/leather/heiress,
	)

/obj/item/enchantingkit/magos
	name = "morphing elixir of the magos' robes"
	desc = "A small container of special morphing dust, tuned to layer robes over a leather under-coat."
	target_items = list(
		/obj/item/clothing/armor/leather = /obj/item/clothing/armor/leather/magos,
	)

/obj/item/enchantingkit/steward
	name = "morphing elixir of the steward's vest"
	desc = "A small container of special morphing dust, tuned to cut a leather coat into a steward's pocketed vest."
	target_items = list(
		/obj/item/clothing/armor/leather = /obj/item/clothing/armor/leather/steward,
	)

/datum/loadout_item/newkeep_court
	abstract_type = /datum/loadout_item/newkeep_court
	ui_category = LOADOUT_PANEL_CATEGORY_NEWKEEP

/datum/loadout_item/newkeep_court/citywatcharmour
	name = "Morphing Elixir: City Watch Armour"
	item_path = /obj/item/enchantingkit/citywatcharmour
	triumph_cost_permanent = 200

/datum/loadout_item/newkeep_court/citywatchhelm
	name = "Morphing Elixir: City Watch Helmet"
	item_path = /obj/item/enchantingkit/citywatchhelm
	triumph_cost_permanent = 150

/datum/loadout_item/newkeep_court/councillor
	name = "Morphing Elixir: Councillorial Uniform"
	item_path = /obj/item/enchantingkit/councillor
	triumph_cost_permanent = 150

/datum/loadout_item/newkeep_court/duke
	name = "Morphing Elixir: Ducal Uniform"
	item_path = /obj/item/enchantingkit/duke
	triumph_cost_permanent = 175

/datum/loadout_item/newkeep_court/duchess
	name = "Morphing Elixir: Duchess' Dress"
	item_path = /obj/item/enchantingkit/duchess
	triumph_cost_permanent = 175

/datum/loadout_item/newkeep_court/hand
	name = "Morphing Elixir: Hand's Jacket"
	item_path = /obj/item/enchantingkit/hand
	triumph_cost_permanent = 175

/datum/loadout_item/newkeep_court/heir
	name = "Morphing Elixir: Heir's Uniform"
	item_path = /obj/item/enchantingkit/heir
	triumph_cost_permanent = 150

/datum/loadout_item/newkeep_court/heiress
	name = "Morphing Elixir: Heiress' Uniform"
	item_path = /obj/item/enchantingkit/heiress
	triumph_cost_permanent = 150

/datum/loadout_item/newkeep_court/magos
	name = "Morphing Elixir: Magos' Robes"
	item_path = /obj/item/enchantingkit/magos
	triumph_cost_permanent = 175

/datum/loadout_item/newkeep_court/steward
	name = "Morphing Elixir: Steward's Vest"
	item_path = /obj/item/enchantingkit/steward
	triumph_cost_permanent = 150

/datum/loadout_item/newkeep_court/citywatch
	name = "City Watch Cape"
	item_path = /obj/item/clothing/cloak/citywatch
	triumph_cost_permanent = 150

/datum/loadout_item/newkeep_court/duchess_hood
	name = "Duchess' Veil"
	item_path = /obj/item/clothing/head/duchess_hood
	triumph_cost_permanent = 150
