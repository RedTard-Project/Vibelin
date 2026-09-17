GLOBAL_LIST_EMPTY(chat_declensions)

/proc/register_chat_declensions(name, list/cases)
	if(!name || !length(cases))
		return
	if(GLOB.chat_declensions[name] ~= cases)
		return

	GLOB.chat_declensions[name] = cases
	var/list/delta = list("[name]" = cases)
	for(var/client/target as anything in GLOB.clients)
		target.tgui_panel?.send_declensions(delta)

/datum/preferences/apply_prefs_to(mob/living/carbon/human/character, icon_updates = TRUE)
	. = ..()
	if(QDELETED(character))
		return
	register_chat_declensions(character.real_name, read_declensions())
