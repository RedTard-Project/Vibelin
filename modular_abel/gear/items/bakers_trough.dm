/obj/structure/bakers_trough
	name = "baker's trough"
	desc = "A large wooden trough, used by professional bakers to work large quantities of dough at once. One ball of dough at a time will not do when you have a village to feed."
	icon = 'modular_abel/gear/icons/structures/bakers_trough.dmi'
	icon_state = "through_empty"
	density = TRUE
	anchored = TRUE
	layer = TABLE_LAYER
	climbable = TRUE
	climb_offset = 10
	pass_flags = LETPASSTHROW
	pass_flags_self = PASSTABLE|LETPASSTHROW
	resistance_flags = FLAMMABLE
	max_integrity = 70
	integrity_failure = 0.33
	blade_dulling = DULLING_BASHCHOP
	destroy_sound = 'sound/combat/hits/onwood/destroyfurniture.ogg'
	attacked_sound = list('sound/combat/hits/onwood/woodimpact (1).ogg', 'sound/combat/hits/onwood/woodimpact (2).ogg')
	var/flour_amount = 0
	var/water_amount = 0
	var/dough_amount = 0
	var/max_flour = 40
	var/max_water = 200
	var/flour_per_dough = 2
	var/water_per_dough = 10
	var/busy = FALSE

/obj/structure/bakers_trough/Initialize()
	. = ..()
	update_appearance(UPDATE_OVERLAYS)

/obj/structure/bakers_trough/examine(mob/user)
	. = ..()
	if(!flour_amount && !water_amount && !dough_amount)
		. += span_notice("It is empty.")
		return

	if(flour_amount || water_amount)
		. += span_notice("It holds [flour_amount] handful[flour_amount == 1 ? "" : "s"] of flour and [water_amount] dram[water_amount == 1 ? "" : "s"] of water.")
		var/water_needed = water_needed_for_flour()
		if(water_amount < water_needed)
			var/water_short = water_needed - water_amount
			. += span_warning("The flour is too dry to work into dough.")
			. += span_notice("It needs [water_short] more dram[water_short == 1 ? "" : "s"] of water.")
	if(dough_amount)
		. += span_notice("There [dough_amount == 1 ? "is" : "are"] [dough_amount] finished dough[dough_amount == 1 ? "" : "s"] ready to be turned out.")

/obj/structure/bakers_trough/get_mechanics_examine(mob/user)
	. = ..()
	. += span_info("Use flour and a container of water on it to fill it, then click it with an empty hand to knead.")
	. += span_info("Right-click it to turn out its contents.")

/obj/structure/bakers_trough/update_overlays()
	. = ..()
	if(dough_amount > 0)
		. += mutable_appearance(icon, "dough")
	else if(flour_amount > 0 && water_amount >= water_per_dough)
		. += mutable_appearance(icon, "wet_flour")
	else if(flour_amount > 0)
		. += mutable_appearance(icon, "flour")

/obj/structure/bakers_trough/item_interaction(mob/living/user, obj/item/tool, list/modifiers)
	if(user.cmode)
		return NONE

	if(busy)
		to_chat(user, span_warning("[src] is already being worked."))
		return ITEM_INTERACT_BLOCKING

	if(istype(tool, /obj/item/reagent_containers/powder/flour))
		return add_flour(tool, user)

	if(istype(tool, /obj/item/storage/sack))
		return add_flour_from_sack(tool, user)

	if(istype(tool, /obj/item/reagent_containers))
		var/obj/item/reagent_containers/container = tool
		if(container.reagents?.has_reagent(/datum/reagent/water, 1))
			return add_water(container, user)

	return NONE

/obj/structure/bakers_trough/attack_hand(mob/living/user)
	. = ..()
	if(.)
		return

	if(busy)
		to_chat(user, span_warning("[src] is already being worked."))
		return TRUE

	var/dough_to_make = available_dough_count()
	if(dough_to_make <= 0)
		to_chat(user, span_warning("[src] needs at least [flour_per_dough] flour and [water_per_dough] drams of water to knead."))
		return TRUE

	to_chat(user, span_notice("I start kneading the dough in [src]."))
	playsound(src, 'sound/foley/kneading_alt.ogg', 90, TRUE, -1)
	busy = TRUE
	if(!do_after(user, get_knead_time(user, dough_to_make), src))
		busy = FALSE
		to_chat(user, span_warning("I stop kneading the dough in [src]."))
		return TRUE

	busy = FALSE
	dough_to_make = available_dough_count()
	if(dough_to_make <= 0)
		return TRUE

	flour_amount -= dough_to_make * flour_per_dough
	water_amount -= dough_to_make * water_per_dough
	dough_amount += dough_to_make
	user.mind?.add_sleep_experience(/datum/attribute/skill/craft/cooking/baking, (GET_MOB_ATTRIBUTE_VALUE(user, STAT_INTELLIGENCE) * 0.5) * dough_to_make)
	user.nobles_seen_servant_work()
	user.visible_message(span_notice("[user] finishes kneading dough in [src]."), span_notice("I finish kneading the dough in [src]."))
	update_appearance(UPDATE_OVERLAYS)
	return TRUE

/obj/structure/bakers_trough/attack_hand_secondary(mob/user, list/modifiers)
	. = ..()
	if(. == SECONDARY_ATTACK_CANCEL_ATTACK_CHAIN)
		return

	if(user.cmode)
		return SECONDARY_ATTACK_CALL_NORMAL

	if(busy)
		to_chat(user, span_warning("[src] is already being worked."))
		return SECONDARY_ATTACK_CANCEL_ATTACK_CHAIN

	if(!flour_amount && !water_amount && !dough_amount)
		to_chat(user, span_warning("[src] is already empty."))
		return SECONDARY_ATTACK_CANCEL_ATTACK_CHAIN

	var/turning_out_dough = dough_amount > 0
	if(turning_out_dough)
		user.visible_message(span_notice("[user] starts turning dough out of [src]."), span_notice("I start turning the dough out of [src]."))
		playsound(src, 'sound/foley/kneading.ogg', 100, TRUE, -1)
	else
		user.visible_message(span_notice("[user] starts emptying [src]."), span_notice("I start emptying [src]."))

	busy = TRUE
	if(!do_after(user, 3 SECONDS, src))
		busy = FALSE
		to_chat(user, span_warning("I stop emptying [src]."))
		return SECONDARY_ATTACK_CANCEL_ATTACK_CHAIN

	busy = FALSE
	empty_trough()
	to_chat(user, span_notice("I finish emptying [src]."))
	return SECONDARY_ATTACK_CANCEL_ATTACK_CHAIN

/obj/structure/bakers_trough/proc/add_flour(obj/item/reagent_containers/powder/flour/added_flour, mob/living/user)
	if(flour_space_left() <= 0)
		to_chat(user, span_warning("[src] can't hold any more flour."))
		return ITEM_INTERACT_BLOCKING

	var/needed_water = added_flour.water_added ? water_per_dough : 0
	if(needed_water && water_space_left() < needed_water)
		to_chat(user, span_warning("[src] can't hold any more water."))
		return ITEM_INTERACT_BLOCKING

	flour_amount++
	water_amount += needed_water
	qdel(added_flour)
	to_chat(user, span_notice("I add the [needed_water ? "wet " : ""]flour to [src]."))
	update_appearance(UPDATE_OVERLAYS)
	return ITEM_INTERACT_SUCCESS

/obj/structure/bakers_trough/proc/add_flour_from_sack(obj/item/storage/sack/sack, mob/living/user)
	var/datum/component/storage/storage = sack.GetComponent(/datum/component/storage)
	if(!storage)
		return NONE

	var/added = 0
	for(var/obj/item/reagent_containers/powder/flour/stored_flour in storage.contents())
		if(flour_space_left() <= 0)
			break
		if(stored_flour.water_added && water_space_left() < water_per_dough)
			break
		storage.remove_from_storage(stored_flour, get_turf(src))
		flour_amount++
		if(stored_flour.water_added)
			water_amount += water_per_dough
		added++
		qdel(stored_flour)

	if(!added)
		to_chat(user, span_warning("[src] can't hold any more flour."))
		return ITEM_INTERACT_BLOCKING

	user.visible_message(span_notice("[user] dumps flour into [src]."), span_notice("I dump [added] handful[added == 1 ? "" : "s"] of flour into [src]."))
	update_appearance(UPDATE_OVERLAYS)
	return ITEM_INTERACT_SUCCESS

/obj/structure/bakers_trough/proc/add_water(obj/item/reagent_containers/container, mob/living/user)
	var/space_left = water_space_left()
	if(space_left <= 0)
		to_chat(user, span_warning("[src] can't hold any more water."))
		return ITEM_INTERACT_BLOCKING

	var/water_to_add = min(space_left, container.reagents.get_reagent_amount(/datum/reagent/water))
	if(water_to_add <= 0)
		return NONE

	container.reagents.remove_reagent(/datum/reagent/water, water_to_add)
	water_amount += water_to_add
	playsound(src, 'sound/foley/splishy.ogg', 100, TRUE, -1)
	if(flour_amount)
		to_chat(user, span_notice("I wet the flour in [src]."))
	else
		to_chat(user, span_notice("I add [water_to_add] dram[water_to_add == 1 ? "" : "s"] of water to [src]."))
	update_appearance(UPDATE_OVERLAYS)
	return ITEM_INTERACT_SUCCESS

/obj/structure/bakers_trough/proc/empty_trough()
	var/turf/drop_turf = get_turf(src)
	for(var/i in 1 to dough_amount)
		new /obj/item/reagent_containers/food/snacks/dough_base(drop_turf)

	var/wet_flour_amount = min(flour_amount, round(water_amount / water_per_dough))
	for(var/i in 1 to wet_flour_amount)
		var/obj/item/reagent_containers/powder/flour/wet_flour = new(drop_turf)
		wet_flour.name = "wet flour"
		wet_flour.desc = "Destined for greatness, at your hands."
		wet_flour.water_added = TRUE
		wet_flour.color = "#d9d0cb"

	for(var/i in 1 to (flour_amount - wet_flour_amount))
		new /obj/item/reagent_containers/powder/flour(drop_turf)

	flour_amount = 0
	water_amount = 0
	dough_amount = 0
	update_appearance(UPDATE_OVERLAYS)

/obj/structure/bakers_trough/proc/available_dough_count()
	return min(round(flour_amount / flour_per_dough), round(water_amount / water_per_dough), round((max_flour / flour_per_dough) - dough_amount))

/obj/structure/bakers_trough/proc/water_needed_for_flour()
	return round(flour_amount / flour_per_dough) * water_per_dough

/obj/structure/bakers_trough/proc/flour_space_left()
	return max(0, max_flour - flour_amount - (dough_amount * flour_per_dough))

/obj/structure/bakers_trough/proc/water_space_left()
	return max(0, max_water - water_amount - (dough_amount * water_per_dough))

/obj/structure/bakers_trough/proc/get_knead_time(mob/living/user, dough_to_make)
	return max(10, 40 - (GET_MOB_SKILL_VALUE_OLD(user, /datum/attribute/skill/craft/cooking) * 5)) * dough_to_make
