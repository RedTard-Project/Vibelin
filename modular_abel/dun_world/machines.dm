/obj/machinery/anvil/bronze
	name = "bronze anvil"
	desc = "Elevating humenity from its primordial stupor since the earliest daes of Psydonia."
	icon = 'modular_abel/dun_world/icons/forge.dmi'
	icon_state = "broanvil"
	max_integrity = 1600

#define SMOKE_COOKING_TIME_MULTIPLIER 3
#define SMOKER_EXP_PER_ITEM 0.5

/obj/machinery/light/fueled/smoker
	name = "smoker"
	desc = "An adorable wooden smoker meant for curing meats with wood fire. No, this isn't where gnomes live."
	icon = 'modular_abel/dun_world/icons/smoker.dmi'
	icon_state = "smoker"
	base_state = "smoker"
	density = TRUE
	on = FALSE
	fueluse = 0
	crossfire = FALSE
	var/maxfood = 6
	var/door_open = FALSE
	var/has_log = FALSE
	var/lit = FALSE
	var/datum/weakref/lastuser_ref
	var/current_cook_progress = 0
	var/target_cook_time = 0

/obj/machinery/light/fueled/smoker/wheeled
	name = "wheeled smoker"
	desc = "An adorable wooden smoker meant for curing meats with wood fire. This one has wheels so you can move it around."
	anchored = FALSE
	icon_state = "w_smoker"
	base_state = "w_smoker"

/obj/machinery/light/fueled/smoker/Initialize()
	. = ..()
	seton(FALSE)
	on = FALSE
	GLOB.fires_list -= src
	update_appearance()

/obj/machinery/light/fueled/smoker/update(trigger = TRUE)
	return

/obj/machinery/light/fueled/smoker/Crossed(atom/movable/AM, oldLoc)
	return

/obj/machinery/light/fueled/smoker/fire_act(added, maxstacks)
	if(!door_open || !has_log || lit)
		return FALSE
	lit = TRUE
	update_appearance()
	visible_message(span_notice("The fuel inside [src] catches fire!"))
	return ..()

/obj/machinery/light/fueled/smoker/get_mechanics_examine(mob/user)
	. = ..()
	. += span_info("Left-clicking inside the <b>door opening</b> interacts with the interior contents.")
	. += span_info("Left-clicking <b>outside the door opening</b> will shut the door when open.")
	. += span_info("Once lit and shut, it will smoke all items inside over time, consuming the log only when finished.")
	. += span_info("Can only be fueled with a small log.")

/obj/machinery/light/fueled/smoker/update_icon_state()
	. = ..()
	if(on && !door_open)
		icon_state = "[base_state]_smoking"
	else if(door_open)
		if(lit)
			icon_state = "[base_state]_burn"
		else if(has_log)
			icon_state = "[base_state]_fuel"
		else
			icon_state = "[base_state]_open"
	else
		icon_state = "[base_state]"

/obj/machinery/light/fueled/smoker/update_overlays()
	. = ..()
	if(!door_open)
		return
	var/index = 0
	for(var/obj/item/I in contents)
		I.pixel_x = 0
		I.pixel_y = 0
		var/mutable_appearance/food_overlay = new /mutable_appearance(I)
		food_overlay.transform *= 0.35
		food_overlay.pixel_x = -2 + index
		food_overlay.pixel_y = -2
		food_overlay.layer = FLOAT_LAYER
		. += food_overlay
		index++

/obj/machinery/light/fueled/smoker/proc/recalculate_cook_time()
	var/total_required = 0
	var/valid_items = 0
	for(var/obj/item/reagent_containers/food/snacks/S in contents)
		if(!S.smoked_type)
			continue
		total_required += S.cooktime ? S.cooktime : 100
		valid_items++
	if(!valid_items)
		target_cook_time = 0
		return
	target_cook_time = round((total_required / valid_items) * SMOKE_COOKING_TIME_MULTIPLIER)

/obj/machinery/light/fueled/smoker/proc/clicked_interior(list/modifiers)
	var/click_x = text2num(LAZYACCESS(modifiers, ICON_X))
	var/click_y = text2num(LAZYACCESS(modifiers, ICON_Y))
	if(isnull(click_x) || isnull(click_y))
		return FALSE
	return (click_x >= 13 && click_x <= 20 && click_y >= 6 && click_y <= 17)

/obj/machinery/light/fueled/smoker/proc/shut_door(mob/user)
	door_open = FALSE
	if(lit && has_log && contents.len)
		on = TRUE
		START_PROCESSING(SSmachines, src)
	user.visible_message(span_notice("[user] shuts [src]."))
	update_appearance()

/obj/machinery/light/fueled/smoker/proc/open_door(mob/user)
	door_open = TRUE
	on = FALSE
	STOP_PROCESSING(SSmachines, src)
	user.visible_message(span_notice("[user] opens the door to [src]."))
	update_appearance()

/obj/machinery/light/fueled/smoker/attackby(obj/item/W, mob/user, list/modifiers)
	lastuser_ref = WEAKREF(user)
	if(!clicked_interior(modifiers))
		if(door_open)
			shut_door(user)
			return
		if(user.cmode)
			return ..()
		return
	if(!door_open)
		open_door(user)
		return
	if(istype(W, /obj/item/grown/log/tree/small))
		if(has_log)
			to_chat(user, span_warning("[src] already has a log inside!"))
			return
		if(!user.transferItemToLoc(W, src))
			return
		has_log = TRUE
		qdel(W)
		to_chat(user, span_notice("You place a log inside [src]."))
		update_appearance()
		return
	if(W.get_temperature())
		if(!has_log)
			to_chat(user, span_warning("There is no fuel in [src] to light!"))
			return
		if(lit)
			to_chat(user, span_warning("[src] is already lit!"))
			return
		lit = TRUE
		user.visible_message(span_notice("[user] lights the log in [src]."))
		update_appearance()
		return
	if(!istype(W, /obj/item/reagent_containers/food/snacks) || HAS_TRAIT(W, TRAIT_NODROP))
		if(user.cmode)
			return ..()
		return
	if(contents.len >= maxfood)
		to_chat(user, span_warning("[src] is already full!"))
		return
	if(!user.transferItemToLoc(W, src))
		return
	recalculate_cook_time()
	playsound(get_turf(src), 'sound/items/wood_sharpen.ogg', 50)
	user.visible_message(span_warning("[user] hangs [W] inside [src]."))
	update_appearance()

/obj/machinery/light/fueled/smoker/attack_hand(mob/user, list/modifiers)
	lastuser_ref = WEAKREF(user)
	if(!clicked_interior(modifiers))
		if(!door_open)
			return ..()
		shut_door(user)
		return
	if(!door_open)
		open_door(user)
		return
	if(!contents.len)
		return
	var/obj/item/I = contents[contents.len]
	I.forceMove(get_turf(user))
	user.put_in_active_hand(I)
	recalculate_cook_time()
	update_appearance()

/obj/machinery/light/fueled/smoker/process()
	if(!on || door_open || !lit || !has_log || !contents.len)
		return
	var/mob/living/carbon/human/lastuser = lastuser_ref?.resolve()
	var/skill_bonus = 0
	if(istype(lastuser))
		skill_bonus = GET_MOB_SKILL_VALUE_OLD(lastuser, /datum/attribute/skill/craft/cooking) * 2
	current_cook_progress += (10 + skill_bonus)
	if(target_cook_time > 0 && current_cook_progress >= target_cook_time)
		finish_batch()

/obj/machinery/light/fueled/smoker/proc/finish_batch()
	var/items_transformed = 0
	for(var/obj/item/reagent_containers/food/snacks/S in contents)
		if(!S.smoked_type)
			continue
		var/obj/item/reagent_containers/food/snacks/result = new S.smoked_type(src)
		if(S.reagents && result.reagents)
			S.reagents.trans_to(result, S.reagents.total_volume)
		qdel(S)
		items_transformed++
	visible_message(span_notice("A rich, smoky aroma drifts out from [src]!"))
	var/mob/living/carbon/human/lastuser = lastuser_ref?.resolve()
	if(items_transformed && istype(lastuser) && lastuser.mind)
		lastuser.mind.add_sleep_experience(/datum/attribute/skill/craft/cooking, GET_MOB_ATTRIBUTE_VALUE(lastuser, STAT_INTELLIGENCE) * (items_transformed * SMOKER_EXP_PER_ITEM))
	has_log = FALSE
	lit = FALSE
	on = FALSE
	STOP_PROCESSING(SSmachines, src)
	current_cook_progress = 0
	target_cook_time = 0
	update_appearance()

/obj/machinery/light/fueled/smoker/Destroy()
	STOP_PROCESSING(SSmachines, src)
	var/turf/T = get_turf(src)
	if(T)
		for(var/obj/item/I in contents)
			I.forceMove(T)
	lastuser_ref = null
	return ..()

#undef SMOKER_EXP_PER_ITEM
#undef SMOKE_COOKING_TIME_MULTIPLIER
