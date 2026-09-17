#if defined(UNIT_TESTS) || defined(SPACEMAN_DMM)
/datum/unit_test/species_outfit_equip

/datum/unit_test/species_outfit_equip/Run()
	var/datum/outfit/tailor/outfit = new
	var/list/expected_slots = list(
		"[ITEM_SLOT_SHIRT]" = outfit.shirt,
		"[ITEM_SLOT_PANTS]" = outfit.pants,
		"[ITEM_SLOT_ARMOR]" = outfit.armor,
		"[ITEM_SLOT_SHOES]" = outfit.shoes,
		"[ITEM_SLOT_HEAD]" = outfit.head,
		"[ITEM_SLOT_CLOAK]" = outfit.cloak,
	)
	var/list/slot_names = list(
		"[ITEM_SLOT_SHIRT]" = "shirt",
		"[ITEM_SLOT_PANTS]" = "pants",
		"[ITEM_SLOT_ARMOR]" = "armor",
		"[ITEM_SLOT_SHOES]" = "shoes",
		"[ITEM_SLOT_HEAD]" = "head",
		"[ITEM_SLOT_CLOAK]" = "cloak",
	)

	for(var/species_id in GLOB.roundstart_species)
		var/species_type = GLOB.species_list[species_id]
		if(!species_type)
			continue

		var/mob/living/carbon/human/subject = allocate(/mob/living/carbon/human)
		subject.set_species(species_type)
		subject.equipOutfit(outfit)

		var/list/missing = list()
		for(var/slot_key in expected_slots)
			if(!expected_slots[slot_key])
				continue
			if(!subject.get_item_by_slot(text2num(slot_key)))
				missing += slot_names[slot_key]

		if(length(missing))
			var/datum/species/species = subject.dna?.species
			Fail("[species?.name || species_id] ([species_id]) spawned without: [missing.Join(", ")]. \
				The garment's allowed_race does not admit this species - give it a clothing_race_proxy \
				in modular_abel/races/outfit_compatibility.dm, or widen the garment's list.", __FILE__, __LINE__)

/datum/unit_test/job_outfit_species_matrix

#define KNOWN_JOB_OUTFIT_MISMATCHES list(\
	/obj/item/clothing/cloak/half,\
	/obj/item/clothing/cloak/half/colored/blood,\
	/obj/item/clothing/cloak/half/duelcape,\
	/obj/item/clothing/cloak/half/shadowcloak,\
	/obj/item/clothing/cloak/half/vet,\
	/obj/item/clothing/cloak/heartfelt,\
	/obj/item/clothing/cloak/heartfelt/shit,\
	/obj/item/clothing/cloak/shredded,\
	/obj/item/clothing/cloak/black_cloak,\
	/obj/item/clothing/cloak/cape/puritan,\
	/obj/item/clothing/shirt/undershirt/puritan,\
	/obj/item/clothing/armor/gambeson/heavy/dress/alt,\
	/obj/item/clothing/armor/rare/grenzelplate,\
	/obj/item/clothing/gloves/rare/grenzelplate,\
	/obj/item/clothing/head/rare/grenzelplate,\
	/obj/item/clothing/shoes/boots/rare/grenzelplate,\
	/obj/item/clothing/armor/rare/zaladplate,\
	/obj/item/clothing/gloves/rare/zaladplate,\
	/obj/item/clothing/head/rare/zaladplate,\
	/obj/item/clothing/shoes/boots/rare/zaladplate,\
	/obj/item/clothing/armor/leather/hide/rousman,\
	/obj/item/clothing/armor/cuirass/iron/shadowplate,\
)

#define OUTFIT_ITEM_SLOTS list("suit", "belt", "gloves", "shoes", "head", "mask", "neck", "glasses", \
	"wrists", "l_pocket", "r_pocket", "beltr", "beltl", "backr", "backl", "cloak", "shirt", "mouth", \
	"pants", "armor", "ring", "r_hand", "l_hand")

/datum/unit_test/job_outfit_species_matrix/Run()
	var/list/garment_races = list()
	var/list/failures = list()
	var/checked_combinations = 0

	var/list/species_instances = list()
	for(var/species_id in GLOB.roundstart_species)
		var/species_type = GLOB.species_list[species_id]
		if(species_type)
			species_instances[species_id] = new species_type()

	for(var/datum/job/job as anything in SSjob.all_occupations)
		for(var/outfit_type in list(job.outfit, job.outfit_female))
			if(!ispath(outfit_type, /datum/outfit))
				continue

			var/datum/outfit/outfit = new outfit_type()
			var/list/garments = list()
			for(var/slot_name in OUTFIT_ITEM_SLOTS)
				var/item_path = outfit.vars[slot_name]
				if(!ispath(item_path, /obj/item/clothing))
					continue
				if(isnull(garment_races[item_path]))
					var/obj/item/clothing/sample = new item_path(run_loc_floor_bottom_left)
					garment_races[item_path] = sample.allowed_race || list()
					qdel(sample)
				garments[item_path] = slot_name
			qdel(outfit)

			if(!length(garments))
				continue

			for(var/species_id in species_instances)
				var/datum/species/species = species_instances[species_id]
				var/gating_id = species.id_override ? species.id_override : species.id
				if(length(job.allowed_races) && !(gating_id in job.allowed_races))
					continue
				if(length(job.blacklisted_species) && (gating_id in job.blacklisted_species))
					continue

				for(var/item_path in garments)
					checked_combinations++
					if(species.is_allowed_clothing_race(garment_races[item_path]))
						continue
					var/list/entry = failures[item_path]
					if(!entry)
						entry = list("species" = list(), "jobs" = list())
						failures[item_path] = entry
					entry["species"] |= species.name
					entry["jobs"] |= job.title

	if(!checked_combinations)
		Fail("checked nothing - the job or species lists came back empty, so this test proves nothing.", __FILE__, __LINE__)
		return

	var/list/known = KNOWN_JOB_OUTFIT_MISMATCHES
	for(var/item_path in failures)
		if(item_path in known)
			continue
		var/list/entry = failures[item_path]
		var/list/species_names = entry["species"]
		var/list/job_titles = entry["jobs"]
		Fail("[item_path] is handed out by [job_titles.Join(", ")] but its allowed_race rejects \
			[species_names.Join(", ")] - those species can take the job and will spawn without it. \
			Either widen the garment's allowed_race, give the species a clothing_race_proxy in \
			modular_abel/races/outfit_compatibility.dm, or stop the job from accepting them.", __FILE__, __LINE__)

	for(var/item_path in known)
		if(!failures[item_path])
			Fail("[item_path] is listed in KNOWN_JOB_OUTFIT_MISMATCHES but no longer mismatches any \
				job - remove it from the list.", __FILE__, __LINE__)

#undef OUTFIT_ITEM_SLOTS
#undef KNOWN_JOB_OUTFIT_MISMATCHES
#endif
