// Taur limb attach/detach behaviour.
//
// This used to override /mob/living/carbon/human/add_bodypart and remove_bodypart, but
// upstream marks both SHOULD_NOT_OVERRIDE(TRUE) and dreamchecker rejects the build for it.
// The sanctioned hooks are the bodypart's own on_adding/on_removal, which add_bodypart and
// remove_bodypart call for us, so the logic lives there now and delegates to the mob.
//
// The mob-side halves stay as procs on /mob/living/carbon/human deliberately: the prebuckle
// signal has to be registered with the human as the registrant, otherwise PROC_REF would
// resolve taur_consent_prebuckle against the bodypart and the handler would never fire.

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
