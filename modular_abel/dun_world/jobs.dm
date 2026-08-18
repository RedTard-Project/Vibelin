/datum/job/merchant/dun_world_guildmaster
	title = "Guildmaster"
	f_title = null
	department_flag = SERFS
	tutorial = "You preside over the craft and trade guilds of these lands, keeper of the ledgers, the contracts, and the guildhall keys."
	total_positions = 0
	spawn_positions = 0

/datum/job/artificer/dun_world_guildsman
	title = "Guildsman"
	f_title = null
	department_flag = SERFS
	tutorial = "You are a sworn member of the guild, plying your trade beneath the Guildmaster's seal."
	total_positions = 0
	spawn_positions = 0

/datum/job/innkeep/dun_world_bathmaster
	title = "Bathmaster"
	f_title = null
	department_flag = SERFS
	tutorial = "You keep the bathhouse, its waters warm and its custom flowing."
	total_positions = 0
	spawn_positions = 0

/datum/job/servant/dun_world_keeper
	title = "Keeper"
	f_title = null
	department_flag = OUTSIDERS
	tutorial = "You keep what others would leave to rot, tending the beasts and grounds left in your charge."
	total_positions = 0
	spawn_positions = 0

/datum/job/merchant/dun_world_trader
	title = "Trader"
	f_title = null
	department_flag = OUTSIDERS
	tutorial = "You are a travelling trader, come to these lands to turn a coin before moving on."
	total_positions = 0
	spawn_positions = 0

/datum/job/monk/dun_world_druid
	title = "Druid"
	f_title = null
	department_flag = CHURCHMEN
	tutorial = "You walk the old green path, tending the rites of grove and field."
	total_positions = 0
	spawn_positions = 0

/datum/job/monk/dun_world_martyr
	title = "Martyr"
	f_title = null
	department_flag = CHURCHMEN
	tutorial = "You have given yourself wholly to the faith, ready to suffer for its sake."
	total_positions = 0
	spawn_positions = 0

/datum/job/vagrant/dun_world_lunatic
	title = "Lunatic"
	f_title = null
	department_flag = OUTSIDERS
	tutorial = "Your wits have wandered off to somewhere the rest of you cannot follow."
	total_positions = 0
	spawn_positions = 0

/datum/job/vagrant/dun_world_vagabond
	title = "Vagabond"
	f_title = null
	department_flag = OUTSIDERS
	tutorial = "You drift from town to town, owning little and owing less."
	total_positions = 0
	spawn_positions = 0

/datum/job/mercenary/dun_world_veteran
	title = "Veteran"
	f_title = null
	department_flag = OUTSIDERS
	tutorial = "Old wars left their marks on you, and a soldier's trade is the only one you know."
	total_positions = 0
	spawn_positions = 0

/datum/antagonist/wretch/dun_world

/datum/antagonist/wretch/dun_world/remove_job()
	return

/datum/antagonist/wretch/dun_world/move_to_spawnpoint()
	var/spawn_point = get_spawn_turf_for_job(ROLE_WRETCH)
	if(spawn_point)
		owner.current?.forceMove(spawn_point)
	else
		SSjob.SendToBackupPoint(owner.current)

/datum/job/wretch
	title = ROLE_WRETCH
	f_title = null
	department_flag = OUTSIDERS
	job_flags = (JOB_EQUIP_RANK | JOB_NEW_PLAYER_JOINABLE | JOB_SHOW_IN_CREDITS)
	display_order = JDO_WRETCH
	factions = list(FACTION_NEUTRAL)
	total_positions = 0
	spawn_positions = 0
	antag_job = TRUE
	antag_role = /datum/antagonist/wretch/dun_world
	is_foreigner = TRUE
	can_have_apprentices = FALSE
	can_random = FALSE
	same_job_respawn_delay = 30 MINUTES
	tutorial = "You fell to the wrong side of civilization, and now carry the bounty and fear that follow a wretch."

/datum/job/steward/dun_world_seneschal
	title = "Seneschal"
	f_title = null
	department_flag = NOBLEMEN
	tutorial = "You run the household of the keep, master of its stores, its staff and its schedule. \
	The Duke rules these lands; you rule the walls he rules them from."
	total_positions = 0
	spawn_positions = 0

/datum/job/minor_noble/dun_world_councillor
	title = "Councillor"
	f_title = null
	department_flag = NOBLEMEN
	tutorial = "You hold a seat at the Duke's council, and your word carries weight in matters of law \
	and coin. Whether he heeds it is another matter entirely."
	total_positions = 0
	spawn_positions = 0

/datum/job/archivist/dun_world_clerk
	title = "Clerk"
	f_title = null
	department_flag = NOBLEMEN
	tutorial = "You keep the ledgers, the writs and the seals of the court. Every debt, every decree \
	and every quiet arrangement passes beneath your pen."
	total_positions = 0
	spawn_positions = 0

/datum/job/minor_noble/dun_world_suitor
	title = "Suitor"
	f_title = null
	department_flag = NOBLEMEN
	tutorial = "You came to these lands to win a hand and a title with it. Charm, blood or coin - \
	whichever you have most of - is your instrument."
	total_positions = 0
	spawn_positions = 0

/datum/job/servant/dun_world_bathhouse_attendant
	title = "Bathhouse Attendant"
	f_title = null
	department_flag = PEASANTS
	tutorial = "You draw the water, work the linens and hold your tongue about whatever is said in \
	the steam."
	total_positions = 0
	spawn_positions = 0

/datum/job/dungeoneer/dun_world_warden
	title = "Warden"
	f_title = null
	department_flag = GARRISON
	tutorial = "You hold the keys to the cells and the keep, warden of all who are kept within."
	total_positions = 0
	spawn_positions = 0

/obj/effect/landmark/start/guildmaster
	name = "Guildmaster"
	jobs_to_spawn = list("Guildmaster")

/obj/effect/landmark/start/guildsman
	name = "Guildsman"
	jobs_to_spawn = list("Guildsman")

/obj/effect/landmark/start/bathmaster
	name = "Bathmaster"
	jobs_to_spawn = list("Bathmaster")

/obj/effect/landmark/start/keeper
	name = "Keeper"
	jobs_to_spawn = list("Keeper")

/obj/effect/landmark/start/trader
	name = "Trader"
	jobs_to_spawn = list("Trader")

/obj/effect/landmark/start/druid
	name = "Druid"
	jobs_to_spawn = list("Druid")

/obj/effect/landmark/start/martyr
	name = "Martyr"
	jobs_to_spawn = list("Martyr")

/obj/effect/landmark/start/lunatic
	name = "Lunatic"
	jobs_to_spawn = list("Lunatic")

/obj/effect/landmark/start/vagabond
	name = "Vagabond"
	jobs_to_spawn = list("Vagabond")

/obj/effect/landmark/start/veteran
	name = "Veteran"
	jobs_to_spawn = list("Veteran")

/obj/effect/landmark/start/warden
	name = "Warden"
	jobs_to_spawn = list("Warden")

/obj/effect/landmark/start/seneschal
	name = "Seneschal"
	jobs_to_spawn = list("Seneschal")

/obj/effect/landmark/start/councillor
	name = "Councillor"
	jobs_to_spawn = list("Councillor")

/obj/effect/landmark/start/clerk
	name = "Clerk"
	jobs_to_spawn = list("Clerk")

/obj/effect/landmark/start/suitor
	name = "Suitor"
	jobs_to_spawn = list("Suitor")

/obj/effect/landmark/start/bathworker
	name = "Bathhouse Attendant"
	jobs_to_spawn = list("Bathhouse Attendant")

/obj/effect/landmark/start/wretch
	name = ROLE_WRETCH
	jobs_to_spawn = list(ROLE_WRETCH)

/obj/effect/landmark/start/late/wretch
	name = ROLE_WRETCH
	jobs_to_spawn = list(ROLE_WRETCH)
