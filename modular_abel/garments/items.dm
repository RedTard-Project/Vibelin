// Dresses, robes, a winter tunic, a toga and a formal skirt.
// Ported from Azure-Peak's rogueclothes shirts.dm / robes.dm / cloaks.dm / pants/skirt.dm,
// added upstream after Vibelin PR #5.
//
// Batch 3 of the clothing port.
//
// Path notes: Azure's /obj/item/clothing/suit/roguetown/shirt/* is /obj/item/clothing/shirt/*
// here, and its /obj/item/clothing/under/roguetown/skirt/* lives under
// /obj/item/clothing/pants/skirt/*.
//
// The four gowns carry no sleeve states in any Azure sheet - they are sleeveless by design -
// so they set no `sleeved` and inherit the parent's sleeve status.

// ---------------------------------------------------------------------------
// Gowns.
// ---------------------------------------------------------------------------

/obj/item/clothing/shirt/dress/blue
	name = "blue dress"
	desc = "A modest blue dress of the kind worn by townswomen on days that matter."
	icon = 'modular_abel/garments/icons/garments_world.dmi'
	mob_overlay_icon = 'modular_abel/garments/icons/garments_onmob.dmi'
	icon_state = "bluedress"
	sellprice = 25

/obj/item/clothing/shirt/dress/green
	name = "green dress"
	desc = "A modest green dress of the kind worn by townswomen on days that matter."
	icon = 'modular_abel/garments/icons/garments_world.dmi'
	mob_overlay_icon = 'modular_abel/garments/icons/garments_onmob.dmi'
	icon_state = "greendress"
	sellprice = 25

/obj/item/clothing/shirt/dress/tavern
	name = "tavern dress"
	desc = "A hard-wearing dress cut for carrying tankards through a crowded room."
	icon = 'modular_abel/garments/icons/garments_world.dmi'
	mob_overlay_icon = 'modular_abel/garments/icons/garments_onmob.dmi'
	icon_state = "taverndress"
	sellprice = 20

/obj/item/clothing/shirt/dress/nightgown
	name = "nightgown"
	desc = "A thin, loose gown meant for sleeping and little else."
	icon = 'modular_abel/garments/icons/garments_world.dmi'
	mob_overlay_icon = 'modular_abel/garments/icons/garments_onmob.dmi'
	icon_state = "nightgown"
	sellprice = 12

// ---------------------------------------------------------------------------
// Robes.
// ---------------------------------------------------------------------------

/obj/item/clothing/shirt/robe/leopard
	name = "leopard bathrobe"
	desc = "A plush bathrobe patterned after a leopard's pelt. Whether any leopard was involved is doubtful."
	icon = 'modular_abel/garments/icons/garments_world.dmi'
	mob_overlay_icon = 'modular_abel/garments/icons/garments_onmob.dmi'
	sleeved = 'modular_abel/garments/icons/garments_sleeves.dmi'
	icon_state = "lpbathrobe"
	sellprice = 30

/obj/item/clothing/shirt/robe/leopard/alt
	name = "open leopard bathrobe"
	desc = "A plush bathrobe patterned after a leopard's pelt, worn hanging open."
	icon_state = "lpbathrobe_open"

/obj/item/clothing/shirt/robe/lunar
	name = "lunar robe"
	desc = "A dark robe scattered with the phases of the moon, favoured by those who keep night hours."
	icon = 'modular_abel/garments/icons/garments_world.dmi'
	mob_overlay_icon = 'modular_abel/garments/icons/garments_onmob.dmi'
	sleeved = 'modular_abel/garments/icons/garments_sleeves.dmi'
	icon_state = "lunarrobe"
	sellprice = 40

/obj/item/clothing/shirt/robe/magician
	name = "magician's robe"
	desc = "A heavy robe cut in the manner favoured by practitioners of the arcyne."
	icon = 'modular_abel/garments/icons/garments_world.dmi'
	mob_overlay_icon = 'modular_abel/garments/icons/garments_onmob.dmi'
	sleeved = 'modular_abel/garments/icons/garments_sleeves.dmi'
	icon_state = "magerobe"
	sellprice = 40

// ---------------------------------------------------------------------------
// Outerwear and the rest.
// ---------------------------------------------------------------------------

/obj/item/clothing/shirt/tunic/winter
	name = "winter coat"
	desc = "A thick, lined coat built to keep the cold on the outside of it."
	icon = 'modular_abel/garments/icons/garments_world.dmi'
	mob_overlay_icon = 'modular_abel/garments/icons/garments_onmob.dmi'
	sleeved = 'modular_abel/garments/icons/garments_sleeves.dmi'
	icon_state = "wintercoat"
	sellprice = 35

/obj/item/clothing/cloak/tabard/toga/dress
	name = "toga"
	desc = "The ancestral predecessor to Psydonia's many tabards, worn by the townsfolk, heroes, and villains of antiquity."
	icon = 'modular_abel/garments/icons/garments_world.dmi'
	mob_overlay_icon = 'modular_abel/garments/icons/garments_onmob.dmi'
	icon_state = "toga_f"
	sellprice = 20

/obj/item/clothing/pants/skirt/formal
	name = "formal skirt"
	desc = "A long, pleated skirt of the sort worn to court and to funerals."
	icon = 'modular_abel/garments/icons/garments_world.dmi'
	mob_overlay_icon = 'modular_abel/garments/icons/garments_onmob.dmi'
	icon_state = "formalskirt"
	sellprice = 22
