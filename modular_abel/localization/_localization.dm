#define LANGUAGE_RUSSIAN "Русский"
#define LANGUAGE_ENGLISH "English"

#define UI_LANG_CODE_RU "ru"
#define UI_LANG_CODE_EN "en"

/datum/preference/choiced/language
	savefile_key = "language"
	savefile_identifier = PREF_PLAYER
	category = "ui"
	can_randomize = FALSE
	should_update_preview = FALSE

/datum/preference/choiced/language/init_possible_values(datum/preferences/prefs)
	return list(LANGUAGE_RUSSIAN, LANGUAGE_ENGLISH)

/datum/preference/choiced/language/create_default_value(datum/preferences/prefs)
	return LANGUAGE_RUSSIAN

/datum/preference/choiced/language/handle_link(datum/preferences/prefs, mob/user)
	switch(prefs.read_preference(/datum/preference/choiced/language))
		if(LANGUAGE_ENGLISH)
			prefs.write_preference(/datum/preference/choiced/language, LANGUAGE_RUSSIAN)
		else
			prefs.write_preference(/datum/preference/choiced/language, LANGUAGE_ENGLISH)

/proc/ui_lang_code(client/target)
	if(!target?.prefs)
		return UI_LANG_CODE_RU
	if(target.prefs.read_preference(/datum/preference/choiced/language) == LANGUAGE_ENGLISH)
		return UI_LANG_CODE_EN
	return UI_LANG_CODE_RU

/client/verb/toggle_ui_language()
	set name = "Язык / Language"
	set category = "Preferences.Options"
	set desc = "Переключить язык интерфейса (RU/EN) / Switch interface language"
	if(!prefs)
		return
	var/new_lang = (prefs.read_preference(/datum/preference/choiced/language) == LANGUAGE_ENGLISH) ? LANGUAGE_RUSSIAN : LANGUAGE_ENGLISH
	prefs.write_preference(/datum/preference/choiced/language, new_lang)
	prefs.save_preferences()
	SStgui.update_uis(prefs)
	to_chat(src, span_notice("Язык интерфейса: [new_lang] / Interface language: [new_lang]"))
