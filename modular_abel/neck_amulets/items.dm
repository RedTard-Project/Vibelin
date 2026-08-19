/obj/item/clothing/neck/carved
	abstract_type = /obj/item/clothing/neck/carved
	name = "carved amulet"
	desc = "You shouldn't be seeing this."
	icon = 'modular_abel/neck_amulets/icons/amulets_world.dmi'
	mob_overlay_icon = 'modular_abel/neck_amulets/icons/amulets_onmob.dmi'
	slot_flags = ITEM_SLOT_NECK|ITEM_SLOT_WRISTS
	equip_sound = 'sound/foley/equip/cloak_equip.ogg'
	pickup_sound = 'sound/foley/equip/cloak_take_off.ogg'
	break_sound = 'sound/foley/cloth_rip.ogg'
	drop_sound = 'sound/foley/dropsound/cloth_drop.ogg'
	resistance_flags = FIRE_PROOF
	grid_width = 32
	grid_height = 32
	sellprice = 90

/// Worn on the wrist these use the wrist sheet instead of the neck one.
/obj/item/clothing/neck/carved/mob_can_equip(mob/living/M, mob/living/equipper, slot, disable_warning = FALSE, bypass_equip_delay_self = FALSE)
	. = ..()
	if(slot == ITEM_SLOT_WRISTS)
		mob_overlay_icon = 'modular_abel/neck_amulets/icons/amulets_wrists.dmi'
	else
		mob_overlay_icon = 'modular_abel/neck_amulets/icons/amulets_onmob.dmi'

/obj/item/clothing/neck/carved/silverjade
	name = "silver joapstone amulet"
	desc = "A silver amulet encrusted with a polished piece of joapstone, donnable both on neck and wrist."
	icon_state = "silver_jade"

/obj/item/clothing/neck/carved/silverturq
	name = "silver ceruleabaster amulet"
	desc = "A silver amulet encrusted with a polished piece of ceruleabaster, donnable both on neck and wrist."
	icon_state = "silver_turq"

/obj/item/clothing/neck/carved/silveronyxa
	name = "silver onyxa amulet"
	desc = "A silver amulet encrusted with a polished piece of onyxa, donnable both on neck and wrist."
	icon_state = "silver_onyxa"

/obj/item/clothing/neck/carved/silvercoral
	name = "silver heartstone amulet"
	desc = "A silver amulet encrusted with a polished piece of heartstone, donnable both on neck and wrist."
	icon_state = "silver_coral"

/obj/item/clothing/neck/carved/silveramber
	name = "silver amber amulet"
	desc = "A silver amulet encrusted with a polished piece of amber, donnable both on neck and wrist."
	icon_state = "silver_amber"

/obj/item/clothing/neck/carved/silveropal
	name = "silver opal amulet"
	desc = "A silver amulet encrusted with a polished piece of opal, donnable both on neck and wrist."
	icon_state = "silver_opal"

/obj/item/clothing/neck/carved/silverrose
	name = "silver rosestone amulet"
	desc = "A silver amulet encrusted with a polished piece of rosestone, donnable both on neck and wrist."
	icon_state = "silver_rose"

/obj/item/clothing/neck/carved/silvershell
	name = "silver shell amulet"
	desc = "A silver amulet encrusted with a polished piece of shell, donnable both on neck and wrist."
	icon_state = "silver_shell"

/obj/item/clothing/neck/carved/gold
	abstract_type = /obj/item/clothing/neck/carved/gold
	sellprice = 140

/obj/item/clothing/neck/carved/gold/amber
	name = "golden amber amulet"
	desc = "A luxurious golden amulet encrusted with a polished piece of amber, donnable both on neck and wrist."
	icon_state = "gold_amber"

/obj/item/clothing/neck/carved/gold/coral
	name = "golden heartstone amulet"
	desc = "A luxurious golden amulet encrusted with a polished piece of heartstone, donnable both on neck and wrist."
	icon_state = "gold_coral"

/obj/item/clothing/neck/carved/gold/onyxa
	name = "golden onyxa amulet"
	desc = "A luxurious golden amulet encrusted with a polished piece of onyxa, donnable both on neck and wrist."
	icon_state = "gold_onyxa"

/obj/item/clothing/neck/carved/gold/opal
	name = "golden opal amulet"
	desc = "A luxurious golden amulet encrusted with a polished piece of opal, donnable both on neck and wrist."
	icon_state = "gold_opal"

/obj/item/clothing/neck/carved/gold/rose
	name = "golden rosestone amulet"
	desc = "A luxurious golden amulet encrusted with a polished piece of rosestone, donnable both on neck and wrist."
	icon_state = "gold_rose"

/obj/item/clothing/neck/carved/gold/shell
	name = "golden shell amulet"
	desc = "A luxurious golden amulet encrusted with a polished piece of shell, donnable both on neck and wrist."
	icon_state = "gold_shell"

/obj/item/clothing/neck/carved/gold/turq
	name = "golden ceruleabaster amulet"
	desc = "A luxurious golden amulet encrusted with a polished piece of ceruleabaster, donnable both on neck and wrist."
	icon_state = "gold_turq"

/obj/item/clothing/neck/carved/gold/jade
	name = "golden joapstone amulet"
	desc = "A luxurious golden amulet encrusted with a polished piece of joapstone, donnable both on neck and wrist."
	icon_state = "gold_jade"

/obj/item/clothing/neck/furscarf
	name = "fur scarf"
	desc = "A thick band of fur worn about the neck against the cold."
	icon = 'modular_abel/neck_amulets/icons/amulets_world.dmi'
	mob_overlay_icon = 'modular_abel/neck_amulets/icons/amulets_onmob.dmi'
	icon_state = "furscarf"
	slot_flags = ITEM_SLOT_NECK
	equip_sound = 'sound/foley/equip/cloak_equip.ogg'
	pickup_sound = 'sound/foley/equip/cloak_take_off.ogg'
	break_sound = 'sound/foley/cloth_rip.ogg'
	drop_sound = 'sound/foley/dropsound/cloth_drop.ogg'
	salvage_result = /obj/item/natural/fur
	salvage_amount = 1
	sellprice = 25
