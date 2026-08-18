// Snouted helmet variants for beastfolk and other muzzled species.
// Sprites ported from Azure-Peak's rogueclothes headwear, added upstream after Vibelin PR #5.
//
// Azure hangs these off helmet families Vanderlin does not have - bascinet/pigface,
// heavy/banneret, heavy/knight/armet, sallet/visored. Rather than import four whole helmet
// lines for the sake of their variants, these are declared as variants of the helmets
// Vanderlin already stocks: the snout is a variation on what is in the armoury, not a new
// piece of kit.
//
// Mapping used:
//   Azure bascinet/pigface/roundface/snouted   -> our helmet/bascinet/snouted
//   Azure sallet/visored/snouted               -> our helmet/sallet/snouted
//   Azure heavy/knight/armet/snouted           -> our helmet/visored/snouted
//   Azure heavy/nochelm/snouted                -> our helmet/heavy/nochelm/snouted (parent already here)
//   Azure heavy/volfplate/psydonic             -> our helmet/heavy/volfplate/psydonic (parent already here)
//
// Not brought over: Azure's banneret sallet, whose "capsallet_s" sprite does not exist in
// its own sheets.

// ---------------------------------------------------------------------------
// Bascinets.
// ---------------------------------------------------------------------------

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

// ---------------------------------------------------------------------------
// Sallets.
// ---------------------------------------------------------------------------

/obj/item/clothing/head/helmet/sallet/snouted
	name = "snouted visored sallet"
	desc = "A visored sallet with the lower plate drawn forward over a muzzle."
	icon = 'modular_abel/snouted_helms/icons/helms_world.dmi'
	mob_overlay_icon = 'modular_abel/snouted_helms/icons/helms_onmob.dmi'
	icon_state = "sallet_visor_s"

/obj/item/clothing/head/helmet/sallet/snouted/iron
	name = "snouted visored iron sallet"
	desc = "A visored iron sallet with the lower plate drawn forward over a muzzle."
	icon_state = "isallet_visor_s"

// ---------------------------------------------------------------------------
// Closed helms.
// ---------------------------------------------------------------------------

/obj/item/clothing/head/helmet/visored/snouted
	name = "snouted armet"
	desc = "A close helm whose visor swells outward to sit over a muzzle."
	icon = 'modular_abel/snouted_helms/icons/helms_world.dmi'
	mob_overlay_icon = 'modular_abel/snouted_helms/icons/helms_onmob.dmi'
	icon_state = "armet_s"

/obj/item/clothing/head/helmet/visored/snouted/iron
	name = "snouted iron armet"
	desc = "A close iron helm whose visor swells outward to sit over a muzzle."
	icon_state = "iarmet_s"

/obj/item/clothing/head/helmet/heavy/nochelm/snouted
	name = "snouted nocturnal helm"
	desc = "The astronomer's helm, reshaped for a muzzled skull."
	icon = 'modular_abel/snouted_helms/icons/helms_world.dmi'
	mob_overlay_icon = 'modular_abel/snouted_helms/icons/helms_onmob.dmi'
	icon_state = "nochelm_s"

// The psydonic volfplate helm uses the tall 32x40 mob sheet, as its parent does.
/obj/item/clothing/head/helmet/heavy/volfplate/psydonic
	name = "psydonic volfplate helm"
	desc = "A volfplate greathelm bearing the marks of the Order, drawn out at the jaw."
	icon = 'modular_abel/snouted_helms/icons/helms_world.dmi'
	mob_overlay_icon = 'modular_abel/snouted_helms/icons/helms_tall.dmi'
	icon_state = "psyhelm_s"
