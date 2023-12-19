ITEM.name = "Wound"
ITEM.description = "One of your character's (hopefully) many wounds! Treat it well."
ITEM.model = Model("models/Gibs/HGIBS.mdl")
ITEM.category = "Wounds"
ITEM.WoundCureAMT = 5
ITEM.functions.toggle = {
	name = "Toggle",
	tip = "useTip",
	icon = "icon16/connect.png",
	OnRun = function(item)
		item.player:SetWoundSlots(item.WoundCureAMT, false)

		return true
	end
}