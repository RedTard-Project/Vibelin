/obj/item/key/walls
	name = "wall key"
	desc = "This key opens the gates and wall posterns of the town."
	icon_state = "spikekey"
	lockids = list("walls")

/obj/item/key/dun_world
	name = "iron key"
	desc = "A heavy iron key, its bow stamped with a worn local seal."

/datum/job/proc/dun_world_grant_keys(mob/living/carbon/human/spawned, list/lockid_list)
	if(!istype(spawned) || !length(lockid_list))
		return
	var/obj/item/key/dun_world/granted = new(spawned)
	granted.lockids = lockid_list.Copy()
	var/obj/item/storage/keyring/ring = locate(/obj/item/storage/keyring) in spawned.get_equipped_items()
	if(ring && SEND_SIGNAL(ring, COMSIG_TRY_STORAGE_INSERT, granted, null, TRUE, FALSE))
		return
	var/obj/item/pack = spawned.get_item_by_slot(ITEM_SLOT_BACK_R) || spawned.get_item_by_slot(ITEM_SLOT_BACK_L)
	if(pack && SEND_SIGNAL(pack, COMSIG_TRY_STORAGE_INSERT, granted, null, TRUE, FALSE))
		return
	spawned.put_in_hands(granted)

/datum/job/proc/dun_world_grant_authority(mob/living/carbon/human/spawned)
	if(!istype(spawned))
		return
	spawned.add_spell(/datum/action/cooldown/spell/undirected/list_target/grant_resident)

/datum/job/innkeep/dun_world_bathmaster/after_spawn(mob/living/carbon/human/spawned, client/player_client)
	. = ..()
	dun_world_grant_keys(spawned, list("bathhouse"))

/datum/job/matron/after_spawn(mob/living/carbon/human/spawned, client/player_client)
	. = ..()
	if(SSmapping.config?.map_name == "Twilight Axis")
		dun_world_grant_keys(spawned, list("bathhouse"))

/datum/job/merchant/dun_world_guildmaster/after_spawn(mob/living/carbon/human/spawned, client/player_client)
	. = ..()
	dun_world_grant_keys(spawned, list("artificer", "blacksmith", "tailor", "merchant"))

/datum/job/artificer/dun_world_guildsman/after_spawn(mob/living/carbon/human/spawned, client/player_client)
	. = ..()
	dun_world_grant_keys(spawned, list("artificer"))

/datum/job/servant/dun_world_keeper/after_spawn(mob/living/carbon/human/spawned, client/player_client)
	. = ..()
	dun_world_grant_keys(spawned, list("soilson", "manor"))

/datum/job/merchant/dun_world_trader/after_spawn(mob/living/carbon/human/spawned, client/player_client)
	. = ..()
	dun_world_grant_keys(spawned, list("merchant"))

/datum/job/monk/dun_world_druid/after_spawn(mob/living/carbon/human/spawned, client/player_client)
	. = ..()
	dun_world_grant_keys(spawned, list("church", "priest", "graveyard"))

/datum/job/monk/dun_world_martyr/after_spawn(mob/living/carbon/human/spawned, client/player_client)
	. = ..()
	dun_world_grant_keys(spawned, list("church", "priest"))

/datum/job/dungeoneer/dun_world_warden/after_spawn(mob/living/carbon/human/spawned, client/player_client)
	. = ..()
	dun_world_grant_keys(spawned, list("dungeon", "vault", "garrison"))

/datum/job/mercenary/dun_world_veteran/after_spawn(mob/living/carbon/human/spawned, client/player_client)
	. = ..()
	dun_world_grant_keys(spawned, list("mercenary"))

/datum/job/lord/after_spawn(mob/living/carbon/human/spawned, client/player_client, clear_job_stats = TRUE)
	. = ..()
	if(SSmapping.config?.map_name == "Twilight Axis")
		dun_world_grant_keys(spawned, list(ACCESS_LORD))
		dun_world_grant_authority(spawned)

/datum/job/consort/after_spawn(mob/living/carbon/human/spawned, client/player_client, clear_job_stats = TRUE)
	. = ..()
	if(SSmapping.config?.map_name == "Twilight Axis")
		dun_world_grant_keys(spawned, list("manor", "walls"))

/datum/job/prince/after_spawn(mob/living/carbon/human/spawned, client/player_client, clear_job_stats = TRUE)
	. = ..()
	if(SSmapping.config?.map_name == "Twilight Axis")
		dun_world_grant_keys(spawned, list("manor", "walls"))

/datum/job/steward/after_spawn(mob/living/carbon/human/spawned, client/player_client, clear_job_stats = TRUE)
	. = ..()
	if(SSmapping.config?.map_name == "Twilight Axis")
		dun_world_grant_keys(spawned, list("steward", "manor", "vault", "walls"))

/datum/job/hand/after_spawn(mob/living/carbon/human/spawned, client/player_client, clear_job_stats = TRUE)
	. = ..()
	if(SSmapping.config?.map_name == "Twilight Axis")
		dun_world_grant_keys(spawned, list("hand", "manor", "steward", "walls", "garrison"))
		dun_world_grant_authority(spawned)

/datum/job/captain/after_spawn(mob/living/carbon/human/spawned, client/player_client, clear_job_stats = TRUE)
	. = ..()
	if(SSmapping.config?.map_name == "Twilight Axis")
		dun_world_grant_keys(spawned, list("at_arms", "garrison", "dungeon", "walls", "manor"))
		dun_world_grant_authority(spawned)

/datum/job/town_elder/after_spawn(mob/living/carbon/human/spawned, client/player_client, clear_job_stats = TRUE)
	. = ..()
	if(SSmapping.config?.map_name == "Twilight Axis")
		dun_world_grant_authority(spawned)

/datum/job/guardsman/after_spawn(mob/living/carbon/human/spawned, client/player_client, clear_job_stats = TRUE)
	. = ..()
	if(SSmapping.config?.map_name == "Twilight Axis")
		dun_world_grant_keys(spawned, list("garrison", "walls", "at_arms"))

/datum/job/squire/after_spawn(mob/living/carbon/human/spawned, client/player_client, clear_job_stats = TRUE)
	. = ..()
	if(SSmapping.config?.map_name == "Twilight Axis")
		dun_world_grant_keys(spawned, list("at_arms", "manor", "walls"))

/datum/job/priest/after_spawn(mob/living/carbon/human/spawned, client/player_client, clear_job_stats = TRUE)
	. = ..()
	if(SSmapping.config?.map_name == "Twilight Axis")
		dun_world_grant_keys(spawned, list("church", "priest", "graveyard"))

/datum/job/monk/after_spawn(mob/living/carbon/human/spawned, client/player_client, clear_job_stats = TRUE)
	. = ..()
	if(SSmapping.config?.map_name == "Twilight Axis")
		dun_world_grant_keys(spawned, list("church", "priest"))

/obj/structure/door/proc/dun_world_bumper_has_key(mob/living/user)
	if(!lock_check(TRUE))
		return FALSE
	var/datum/lock/key/KL = lock
	for(var/obj/item/I in user.get_equipped_items(INCLUDE_HELD))
		if(KL.check_access(I))
			return TRUE
	return FALSE

/obj/structure/door/Bumped(atom/movable/AM)
	if(isliving(AM) && locked() && SSmapping.config?.map_name == "Twilight Axis" && dun_world_bumper_has_key(AM))
		var/datum/lock/key/KL = lock
		KL.locked = FALSE
		. = ..()
		KL.locked = TRUE
		return .
	return ..()
