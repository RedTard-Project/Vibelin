#define TGUI_THEME_DEFAULT "vibelin"
#define TGUI_FONT_SIZE_DEFAULT 14
#define TGUI_FONT_SIZE_MIN 10
#define TGUI_FONT_SIZE_MAX 20
#define TGUI_LINE_HEIGHT_DEFAULT 120
#define TGUI_LINE_HEIGHT_MIN 100
#define TGUI_LINE_HEIGHT_MAX 220
#define TGUI_LINE_HEIGHT_STEP 5

GLOBAL_LIST_INIT(tgui_themes, list(
	"grim" = "Grim",
	"vibelin" = "Vibelin",
))

/proc/sanitize_tgui_theme(theme)
	if(istext(theme) && GLOB.tgui_themes[theme])
		return theme
	return TGUI_THEME_DEFAULT

/datum/preferences/var/character_setup_tgui_font_size = null
/datum/preferences/var/character_setup_tgui_line_height = null

/proc/sanitize_tgui_font_size(value)
	if(isnull(value))
		return null
	if(!isnum(value))
		value = text2num("[value]")
	if(!isnum(value))
		return null
	return clamp(round(value, 1), TGUI_FONT_SIZE_MIN, TGUI_FONT_SIZE_MAX)

/proc/sanitize_tgui_line_height(value)
	if(isnull(value))
		return null
	if(!isnum(value))
		value = text2num("[value]")
	if(!isnum(value))
		return null
	return clamp(round(value, TGUI_LINE_HEIGHT_STEP), TGUI_LINE_HEIGHT_MIN, TGUI_LINE_HEIGHT_MAX)

/proc/tgui_theme_options()
	var/list/options = list()
	for(var/value in GLOB.tgui_themes)
		options += list(list("value" = value, "label" = GLOB.tgui_themes[value]))
	return options

/proc/tgui_text_bounds()
	return list(
		"font_min" = TGUI_FONT_SIZE_MIN,
		"font_max" = TGUI_FONT_SIZE_MAX,
		"font_default" = TGUI_FONT_SIZE_DEFAULT,
		"line_min" = TGUI_LINE_HEIGHT_MIN,
		"line_max" = TGUI_LINE_HEIGHT_MAX,
		"line_step" = TGUI_LINE_HEIGHT_STEP,
		"line_default" = TGUI_LINE_HEIGHT_DEFAULT,
	)

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
	var/font_size = sanitize_tgui_font_size(user?.client?.prefs?.character_setup_tgui_font_size)
	if(font_size)
		window_block["font_size"] = font_size
	var/line_height = sanitize_tgui_line_height(user?.client?.prefs?.character_setup_tgui_line_height)
	if(line_height)
		window_block["line_height"] = line_height
