/datum/map_adjustment/dun_world
	map_file_name = "dun_world_new.dmm"
	blacklist = list(
		/datum/job/minor_noble,
	)
	advclass_blacklist = list(
		/datum/job/advclass/royalknight/steam,
	)
	slot_adjust = list(
		/datum/job/merchant/dun_world_guildmaster = 1,
		/datum/job/artificer/dun_world_guildsman = 4,
		/datum/job/innkeep/dun_world_bathmaster = 1,
		/datum/job/servant/dun_world_keeper = 1,
		/datum/job/merchant/dun_world_trader = 5,
		/datum/job/monk/dun_world_druid = 2,
		/datum/job/monk/dun_world_martyr = 1,
		/datum/job/vagrant/dun_world_lunatic = 1,
		/datum/job/vagrant/dun_world_vagabond = 12,
		/datum/job/mercenary/dun_world_veteran = 1,
		/datum/job/dungeoneer/dun_world_warden = 4,
		/datum/job/steward/dun_world_seneschal = 1,
		/datum/job/minor_noble/dun_world_councillor = 3,
		/datum/job/archivist/dun_world_clerk = 1,
		/datum/job/minor_noble/dun_world_suitor = 0,
		/datum/job/servant/dun_world_bathhouse_attendant = 5,
		// Abyssor dream cult - only Twilight Axis opts in, see abyssor/map_config.dm.
		/datum/job/painter = 1,
	)

/datum/map_adjustment/dun_world/job_change()
	. = ..()
	change_job_position(/datum/job/lord, 1, 1)
	change_job_position(/datum/job/villager, 0, 40)
	change_job_position(/datum/job/wretch, 10, 25)
	GLOB.peasant_positions.Add(/datum/job/villager::title, "Bathhouse Attendant")
	GLOB.serf_positions.Add("Guildmaster", "Guildsman", "Bathmaster")
	GLOB.noble_positions.Add("Seneschal", "Councillor", "Clerk", "Suitor")
	GLOB.noble_courthand_positions.Add("Seneschal", "Councillor", "Clerk", "Suitor")
	GLOB.church_positions.Add("Druid", "Martyr", "Painter")
	GLOB.garrison_positions.Add("Warden")
	GLOB.allmig_positions.Add("Keeper", "Trader", "Lunatic", "Vagabond", "Veteran", ROLE_WRETCH)
