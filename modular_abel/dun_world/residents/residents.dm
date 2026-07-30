/datum/quirk/boon/resident
	name = "Resident"
	desc = "I am no stranger to these lands. I hold the right to a home of my own here."
	point_value = -3

/datum/quirk/boon/resident/proc/clear_foreigner_status()
	if(!owner)
		return
	REMOVE_TRAIT(owner, TRAIT_FOREIGNER, JOB_TRAIT)
	REMOVE_TRAIT(owner, TRAIT_FOREIGNER, TRAIT_GENERIC)

/datum/quirk/boon/resident/on_spawn()
	. = ..()
	if(owner)
		to_chat(owner, span_notice("I feel at home here."))
	clear_foreigner_status()

/datum/quirk/boon/resident/after_job_spawn(datum/job/job)
	clear_foreigner_status()

/datum/quirk/boon/resident/on_remove()
	. = ..()
	if(owner)
		to_chat(owner, span_danger("I no longer feel like a local resident."))

/mob/living/carbon/human/var/received_resident_key = FALSE

/obj/item/key/town
	name = "homestead key"
	icon_state = "rustkey"

/obj/structure/door/town
	homestead = TRUE
	bump_closed = TRUE
	close_delay = 1 SECONDS

/obj/structure/door/town/blacksmith
	required_job_title = JOB_BLACKSMITH

/obj/structure/door/town/fisher
	required_job_title = JOB_FISHER

/obj/structure/door/town/hunter
	required_job_title = JOB_HUNTER

/obj/structure/door/town/seamstress
	required_job_title = JOB_TAILOR

/obj/structure/door/town/woodworker
	required_job_title = JOB_LUMBERJACK

/obj/structure/door
	var/homestead = FALSE
	var/grant_resident_key = TRUE
	var/resident_key_type = /obj/item/key/town
	var/house_id
	var/required_job_title

/proc/generate_town_lockid(obj/structure/door/D)
	return "town_[world.time % 1000000][D.x][D.y][D.z][rand(1, 1000)]"

/obj/structure/door/Initialize()
	. = ..()
	if(!homestead)
		return
	if(!house_id)
		house_id = generate_town_lockid(src)
	if(!lock_check(TRUE))
		return
	var/datum/lock/key/KL = lock
	KL.lockid_list = list(house_id)
	KL.locked = TRUE

/obj/structure/door/proc/try_award_resident_key(mob/user)
	if(!grant_resident_key || !ishuman(user))
		return FALSE
	var/mob/living/carbon/human/H = user
	if(!H.has_quirk(/datum/quirk/boon/resident) || H.received_resident_key || !house_id)
		return FALSE
	if(required_job_title && (!H.mind || !H.mind.assigned_role || H.mind.assigned_role.title != required_job_title))
		to_chat(H, span_warning("This home is set aside for the [required_job_title]."))
		return FALSE
	if(alert(H, "Is this my home?", "Home", "Yes", "No") != "Yes")
		return FALSE
	var/obj/item/key/town/K = new resident_key_type(get_turf(H))
	K.lockids = list(house_id)
	H.put_in_hands(K)
	H.received_resident_key = TRUE
	grant_resident_key = FALSE
	name = "[H.real_name]'s house"
	to_chat(H, span_notice("I find the key to my home."))
	return TRUE

/obj/structure/door/attack_hand(mob/user)
	if(homestead && try_award_resident_key(user))
		return
	return ..()

/obj/structure/door/TryToSwitchState(atom/user)
	if(homestead)
		if(grant_resident_key)
			return FALSE
		if(ishuman(user))
			var/mob/living/carbon/human/H = user
			if(!H.has_quirk(/datum/quirk/boon/resident))
				to_chat(H, span_warning("This is not my home."))
				return FALSE
	return ..()

/datum/job/after_spawn(mob/living/carbon/human/spawned, client/player_client, clear_job_stats = TRUE)
	. = ..()
	if(SSmapping.config?.map_name != "Twilight Axis")
		return
	if(!istype(spawned))
		return
	if(!(department_flag & (PEASANTS | SERFS)))
		return
	if(!spawned.has_quirk(/datum/quirk/boon/resident))
		spawned.add_quirk(/datum/quirk/boon/resident)
