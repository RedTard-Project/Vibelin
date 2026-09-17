/datum/tgui_panel/proc/send_declensions(list/payload)
	if(!length(payload) || !is_ready())
		return
	window.send_message("localization/declensions", payload)

/datum/tgui_panel/proc/send_language()
	if(!is_ready())
		return
	window.send_message("localization/config", list(
		"lang" = ui_lang_code(client),
		"dictionaryUrl" = SSassets.transport.get_asset_url(CHAT_LOCALIZATION_ASSET),
	))

// Hooked on the panel's own "ready" handshake rather than on initialize(), which
// returns at its first sleep and would race the window actually being up.
/datum/tgui_panel/on_message(type, payload)
	. = ..()
	if(type != "ready")
		return

	window.send_asset(get_asset_datum(/datum/asset/json/chat_localization))
	send_language()
	send_declensions(GLOB.chat_declensions)

/client/proc/push_chat_language()
	tgui_panel?.send_language()
