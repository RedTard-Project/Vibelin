GLOBAL_LIST_EMPTY(sheet_chargen)
GLOBAL_LIST_EMPTY(sheet_chargen_fields)
GLOBAL_LIST_EMPTY(sheet_chargen_terms)
GLOBAL_VAR_INIT(sheet_chargen_loaded, FALSE)

/// Loads strings/chargen.txt. Like traits.txt this resolves server-side and never
/// reaches the browser dictionary, because the keys are type paths rather than
/// English text: an upstream reword of a species blurb must not silently orphan
/// its translation.
///
/// Two line shapes:
///   /type/path        = <name> | <description>
///   /type/path:field  = <text>
/// A type path cannot contain ":", which is what makes the field suffix safe.
/proc/load_chargen_sheet()
	GLOB.sheet_chargen_loaded = TRUE

	var/datum/asset/json/chat_localization/asset = get_asset_datum(/datum/asset/json/chat_localization)
	if(!asset)
		stack_trace("chargen sheet: the localization asset is missing, chargen stays English")
		return

	for(var/list/pair as anything in asset.read_pairs("chargen.txt"))
		var/key = pair[1]
		var/value = pair[2]

		var/field_at = findtext(key, ":")
		if(field_at)
			var/field = copytext(key, field_at + 1)
			var/path = text2path(copytext(key, 1, field_at))
			if(!ispath(path))
				stack_trace("chargen sheet: \"[key]\" is not a type, entry dropped")
				continue
			if(!length(field))
				stack_trace("chargen sheet: \"[key]\" has an empty field name, entry dropped")
				continue
			GLOB.sheet_chargen_fields["[path]:[field]"] = value
			continue

		var/path = text2path(key)
		if(!ispath(path))
			stack_trace("chargen sheet: \"[key]\" is not a type, entry dropped")
			continue

		var/split_at = findtext(value, " | ")
		if(!split_at)
			stack_trace("chargen sheet: \"[key]\" has no \" | \" between its name and description, entry dropped")
			continue
		GLOB.sheet_chargen[path] = list(
			copytext(value, 1, split_at),
			copytext(value, split_at + length(" | ")),
		)

	for(var/list/pair as anything in asset.read_pairs("chargen_terms.txt"))
		GLOB.sheet_chargen_terms[pair[1]] = pair[2]

/proc/chargen_sheet_ensure_loaded()
	if(!GLOB.sheet_chargen_loaded)
		load_chargen_sheet()

/// TRUE when this client should be served the Russian chargen strings.
/proc/chargen_sheet_active(client/target)
	return ui_lang_code(target) == UI_LANG_CODE_RU

/proc/chargen_tr_name_for(ru, path, fallback)
	if(!ru)
		return fallback
	chargen_sheet_ensure_loaded()
	var/list/entry = GLOB.sheet_chargen[path]
	return (entry && length(entry[1])) ? entry[1] : fallback

/proc/chargen_tr_name(client/target, path, fallback)
	return chargen_tr_name_for(chargen_sheet_active(target), path, fallback)

/proc/chargen_tr_desc_for(ru, path, fallback)
	if(!ru)
		return fallback
	chargen_sheet_ensure_loaded()
	var/list/entry = GLOB.sheet_chargen[path]
	return (entry && length(entry[2])) ? entry[2] : fallback

/proc/chargen_tr_desc(client/target, path, fallback)
	return chargen_tr_desc_for(chargen_sheet_active(target), path, fallback)

/proc/chargen_tr_term_for(ru, term)
	if(!ru)
		return term
	chargen_sheet_ensure_loaded()
	var/translated = GLOB.sheet_chargen_terms["[term]"]
	return translated || term

/proc/chargen_tr_term(client/target, term)
	return chargen_tr_term_for(chargen_sheet_active(target), term)

/proc/chargen_tr_line_for(ru, key, fallback, term)
	. = fallback
	if(ru)
		chargen_sheet_ensure_loaded()
		var/translated = GLOB.sheet_chargen_terms["[key]"]
		if(length(translated))
			. = translated
	if(!isnull(term))
		. = replacetext(., "%TERM%", "[term]")

/proc/chargen_tr_line(client/target, key, fallback, term)
	return chargen_tr_line_for(chargen_sheet_active(target), key, fallback, term)

/proc/chargen_tr_field_for(ru, path, field, fallback)
	if(!ru)
		return fallback
	chargen_sheet_ensure_loaded()
	var/translated = GLOB.sheet_chargen_fields["[path]:[field]"]
	return length(translated) ? translated : fallback

/proc/chargen_tr_field(client/target, path, field, fallback)
	return chargen_tr_field_for(chargen_sheet_active(target), path, field, fallback)

/// Writes every species, faith and patron the sheet does not cover to the log in
/// the exact line format chargen.txt expects, so filling the file is copy-paste
/// rather than a transcription job. Admin-only; produces no gameplay effect.
/client/verb/chargen_sheet_report()
	set name = "Chargen Sheet: Missing Keys"
	set category = "Debug.Telemetry"
	set desc = "Dump untranslated chargen keys to chargen_sheet.log in chargen.txt format."
	if(!check_rights(R_DEBUG))
		return

	chargen_sheet_ensure_loaded()
	var/list/lines = list()
	var/missing = 0

	for(var/species_id in GLOB.roundstart_species)
		var/species_type = GLOB.species_list[species_id]
		if(!species_type || GLOB.sheet_chargen[species_type])
			continue
		var/datum/species/species = new species_type()
		lines += "[species_type] = [species.name] | [species.desc]"
		missing++

	for(var/faith_type in GLOB.faith_list)
		var/datum/faith/faith = GLOB.faith_list[faith_type]
		if(!faith || GLOB.sheet_chargen[faith_type])
			continue
		lines += "[faith_type] = [faith.name] | [faith.desc]"
		missing++

	for(var/patron_type in GLOB.patron_list)
		var/datum/patron/patron = GLOB.patron_list[patron_type]
		if(!patron || GLOB.sheet_chargen[patron_type])
			continue
		lines += "[patron_type] = [patron.display_name || patron.name] | [patron.desc]"
		for(var/field in list("domain", "boons", "sins", "flaws", "worshippers"))
			var/text = patron.vars[field]
			if(length(text))
				lines += "[patron_type]:[field] = [text]"
		missing++

	var/path = "[GLOB.log_directory]/chargen_sheet.log"
	for(var/line in lines)
		WRITE_LOG(path, replacetext("[line]", "\n", "\\n"))
	to_chat(src, span_notice("chargen sheet: [missing] untranslated entries written to [path]."))
