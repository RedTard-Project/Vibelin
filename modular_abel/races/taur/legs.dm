/obj/item/bodypart/taur/on_adding(mob/living/carbon/new_owner)
	. = ..()
	if(!ishuman(new_owner))
		return
	var/mob/living/carbon/human/human_owner = new_owner
	human_owner.on_taur_limb_added(bodypart_disabled)

/obj/item/bodypart/taur/on_removal(mob/living/carbon/old_owner)
	. = ..()
	if(!ishuman(old_owner))
		return
	var/mob/living/carbon/human/human_owner = old_owner
	human_owner.on_taur_limb_removed(bodypart_disabled)

/mob/living/carbon/human/proc/on_taur_limb_added(limb_disabled)
	set_num_legs(num_legs + 2)
	if(!limb_disabled)
		set_usable_legs(usable_legs + 2)
	AddElement(/datum/element/ridable, /datum/component/riding/creature/taur)
	RegisterSignal(src, COMSIG_MOVABLE_PREBUCKLE, PROC_REF(taur_consent_prebuckle), override = TRUE)
	add_verb(src, /mob/living/carbon/human/verb/toggle_taur_riding)

/mob/living/carbon/human/proc/on_taur_limb_removed(limb_disabled)
	set_num_legs(num_legs - 2)
	if(!limb_disabled)
		set_usable_legs(usable_legs - 2)
	if(has_buckled_mobs())
		unbuckle_all_mobs()
	RemoveElement(/datum/element/ridable, /datum/component/riding/creature/taur)
	UnregisterSignal(src, COMSIG_MOVABLE_PREBUCKLE)
	remove_verb(src, /mob/living/carbon/human/verb/toggle_taur_riding)
