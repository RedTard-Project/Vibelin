/mob/living/carbon/human
	var/can_do_sex = TRUE
	var/datum/weakref/sex_surrender_ref

/mob/living/proc/get_erp_organs()
	var/list/L = list()
	var/mob/living/carbon/human/H = src
	if(!istype(H))
		return L

	for(var/obj/item/organ/O in H.internal_organs)
		if(O.sex_organ)
			L += O.sex_organ

	for(var/obj/item/bodypart/B in H.bodyparts)
		if(B.sex_organ)
			L += B.sex_organ

	return L

/mob/living/proc/get_erp_organ(type)
	for(var/datum/erp_sex_organ/O in get_erp_organs())
		if(O.erp_organ_type == type)
			return O
	return null

/mob/living/carbon/human/proc/is_lamia_taur()
	return FALSE

/mob/living/carbon/human/proc/is_dullahan_head_partner()
	return FALSE

/mob/living/carbon/human/proc/is_erp_blocked_as_target()
	return FALSE

/mob/living/carbon/human/proc/is_physically_restrained(node_flags)
	if(handcuffed || legcuffed)
		return TRUE

	if(node_flags & SEX_ORGAN_MOUTH)
		if(is_mouth_covered())
			return TRUE

	if(node_flags & SEX_ORGAN_HANDS)
		if(HAS_TRAIT(src, TRAIT_HANDS_BLOCKED))
			return TRUE
		var/L = get_item_for_held_index(LEFT_HANDS)
		var/R = get_item_for_held_index(RIGHT_HANDS)
		if((L && !is_sex_toy(L)) && (R && !is_sex_toy(R)))
			return TRUE

	if(node_flags & SEX_ORGAN_LEGS)
		if(legcuffed)
			return TRUE

	return FALSE

/obj/item/clothing/proc/get_propagade_kinks()
	if(islist(propagade_kink) && propagade_kink.len)
		return propagade_kink
	return null

/mob/living/carbon/human/proc/get_worn_kink_tags()
	var/list/out = list()
	for(var/obj/item/I in get_equipped_items())
		if(!istype(I, /obj/item/clothing))
			continue
		var/obj/item/clothing/C = I
		var/list/L = C.get_propagade_kinks()
		if(!L || !L.len)
			continue
		for(var/k in L)
			out[k] = TRUE
	return out

/mob/living/proc/get_highest_grab_state_on(mob/living/target)
	if(!istype(target))
		return 0
	if(pulling == target)
		return grab_state
	return 0

/mob/living/proc/stamina_add(amount)
	adjust_stamina(amount)
	return stamina < maximum_stamina

/mob/living/carbon/human/proc/set_sex_surrender_to(mob/living/carbon/human/mob_object)
	if(mob_object)
		sex_surrender_ref = WEAKREF(mob_object)
	else
		sex_surrender_ref = null

/mob/living/carbon/human/proc/is_surrendering_to(mob/living/carbon/human/mob_object)
	if(!mob_object || !sex_surrender_ref)
		return FALSE
	var/mob/living/carbon/human/target = sex_surrender_ref.resolve()
	if(!target || QDELETED(target))
		sex_surrender_ref = null
		return FALSE
	return target == mob_object

/mob/living/proc/start_erp_session(mob/living/target)
	if(!ishuman(src) || !ishuman(target))
		return
	return erp_try_start(src, target, src)

/mob/living/proc/start_erp_session_atom(atom/target_atom)
	if(!ishuman(src))
		return
	return erp_try_start(src, target_atom, src)

/mob/living/proc/erp_resync_after_body_restore()
	if(!SSerp)
		return

	var/client/C = client
	var/datum/erp_controller/EC = null
	if(C)
		EC = SSerp.get_controller_for_client(C)
	if(!EC)
		EC = SSerp.get_controller_for(src)

	if(EC)
		EC.rebind_owner(src, C, src)
		if(EC.owner)
			EC.owner.attach_client(C)
			EC.owner.set_effect_mob(src)
			EC.owner.mark_organs_dirty()
			EC.owner.rebuild_organs()

		for(var/datum/erp_actor/A as anything in EC.actors)
			if(!A || QDELETED(A))
				continue
			if(A.active_actor == src || A.physical == src || A.get_signal_mob() == src)
				A.attach_client(C)
				A.set_effect_mob(src)
				A.mark_organs_dirty()
				A.rebuild_organs()

		EC.request_ui_update()

	SSerp.apply_prefs_for_mob(src)
	SEND_SIGNAL(src, COMSIG_ERP_ANATOMY_CHANGED)

/mob/living/carbon/human/proc/erp_on_spawn_setup()
	if(QDELETED(src))
		return
	can_do_sex = TRUE
	if(!client?.prefs?.erp_enabled)
		return
	if(!GetComponent(/datum/component/arousal))
		AddComponent(/datum/component/arousal)
	if(client?.prefs)
		client.prefs.apply_erp_kinks_to_mob(src)
	SSerp.apply_prefs_for_mob(src)

/mob/living/carbon/human/Login()
	. = ..()
	erp_on_spawn_setup()
	erp_resync_after_body_restore()
	erp_register_clothing_signals()
