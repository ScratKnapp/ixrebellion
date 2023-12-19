ITEM.name = "Buff Skill"
ITEM.description = "One of your character's (hopefully) many wounds! Treat it well."
ITEM.model = Model("models/Gibs/HGIBS.mdl")
ITEM.category = "Wounds"
ITEM.skill = "Test"
ITEM.Buff = 5
ITEM.functions.toggle = {
    name = "Toggle",
    tip = "useTip",
    icon = "icon16/connect.png",
    OnRun = function(item)
        item.player:AddSkillBoost(item.uniqueID, item.skill, item.buff)

        return true
    end
}