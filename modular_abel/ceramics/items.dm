// Fired ceramic vessels.
// Ported from Azure-Peak code/game/objects/items/rogueitems/ceramics.dm, added upstream
// after Vibelin PR #5.
//
// Azure's ceramics is a two-stage system: a wheel recipe makes an unfired /obj/item/natural/clay
// subtype, which a kiln then fires into the finished vessel. Vanderlin's own pottery wheel
// (code/datums/pottery_recipes/) hands the finished item straight back, so only the fired
// halves are ported and the recipes in recipes.dm plug into that system instead.
//
// Azure's glaze_bonus_pct belongs to its glazing mechanic, which Vanderlin does not have,
// so it is dropped.

/obj/item/reagent_containers/glass/bottle/ceramic
	abstract_type = /obj/item/reagent_containers/glass/bottle/ceramic
	icon = 'modular_abel/ceramics/icons/ceramics.dmi'
	desc = "A fired clay vessel."
	reagent_flags = OPENCONTAINER
	spillable = TRUE
	amount_per_transfer_from_this = 10
	possible_transfer_amounts = list(5, 10, 20)
	grid_height = 64
	grid_width = 64
	dropshrink = 0.9
	sellprice = 12

/obj/item/reagent_containers/glass/bottle/ceramic/amphora
	name = "ceramic amphora"
	desc = "A large ceramic amphora, a vessel with an ancient design that originated off of Etrusca's coast."
	icon_state = "clayamphorabaked"
	volume = 200 // Amphoras can store large amounts of liquid.
	sellprice = 24

/obj/item/reagent_containers/glass/bottle/ceramic/tallvase
	name = "tall ceramic vase"
	desc = "A remarkably tall clay vessel for storing copious amounts of liquid."
	icon_state = "claytallvasebaked"
	volume = 160
	sellprice = 20

/obj/item/reagent_containers/glass/bottle/ceramic/bamana
	name = "ceramic bamana pot"
	desc = "A wide Naledian style pot that is useful for holding large amounts of liquid."
	icon_state = "claybamanabaked"
	volume = 130
	sellprice = 18

/obj/item/reagent_containers/glass/bottle/ceramic/standing
	name = "standing ceramic vase"
	desc = "A curious ceramic vessel with two humenoid legs helping it stand upright."
	icon_state = "clayfeetbaked"
	volume = 100
	sellprice = 16

/obj/item/reagent_containers/glass/bottle/ceramic/skinny
	name = "skinny ceramic vase"
	desc = "A skinny ceramic vessel that holds a meager amount of liquid."
	icon_state = "clayskinnybaked"
	volume = 35
	grid_height = 32
	grid_width = 32
	sellprice = 8
