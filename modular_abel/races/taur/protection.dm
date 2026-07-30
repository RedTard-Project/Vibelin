// Taurs may wear ordinary footwear/pants for the armor, but only purpose-made horseshoes render on a beast lower body; everything else is worn invisibly.
/obj/item/clothing/shoes/build_worn_icon(age = AGE_ADULT, default_layer = 0, default_icon_file = null, isinhands = FALSE, femaleuniform = NO_FEMALE_UNIFORM, override_state = null, coom = FALSE, customi = null, sleeveindex, force_child = FALSE)
	var/mob/living/carbon/human/H = loc
	if(!isinhands && istype(H) && H.get_taur_tail() && !istype(src, /obj/item/clothing/shoes/taur_horseshoes))
		return mutable_appearance('icons/blanks/32x32.dmi', "nothing", -default_layer)
	return ..()

/obj/item/clothing/shoes/taur_horseshoes
	name = "iron horseshoes"
	desc = "A pair of sturdy iron horseshoes fixed to leather straps for taur hooves."
	gender = PLURAL
	icon = 'icons/roguetown/clothing/feet.dmi'
	mob_overlay_icon = 'modular_abel/races/icons/clothing/onmob/saiga.dmi'
	sleeved = null
	icon_state = "iplateboots"
	item_state = "iron_horseshoes"
	body_parts_covered = FEET
	armor_type = /datum/armor/boots/plate/bad
	max_integrity = ARMOR_INT_LEG_IRON_PLATE
	armor_class = AC_MEDIUM
	anvilrepair = /datum/attribute/skill/craft/armor_repair
	smeltresult = /obj/item/ingot/iron
	resistance_flags = FIRE_PROOF
	sellprice = VALUE_IRON_ARMOR
	item_weight = 1.4 KILOGRAMS
	var/onmob_state = "iron_horseshoes"

/obj/item/clothing/shoes/taur_horseshoes/build_worn_icon(age = AGE_ADULT, default_layer = 0, default_icon_file = null, isinhands = FALSE, femaleuniform = NO_FEMALE_UNIFORM, override_state = null, coom = FALSE, customi = null, sleeveindex, force_child = FALSE)
	if(!isinhands && !override_state)
		override_state = onmob_state
	var/mutable_appearance/image = ..()
	if(!isinhands && istype(image, /mutable_appearance))
		image.pixel_x = -16
		image.pixel_y = -1
	return image

/obj/item/clothing/shoes/taur_horseshoes/mob_can_equip(mob/living/M, mob/living/equipper, slot, disable_warning = FALSE, bypass_equip_delay_self = FALSE)
	var/mob/living/carbon/human/H = M
	if(!istype(H) || !H.get_taur_tail())
		if(M && !disable_warning)
			to_chat(M, span_warning("These horseshoes can only be worn by taurs."))
		return FALSE
	return ..()

/obj/item/clothing/shoes/taur_horseshoes/steel
	name = "steel horseshoes"
	desc = "Well-forged steel horseshoes on thick leather straps. Heavier than iron, but they protect a taur's hooves far better."
	icon_state = "armorboots"
	item_state = "steel_horseshoes"
	onmob_state = "steel_horseshoes"
	armor_type = /datum/armor/boots/plate/good
	max_integrity = ARMOR_INT_LEG_STEEL_PLATE
	armor_class = AC_HEAVY
	smeltresult = /obj/item/ingot/steel
	sellprice = VALUE_STEEL_ARMOR
	item_weight = 2.1 KILOGRAMS

/obj/item/clothing/shoes/taur_horseshoes/leather
	name = "leather hoofguards"
	desc = "Layered leather wraps and pads strapped over a taur's hooves. Light and quiet, but they offer only modest protection."
	icon_state = "leatherboots"
	item_state = "iron_horseshoes"
	color = "#8a5a2b"
	armor_type = /datum/armor/boots/leather
	max_integrity = INTEGRITY_STANDARD
	armor_class = AC_LIGHT
	anvilrepair = null
	sewrepair = /datum/attribute/skill/craft/tanning/patching
	smeltresult = null
	salvage_result = /obj/item/natural/hide/cured
	salvage_amount = 1
	resistance_flags = FLAMMABLE
	sellprice = VALUE_LEATHER_ARMOR_PLUS
	item_weight = 1 KILOGRAMS

/obj/item/clothing/pants/build_worn_icon(age = AGE_ADULT, default_layer = 0, default_icon_file = null, isinhands = FALSE, femaleuniform = NO_FEMALE_UNIFORM, override_state = null, coom = FALSE, customi = null, sleeveindex, force_child = FALSE)
	var/mob/living/carbon/human/H = loc
	if(!isinhands && istype(H) && H.get_taur_tail())
		return mutable_appearance('icons/blanks/32x32.dmi', "nothing", -default_layer)
	return ..()
