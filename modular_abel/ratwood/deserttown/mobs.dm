/mob/living/simple_animal/hostile/retaliate/camel
	icon = 'modular_abel/ratwood/icons/deserttown/camel.dmi'
	name = "camel"
	desc = "A humped beast of the dunes, sour of temper and tireless of stride."
	icon_state = "camel"
	icon_living = "camel"
	icon_dead = "camel_dead"
	gender = FEMALE
	mob_biotypes = MOB_ORGANIC|MOB_BEAST
	emote_see = list("looks around.", "chews some leaves.")
	speak_chance = 1
	see_in_dark = 6
	lighting_alpha = LIGHTING_PLANE_ALPHA_MOSTLY_VISIBLE
	move_to_delay = 8
	animal_species = /mob/living/simple_animal/hostile/retaliate/camel
	botched_butcher_results = list(/obj/item/reagent_containers/food/snacks/meat/steak = 2,
						/obj/item/natural/hide = 2)
	butcher_results = list(/obj/item/reagent_containers/food/snacks/meat/steak = 3,
						/obj/item/reagent_containers/food/snacks/fat = 2,
						/obj/item/natural/hide = 3)
	perfect_butcher_results = list(/obj/item/reagent_containers/food/snacks/meat/steak = 4,
						/obj/item/reagent_containers/food/snacks/fat = 2,
						/obj/item/natural/hide = 3,
						/obj/item/natural/fur = 2)
	base_intents = list(/datum/intent/simple/headbutt)
	health = 156
	maxHealth = 156
	food_type = list(/obj/item/reagent_containers/food/snacks/produce/grain/wheat,
					/obj/item/reagent_containers/food/snacks/produce/grain/oat,
					/obj/item/reagent_containers/food/snacks/produce/fruit/apple)
	tame_chance = 25
	bonus_tame_chance = 15
	footstep_type = FOOTSTEP_MOB_SHOE
	pooptype = /obj/item/natural/poo/horse
	faction = list("saiga")
	attack_verb_continuous = "headbutts"
	attack_verb_simple = "headbutt"
	melee_damage_lower = 10
	melee_damage_upper = 25
	retreat_distance = 10
	minimum_distance = 10
	attack_sound = list('sound/vo/mobs/saiga/attack (1).ogg', 'sound/vo/mobs/saiga/attack (2).ogg')
	can_buckle = TRUE
	buckle_lying = 0
	can_saddle = TRUE
	remains_type = /obj/effect/decal/remains/saiga
	ai_controller = /datum/ai_controller/saiga

/mob/living/simple_animal/hostile/retaliate/camel/update_icon()
	cut_overlays()
	..()
	if(stat != DEAD)
		if(ssaddle)
			var/mutable_appearance/saddlet = mutable_appearance(icon, "saddle-c-above", 4.3)
			add_overlay(saddlet)
			saddlet = mutable_appearance(icon, "saddle-c")
			add_overlay(saddlet)
		if(has_buckled_mobs())
			var/mutable_appearance/mounted = mutable_appearance(icon, "camel_mounted", 4.3)
			add_overlay(mounted)

/mob/living/simple_animal/hostile/retaliate/camel/Initialize()
	. = ..()
	AddElement(/datum/element/ai_retaliate)

/mob/living/simple_animal/hostile/retaliate/camel/tamed(mob/user)
	. = ..()
	deaggroprob = 30
	if(.)
		return
	if(can_buckle)
		AddElement(/datum/element/ridable, /datum/component/riding/creature/saiga)

/mob/living/simple_animal/hostile/retaliate/camel/get_sound(input)
	switch(input)
		if("aggro")
			return pick('sound/vo/mobs/saiga/attack (1).ogg', 'sound/vo/mobs/saiga/attack (2).ogg')
		if("pain")
			return pick('sound/vo/mobs/saiga/pain (1).ogg', 'sound/vo/mobs/saiga/pain (2).ogg', 'sound/vo/mobs/saiga/pain (3).ogg')
		if("death")
			return pick('sound/vo/mobs/saiga/death (1).ogg', 'sound/vo/mobs/saiga/death (2).ogg')
		if("idle")
			return pick('sound/vo/mobs/saiga/idle (1).ogg', 'sound/vo/mobs/saiga/idle (2).ogg', 'sound/vo/mobs/saiga/idle (3).ogg', 'sound/vo/mobs/saiga/idle (4).ogg', 'sound/vo/mobs/saiga/idle (5).ogg', 'sound/vo/mobs/saiga/idle (6).ogg', 'sound/vo/mobs/saiga/idle (7).ogg')

/mob/living/simple_animal/hostile/retaliate/camel/death()
	unbuckle_all_mobs()
	. = ..()

/mob/living/simple_animal/hostile/retaliate/camel/tame
	tame = TRUE

/mob/living/simple_animal/hostile/retaliate/camel/tame/saddled/Initialize()
	. = ..()
	var/obj/item/natural/saddle/S = new(src)
	ssaddle = S
	update_icon()

/mob/living/simple_animal/hostile/retaliate/hyena
	icon = 'modular_abel/ratwood/icons/deserttown/Hyena.dmi'
	name = "hyena"
	desc = "Usually content to leave menfolk alone if well-fed, but something in the wilds turns them hungry, persistent, and vicious."
	icon_state = "yeen"
	icon_living = "yeen"
	icon_dead = "yeend"
	faction = list("orcs", "wolfs")
	emote_hear = null
	emote_see = null
	see_in_dark = 9
	move_to_delay = 2
	vision_range = 9
	aggro_vision_range = 9
	butcher_results = list(/obj/item/reagent_containers/food/snacks/meat/steak = 2,
						/obj/item/natural/hide = 2,
						/obj/item/natural/fur = 1)
	health = 100
	maxHealth = 100
	food_type = list(/obj/item/reagent_containers/food/snacks/meat,
					/obj/item/bodypart,
					/obj/item/organ)
	base_intents = list(/datum/intent/simple/bite)
	attack_sound = list('sound/vo/mobs/vw/attack (1).ogg', 'sound/vo/mobs/vw/attack (2).ogg', 'sound/vo/mobs/vw/attack (3).ogg', 'sound/vo/mobs/vw/attack (4).ogg')
	melee_damage_lower = 15
	melee_damage_upper = 20
	simple_detect_bonus = 20
	retreat_distance = 0
	minimum_distance = 0
	deaggroprob = 0
	defprob = 35
	del_on_deaggro = 44 SECONDS
	retreat_health = 0.4
	dodgetime = 17
	remains_type = /obj/effect/decal/remains/hyena
	ai_controller = /datum/ai_controller/volf

/obj/effect/decal/remains/hyena
	name = "remains"
	gender = PLURAL
	icon_state = "bones"
	icon = 'icons/roguetown/mob/monster/vol.dmi'

/mob/living/simple_animal/hostile/retaliate/hyena/Initialize()
	. = ..()
	AddElement(/datum/element/ai_retaliate)
	AddElement(/datum/element/ai_flee_while_injured, 0.75, retreat_health)
	gender = MALE
	if(prob(33))
		gender = FEMALE
	ADD_TRAIT(src, TRAIT_CRITICAL_WEAKNESS, TRAIT_GENERIC)
	update_icon()

/mob/living/simple_animal/hostile/retaliate/hyena/death(gibbed)
	..()
	update_icon()

/mob/living/simple_animal/hostile/retaliate/hyena/get_sound(input)
	switch(input)
		if("aggro")
			return pick('sound/vo/mobs/vw/aggro (1).ogg', 'sound/vo/mobs/vw/aggro (2).ogg')
		if("pain")
			return pick('sound/vo/mobs/vw/pain (1).ogg', 'sound/vo/mobs/vw/pain (2).ogg', 'sound/vo/mobs/vw/pain (3).ogg')
		if("death")
			return pick('sound/vo/mobs/vw/death (1).ogg', 'sound/vo/mobs/vw/death (2).ogg', 'sound/vo/mobs/vw/death (3).ogg', 'sound/vo/mobs/vw/death (4).ogg', 'sound/vo/mobs/vw/death (5).ogg')
		if("idle")
			return pick('sound/vo/mobs/vw/idle (1).ogg', 'sound/vo/mobs/vw/idle (2).ogg', 'sound/vo/mobs/vw/idle (3).ogg', 'sound/vo/mobs/vw/idle (4).ogg')
		if("cidle")
			return pick('sound/vo/mobs/vw/bark (1).ogg', 'sound/vo/mobs/vw/bark (2).ogg', 'sound/vo/mobs/vw/bark (3).ogg', 'sound/vo/mobs/vw/bark (4).ogg', 'sound/vo/mobs/vw/bark (5).ogg', 'sound/vo/mobs/vw/bark (6).ogg', 'sound/vo/mobs/vw/bark (7).ogg')

/mob/living/simple_animal/hostile/retaliate/hyena/simple_limb_hit(zone)
	if(!zone)
		return ""
	switch(zone)
		if(BODY_ZONE_PRECISE_R_EYE)
			return "head"
		if(BODY_ZONE_PRECISE_L_EYE)
			return "head"
		if(BODY_ZONE_PRECISE_NOSE)
			return "nose"
		if(BODY_ZONE_PRECISE_MOUTH)
			return "mouth"
		if(BODY_ZONE_PRECISE_SKULL)
			return "head"
		if(BODY_ZONE_PRECISE_EARS)
			return "head"
		if(BODY_ZONE_PRECISE_NECK)
			return "neck"
		if(BODY_ZONE_PRECISE_L_HAND)
			return "foreleg"
		if(BODY_ZONE_PRECISE_R_HAND)
			return "foreleg"
		if(BODY_ZONE_PRECISE_L_FOOT)
			return "leg"
		if(BODY_ZONE_PRECISE_R_FOOT)
			return "leg"
		if(BODY_ZONE_PRECISE_STOMACH)
			return "stomach"
		if(BODY_ZONE_PRECISE_GROIN)
			return "tail"
		if(BODY_ZONE_HEAD)
			return "head"
		if(BODY_ZONE_R_LEG)
			return "leg"
		if(BODY_ZONE_L_LEG)
			return "leg"
		if(BODY_ZONE_R_ARM)
			return "foreleg"
		if(BODY_ZONE_L_ARM)
			return "foreleg"
	return ..()
