GLOBAL_LIST_EMPTY(examine_descriptions)
GLOBAL_VAR_INIT(examine_descriptions_loaded, FALSE)

/// Loads strings/descriptions.txt into a typepath -> text table. A key that is
/// not a real type is dropped with a stack_trace rather than stored under null,
/// so a renamed type shows up in the logs instead of going quiet.
/proc/load_examine_descriptions()
	GLOB.examine_descriptions_loaded = TRUE

	var/datum/asset/json/chat_localization/asset = get_asset_datum(/datum/asset/json/chat_localization)
	if(!asset)
		stack_trace("examine descriptions: the localization asset is missing, descriptions stay English")
		return

	for(var/list/pair as anything in asset.read_pairs("descriptions.txt"))
		var/path = text2path(pair[1])
		if(!ispath(path))
			stack_trace("examine descriptions: \"[pair[1]]\" is not a type, entry dropped")
			continue
		GLOB.examine_descriptions[path] = pair[2]

/// Keyed by type rather than by the English text, so rewording a desc upstream
/// cannot silently orphan the translation. get_examine_desc() already takes the
/// user, so the swap is per-client and the English is untouched for everyone else.
/atom/get_examine_desc(mob/user)
	if(ui_lang_code(user?.client) == UI_LANG_CODE_RU)
		if(!GLOB.examine_descriptions_loaded)
			load_examine_descriptions()
		var/translated = GLOB.examine_descriptions[type]
		if(translated)
			return translated
	return desc
