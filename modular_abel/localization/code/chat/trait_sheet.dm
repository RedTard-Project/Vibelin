GLOBAL_LIST_EMPTY(sheet_traits)
GLOBAL_LIST_EMPTY(sheet_quirks)
GLOBAL_LIST_EMPTY(sheet_languages)
GLOBAL_VAR_INIT(sheet_loaded, FALSE)

/// Loads strings/traits.txt. Trait lines are keyed by the trait's name, which is
/// what its TRAIT_* define expands to; quirk and language lines are keyed by type
/// path and are dropped with a stack_trace if the path no longer resolves, so a
/// rename shows up in the logs instead of going quiet.
/proc/load_trait_sheet()
	GLOB.sheet_loaded = TRUE

	var/datum/asset/json/chat_localization/asset = get_asset_datum(/datum/asset/json/chat_localization)
	if(!asset)
		stack_trace("trait sheet: the localization asset is missing, the sheet stays English")
		return

	for(var/list/pair as anything in asset.read_pairs("traits.txt"))
		var/key = pair[1]
		var/value = pair[2]
		if(copytext(key, 1, 2) == "/")
			var/path = text2path(key)
			if(!ispath(path))
				stack_trace("trait sheet: \"[key]\" is not a type, entry dropped")
				continue
			if(ispath(path, /datum/language))
				GLOB.sheet_languages[path] = value
			else
				GLOB.sheet_quirks[path] = value
			continue

		var/split_at = findtext(value, " | ")
		if(!split_at)
			stack_trace("trait sheet: trait \"[key]\" has no \" | \" between its name and description, entry dropped")
			continue
		GLOB.sheet_traits[key] = list(
			copytext(value, 1, split_at),
			copytext(value, split_at + length(" | ")),
		)

/// The sheet is built by one upstream Click() branch that interpolates the
/// English straight into the message, so there is nothing for the client
/// dictionary to key on that would survive a reword. This override reproduces
/// that branch for Russian players only and defers everything else to ..().
/atom/movable/screen/skills/Click(location, control, params)
	var/list/modifiers = params2list(params)
	if(!LAZYACCESS(modifiers, RIGHT_CLICK) || ui_lang_code(usr?.client) != UI_LANG_CODE_RU)
		return ..()
	if(!isliving(usr))
		return ..()

	if(!GLOB.sheet_loaded)
		load_trait_sheet()

	var/mob/living/user = usr
	var/found_trait = FALSE
	to_chat(user, "*----*")

	if(ishuman(user))
		var/mob/living/carbon/human/human_user = user
		for(var/datum/quirk/vice/vice in human_user.quirks)
			var/translated = GLOB.sheet_quirks[vice.type]
			to_chat(human_user, "<span class='info'>[translated || vice.get_desc()]</span>")
		to_chat(human_user, "*----*")
		var/datum/language_holder/holder = human_user.mind?.language_holder
		if(holder)
			if(!length(holder.languages))
				to_chat(human_user, "<span class='warning'>Я не знаю ни одного языка.</span>")
			else
				for(var/language in holder.languages)
					var/datum/language/spoken = GLOB.language_datum_instances[language]
					var/translated = GLOB.sheet_languages[spoken.type]
					to_chat(human_user, "<span class='info'>[translated || spoken.name] - ,[spoken.key]</span>")
			to_chat(human_user, "*----*")

	for(var/trait_name in GLOB.roguetraits)
		if(!HAS_TRAIT(user, trait_name))
			continue
		found_trait = TRUE
		var/list/translated = GLOB.sheet_traits[trait_name]
		if(translated)
			to_chat(user, "[translated[1]] — <span class='info'>[translated[2]]</span>")
		else
			to_chat(user, "[trait_name] - <span class='info'>[GLOB.roguetraits[trait_name]]</span>")

	if(!found_trait)
		to_chat(user, "<span class='warning'>Особых черт у меня нет.</span>")
	to_chat(user, "*----*")
	return
