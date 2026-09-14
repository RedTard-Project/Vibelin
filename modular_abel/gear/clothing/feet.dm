/obj/item/clothing/shoes/boots/armor/bronze_maille
	name = "bronze maille boots"
	desc = "A pair of leather boots, reinforced with smaller bronze plates along the feet and ankles. A thick layer of chainmail has been woven across the cuffs of each boot."
	icon = 'modular_abel/gear/icons/feet.dmi'
	mob_overlay_icon = 'modular_abel/gear/icons/onmob/feet.dmi'
	icon_state = "bsoldierboots"
	item_state = "bsoldierboots"
	armor_class = AC_LIGHT
	armor_type = /datum/armor/maille/bronze
	max_integrity = INTEGRITY_OLD_STANDARD + 50
	smeltresult = /obj/item/ingot/bronze
	melting_material = /datum/material/bronze
	melt_amount = 75

/obj/item/clothing/shoes/boots/armor/maille_steel
	name = "maille boots"
	desc = "A pair of leather boots, reinforced with smaller steel plates along the feet and ankles. Woven into the top of each boot's cuff is a thick layer of chainmail."
	body_parts_covered = FEET
	icon = 'modular_abel/gear/icons/feet.dmi'
	mob_overlay_icon = 'modular_abel/gear/icons/onmob/feet.dmi'
	icon_state = "shalfplateboots"
	item_state = "shalfplateboots"
	armor_type = /datum/armor/boots/maille
	armor_class = AC_LIGHT
	max_integrity = INTEGRITY_OLD_STRONG
	smeltresult = /obj/item/ingot/steel_slag

/obj/item/clothing/shoes/heels
	name = "high-heeled shoes"
	desc = "Elegant shoes that're lightly elevated in the rear, providing a distinctive 'click' with each step."
	icon = 'modular_abel/gear/icons/feet.dmi'
	mob_overlay_icon = 'modular_abel/gear/icons/onmob/feet.dmi'
	icon_state = "heels"
	item_state = "heels"
	detail_tag = "_detail"
	color = "#FFFFFF"
	detail_color = "#FFFFFF"

/obj/item/clothing/shoes/heels/attack_hand_secondary(mob/user, list/modifiers)
	. = ..()
	var/choice = tgui_input_list(user, "Choose a color.", "Uniform colors", GLOB.noble_dyes)
	if(!choice)
		return
	detail_color = GLOB.noble_dyes[choice]
	update_appearance(UPDATE_ICON)

/obj/item/clothing/shoes/heels/update_overlays()
	. = ..()
	if(!get_detail_tag())
		return
	var/mutable_appearance/pic = mutable_appearance(icon(icon, "[icon_state][detail_tag]"))
	pic.appearance_flags = RESET_COLOR
	if(get_detail_color())
		pic.color = get_detail_color()
	. += pic

/obj/item/clothing/shoes/heels/donator_gold
	name = "high-heeled golden shoes"
	desc = "Gold-laced shoes that're lightly elevated in the rear, providing a distinctive 'click' with each step."
	icon_state = "goldheels"
	item_state = "goldheels"

/obj/item/clothing/shoes/heels/donator_silver
	name = "high-heeled silver shoes"
	desc = "Silver-laced shoes that're lightly elevated in the rear, providing a distinctive 'click' with each step."
	icon_state = "silverheels"
	item_state = "silverheels"

/obj/item/clothing/shoes/sandals/toga
	name = "fancy sandals"
	desc = "Delicate sandals of gleaming leather, their slender straps rising in graceful spirals to embrace the ankle."
	icon = 'modular_abel/gear/icons/feet.dmi'
	mob_overlay_icon = 'modular_abel/gear/icons/onmob/feet.dmi'
	icon_state = "toga_sandals"
	item_state = "toga_sandals"
	salvage_result = /obj/item/natural/hide/cured
	salvage_amount = 1
