/obj/item/enchantingkit
	name = "morphing elixir"
	desc = "A small container of special morphing dust, perfect to make a specific item."
	icon = 'modular_abel/gear/icons/items.dmi'
	icon_state = "enchanting_kit"
	w_class = WEIGHT_CLASS_SMALL
	/// Assoc list of target typepath to the typepath it morphs into. Ordered most specific first.
	var/list/target_items = list()
	/// Fallback result when a matched entry maps to null.
	var/result_item = null
	/// TRUE matches only the exact typepaths in target_items, so subtypes are left alone.
	var/exact_type = FALSE

/obj/item/enchantingkit/proc/matched_target_type(obj/item/target)
	for(var/candidate_type in target_items)
		if(exact_type)
			if(target.type == candidate_type)
				return candidate_type
		else if(istype(target, candidate_type))
			return candidate_type
	return null

/obj/item/enchantingkit/proc/morph_result_for(obj/item/target)
	var/matched_type = matched_target_type(target)
	if(!matched_type)
		return null
	return target_items[matched_type] || result_item

/obj/item/enchantingkit/pre_attack(obj/item/target, mob/user)
	if(!target || !user)
		return ..()
	if(!matched_target_type(target))
		return ..()
	var/result_type = morph_result_for(target)
	if(!result_type)
		to_chat(user, span_warning("[src] doesn't know how to morph [target]."))
		return TRUE
	var/turf/drop_location = get_turf(user) || get_turf(target)
	if(!drop_location)
		to_chat(user, span_warning("Nowhere to morph [target]."))
		return TRUE
	if(target.loc == user)
		user.temporarilyRemoveItemFromInventory(target, TRUE)
	var/obj/item/morphed = new result_type(drop_location)
	to_chat(user, span_notice("You apply [src] to [target], using the enchanting dust and tools to turn it into [morphed]."))
	morphed.name += " <font size = 1>([target.name])</font>"
	qdel(target)
	if(!user.put_in_hands(morphed))
		morphed.forceMove(drop_location)
	user.update_body()
	qdel(src)
	return TRUE

/obj/item/enchantingkit/get_mechanics_examine(mob/user)
	. = ..()
	. += span_info("Left-clicking the appropriate item with this elixir will gift it a unique appearance.")

/obj/item/enchantingkit/weapon
	abstract_type = /obj/item/enchantingkit/weapon

/obj/item/enchantingkit/weapon/pre_attack(obj/item/target, mob/user)
	if(!target || !user)
		return ..()
	if(!matched_target_type(target))
		return ..()
	var/obj/item/weapon/result_type = morph_result_for(target)
	if(!result_type)
		to_chat(user, span_warning("[src] doesn't know how to morph [target]."))
		return TRUE
	target.icon = initial(result_type.icon)
	target.icon_state = initial(result_type.icon_state)
	target.item_state = initial(result_type.item_state)
	target.lefthand_file = initial(result_type.lefthand_file)
	target.righthand_file = initial(result_type.righthand_file)
	to_chat(user, span_notice("You apply [src] to [target], using the enchanting dust and tools to turn it into [initial(result_type.name)]."))
	target.name = "[initial(result_type.name)] <font size = 1>([target.name])</font>"
	target.desc = initial(result_type.desc)
	target.update_icon()
	user.update_body()
	qdel(src)
	return TRUE
