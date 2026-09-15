GLOBAL_LIST_INIT(spellbook_theme_flavor_ru, list(
	FORM_FIRE = "От её страниц исходит слабый жар, а все руны едва заметно подпалены.",
	FORM_ICE = "Её страницы холодны на ощупь и покрыты инеем, что никогда толком не тает.",
	FORM_LIGHTNING = "Стоит открыть обложку, как между рун начинают ползать крошечные искры.",
	FORM_EARTH = "Её переплёт прошит тонкими рудными жилами и тяжёл, что речной камень.",
	FORM_ARCANE = "Её письмо складывается само в себя так, что глаз не поспевает уследить.",
	FORM_DEATH = "Над её страницами витает слабый могильный холод.",
	FORM_LIFE = "По её полям вьётся тонкая живая зелёная вязь.",
	FORM_AIR = "Её страницы тихо шелестят даже в полном безветрии.",
	FORM_WATER = "На обложке выступает испарина, как бы сухо ни было в комнате.",
	FORM_BLOOD = "Приторный запах металла липнет к страницам, между которыми без конца сочится кровь.",
))

/// Walks up the type tree so a subtype that only exists to carry stats still
/// resolves to its parent's translation. Only the handful of procs below may
/// use this: the generic hook stays on an exact-type lookup, because a subtype
/// with a genuinely different desc would otherwise silently inherit the wrong
/// Russian text instead of falling back to its own English.
/proc/examine_description_for_type(atom_type)
	if(!GLOB.examine_descriptions_loaded)
		load_examine_descriptions()
	for(var/path = atom_type, ispath(path), path = type2parent(path))
		var/found = GLOB.examine_descriptions[path]
		if(found)
			return found
	return null

/obj/item/spellbook/get_examine_desc(mob/user)
	if(ui_lang_code(user?.client) != UI_LANG_CODE_RU)
		return ..()
	var/base = examine_description_for_type(type)
	if(!base)
		return ..()
	var/flavor = themed_form ? GLOB.spellbook_theme_flavor_ru[themed_form] : null
	return flavor ? "[base] [flavor]" : base

/obj/structure/flora/grass/herb/get_examine_desc(mob/user)
	if(ui_lang_code(user?.client) != UI_LANG_CODE_RU)
		return ..()
	return "Трава. С виду похожа на [name]."

/obj/item/ration/get_examine_desc(mob/user)
	if(!food || ui_lang_code(user?.client) != UI_LANG_CODE_RU)
		return ..()
	if(food.w_class >= WEIGHT_CLASS_NORMAL)
		return "Большой паёк; внутри — [food.name]."
	return "Малый паёк; внутри — [food.name]."

/obj/item/slapcraft_assembly/get_examine_desc(mob/user)
	if(!recipe || ui_lang_code(user?.client) != UI_LANG_CODE_RU)
		return ..()
	return "Похоже, это незаконченный [recipe.name]."

/obj/structure/wild_plant/get_examine_desc(mob/user)
	if(!plant_type || ui_lang_code(user?.client) != UI_LANG_CODE_RU)
		return ..()
	return "Дикая поросль: [plant_type.name]."
