GLOBAL_LIST_INIT(modular_race_followers, list(
	SPEC_ID_ELF_SUN = SPEC_ID_ELF,
	SPEC_ID_TABAXI = SPEC_ID_RAKSHARI,
	SPEC_ID_VULPKANIN = SPEC_ID_RAKSHARI,
	SPEC_ID_LUPIAN = SPEC_ID_RAKSHARI,
	SPEC_ID_AKULA = SPEC_ID_RAKSHARI,
	SPEC_ID_ANTHROMORPH = SPEC_ID_RAKSHARI,
	SPEC_ID_LIZARDFOLK = SPEC_ID_RAKSHARI,
	SPEC_ID_DRACON = SPEC_ID_RAKSHARI,
	SPEC_ID_MOTH = SPEC_ID_RAKSHARI,
	SPEC_ID_TAUR_KIN = SPEC_ID_RAKSHARI,
	SPEC_ID_AURA = SPEC_ID_RAKSHARI,
	SPEC_ID_OOZE = SPEC_ID_HUMEN,
))

GLOBAL_LIST_INIT(modular_outsider_categories, list(
	CTAG_ADVENTURER,
	CTAG_PILGRIM,
	CTAG_WRETCH,
	CTAG_CHALLENGE,
))

/datum/job/New()
	. = ..()
	if(!length(allowed_races))
		return
	for(var/new_id in GLOB.modular_race_followers)
		var/proxy_id = GLOB.modular_race_followers[new_id]
		if(proxy_id in allowed_races)
			allowed_races |= new_id

/datum/job/advclass/New()
	. = ..()
	if(!length(allowed_races))
		return
	if(length(allowed_races) < 7)
		return
	if(length(allowed_patrons))
		return
	if(!length(category_tags))
		return
	if(!length(category_tags & GLOB.modular_outsider_categories))
		return
	for(var/new_id in GLOB.modular_race_followers)
		allowed_races |= new_id
