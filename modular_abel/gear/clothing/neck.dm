/obj/item/clothing/neck/chaincoif/bronze
	name = "bronze chain coif"
	desc = "A maille-hood, fashioned from interlinked bronze rings. As preached by the Pantheon, these maille-hoods were originally made in mimicry of what was worn by the earliest priests."
	icon = 'modular_abel/gear/icons/neck.dmi'
	mob_overlay_icon = 'modular_abel/gear/icons/onmob/neck.dmi'
	icon_state = "bchaincoif"
	armor_type = /datum/armor/maille/bronze
	max_integrity = INTEGRITY_OLD_STRONG + 75
	smeltresult = /obj/item/ingot/bronze
	melting_material = /datum/material/bronze

/obj/item/clothing/neck/loveamulet
	name = "tears of love amulet"
	desc = "This amulet is made in a southern county of the empire. Faceted with black diamonds, this piece of jewelry symbolizes the pain and sadness that lies beneath the surface of happiness and tranquility."
	icon = 'modular_abel/gear/icons/neck.dmi'
	mob_overlay_icon = 'modular_abel/gear/icons/onmob/neck.dmi'
	icon_state = "loveamulet"
	item_state = "loveamulet"

/obj/item/clothing/neck/psycross/matthios/moneta
	name = "pierced coin amulet"
	desc = "A simple luck charm - a zenny, pierced by a blade and hanging on a thin iron chain. A tiny inscription upon the amulet's edge reads: «All tyrants will die alone.»"
	icon = 'modular_abel/gear/icons/neck.dmi'
	mob_overlay_icon = 'modular_abel/gear/icons/onmob/neck.dmi'
	icon_state = "matthios"
	item_state = "matthios"

/obj/item/clothing/neck/psycross/matthios/moneta/examine(mob/user)
	. = ..()
	if(!iscarbon(user))
		return
	var/mob/living/carbon/H = user
	if(istype(H.patron, /datum/patron/inhumen/matthios))
		. += span_info("A recognizable charm of Matthios' own - a coin shattered, a symbol of the pure rejection of wealth by those who would be oppressed with it. The amulet contains no power of its own, yet as you hold it in the palm of your hand, you can feel the promise of freedom empowering you.")
