/turf/open/floor/cobblerock/dun_world
	icon = 'modular_abel/dun_world/icons/roguefloor.dmi'

/turf/open/floor/cobble/dun_world
	icon = 'modular_abel/dun_world/icons/roguefloor.dmi'

/turf/open/floor/cobble/mossy/dun_world

/turf/open/floor/hexstone/dun_world
	icon = 'modular_abel/dun_world/icons/roguefloor.dmi'
	icon_state = "hexstone"

/turf/open/floor/churchrough/dun_world
	icon = 'modular_abel/dun_world/icons/roguefloor.dmi'
	icon_state = "church_rough"

/turf/open/floor/church/dun_world
	icon = 'modular_abel/dun_world/icons/roguefloor.dmi'
	icon_state = "church"

/obj/effect/decal/cobbleedge/dun_world
	icon = null
	icon_state = null
	mouse_opacity = MOUSE_OPACITY_TRANSPARENT

/obj/effect/decal/cobbleedge/alt/dun_world
	icon = null
	icon_state = null
	mouse_opacity = MOUSE_OPACITY_TRANSPARENT

/obj/effect/decal/cobbleedge/mossy/dun_world
	icon = null
	icon_state = null
	mouse_opacity = MOUSE_OPACITY_TRANSPARENT

/obj/structure/curtain/dun_world
	color = "#ffffff"
	alpha = 255

/obj/structure/curtain/dun_world/red
	color = "#a32121"

/obj/structure/curtain/dun_world/blue
	color = CLOTHING_BLUE

/obj/structure/curtain/dun_world/green
	color = CLOTHING_DARK_GREEN

/obj/structure/curtain/dun_world/brown
	color = CLOTHING_BROWN

/obj/structure/curtain/dun_world/purple
	color = "#8747b1"

/obj/structure/curtain/dun_world/magenta
	color = "#962e5c"

/obj/structure/curtain/dun_world/black
	color = "#414143"

/obj/structure/fluff/railing/tall/palisade/dun_world
	desc = "A rudimentary barrier that might keep the monsters at bay."
	max_integrity = 400
	climbable = FALSE
	pass_crawl = FALSE
	pass_throwing = FALSE
	pass_projectile = FALSE
	opacity = TRUE

/obj/structure/fluff/railing/tall/palisade/dun_world/Initialize(mapload, ...)
	. = ..()
	smooth_dun_world_palisades()

/obj/structure/fluff/railing/tall/palisade/dun_world/Destroy()
	var/turf/old_loc = loc
	. = ..()
	if(!old_loc)
		return
	for(var/check_dir in GLOB.cardinals)
		var/turf/neighbor_turf = get_step(old_loc, check_dir)
		if(!neighbor_turf)
			continue
		for(var/obj/structure/fluff/railing/tall/palisade/dun_world/neighbor in neighbor_turf)
			neighbor.smooth_dun_world_palisades(TRUE)

/obj/structure/fluff/railing/tall/palisade/dun_world/OnCrafted(dirin, mob/user)
	. = ..()
	smooth_dun_world_palisades()

/obj/structure/fluff/railing/tall/palisade/dun_world/proc/smooth_dun_world_palisades(neighbors = FALSE)
	cut_overlays()
	if(!(dir in list(EAST, WEST)))
		return
	var/turf/north_turf = get_step(src, NORTH)
	if(north_turf)
		for(var/obj/structure/fluff/railing/tall/palisade/dun_world/fence in north_turf)
			if(fence.dir != dir)
				continue
			if(!neighbors)
				fence.smooth_dun_world_palisades(TRUE)
			var/mutable_appearance/smooth_above = mutable_appearance(icon, "fence_smooth_above")
			smooth_above.dir = dir
			add_overlay(smooth_above)
	var/turf/south_turf = get_step(src, SOUTH)
	if(south_turf)
		for(var/obj/structure/fluff/railing/tall/palisade/dun_world/fence in south_turf)
			if(fence.dir != dir)
				continue
			if(!neighbors)
				fence.smooth_dun_world_palisades(TRUE)
			var/mutable_appearance/smooth_below = mutable_appearance(icon, "fence_smooth_below")
			smooth_below.dir = dir
			add_overlay(smooth_below)

/obj/structure/table/wood/counter/dun_world
	dir = SOUTH

/obj/structure/table/wood/counter/dun_world/north
	dir = NORTH

/obj/structure/table/wood/counter/end/dun_world
	dir = SOUTH

/obj/structure/table/wood/counter/end/dun_world/north
	dir = NORTH

/obj/structure/table/wood/counter/end/dun_world/east
	dir = EAST

/obj/structure/table/wood/counter/end/dun_world/west
	dir = WEST

/obj/structure/table/wood/large/dun_world
	dir = SOUTH

/obj/structure/table/wood/large/dun_world/north
	icon_state = "largetable"
	dir = NORTH

/obj/structure/table/wood/large/dun_world/east
	icon_state = "largetable"
	dir = EAST

/obj/structure/table/wood/large/dun_world/west
	icon_state = "largetable"
	dir = WEST

/obj/structure/table/wood/large/corner/dun_world
	dir = SOUTH

/obj/structure/table/wood/large/corner/dun_world/north_east
	dir = NORTHEAST

/obj/structure/table/wood/large/corner/dun_world/north_west
	dir = NORTHWEST

/obj/structure/table/wood/large/corner/dun_world/south_east
	dir = SOUTHEAST

/obj/structure/table/wood/large/corner/dun_world/south_west
	dir = SOUTHWEST

/obj/structure/closet/crate/drawer/dun_world
	dir = SOUTH

/obj/structure/closet/crate/drawer/random/dun_world
	dir = SOUTH

/obj/structure/closet/crate/drawer/inn/dun_world
	dir = SOUTH

/turf/closed/wall/mineral/roofwall/middle/dir1
	dir = NORTH

/turf/closed/wall/mineral/roofwall/middle/dir4
	dir = EAST

/turf/closed/wall/mineral/roofwall/middle/dir8
	dir = WEST

/turf/closed/wall/mineral/roofwall/outercorner/dir1
	dir = NORTH

/turf/closed/wall/mineral/roofwall/outercorner/dir4
	dir = EAST

/turf/closed/wall/mineral/roofwall/outercorner/dir8
	dir = WEST

/turf/closed/wall/mineral/roofwall/innercorner/dir1
	dir = NORTH

/turf/closed/wall/mineral/roofwall/innercorner/dir4
	dir = EAST

/turf/closed/wall/mineral/roofwall/innercorner/dir8
	dir = WEST

/obj/effect/dun_world_movable_light_proxy
	name = ""
	desc = ""
	icon = null
	icon_state = null
	alpha = 0
	anchored = TRUE
	invisibility = INVISIBILITY_LIGHTING
	mouse_opacity = MOUSE_OPACITY_TRANSPARENT
	light_system = MOVABLE_LIGHT
	light_outer_range = 0
	light_power = 1
	light_color = "#ffa35c"
	light_on = FALSE

/obj/effect/dun_world_movable_light_proxy/Initialize(mapload, _outer = 8, _power = 1, _color = "#ffa35c", _on = TRUE)
	if(_outer > 0)
		light_outer_range = _outer
	light_inner_range = 0
	if(!isnull(_power))
		light_power = _power
	if(_color)
		light_color = _color
	light_on = !!_on
	. = ..()

/obj/machinery/light/fueled
	var/dun_world_compat = FALSE
	var/tmp/obj/effect/dun_world_movable_light_proxy/dun_world_proxy

/obj/machinery/light/fueled/Initialize()
	. = ..()
	dun_world_apply_compat()
	if(dun_world_compat)
		dun_world_sync_light_proxy()

/obj/machinery/light/fueled/update()
	. = ..()
	if(dun_world_compat)
		dun_world_sync_light_proxy()

/obj/machinery/light/fueled/Destroy()
	if(dun_world_proxy)
		QDEL_NULL(dun_world_proxy)
	return ..()

/obj/machinery/light/fueled/proc/dun_world_apply_compat()
	if(!dun_world_compat)
		var/area/A = get_area(src)
		if(A?.dun_world_lighting_compat)
			dun_world_compat = TRUE
	if(dun_world_compat)
		brightness = 0
		set_light(0)

/obj/machinery/light/fueled/torchholder/dun_world_apply_compat()
	return

/obj/machinery/light/fueled/torchholder/dun_world_sync_light_proxy()
	return

/obj/machinery/light/fueled/proc/dun_world_sync_light_proxy()
	if(!dun_world_compat)
		return
	var/turf/anchor = get_turf(src)
	if(!anchor)
		return
	var/proxy_outer = dun_world_compat_outer_range()
	var/proxy_power = dun_world_compat_power()
	var/proxy_color = dun_world_compat_color()
	var/should_be_on = on && status == LIGHT_OK && proxy_outer > 0 && proxy_power > 0

	if(QDELETED(dun_world_proxy))
		dun_world_proxy = null

	if(!dun_world_proxy)
		dun_world_proxy = new(anchor, proxy_outer, proxy_power, proxy_color, should_be_on)
		return

	if(dun_world_proxy.loc != anchor)
		dun_world_proxy.forceMove(anchor)
	dun_world_proxy.set_light_on(should_be_on)

/obj/machinery/light/fueled/proc/dun_world_compat_outer_range()
	return initial(brightness)

/obj/machinery/light/fueled/proc/dun_world_compat_power()
	return initial(bulb_power)

/obj/machinery/light/fueled/proc/dun_world_compat_color()
	if(color)
		return color
	return bulb_colour

/obj/machinery/light/fueled/wallfire/candle/dun_world
	dun_world_compat = TRUE

/obj/machinery/light/fueled/wallfire/candle/r/dun_world
	dun_world_compat = TRUE

/obj/machinery/light/fueled/wallfire/candle/l/dun_world
	dun_world_compat = TRUE

/obj/machinery/light/fueled/wallfire/candle/blue/dun_world
	dun_world_compat = TRUE

/obj/machinery/light/fueled/wallfire/candle/blue/r/dun_world
	dun_world_compat = TRUE

/obj/machinery/light/fueled/wallfire/candle/blue/l/dun_world
	dun_world_compat = TRUE

/obj/machinery/light/fueled/wallfire/candle/weak/dun_world
	dun_world_compat = TRUE

/obj/machinery/light/fueled/wallfire/candle/weak/r/dun_world
	dun_world_compat = TRUE

/obj/machinery/light/fueled/wallfire/candle/weak/l/dun_world
	dun_world_compat = TRUE

/obj/machinery/light/fueled/wallfire/candle/lamp/dun_world
	dun_world_compat = TRUE

/obj/machinery/light/fueled/wallfire/candle/dun_world/floorcandle
	name = "candles"
	icon = 'icons/roguetown/items/lighting.dmi'
	icon_state = "floorcandle1_lit"
	base_state = "floorcandle1"
	layer = TABLE_LAYER
	SET_BASE_PIXEL(0, 0)

/obj/machinery/light/fueled/wallfire/candle/dun_world/floorcandle/update_icon_state()
	. = ..()
	icon_state = on ? "[base_state]_lit" : base_state

/obj/machinery/light/fueled/wallfire/candle/dun_world/floorcandle/alt
	icon_state = "floorcandle0_lit"
	base_state = "floorcandle0"

/obj/machinery/light/fueled/wallfire/candle/dun_world/floorcandle/pink
	color = "#f858b5ff"
	bulb_colour = "#ff13d8ff"

/obj/machinery/light/fueled/wallfire/candle/dun_world/floorcandle/alt/pink
	color = "#f858b5ff"
	bulb_colour = "#ff13d8ff"

/obj/machinery/light/fueled/wallfire/dun_world_fireplace
	name = "fireplace"
	desc = "A warm fire dances between a pile of half-burnt logs upon a bed of glowing embers."
	brightness = 4
	bulb_colour = "#ffa35c"
	SET_BASE_PIXEL(0, 32)

/obj/machinery/light/fueled/firebowl/dun_world
	brightness = 12

/obj/machinery/light/fueled/firebowl/church/dun_world
	brightness = 12

/obj/machinery/light/fueled/firebowl/stump/dun_world
	brightness = 12

/obj/machinery/light/fueled/firebowl/standing/dun_world
	brightness = 12

/obj/machinery/light/fueled/firebowl/standing/blue/dun_world
	brightness = 12

/obj/structure/stairs/dun_world
	density = FALSE
	obj_flags = CAN_BE_HIT | IGNORE_SINK | BLOCK_Z_OUT_DOWN | BLOCK_Z_IN_UP

/obj/structure/stairs/stone/dun_world
	density = FALSE
	obj_flags = CAN_BE_HIT | IGNORE_SINK | BLOCK_Z_OUT_DOWN | BLOCK_Z_IN_UP

/obj/structure/stairs/fancy/dun_world
	density = FALSE
	obj_flags = CAN_BE_HIT | IGNORE_SINK | BLOCK_Z_OUT_DOWN | BLOCK_Z_IN_UP

/obj/structure/stairs/fancy/c/dun_world
	density = FALSE
	obj_flags = CAN_BE_HIT | IGNORE_SINK | BLOCK_Z_OUT_DOWN | BLOCK_Z_IN_UP

/obj/structure/stairs/fancy/r/dun_world
	density = FALSE
	obj_flags = CAN_BE_HIT | IGNORE_SINK | BLOCK_Z_OUT_DOWN | BLOCK_Z_IN_UP

/obj/structure/stairs/fancy/l/dun_world
	density = FALSE
	obj_flags = CAN_BE_HIT | IGNORE_SINK | BLOCK_Z_OUT_DOWN | BLOCK_Z_IN_UP

/turf/open/water/river/dun_world
	dir = SOUTH

/turf/open/water/river/dun_world/north
	dir = NORTH

/turf/open/water/river/dun_world/east
	dir = EAST

/turf/open/water/river/dun_world/west
	dir = WEST

/mob/dead/observer
	hud_type = /datum/hud/ghost/dun_world

/datum/hud/ghost/dun_world/New(mob/owner)
	. = ..()
	var/atom/movable/screen/ghost/teleport/old_teleport
	for(var/atom/movable/screen/ghost/teleport/teleport_button as anything in static_inventory)
		old_teleport = teleport_button
		break
	if(old_teleport)
		static_inventory -= old_teleport
		qdel(old_teleport)
	static_inventory += new /atom/movable/screen/ghost/teleport/dun_world(null, src)

/atom/movable/screen/ghost/teleport/dun_world/Click()
	var/mob/dead/observer/G = usr
	G.dun_world_dead_tele()

/mob/dead/observer/proc/dun_world_dead_tele()
	if(!isobserver(src))
		to_chat(src, span_warning("Not when you're not dead!"))
		return

	var/area/thearea = browser_input_list(src, "Area to jump to", "Where?", sortNames(GLOB.areas))
	if(!thearea || QDELETED(src))
		return

	var/list/possible_turfs = get_area_turfs(thearea)
	if(!length(possible_turfs))
		to_chat(src, span_warning("No location available!"))
		return

	forceMove(pick(possible_turfs))

/obj/effect/landmark/start/lord/Initialize(mapload)
	. = ..()
	if(SSmapping.config?.map_name == "Twilight Axis")
		GLOB.latejoin_landmarks |= src

/datum/job/lord/New()
	. = ..()
	if(SSmapping.config?.monarch_title)
		ruler_title = SSmapping.config.monarch_title

/obj/effect/landmark/start/outsider/Initialize(mapload)
	. = ..()
	if(SSmapping.config?.map_name == "Twilight Axis")
		jobs_to_spawn -= ROLE_WRETCH

/datum/controller/subsystem/job/get_last_resort_spawn_points()
	if(SSmapping.config?.map_name == "Twilight Axis")
		var/obj/effect/landmark/start/outsider/fallback = locate(/obj/effect/landmark/start/outsider) in GLOB.latejoin_landmarks
		if(fallback)
			return fallback
	return ..()

/obj/effect/wisp/prestidigitation/willowwisp
	name = "Will-o'-the-wisp"
	desc = "A small, fiery ball of light made up of mystical energy."

/obj/structure/lever/bookcase
	name = "Bookcase"
	desc = "Refuge for few, an irrelevance to most."
	icon_state = "booklever0"

/obj/structure/lever/bookcase/onkick(mob/user)
	return

/obj/structure/lever/bookcase/attack_hand(mob/user)
	if(!isliving(user))
		return
	var/mob/living/L = user
	L.changeNext_move(CLICK_CD_MELEE)
	var/used_time = pulltime - (GET_MOB_ATTRIBUTE_VALUE(L, STAT_STRENGTH) * 1 SECONDS)
	user.visible_message(span_warning("[user] pulls the book out of place."))
	user.log_message("pulled the lever with redstone id \"[redstone_id]\"", LOG_GAME)
	if(do_after(user, used_time))
		for(var/obj/structure/structure in redstone_attached)
			INVOKE_ASYNC(structure, PROC_REF(redstone_triggered), user)
		trigger_wire_network(user)
		toggled = !toggled
		icon_state = "booklever[toggled]"
		playsound(src, 'sound/foley/lever.ogg', 100, extrarange = 3)

/obj/structure/bars/passage/shutter/bookcase
	name = "Empty Bookcase"
	desc = "Refuge for few, an irrelevance to most."
	icon_state = "decoybookcase0"

/obj/structure/bars/passage/shutter/bookcase/redstone_triggered(mob/user)
	if(obj_broken)
		return
	if(density)
		icon_state = "decoybookcase1"
		density = FALSE
		opacity = FALSE
	else
		icon_state = "decoybookcase0"
		density = TRUE
		opacity = TRUE
