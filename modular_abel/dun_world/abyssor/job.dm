// The Painter - Abyssor's dream-scryer.
// Ported from Azure-Peak code/modules/jobs/job_types/roguetown/church/painter.dm.
//
// Adapted for Vanderlin: Azure's subclass_stats/subclass_skills lists are Vanderlin's
// /datum/attribute_holder/sheet, TRAIT_WATERBREATHING is TRAIT_NODROWN, and Azure's
// TRAIT_RITUALIST is dropped entirely - it gates Azure's chalk-circle ritual system,
// which Vanderlin does not have.
//
// Slots are 0 by default so the job is invisible on every stock map. Twilight Axis turns
// it on through its map_adjustment slot_adjust; see modular_abel/dun_world/map_adjustment.dm.
// map_check() additionally hard-gates it on the per-map abyssor_cult switch so an admin
// re-opening slots on a map that never opted in still cannot spawn one.

/datum/attribute_holder/sheet/job/painter
	raw_attribute_list = list(
		STAT_INTELLIGENCE = 2,
		STAT_PERCEPTION = 2,
		STAT_SPEED = 1,
		STAT_STRENGTH = -1,
		/datum/attribute/skill/misc/reading = 40,
		/datum/attribute/skill/magic/holy = 40,
		/datum/attribute/skill/misc/medicine = 30,
		/datum/attribute/skill/misc/swimming = 30,
		/datum/attribute/skill/labor/fishing = 30,
		/datum/attribute/skill/combat/polearms = 20,
		/datum/attribute/skill/combat/wrestling = 10,
		/datum/attribute/skill/combat/unarmed = 10,
		/datum/attribute/skill/craft/alchemy = 20,
		/datum/attribute/skill/craft/crafting = 30,
		/datum/attribute/skill/misc/athletics = 10,
	)

/datum/attribute_holder/sheet/job/painter/old
	raw_attribute_list = list(
		STAT_INTELLIGENCE = 3,
		STAT_PERCEPTION = 2,
		STAT_SPEED = 0,
		STAT_STRENGTH = -1,
		/datum/attribute/skill/misc/reading = 50,
		/datum/attribute/skill/magic/holy = 50,
		/datum/attribute/skill/misc/medicine = 30,
		/datum/attribute/skill/misc/swimming = 30,
		/datum/attribute/skill/labor/fishing = 40,
		/datum/attribute/skill/combat/polearms = 20,
		/datum/attribute/skill/combat/wrestling = 10,
		/datum/attribute/skill/combat/unarmed = 10,
		/datum/attribute/skill/craft/alchemy = 20,
		/datum/attribute/skill/craft/crafting = 30,
		/datum/attribute/skill/misc/athletics = 10,
	)

/datum/job/painter
	title = "Painter"
	f_title = null
	tutorial = "Not a painter in the traditional sense, you are a visionary. Peer into the dream pool of Abyssor \
	and receive great visions of past, present and future. Gaze into the esotheric realm of the Deepfather's dream. \
	Go bother others with your prophecies."
	department_flag = CHURCHMEN
	job_flags = (JOB_ANNOUNCE_ARRIVAL | JOB_SHOW_IN_CREDITS | JOB_EQUIP_RANK | JOB_NEW_PLAYER_JOINABLE)
	display_order = JDO_PAINTER
	factions = list(FACTION_TOWN)
	// Twilight Axis opens these through its map_adjustment; every other map leaves them shut.
	total_positions = 0
	spawn_positions = 0

	allowed_patrons = list(/datum/patron/divine/abyssor)
	allowed_ages = ALL_AGES_LIST

	outfit = /datum/outfit/painter
	give_bank_account = TRUE
	knows_the_town = TRUE
	known_by_the_town = TRUE
	job_bitflag = BITFLAG_CHURCH

	exp_types_granted = list(EXP_TYPE_CHURCH, EXP_TYPE_CLERIC)

	attribute_sheet = /datum/attribute_holder/sheet/job/painter
	attribute_sheet_old = /datum/attribute_holder/sheet/job/painter/old

	languages = list(/datum/language/abyssal)
	traits = list(TRAIT_NODROWN)

/// Hard gate: the Painter only exists on maps that opted into the dream cult.
/datum/job/painter/special_job_check(mob/dead/new_player/player)
	if(!ABYSSOR_CULT_ENABLED)
		return FALSE
	return ..()

/datum/outfit/painter
	name = "Painter"
	head = /obj/item/clothing/head/roguehood/abyssor_painter
	armor = /obj/item/clothing/shirt/robe/abyssor_painter_sea
	neck = /obj/item/clothing/neck/psycross/silver/divine/abyssor
	pants = /obj/item/clothing/pants/trou
	shoes = /obj/item/clothing/shoes/sandals
	belt = /obj/item/storage/belt/leather/rope
	beltr = /obj/item/storage/belt/pouch/coins/poor
	beltl = /obj/item/key/church
	backl = /obj/item/weapon/polearm/woodstaff/quarterstaff
	backr = /obj/item/storage/backpack/satchel/cloth
	backpack_contents = list(
		/obj/item/dream_material/parchment_raw = 2,
	)

/obj/effect/landmark/start/painter
	name = "Painter"
	jobs_to_spawn = list("Painter")
