#define LOCALIZATION_STRINGS_DIR "modular_abel/localization/strings"
#define LOCALIZATION_DICT_VERSION 1
#define LOCALIZATION_SEPARATOR " = "

// The key /datum/asset/json registers itself under; the panel is handed the URL
// this resolves to, whichever transport SSassets is running.
#define CHAT_LOCALIZATION_ASSET "data/chat_localization.json"

GLOBAL_LIST_INIT(chat_noun_cases, list("nom", "gen", "dat", "acc", "ins", "pre"))

/datum/asset/json/chat_localization
	name = "chat_localization"

/datum/asset/json/chat_localization/generate()
	// items.txt first so nouns.txt wins a collision: it is the closed set of body
	// parts parse_zone() returns, and "chest" is a body part far more often than
	// it is a container.
	var/list/nouns = load_nouns("items.txt")
	nouns |= load_nouns("nouns.txt")

	var/list/fragments = load_pairs("fragments.txt")
	// descriptions.txt is deliberately absent: it is keyed by type and resolved
	// server-side in get_examine_desc(), so the panel never needs it.
	for(var/filename in list("speech.txt", "medical.txt", "world.txt", "status.txt"))
		fragments |= load_pairs(filename)

	return list(
		"version" = LOCALIZATION_DICT_VERSION,
		"nouns" = nouns,
		"fragments" = fragments,
		"patterns" = load_patterns("patterns.txt"),
	)

// Returns the file's "key = value" lines already split and trimmed, skipping
// blanks and # comments. A missing file degrades to nothing rather than raising,
// so a broken translation can never stop the round from booting.
/datum/asset/json/chat_localization/proc/read_pairs(filename)
	var/list/pairs = list()
	var/path = "[LOCALIZATION_STRINGS_DIR]/[filename]"
	if(!fexists(path))
		stack_trace("chat localization: missing strings file [path]")
		return pairs

	var/line_number = 0
	for(var/raw_line in splittext(file2text(path), "\n"))
		line_number++
		var/line = trim(raw_line)
		if(!length(line) || copytext(line, 1, 2) == "#")
			continue

		var/split_at = findtext(line, LOCALIZATION_SEPARATOR)
		if(!split_at)
			stack_trace("chat localization: [filename]:[line_number] has no \"[LOCALIZATION_SEPARATOR]\" separator, skipped")
			continue

		var/key = trim(copytext(line, 1, split_at))
		var/value = trim(copytext(line, split_at + length(LOCALIZATION_SEPARATOR)))
		if(!length(key) || !length(value))
			stack_trace("chat localization: [filename]:[line_number] has an empty key or value, skipped")
			continue

		// The only escape the format has, because a line break is the one thing a
		// line-based record cannot hold. 153 of the game's descs contain one.
		key = replacetext(key, "\\n", "\n")
		value = replacetext(value, "\\n", "\n")

		pairs += list(list(key, value))
	return pairs

/datum/asset/json/chat_localization/proc/load_pairs(filename)
	var/list/table = list()
	for(var/list/pair as anything in read_pairs(filename))
		table[pair[1]] = pair[2]
	return table

// Patterns stay an ordered list: the first one that matches wins, so the order
// the translator wrote them in is load-bearing.
/datum/asset/json/chat_localization/proc/load_patterns(filename)
	var/list/patterns = list()
	for(var/list/pair as anything in read_pairs(filename))
		patterns += list(list("re" = pair[1], "ru" = pair[2]))
	return patterns

/datum/asset/json/chat_localization/proc/load_nouns(filename)
	var/list/nouns = list()
	var/expected = length(GLOB.chat_noun_cases)

	for(var/list/pair as anything in read_pairs(filename))
		var/list/forms = splittext(pair[2], "|")
		if(length(forms) != expected)
			stack_trace("chat localization: [filename] entry \"[pair[1]]\" lists [length(forms)] forms, expected [expected]")
			continue

		var/list/cases = list()
		for(var/index in 1 to expected)
			var/form = trim(forms[index])
			if(length(form))
				cases[GLOB.chat_noun_cases[index]] = form
		if(length(cases))
			nouns[pair[1]] = cases
	return nouns

#undef LOCALIZATION_STRINGS_DIR
#undef LOCALIZATION_DICT_VERSION
#undef LOCALIZATION_SEPARATOR
