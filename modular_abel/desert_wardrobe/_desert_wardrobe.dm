/obj/item/clothing/face/exoticsilk
	abstract_type = /obj/item/clothing/face/exoticsilk
	name = "silk veil"
	desc = "A veil of fine silk, worn across the lower face."
	icon = 'modular_abel/desert_wardrobe/icons/desert_wardrobe_world.dmi'
	mob_overlay_icon = 'modular_abel/desert_wardrobe/icons/desert_wardrobe_onmob.dmi'

/obj/item/clothing/head/tagelmust
	name = "tagelmust"
	desc = "A long indigo cloth wound round the head and across the face, leaving a band for the eyes."
	icon = 'modular_abel/desert_wardrobe/icons/desert_wardrobe_world.dmi'
	mob_overlay_icon = 'modular_abel/desert_wardrobe/icons/desert_wardrobe_onmob.dmi'
	icon_state = "blue_hood"
	sellprice = 45

/obj/item/clothing/head/turban/fancypurple
	name = "fancy purple turban"
	desc = "A turban of dyed purple silk, wound high and pinned with more care than the weather requires."
	icon = 'modular_abel/desert_wardrobe/icons/desert_wardrobe_world.dmi'
	mob_overlay_icon = 'modular_abel/desert_wardrobe/icons/desert_wardrobe_onmob.dmi'
	icon_state = "purple_hood"
	sellprice = 55

/obj/item/clothing/head/magoshat
	name = "zybantine magos hat"
	desc = "A tall curled hat in the zybantine fashion, worn by magi who want the ceiling to know it."
	icon = 'modular_abel/desert_wardrobe/icons/desert_wardrobe_world.dmi'
	mob_overlay_icon = 'modular_abel/desert_wardrobe/icons/desert_wardrobe_onmob48.dmi'
	icon_state = "jafar"
	sellprice = 70

/obj/item/clothing/shirt/robe/bisht
	name = "bisht"
	desc = "A loose open robe of undyed wool, worn over everything else against sun and sand alike."
	icon = 'modular_abel/desert_wardrobe/icons/desert_wardrobe_world.dmi'
	mob_overlay_icon = 'modular_abel/desert_wardrobe/icons/desert_wardrobe_onmob.dmi'
	icon_state = "greythawb"
	sellprice = 45

/obj/item/clothing/shirt/robe/bisht/grey
	name = "grey bisht"
	desc = "The same cut in grey, favoured where the dust is the colour of the road."
	icon = 'modular_abel/desert_wardrobe/icons/desert_wardrobe_world.dmi'
	mob_overlay_icon = 'modular_abel/desert_wardrobe/icons/desert_wardrobe_onmob.dmi'
	icon_state = "bluethawb"
	sellprice = 45

/obj/item/clothing/shirt/robe/bisht/purple
	name = "purple bisht"
	desc = "A bisht dyed deep purple. The dye costs more than the wool and both parties know it."
	icon = 'modular_abel/desert_wardrobe/icons/desert_wardrobe_world.dmi'
	mob_overlay_icon = 'modular_abel/desert_wardrobe/icons/desert_wardrobe_onmob.dmi'
	icon_state = "purplethawb"
	sellprice = 70

/obj/item/clothing/shirt/robe/bisht/guild
	name = "guild bisht"
	desc = "A merchant's bisht, trimmed at the hem with the banding of a trade house."
	icon = 'modular_abel/desert_wardrobe/icons/desert_wardrobe_world.dmi'
	mob_overlay_icon = 'modular_abel/desert_wardrobe/icons/desert_wardrobe_onmob.dmi'
	icon_state = "merbisht"
	sellprice = 80

/obj/item/clothing/shirt/dress/thawb
	name = "thawb"
	desc = "An ankle-length robe of light cloth, cut loose enough that the heat has somewhere to go."
	icon = 'modular_abel/desert_wardrobe/icons/desert_wardrobe_world.dmi'
	mob_overlay_icon = 'modular_abel/desert_wardrobe/icons/desert_wardrobe_onmob.dmi'
	icon_state = "thawb"
	sellprice = 40

/obj/item/clothing/shirt/dress/thawb/gold
	name = "gold-trimmed thawb"
	desc = "A thawb with gold thread worked along the collar and cuff, for a household that entertains."
	icon = 'modular_abel/desert_wardrobe/icons/desert_wardrobe_world.dmi'
	mob_overlay_icon = 'modular_abel/desert_wardrobe/icons/desert_wardrobe_onmob.dmi'
	icon_state = "thawbgold"
	sellprice = 75

/obj/item/clothing/pants/sirwal
	name = "sirwal"
	desc = "Wide trousers gathered at the ankle, cut for riding and for sitting cross-legged afterwards."
	icon = 'modular_abel/desert_wardrobe/icons/desert_wardrobe_world.dmi'
	mob_overlay_icon = 'modular_abel/desert_wardrobe/icons/desert_wardrobe_onmob.dmi'
	icon_state = "sirwal"
	sellprice = 35

/obj/item/clothing/shirt/exoticsilkbra/green
	name = "green silk bra"
	desc = "A band of fine green silk, more costly than it looks and looking exactly as it costs."
	icon = 'modular_abel/desert_wardrobe/icons/desert_wardrobe_world.dmi'
	mob_overlay_icon = 'modular_abel/desert_wardrobe/icons/desert_wardrobe_onmob.dmi'
	icon_state = "exoticsilkbrag"
	sellprice = 60

/obj/item/clothing/shirt/exoticsilkbra/red
	name = "red silk bra"
	desc = "The same in red, which is the colour people remember."
	icon = 'modular_abel/desert_wardrobe/icons/desert_wardrobe_world.dmi'
	mob_overlay_icon = 'modular_abel/desert_wardrobe/icons/desert_wardrobe_onmob.dmi'
	icon_state = "exoticsilkbrar"
	sellprice = 60

/obj/item/clothing/face/exoticsilk/green
	name = "green silk veil"
	desc = "A veil of green silk pinned below the eyes. It hides a face and flatters what is left of it."
	icon_state = "exoticsilkmaskg"
	sellprice = 55

/obj/item/clothing/face/exoticsilk/red
	name = "red silk veil"
	desc = "A red silk veil worn across the face, sheer enough to be a suggestion rather than a barrier."
	icon_state = "exoticsilkmaskr"
	sellprice = 55

/datum/loadout_item/desert_wardrobe
	abstract_type = /datum/loadout_item/desert_wardrobe
	ui_category = LOADOUT_PANEL_CATEGORY_DESERT

/datum/loadout_item/desert_wardrobe/tagelmust
	name = "Tagelmust"
	item_path = /obj/item/clothing/head/tagelmust
	triumph_cost_permanent = 75

/datum/loadout_item/desert_wardrobe/turban_purple
	name = "Fancy Purple Turban"
	item_path = /obj/item/clothing/head/turban/fancypurple
	triumph_cost_permanent = 100

/datum/loadout_item/desert_wardrobe/magoshat
	name = "Zybantine Magos Hat"
	item_path = /obj/item/clothing/head/magoshat
	triumph_cost_permanent = 125

/datum/loadout_item/desert_wardrobe/bisht
	name = "Bisht"
	item_path = /obj/item/clothing/shirt/robe/bisht
	triumph_cost_permanent = 75

/datum/loadout_item/desert_wardrobe/bisht_grey
	name = "Grey Bisht"
	item_path = /obj/item/clothing/shirt/robe/bisht/grey
	triumph_cost_permanent = 75

/datum/loadout_item/desert_wardrobe/bisht_purple
	name = "Purple Bisht"
	item_path = /obj/item/clothing/shirt/robe/bisht/purple
	triumph_cost_permanent = 125

/datum/loadout_item/desert_wardrobe/bisht_guild
	name = "Guild Bisht"
	item_path = /obj/item/clothing/shirt/robe/bisht/guild
	triumph_cost_permanent = 150

/datum/loadout_item/desert_wardrobe/thawb
	name = "Thawb"
	item_path = /obj/item/clothing/shirt/dress/thawb
	triumph_cost_permanent = 60

/datum/loadout_item/desert_wardrobe/thawb_gold
	name = "Gold-Trimmed Thawb"
	item_path = /obj/item/clothing/shirt/dress/thawb/gold
	triumph_cost_permanent = 125

/datum/loadout_item/desert_wardrobe/sirwal
	name = "Sirwal"
	item_path = /obj/item/clothing/pants/sirwal
	triumph_cost_permanent = 50

/datum/loadout_item/desert_wardrobe/silkbra_green
	name = "Green Silk Bra"
	item_path = /obj/item/clothing/shirt/exoticsilkbra/green
	triumph_cost_permanent = 100

/datum/loadout_item/desert_wardrobe/silkbra_red
	name = "Red Silk Bra"
	item_path = /obj/item/clothing/shirt/exoticsilkbra/red
	triumph_cost_permanent = 100

/datum/loadout_item/desert_wardrobe/silkveil_green
	name = "Green Silk Veil"
	item_path = /obj/item/clothing/face/exoticsilk/green
	triumph_cost_permanent = 90

/datum/loadout_item/desert_wardrobe/silkveil_red
	name = "Red Silk Veil"
	item_path = /obj/item/clothing/face/exoticsilk/red
	triumph_cost_permanent = 90
