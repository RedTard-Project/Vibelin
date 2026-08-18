// The dream pool and its gate.
// Ported from Azure-Peak code/modules/roguetown/roguemachine/abyssorcult/dream_pool.dm.
//
// NOT ported yet: the group-ritual processing (handle_ritual_start / coordinate_channeling_loop /
// spawn_deep_one_wave / generate_inundation_loot). Those drive Azure's /datum/tgui_module/
// vortex_ritual_selection window, and Vanderlin has no /datum/tgui_module base - that layer
// needs a real tgui interface written against SStgui rather than a straight port. The pool
// itself, its gate and the redstone hookup all work; the ritual chain is the follow-up.

/obj/structure/roguemachine/dream_pool
	name = "dream pool"
	desc = ""
	icon = 'modular_abel/dun_world/abyssor/icons/abyssor_pool.dmi'
	icon_state = "whirl"
	resistance_flags = INDESTRUCTIBLE
	pixel_x = -32
	pixel_y = -32
	interaction_flags_atom = INTERACT_ATOM_ATTACK_HAND
	redstone_structure = TRUE
	var/obj/structure/dream_pool_door/linked_door
	/// Tracks if a group ritual is actively processing right now
	var/ritual_active = FALSE

/obj/structure/roguemachine/dream_pool/Initialize(mapload)
	. = ..()
	linked_door = new /obj/structure/dream_pool_door(get_turf(src))
	linked_door.linked_pool = src
	update_icon()

/obj/structure/roguemachine/dream_pool/proc/get_outer_rim_turfs()
	var/list/turf/outer_rim = list()
	var/turf/center = get_turf(src)
	if(!center)
		return outer_rim
	for(var/turf/T in range(2, center))
		if(get_dist(center, T) == 2)
			outer_rim += T
	return outer_rim

/obj/structure/roguemachine/dream_pool/examine(mob/user)
	. = ..()
	if(linked_door?.gate_closed)
		. += span_notice("Incredibly heavy, rusty doors obscure the contents of this elaborate metallic indentation. It looks very old.")
	else
		. += span_notice("The gate doors have retracted. A swirling vortex bombards you with imagery of a strange realm. Just looking into it makes you dizzy, best not to stare... Especially as something gazes back from beneath the surface.")

/obj/structure/roguemachine/dream_pool/attack_hand(mob/user, list/modifiers)
	. = ..()
	if(.)
		return
	if(linked_door)
		linked_door.attack_hand(user, modifiers)

/obj/structure/roguemachine/dream_pool/redstone_triggered(mob/user)
	..()
	if(!linked_door || linked_door.animating)
		return

	if(linked_door.gate_closed)
		linked_door.open_gate(user)
	else
		linked_door.close_gate(user)

/obj/structure/dream_pool_door
	name = "dream pool door"
	desc = ""
	icon = 'modular_abel/dun_world/abyssor/icons/abyssor_pool.dmi'
	icon_state = "door"
	resistance_flags = INDESTRUCTIBLE
	pixel_x = -32
	pixel_y = -32
	layer = ABOVE_OBJ_LAYER
	mouse_opacity = MOUSE_OPACITY_TRANSPARENT
	var/gate_closed = TRUE
	var/animating = FALSE
	var/obj/structure/roguemachine/dream_pool/linked_pool
	var/mutable_appearance/frame_overlay

/obj/structure/dream_pool_door/Initialize(mapload)
	. = ..()
	frame_overlay = mutable_appearance(icon, "frame")
	update_icon()

/obj/structure/dream_pool_door/Destroy()
	if(linked_pool)
		linked_pool.linked_door = null
		linked_pool = null
	return ..()

/obj/structure/dream_pool_door/attack_hand(mob/user, list/modifiers)
	. = ..()
	if(.)
		return
	if(animating)
		to_chat(user, span_warning("The gate mechanism is currently operating!"))
		return
	if(gate_closed)
		open_gate(user)
	else
		close_gate(user)

/obj/structure/dream_pool_door/proc/open_gate(mob/user)
	animating = TRUE
	visible_message(span_notice("[src]'s heavy frame groans as the portal lock turns."))
	flick("door_opening", src)
	addtimer(CALLBACK(src, PROC_REF(finish_open_gate)), 5 SECONDS)

/obj/structure/dream_pool_door/proc/close_gate(mob/user)
	animating = TRUE
	visible_message(span_notice("The frame clangs as the pool doors begin sliding back into place."))
	flick("door_closing", src)
	addtimer(CALLBACK(src, PROC_REF(finish_close_gate)), 5 SECONDS)

/obj/structure/dream_pool_door/proc/finish_open_gate()
	gate_closed = FALSE
	animating = FALSE
	icon_state = null
	visible_message(span_purple("With a heavy hiss, the dream pool's gate slides fully open!"))
	update_icon()
	playsound(src, 'sound/foley/lever.ogg', 100)

/obj/structure/dream_pool_door/proc/finish_close_gate()
	gate_closed = TRUE
	animating = FALSE
	icon_state = "door"
	visible_message(span_notice("[src]'s rusty seal locks tightly into place."))
	update_icon()
	playsound(src, 'sound/foley/lever.ogg', 100)

/obj/structure/dream_pool_door/update_overlays()
	. = ..()
	if(frame_overlay)
		. += frame_overlay
