/datum/bodypart_feature/smallclothes/get_bodypart_overlay(obj/item/bodypart/bodypart)
	if(!accessory_type || bodypart.skeletonized)
		return
	var/mob/living/carbon/human/human = bodypart.owner
	if(!human)
		human = bodypart.original_owner
	if(!istype(human))
		return
	var/datum/sprite_accessory/accessory = SPRITE_ACCESSORY(accessory_type)
	var/list/appearances = accessory.get_appearance(null, bodypart, accessory_colors)
	if(!appearances)
		return
	var/extra_state
	if(accessory.smallclothes_covers_torso && accessory.smallclothes_torso_is_visible(human))
		extra_state = accessory.smallclothes_extra_state(human)
	if(extra_state)
		var/list/extra_appearances = accessory.get_overlay(
			extra_state,
			accessory_colors,
			dummy_block = istype(human, /mob/living/carbon/human/dummy),
			icon_file = accessory.icon,
		)
		accessory.adjust_appearance_list(extra_appearances, null, bodypart, human)
		appearances += extra_appearances
	return appearances

/datum/species/handle_body(mob/living/carbon/human/human)
	if(!human.uses_smallclothes_features && !human.get_bodypart_feature_of_slot("smallclothes_bottom"))
		return ..()
	var/saved_underwear = human.underwear
	human.underwear = null
	. = ..()
	human.underwear = saved_underwear
