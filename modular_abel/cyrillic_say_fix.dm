/proc/capitalize_utf8(t as text)
	if(!t)
		return t
	return uppertext(copytext_char(t, 1, 2)) + copytext_char(t, 2)

/mob/living/treat_message(message)
	. = ..()
	. = capitalize_utf8(.)

/mob/living/brain/treat_message(message)
	. = ..()
	. = capitalize_utf8(.)

/mob/dead/observer/profane/say(message, bubble_type, list/spans = list(), sanitize = TRUE, datum/language/language = null, ignore_spam = FALSE, forced = null)
	if(!message)
		return
	if(client)
		if(client.prefs.muted & MUTE_IC)
			to_chat(src, "<span class='boldwarning'>I cannot send IC messages (muted).</span>")
			return
		if(!(ignore_spam || forced) && src.client.handle_spam_prevention(message, MUTE_IC))
			return
	message = capitalize_utf8(trim(copytext_char(sanitize(message), 1, MAX_MESSAGE_LEN)))
	var/rendered = "<span class='say'><span class='name'>[name]</span> <span class='message'>[say_quote(message)]</span></span>"
	visible_message(message = rendered, self_message = FALSE, blind_message = rendered, vision_distance = 0)
