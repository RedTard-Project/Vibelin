/obj/structure/dream_pylon
	name = "painted pylon"
	desc = "A strange pulsing pylon that seems to be made out of thick, solidified swirls of abyssal paints."
	icon = 'modular_abel/dun_world/abyssor/icons/abyssor_pylon.dmi'
	icon_state = "pylon"
	anchored = TRUE
	density = TRUE
	resistance_flags = FIRE_PROOF | ACID_PROOF
	max_integrity = 500

	/// Tracks the active overlay object currently attached to the pylon
	var/obj/effect/pylon_overlay/active_overlay
	/// The typepath of the status effect infusion currently hosted inside this pylon
	var/datum/status_effect/infusion/infusion_payload = /datum/status_effect/infusion/intelligence
	/// Current amount of abyssal energy stored
	var/charge = 100
	/// Max capability reservoir
	var/max_charge = 100
	/// Cost per extraction
	var/charge_cost_per_use = 25
	/// Color hex applied to the central core overlay and player outlines
	var/pylon_color
	/// Whether this pylon can currently be topped up by a replenishment miracle. Resets when infusion changes.
	var/can_recharge = TRUE

/obj/structure/dream_pylon/get_mechanics_examine(mob/user)
	. = ..()
	. += span_info("Dream pylons with a floating ball of dream energies can be interacted with to receive a buff.")
	. += span_info("Buffs from pylons rapidly decay when out of their range, the pylon will glow red when out of range.")
	. += span_info("You can only benefit from one pylon at a time.")
	. += span_info("You can interact with a pylon to return a buff prematurely.")
	. += span_info("Inserting a new dream seed will fully recharge a pylon.")
	. += span_info("Pylons with the same infusion type can support said infusion if you step out of range of one, and into another.")

/obj/structure/dream_pylon/Initialize(mapload)
	. = ..()
	update_pylon_appearance()

/obj/structure/dream_pylon/Destroy()
	if(active_overlay)
		qdel(active_overlay)
		active_overlay = null
	return ..()

/obj/structure/dream_pylon/proc/update_pylon_appearance()
	if(charge < charge_cost_per_use)
		set_pylon_overlay(null, null)
	else
		var/chosen_state = pylon_color ? "ball_grey" : "ball"
		set_pylon_overlay('modular_abel/dun_world/abyssor/icons/abyssor_pylon.dmi', chosen_state)

/obj/structure/dream_pylon/examine(mob/user)
	. = ..()
	if(charge <= 0 || !infusion_payload)
		. += span_warning("Its central core looks completely hollowed out, awaiting an infusion.")
	else
		var/amount_of_charges = floor(charge / charge_cost_per_use)
		var/infusion_name = initial(infusion_payload.id)
		var/message = (amount_of_charges > 0) ? amount_of_charges : "No"
		. += span_notice("It is imbued with the essence of <b>[infusion_name]</b>. It appears to have <b>[message]</b> uses left.")

/obj/structure/dream_pylon/proc/set_pylon_overlay(new_icon, new_icon_state)
	if(active_overlay)
		cut_overlay(active_overlay)
		qdel(active_overlay)
		active_overlay = null

	if(!new_icon || !new_icon_state)
		return

	var/obj/effect/pylon_overlay/O = new(src)
	O.icon = new_icon
	O.icon_state = new_icon_state
	if(pylon_color)
		O.color = pylon_color
	active_overlay = O
	add_overlay(active_overlay)

/obj/effect/pylon_overlay
	name = "ball"
	desc = "A spooky abyssal ball, pondering its own orb."
	mouse_opacity = MOUSE_OPACITY_TRANSPARENT
	layer = ABOVE_OBJ_LAYER

/obj/structure/dream_pylon/interact(mob/living/user)
	if(!istype(user) || user.stat != CONSCIOUS)
		return

	var/datum/status_effect/infusion/existing_effect
	for(var/datum/status_effect/infusion/I in user.status_effects)
		existing_effect = I
		break

	if(existing_effect)
		var/obj/structure/dream_pylon/target_pylon = existing_effect.pylon_ref?.resolve()
		if(target_pylon == src && existing_effect.type == infusion_payload)
			visible_message(span_notice("[user] touches [src], rendering their active infusion back into the structure."))
			existing_effect.refund_charge()
			return
		to_chat(user, span_warning("You are already attuned to a pylon's infusion! Clear your mind first."))
		return

	if(charge < charge_cost_per_use)
		to_chat(user, span_warning("The pylon doesn't have enough residual charge left to manifest an infusion."))
		return

	charge = max(0, charge - charge_cost_per_use)
	user.apply_status_effect(infusion_payload, src)
	visible_message(span_purple("[user] absorbs a pulsing splash of paint from [src]!"))
	update_pylon_appearance()

/obj/structure/dream_pylon/attackby(obj/item/I, mob/user, params)
	if(istype(I, /obj/item/dream_material/dream_seed))
		if(!do_after(user, 1 SECONDS))
			to_chat(user, span_warning("I was interrupted!"))
			return
		var/obj/item/dream_material/dream_seed/seed = I
		seed.apply_to_pylon(src, user)
		return TRUE

	return ..()

/obj/structure/dream_pylon/proc/set_infusion(datum/status_effect/infusion/new_infusion, new_max_charge, new_charge, new_color)
	infusion_payload = new_infusion
	max_charge = new_max_charge
	charge = new_charge
	pylon_color = new_color
	can_recharge = TRUE
	update_pylon_appearance()

/datum/status_effect/infusion
	id = "Pylon Infusion"
	duration = 20 MINUTES
	tick_interval = 2 SECONDS
	status_type = STATUS_EFFECT_UNIQUE

	/// Weak reference back to the original source pylon
	var/datum/weakref/pylon_ref
	/// The tether bounding parameters
	var/max_range = 5
	/// Tracking variable to ensure warning alerts only dispatch once when breaking boundary lines
	var/out_of_range = FALSE
	/// The decay multiplier when out of range (10x = 20 minutes compresses to 2 minutes)
	var/decay_multiplier = 10
	/// The last tick time we processed (to handle variable tick intervals)
	var/last_tick_time = 0
	/// The total "effective" time consumed (accounting for acceleration)
	var/total_effective_consumed = 0
	/// The original duration (stored for ratio calculations)
	var/original_duration = 20 MINUTES
	var/image/pylon_outline

/datum/status_effect/infusion/on_creation(mob/living/new_owner, obj/structure/dream_pylon/source_pylon)
	if(source_pylon)
		pylon_ref = WEAKREF(source_pylon)
	last_tick_time = world.time
	original_duration = initial(duration)
	. = ..()
	if(owner && source_pylon)
		var/outline_color = source_pylon.pylon_color ? source_pylon.pylon_color : "#7A288A"
		update_pylon_outline(source_pylon, outline_color)

/datum/status_effect/infusion/Destroy()
	if(pylon_outline)
		if(owner?.client)
			owner.client.images -= pylon_outline
		qdel(pylon_outline)
		pylon_outline = null
	return ..()

/datum/status_effect/infusion/tick(wait)
	var/obj/structure/dream_pylon/P = pylon_ref?.resolve()

	if(!P || QDELETED(P))
		to_chat(owner, span_userdanger("You feel your link sever as the source pylon is completely destroyed!"))
		qdel(src)
		return

	var/distance = get_dist(owner, P)
	var/is_mismatched = (P.infusion_payload != type)
	var/is_far = (distance > max_range)

	var/time_passed = world.time - last_tick_time
	last_tick_time = world.time

	var/effective_time_consumed = time_passed

	if(is_mismatched || is_far)
		if(!out_of_range)
			var/obj/structure/dream_pylon/new_pylon
			for(var/obj/structure/dream_pylon/nearby_pylon in range(max_range, owner))
				if(nearby_pylon == P || QDELETED(nearby_pylon))
					continue
				if(nearby_pylon.infusion_payload == type)
					new_pylon = nearby_pylon
					break

			if(new_pylon)
				pylon_ref = WEAKREF(new_pylon)

				if(pylon_outline)
					if(owner?.client)
						owner.client.images -= pylon_outline
					qdel(pylon_outline)
					pylon_outline = null

				var/new_color = new_pylon.pylon_color ? new_pylon.pylon_color : "#7A288A"
				update_pylon_outline(new_pylon, new_color)

				if(prob(50))
					to_chat(owner, span_notice("Your infusion latches onto a nearby matching pylon!"))

				total_effective_consumed += effective_time_consumed
				return
			out_of_range = TRUE
			if(is_mismatched)
				to_chat(owner, span_warning("The source pylon's essence no longer matches your infusion! Your link begins decaying rapidly."))
			else
				to_chat(owner, span_warning("You have wandered too far from the pylon! Your infusion begins decaying rapidly."))
			update_pylon_outline(P, COLOR_RED)
		effective_time_consumed = time_passed * decay_multiplier
		duration -= time_passed * (decay_multiplier - 1)

	else if(out_of_range && !is_mismatched)
		out_of_range = FALSE
		to_chat(owner, span_notice("You have stepped back into range of the pylon. Your infusion stabilizes."))
		var/outline_color = P.pylon_color ? P.pylon_color : "#7A288A"
		update_pylon_outline(P, outline_color)

	total_effective_consumed += effective_time_consumed

/datum/status_effect/infusion/proc/refund_charge()
	var/obj/structure/dream_pylon/P = pylon_ref?.resolve()
	if(!P || QDELETED(P))
		qdel(src)
		return

	var/ratio_consumed = total_effective_consumed / original_duration
	var/ratio_remaining = max(0, 1 - ratio_consumed)

	var/charge_to_restore = round(P.charge_cost_per_use * ratio_remaining)
	P.charge = min(P.max_charge, P.charge + charge_to_restore)

	to_chat(owner, span_notice("You touch the edge of the pylon, letting the paint ooze back into the ball. [charge_to_restore] energy points flow back to the pylon."))
	P.update_pylon_appearance()
	qdel(src)

/datum/status_effect/infusion/proc/update_pylon_outline(obj/structure/dream_pylon/P, new_color)
	if(!owner?.client || !P)
		return
	var/alpha_hex = "80"
	var/final_color = new_color
	if(length(new_color) == 7 && copytext(new_color, 1, 2) == "#")
		final_color = "[new_color][alpha_hex]"

	if(pylon_outline)
		pylon_outline.filters = null
		pylon_outline.filters += filter(type = "outline", size = 1, color = final_color)
	else
		var/image/I = image(icon = P.icon, loc = P, icon_state = P.icon_state, layer = P.layer + 0.05)

		if(P.active_overlay)
			I.overlays += image(icon = P.active_overlay.icon, icon_state = P.active_overlay.icon_state)

		I.filters += filter(type = "outline", size = 1, color = final_color)

		pylon_outline = I
		owner.client.images += pylon_outline

/datum/status_effect/infusion/intelligence
	id = "Intelligence Infusion"
	alert_type = /atom/movable/screen/alert/status_effect/buff/intelligence_infusion
	effectedstats = list(STAT_INTELLIGENCE = 2)
	examine_text = "SUBJECTPRONOUN looks surrounded by a shimmering, thoughtful aura of dark paint."

/atom/movable/screen/alert/status_effect/buff/intelligence_infusion
	name = "Intelligence Infusion"
	desc = "Abyssor's dream is vivid in my mind, improving my ability to imagine all sorts of new possibilities."

/datum/status_effect/infusion/perception
	id = "Perception Infusion"
	alert_type = /atom/movable/screen/alert/status_effect/buff/perception_infusion
	effectedstats = list(STAT_PERCEPTION = 2)
	examine_text = "SUBJECTPRONOUN looks surrounded by a shimmering, perception-sharpening aura of dark paint."

/atom/movable/screen/alert/status_effect/buff/perception_infusion
	name = "Perception Infusion"
	desc = "Abyssor's dream is vivid in my mind, shapes of paint outline objects and people in the distance, making them clearer."

/datum/status_effect/infusion/fortune
	id = "Fortuitous Infusion"
	alert_type = /atom/movable/screen/alert/status_effect/buff/fortune_infusion
	effectedstats = list(STAT_FORTUNE = 3)
	examine_text = "SUBJECTPRONOUN looks surrounded by a shimmering, luck-inducing aura of dark paint."

/atom/movable/screen/alert/status_effect/buff/fortune_infusion
	name = "Fortuitous Infusion"
	desc = "Abyssor's dream is vivid in my mind, paint sinking out in nearby waters to draw forth the rarest fish."

/datum/status_effect/infusion/strength
	id = "Strength Infusion"
	alert_type = /atom/movable/screen/alert/status_effect/buff/strength_infusion
	effectedstats = list(STAT_STRENGTH = 1)
	decay_multiplier = 40
	examine_text = "SUBJECTPRONOUN looks surrounded by a shimmering, muscle-fostering aura of dark paint."

/atom/movable/screen/alert/status_effect/buff/strength_infusion
	name = "Strength Infusion"
	desc = "Abyssor's dream is vivid in my mind, my mind flooded with imagery of myself lifting heavy objects and people."

/datum/status_effect/infusion/speed
	id = "Speed Infusion"
	alert_type = /atom/movable/screen/alert/status_effect/buff/speed_infusion
	effectedstats = list(STAT_SPEED = 1)
	decay_multiplier = 40
	examine_text = "SUBJECTPRONOUN looks surrounded by a shimmering, speeding aura of dark paint."

/atom/movable/screen/alert/status_effect/buff/speed_infusion
	name = "Speed Infusion"
	desc = "Abyssor's dream is vivid in my mind, my mind flooded with imagery of hares outspeeding turtles."

/datum/status_effect/infusion/ambush_trait
	id = "Sneaky Infusion"
	alert_type = /atom/movable/screen/alert/status_effect/buff/sneak_infusion
	effectedstats = list()
	examine_text = "SUBJECTPRONOUN looks surrounded by a shimmering, obscuring aura of dark paint."

/datum/status_effect/infusion/ambush_trait/on_apply()
	. = ..()
	ADD_TRAIT(owner, TRAIT_MANEATER_IMMUNITY, TRAIT_INFUSION)
	ADD_TRAIT(owner, TRAIT_FLOWERFIELD_IMMUNITY, TRAIT_INFUSION)

/datum/status_effect/infusion/ambush_trait/on_remove()
	. = ..()
	REMOVE_TRAIT(owner, TRAIT_MANEATER_IMMUNITY, TRAIT_INFUSION)
	REMOVE_TRAIT(owner, TRAIT_FLOWERFIELD_IMMUNITY, TRAIT_INFUSION)

/atom/movable/screen/alert/status_effect/buff/sneak_infusion
	name = "Sneaky Infusion"
	desc = "Abyssor's dream is vivid in my mind, showing hints of rustling bushes and maneaters."
