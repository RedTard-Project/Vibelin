/obj/item/clothing/head/helmet/bascinet/snouted
	name = "snouted bascinet"
	desc = "A rounded bascinet beaten out at the face to leave room for a muzzle."
	icon = 'modular_abel/snouted_helms/icons/helms_world.dmi'
	mob_overlay_icon = 'modular_abel/snouted_helms/icons/helms_onmob.dmi'
	icon_state = "roundface_s"

/obj/item/clothing/head/helmet/bascinet/snouted/iron
	name = "snouted iron bascinet"
	desc = "A rounded iron bascinet beaten out at the face to leave room for a muzzle."
	icon_state = "iroundface_s"
	smeltresult = /obj/item/ingot/iron
	sellprice = VALUE_IRON_HELMET

/obj/item/clothing/head/helmet/sallet/snouted
	name = "snouted visored sallet"
	desc = "A visored sallet with the lower plate drawn forward over a muzzle."
	icon = 'modular_abel/snouted_helms/icons/helms_world.dmi'
	mob_overlay_icon = 'modular_abel/snouted_helms/icons/helms_onmob.dmi'
	icon_state = "sallet_visor_s"

/obj/item/clothing/head/helmet/sallet/iron/snouted
	name = "snouted visored iron sallet"
	desc = "A visored iron sallet with the lower plate drawn forward over a muzzle."
	icon = 'modular_abel/snouted_helms/icons/helms_world.dmi'
	mob_overlay_icon = 'modular_abel/snouted_helms/icons/helms_onmob.dmi'
	icon_state = "isallet_visor_s"

/obj/item/clothing/head/helmet/visored/knight/snouted
	name = "snouted armet"
	desc = "A close helm whose visor swells outward to sit over a muzzle."
	icon = 'modular_abel/snouted_helms/icons/helms_world.dmi'
	mob_overlay_icon = 'modular_abel/snouted_helms/icons/helms_onmob.dmi'
	icon_state = "armet_s"
	bloody_icon = 'icons/effects/blood.dmi'
	bloody_icon_state = "helmetblood"
	worn_x_dimension = 32
	worn_y_dimension = 32

/obj/item/clothing/head/helmet/visored/knight/iron/snouted
	name = "snouted iron armet"
	desc = "A close iron helm whose visor swells outward to sit over a muzzle."
	icon = 'modular_abel/snouted_helms/icons/helms_world.dmi'
	mob_overlay_icon = 'modular_abel/snouted_helms/icons/helms_onmob.dmi'
	icon_state = "iarmet_s"
	bloody_icon = 'icons/effects/blood.dmi'
	bloody_icon_state = "helmetblood"
	worn_x_dimension = 32
	worn_y_dimension = 32

/obj/item/clothing/head/helmet/heavy/nochelm/snouted
	name = "snouted nocturnal helm"
	desc = "The astronomer's helm, reshaped for a muzzled skull."
	icon = 'modular_abel/snouted_helms/icons/helms_world.dmi'
	mob_overlay_icon = 'modular_abel/snouted_helms/icons/helms_onmob.dmi'
	icon_state = "nochelm_s"

/obj/item/clothing/head/helmet/heavy/volfplate/psydonic
	name = "psydonic volfplate helm"
	desc = "A volfplate greathelm bearing the marks of the Order, drawn out at the jaw."
	icon = 'modular_abel/snouted_helms/icons/helms_world.dmi'
	mob_overlay_icon = 'modular_abel/snouted_helms/icons/helms_tall.dmi'
	icon_state = "psyhelm_s"

/datum/anvil_recipe/armor/iron/bascinet_snouted
	name = "Bascinet, Snouted, Iron (+1 Iron)"
	additional_items = list(/obj/item/ingot/iron)
	created_item = /obj/item/clothing/head/helmet/bascinet/snouted/iron
	craftdiff = 3

/datum/anvil_recipe/armor/steel/bascinet_snouted
	name = "Bascinet, Snouted (+1 Steel)"
	additional_items = list(/obj/item/ingot/steel)
	created_item = /obj/item/clothing/head/helmet/bascinet/snouted
	craftdiff = 3

/datum/anvil_recipe/armor/iron/sallet_snouted
	name = "Visored Sallet, Snouted, Iron (+1 Iron)"
	additional_items = list(/obj/item/ingot/iron)
	created_item = /obj/item/clothing/head/helmet/sallet/iron/snouted
	craftdiff = 3

/datum/anvil_recipe/armor/steel/sallet_snouted
	name = "Visored Sallet, Snouted (+1 Steel)"
	additional_items = list(/obj/item/ingot/steel)
	created_item = /obj/item/clothing/head/helmet/sallet/snouted
	craftdiff = 3

/datum/anvil_recipe/armor/iron/armet_snouted
	name = "Armet, Snouted, Iron (+1 Iron)"
	additional_items = list(/obj/item/ingot/iron)
	created_item = /obj/item/clothing/head/helmet/visored/knight/iron/snouted
	craftdiff = 4

/datum/anvil_recipe/armor/steel/armet_snouted
	name = "Armet, Snouted (+1 Steel)"
	additional_items = list(/obj/item/ingot/steel)
	created_item = /obj/item/clothing/head/helmet/visored/knight/snouted
	craftdiff = 4

/datum/anvil_recipe/armor/steel/nochelm_snouted
	name = "Nocturnal Helm, Snouted (+1 Steel)"
	additional_items = list(/obj/item/ingot/steel)
	created_item = /obj/item/clothing/head/helmet/heavy/nochelm/snouted
	craftdiff = 4

/datum/anvil_recipe/armor/volfplate_psydonic
	name = "psydonic volfplate helm"
	required_material = /obj/item/ingot/steel
	additional_items = list(/obj/item/ingot/steel)
	created_item = /obj/item/clothing/head/helmet/heavy/volfplate/psydonic
	craftdiff = 4

/obj/item/enchantingkit/snouted_bascinet
	name = "morphing elixir of the snouted bascinet"
	desc = "A small container of special morphing dust, tuned to beat a bascinet out at the face to leave room for a muzzle."
	exact_type = TRUE
	target_items = list(
		/obj/item/clothing/head/helmet/bascinet = /obj/item/clothing/head/helmet/bascinet/snouted,
	)

/obj/item/enchantingkit/snouted_sallet
	name = "morphing elixir of the snouted sallet"
	desc = "A small container of special morphing dust, tuned to draw a visored sallet's lower plate forward over a muzzle."
	exact_type = TRUE
	target_items = list(
		/obj/item/clothing/head/helmet/sallet/iron = /obj/item/clothing/head/helmet/sallet/iron/snouted,
		/obj/item/clothing/head/helmet/sallet = /obj/item/clothing/head/helmet/sallet/snouted,
	)

/obj/item/enchantingkit/snouted_armet
	name = "morphing elixir of the snouted armet"
	desc = "A small container of special morphing dust, tuned to swell a close helm's visor outward over a muzzle."
	exact_type = TRUE
	target_items = list(
		/obj/item/clothing/head/helmet/visored/knight/iron = /obj/item/clothing/head/helmet/visored/knight/iron/snouted,
		/obj/item/clothing/head/helmet/visored/knight = /obj/item/clothing/head/helmet/visored/knight/snouted,
	)

/obj/item/enchantingkit/snouted_nochelm
	name = "morphing elixir of the snouted nocturnal helm"
	desc = "A small container of special morphing dust, tuned to reshape the astronomer's helm for a muzzled skull."
	exact_type = TRUE
	target_items = list(
		/obj/item/clothing/head/helmet/heavy/nochelm = /obj/item/clothing/head/helmet/heavy/nochelm/snouted,
	)

/obj/item/enchantingkit/psydonic_volfplate
	name = "morphing elixir of the psydonic volfplate"
	desc = "A small container of special morphing dust, tuned to draw a volfplate greathelm out at the jaw and mark it with the Order."
	exact_type = TRUE
	target_items = list(
		/obj/item/clothing/head/helmet/heavy/volfplate = /obj/item/clothing/head/helmet/heavy/volfplate/psydonic,
	)

/datum/loadout_item/azure_snouted_helm
	abstract_type = /datum/loadout_item/azure_snouted_helm
	ui_category = LOADOUT_PANEL_CATEGORY_AZURE
	ui_icon = 'modular_abel/snouted_helms/icons/helms_world.dmi'

/datum/loadout_item/azure_snouted_helm/bascinet
	name = "Morphing Elixir: Snouted Bascinet"
	item_path = /obj/item/enchantingkit/snouted_bascinet
	ui_icon_state = "roundface_s"

/datum/loadout_item/azure_snouted_helm/sallet
	name = "Morphing Elixir: Snouted Sallet"
	item_path = /obj/item/enchantingkit/snouted_sallet
	ui_icon_state = "sallet_visor_s"

/datum/loadout_item/azure_snouted_helm/armet
	name = "Morphing Elixir: Snouted Armet"
	item_path = /obj/item/enchantingkit/snouted_armet
	ui_icon_state = "armet_s"

/datum/loadout_item/azure_snouted_helm/nochelm
	name = "Morphing Elixir: Snouted Nocturnal Helm"
	item_path = /obj/item/enchantingkit/snouted_nochelm
	ui_icon_state = "nochelm_s"

/datum/loadout_item/azure_snouted_helm/psydonic_volfplate
	name = "Morphing Elixir: Psydonic Volfplate Helm"
	item_path = /obj/item/enchantingkit/psydonic_volfplate
	ui_icon_state = "psyhelm_s"
