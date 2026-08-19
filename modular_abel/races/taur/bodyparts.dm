/obj/item/bodypart/taur
	name = "taur"
	desc = ""
	icon = 'modular_abel/races/icons/taurs.dmi'
	icon_state = ""
	max_damage = 300
	body_zone = BODY_ZONE_TAUR
	body_part = LEGS
	body_damage_coeff = 1
	px_x = -16
	px_y = 12
	subtargets = list(BODY_ZONE_L_LEG, BODY_ZONE_PRECISE_L_FOOT, BODY_ZONE_R_LEG, BODY_ZONE_PRECISE_R_FOOT)
	grabtargets = list(BODY_ZONE_L_LEG, BODY_ZONE_PRECISE_L_FOOT, BODY_ZONE_R_LEG, BODY_ZONE_PRECISE_R_FOOT)

	var/offset_x = -16
	var/offset_y = 0
	var/body_offset_y = 0
	/// Pixels added to the penis/testicles/vagina overlays, left/right.
	var/genital_offset_x = 0
	/// Pixels added to the penis/testicles/vagina overlays. Negative sits them lower, toward the belly.
	var/genital_offset_y = -10
	var/bellyride_victim_y_offset = 0
	var/bellyride_quadruped = FALSE
	var/taur_icon_state = "naga_s"
	var/taur_markings_state = null
	var/taur_tertiary_state = null

	var/has_taur_color = FALSE
	var/color_blend_mode = BLEND_ADD
	var/taur_color = null
	var/taur_markings = null
	var/taur_tertiary = null

	var/icon/clip_mask_icon = 'modular_abel/races/icons/taurs.dmi'
	var/clip_mask_state = "taur_clip_mask_def"
	var/tmp/icon/clip_mask

/obj/item/bodypart/taur/New()
	. = ..()
	if(clip_mask_state)
		clip_mask = icon(icon = (clip_mask_icon || icon), icon_state = clip_mask_state)

/obj/item/bodypart/taur/get_limb_icon(dropped, hideaux = FALSE)
	. = list()
	var/image_dir = 0
	if(dropped)
		image_dir = SOUTH

	var/icon/tail_s = new /icon("icon" = icon, "icon_state" = taur_icon_state, "dir" = image_dir)
	if(has_taur_color && taur_color)
		tail_s.Blend(taur_color, color_blend_mode)
	var/image/working = image(tail_s)
	working.layer = -BODYPARTS_LAYER
	working.pixel_x = offset_x
	working.pixel_y = offset_y
	. += working

	if(taur_markings_state)
		var/icon/taur_m = new /icon("icon" = icon, "icon_state" = taur_markings_state, "dir" = image_dir)
		if(has_taur_color && taur_markings)
			taur_m.Blend(taur_markings, color_blend_mode)
		var/image/markings = image(taur_m)
		markings.layer = -BODY_ADJ_LAYER
		markings.pixel_x = offset_x
		markings.pixel_y = offset_y
		. += markings

	if(taur_tertiary_state)
		var/icon/taur_t = new /icon("icon" = icon, "icon_state" = taur_tertiary_state, "dir" = image_dir)
		if(has_taur_color && taur_tertiary)
			taur_t.Blend(taur_tertiary, color_blend_mode)
		var/image/tertiary = image(taur_t)
		tertiary.layer = -BODY_ADJ_LAYER
		tertiary.pixel_x = offset_x
		tertiary.pixel_y = offset_y
		. += tertiary

GLOBAL_LIST_INIT(taur_types, subtypesof(/obj/item/bodypart/taur))

/obj/item/bodypart/taur/lamia
	name = "Lamia Tail"
	taur_icon_state = "altnaga_s"
	taur_markings_state = "naga_tail_markings_lamian_tail"
	has_taur_color = TRUE

/obj/item/bodypart/taur/lamiastriped
	name = "Striped Lamia Tail"
	taur_icon_state = "altnaga_s"
	taur_markings_state = "naga_tail_markings_lamian_tail"
	taur_tertiary_state = "nagastriped_markings"
	has_taur_color = TRUE

/obj/item/bodypart/taur/fatlamia
	name = "Fat Lamia Tail"
	taur_icon_state = "nagafat_s"
	taur_markings_state = "nagafat_markings"
	has_taur_color = TRUE

/obj/item/bodypart/taur/mermaid
	name = "Mermaid Tail"
	taur_icon_state = "altmermaid_s"
	taur_markings_state = "altmermaid_markings"
	taur_tertiary_state = "altmermaid_markings2"
	has_taur_color = TRUE

/obj/item/bodypart/taur/orca
	name = "Orca Tail"
	taur_icon_state = "orcamermaid_s"
	has_taur_color = TRUE

/obj/item/bodypart/taur/tentacle
	name = "Tentacles"
	taur_icon_state = "tentacle_s"
	taur_markings_state = "tentacle_markings"
	has_taur_color = TRUE

/obj/item/bodypart/taur/otie
	name = "Otie Body"
	bellyride_quadruped = TRUE
	taur_icon_state = "otie_s"
	taur_markings_state = "otie_markings"
	taur_tertiary_state = "otie_markings_2"
	has_taur_color = TRUE

/obj/item/bodypart/taur/canine
	name = "Canine Body"
	bellyride_quadruped = TRUE
	taur_icon_state = "canine_s"
	taur_markings_state = "canine_markings"
	taur_tertiary_state = "canine_markings_2"
	has_taur_color = TRUE

/obj/item/bodypart/taur/venard
	name = "Venard Body"
	bellyride_quadruped = TRUE
	taur_icon_state = "venard_s"
	taur_markings_state = "venard_markings"
	taur_tertiary_state = "venard_markings_2"
	has_taur_color = TRUE

/obj/item/bodypart/taur/drake
	name = "Drake Body"
	bellyride_quadruped = TRUE
	taur_icon_state = "drake_s"
	taur_markings_state = "drake_markings"
	has_taur_color = TRUE

/obj/item/bodypart/taur/dragon
	name = "Dragon Body"
	bellyride_quadruped = TRUE
	taur_icon_state = "drake2_s"
	taur_markings_state = "drake2_markings"
	taur_tertiary_state = "drake2_markings_2"
	has_taur_color = TRUE

/obj/item/bodypart/taur/noodle
	name = "Noodle Dragon Body"
	bellyride_quadruped = TRUE
	taur_icon_state = "noodle_s"
	taur_markings_state = "noodle_markings"
	taur_tertiary_state = "noodle_markings_2"
	has_taur_color = TRUE

/obj/item/bodypart/taur/horse
	name = "Saiga Body"
	bellyride_quadruped = TRUE
	taur_icon_state = "saiga_s"
	clip_mask_state = "clip_mask_saiga"
	has_taur_color = TRUE

/obj/item/bodypart/taur/deer
	name = "Deer Body"
	bellyride_quadruped = TRUE
	taur_icon_state = "deer_s"
	taur_markings_state = "deer_markings"
	has_taur_color = TRUE

/obj/item/bodypart/taur/redpanda
	name = "Red Panda Body"
	bellyride_quadruped = TRUE
	taur_icon_state = "redpanda_s"
	taur_markings_state = "redpanda_markings"
	has_taur_color = TRUE

/obj/item/bodypart/taur/rat
	name = "Rat Body"
	bellyride_quadruped = TRUE
	taur_icon_state = "rat_s"
	taur_markings_state = "rat_markings"
	has_taur_color = TRUE

/obj/item/bodypart/taur/skunk
	name = "Skunk Body"
	bellyride_quadruped = TRUE
	taur_icon_state = "skunk_s"
	taur_markings_state = "skunk_markings"
	taur_tertiary_state = "skunk_markings_2"
	has_taur_color = TRUE

/obj/item/bodypart/taur/kitsune
	name = "Kitsune Body"
	bellyride_quadruped = TRUE
	taur_icon_state = "kitsune_s"
	taur_markings_state = "kitsune_markings"
	taur_tertiary_state = "kitsune_markings_2"
	has_taur_color = TRUE

/obj/item/bodypart/taur/feline
	name = "Feline Body"
	bellyride_quadruped = TRUE
	taur_icon_state = "feline_s"
	taur_markings_state = "feline_markings"
	taur_tertiary_state = "feline_markings_2"
	has_taur_color = TRUE

/obj/item/bodypart/taur/snep
	name = "Tempest Body"
	bellyride_quadruped = TRUE
	taur_icon_state = "tempest_s"
	taur_markings_state = "feline_markings"
	taur_tertiary_state = "feline_markings_2"
	has_taur_color = TRUE

/obj/item/bodypart/taur/tiger
	name = "Tiger Body"
	bellyride_quadruped = TRUE
	taur_icon_state = "feline_s"
	taur_markings_state = "tiger_markings"
	taur_tertiary_state = "tiger_markings_2"
	has_taur_color = TRUE

/obj/item/bodypart/taur/spider
	name = "Spider Body"
	taur_icon_state = "spider_s"
	taur_markings_state = "spider_markings"
	taur_tertiary_state = "spider_markings_2"
	has_taur_color = TRUE

/obj/item/bodypart/taur/arachne
	name = "Arachne Body"
	px_y = 10
	taur_icon_state = "arachne_s"
	taur_markings_state = "arachne_markings"
	taur_tertiary_state = "arachne_markings_2"
	has_taur_color = TRUE

/obj/item/bodypart/taur/centipede
	name = "Centipede Body"
	bellyride_quadruped = TRUE
	taur_icon_state = "centipede_s"
	taur_markings_state = "centipede_markings"
	taur_tertiary_state = "centipede_markings_2"
	has_taur_color = TRUE

/obj/item/bodypart/taur/sloog
	name = "Sloog Body"
	taur_icon_state = "sloog_s"
	taur_markings_state = "sloog_markings"
	has_taur_color = TRUE

/obj/item/bodypart/taur/ant
	name = "Ant Body"
	taur_icon_state = "ant_s"
	taur_markings_state = "ant_markings"
	has_taur_color = TRUE

/obj/item/bodypart/taur/wasp
	name = "Wasp Body"
	taur_icon_state = "wasp_s"
	taur_markings_state = "wasp_markings"
	has_taur_color = TRUE

/obj/item/bodypart/taur/insect
	name = "Insect Body"
	taur_icon_state = "insect_s"
	taur_markings_state = "insect_markings"
	taur_tertiary_state = "insect_markings_2"
	has_taur_color = TRUE

/obj/item/bodypart/taur/jdeer
	icon = 'modular_abel/races/icons/taur2.dmi'
	name = "Large Deer Body"
	bellyride_quadruped = TRUE
	body_offset_y = 17
	bellyride_victim_y_offset = 3
	taur_icon_state = "jdeer_s"
	taur_markings_state = "jdeer_markings"
	has_taur_color = TRUE
