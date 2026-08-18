// Painter vestments and the paint staff spawner.
// Ported from Azure-Peak code/modules/roguetown/roguemachine/abyssorcult/dream_equipment.dm.
//
// Azure keeps these under /obj/item/clothing/suit/roguetown/... ; Vanderlin dropped the
// "roguetown" segment years ago, so they live at the Vanderlin paths here and the Azure
// paths are pointed at them from modular_abel/dun_world/config/map.json.

/obj/item/clothing/shirt/robe/abyssor_painter // thanks to ket for the abyssor clothing sprites
	name = "rainfall robe"
	desc = "A long robe formed of many layers of thin, light fabric; designed not to become over-heavy \
	while waterlogged. \
	This robe is commonly worn by abyssorites that follow the path of the dream painter. \
	Said to have been dyed with paints from his dream in a pattern that resembles rainfall."
	icon_state = "rain"
	icon = 'modular_abel/dun_world/abyssor/icons/abyssor.dmi'
	mob_overlay_icon = 'modular_abel/dun_world/abyssor/icons/abyssor_onmob.dmi'
	sleeved = 'modular_abel/dun_world/abyssor/icons/abyssor_onmob.dmi'
	color = null

/obj/item/clothing/shirt/robe/abyssor_painter_sea
	name = "sea robe"
	desc = "A long robe formed of many layers of thin, light fabric; designed not to become over-heavy \
	while waterlogged. \
	This robe is commonly worn by abyssorites that follow the path of the dream painter. \
	Said to have been dyed with paints from his dream in a pattern that resembles the waves of the great blue."
	icon_state = "sea"
	icon = 'modular_abel/dun_world/abyssor/icons/abyssor.dmi'
	mob_overlay_icon = 'modular_abel/dun_world/abyssor/icons/abyssor_onmob.dmi'
	sleeved = 'modular_abel/dun_world/abyssor/icons/abyssor_onmob.dmi'
	color = null

/obj/item/clothing/shirt/robe/abyssor_leader
	name = "sylveric robe"
	desc = "A long robe formed of many layers of thin, light fabric; designed not to become over-heavy \
	while waterlogged. \
	This robe is commonly worn by exalted abyssorites that follow the path of the dream painter. \
	Said to have been dyed with paints from his dream in a pattern that resembles the woes of His dream."
	icon_state = "leaderrobe"
	icon = 'modular_abel/dun_world/abyssor/icons/abyssor.dmi'
	mob_overlay_icon = 'modular_abel/dun_world/abyssor/icons/abyssor_onmob.dmi'
	sleeved = 'modular_abel/dun_world/abyssor/icons/abyssor_onmob.dmi'
	color = null

/obj/item/clothing/head/roguehood/abyssor_painter
	name = "quicksilver hood"
	desc = "A hood worn by the followers of Abyssor, with a unique spiral wrapping. How do they even see out of this? \
	It's said out of the many pigments of the dream, the most potent resembles quicksilver. \
	Hoods like these are designed to capture the fumes that are given off by the silvery paint... after completing certain rites."
	color = null
	icon_state = "silverhood"
	item_state = "silverhood"
	icon = 'modular_abel/dun_world/abyssor/icons/abyssor.dmi'
	mob_overlay_icon = 'modular_abel/dun_world/abyssor/icons/abyssor_onmob.dmi'
	slot_flags = ITEM_SLOT_HEAD|ITEM_SLOT_MASK
	max_integrity = 180
