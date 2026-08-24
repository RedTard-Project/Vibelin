#define TGUI_THEME_DEFAULT "grim"

GLOBAL_LIST_INIT(tgui_themes, list(
	"grim" = "Grim",
	"vibelin" = "Vibelin",
))

/proc/sanitize_tgui_theme(theme)
	if(istext(theme) && GLOB.tgui_themes[theme])
		return theme
	return TGUI_THEME_DEFAULT

/proc/tgui_theme_options()
	var/list/options = list()
	for(var/value in GLOB.tgui_themes)
		options += list(list("value" = value, "label" = GLOB.tgui_themes[value]))
	return options

/datum/tgui/get_payload(custom_data, with_data, with_static_data)
	. = ..()
	if(!islist(.))
		return
	var/list/payload = .
	var/list/config_block = payload["config"]
	if(!islist(config_block))
		return
	var/list/window_block = config_block["window"]
	if(!islist(window_block))
		return
	window_block["theme"] = sanitize_tgui_theme(user?.client?.prefs?.character_setup_tgui_theme)
