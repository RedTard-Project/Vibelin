// Required by the generated map: the Twilight Axis .dmm places this turf path directly.
/turf/open/rebound
	name = "undercurrent"
	desc = "These waters reject those without proper will."
	icon = 'modular_abel/dun_world/icons/roguefloor.dmi'
	icon_state = "water"
	color = "#2a3852"
	alpha = 50

/turf/open/rebound/Entered(atom/movable/AM)
	..()
	if(AM.throwing)
		return

	if(!isliving(AM) && !isitem(AM))
		return
	var/turf/previous_turf = AM.loc
	if(istype(AM))
		previous_turf = get_step(src, REVERSE_DIR(AM.dir))

	var/entry_dir = get_dir(previous_turf, src)
	if(!entry_dir)
		entry_dir = AM.dir || pick(NORTH, SOUTH, EAST, WEST)

	var/rebound_dir = REVERSE_DIR(entry_dir)
	var/turf/target_turf = get_ranged_target_turf(src, rebound_dir, 5)
	if(istype(target_turf, /turf/open/rebound))
		var/list/safe_landings = list()
		for(var/turf/T in orange(2, target_turf))
			if(T.density || istype(T, /turf/open/rebound))
				continue
			safe_landings += T
		if(length(safe_landings))
			target_turf = pick(safe_landings)
	if(target_turf)
		if(isliving(AM))
			var/mob/living/L = AM
			to_chat(L, span_userdanger("The currents reject you!"))
			playsound(src, 'modular_abel/dun_world/abyssor/sound/abyssor_splash.ogg', 70, TRUE)
			L.Knockdown(1 SECONDS)
		AM.throw_at(target_turf, 5, 1)
