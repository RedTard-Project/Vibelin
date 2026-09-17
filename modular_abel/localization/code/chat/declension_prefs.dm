#define MAX_DECLENSION_LEN 128

/datum/preference/text/declension
	abstract_type = /datum/preference/text/declension
	savefile_identifier = PREF_CHARACTER
	category = "character"
	can_randomize = FALSE
	should_apply = FALSE
	should_update_preview = FALSE
	should_strip_html = TRUE
	maximum_value_length = MAX_DECLENSION_LEN
	/// Key this case is published under in the declension payload.
	var/case_key
	/// Shown in the input box, with an example of the case being asked for.
	var/prompt

// encode = FALSE, or the Cyrillic this whole feature exists for never survives
// the round trip. reject_bad_name() is ASCII-only and must not be used here;
// the base text pref already strips HTML on deserialize.
/datum/preference/text/declension/handle_link(datum/preferences/prefs, mob/user)
	var/new_value = browser_input_text(
		user,
		prompt,
		"СКЛОНЕНИЯ",
		prefs.read_preference(type),
		MAX_DECLENSION_LEN,
		encode = FALSE,
	)
	if(isnull(new_value))
		return
	prefs.write_preference(type, trim(new_value))

/datum/preference/text/declension/genitive
	savefile_key = "declension_genitive"
	case_key = "gen"
	prompt = "Родительный падеж — кого? чего? (например: Ивана Петрова)"

/datum/preference/text/declension/dative
	savefile_key = "declension_dative"
	case_key = "dat"
	prompt = "Дательный падеж — кому? чему? (например: Ивану Петрову)"

/datum/preference/text/declension/accusative
	savefile_key = "declension_accusative"
	case_key = "acc"
	prompt = "Винительный падеж — кого? что? (например: Ивана Петрова)"

/datum/preference/text/declension/instrumental
	savefile_key = "declension_instrumental"
	case_key = "ins"
	prompt = "Творительный падеж — кем? чем? (например: Иваном Петровым)"

/datum/preference/text/declension/prepositional
	savefile_key = "declension_prepositional"
	case_key = "pre"
	prompt = "Предложный падеж — о ком? о чём? (например: Иване Петрове)"

/datum/preferences/proc/read_declensions()
	var/list/cases = list()
	for(var/datum/preference/text/declension/pref as anything in subtypesof(/datum/preference/text/declension))
		var/case_key = initial(pref.case_key)
		if(!case_key)
			continue
		var/value = trim(read_preference(pref))
		if(value)
			cases[case_key] = value
	return cases

#undef MAX_DECLENSION_LEN
