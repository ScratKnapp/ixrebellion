-------------------------------------------------------------------------------------------
ITEM.name = "Attributes Base"
-------------------------------------------------------------------------------------------
ITEM.description = " "
-------------------------------------------------------------------------------------------
ITEM.model = "models/props_lab/jar01b.mdl"
-------------------------------------------------------------------------------------------
ITEM.width = 1
-------------------------------------------------------------------------------------------
ITEM.height = 1
-------------------------------------------------------------------------------------------
ITEM.duration = 1200 --default duration
-------------------------------------------------------------------------------------------
--[[
ITEM.attribBoosts = { --attribute boosts
	[attribname] = 1,
}
--]]
-------------------------------------------------------------------------------------------
ITEM.functions._use = {
    name = "Use",
    icon = "icon16/pill.png",
    OnRun = function(item)
        local client = item.player
        local char = client:GetCharacter()
        if char and client:Alive() then
            if item.attribBoosts then
                for k, v in pairs(item.attribBoosts) do
                    char:AddBoost(item.uniqueID, k, v)
                end
            end

            local charID = char:GetID()
            local name = item.name
            timer.Create(
                "AttribEffect_" .. item.uniqueID .. "_" .. client:EntIndex(),
                item.duration,
                1,
                function()
                    if client and IsValid(client) then
                        local curChar = client:GetCharacter()
                        if curChar and curChar:GetID() == charID then
                            client:notify(Format("%s has worn off.", name))
                            if item.attribBoosts then
                                for k, v in pairs(item.attribBoosts) do
                                    char:RemoveBoost(item.uniqueID, k)
                                end
                            end
                        end
                    end
                end
            )
        end
    end,
    OnCanRun = function(item) return not IsValid(item.entity) end
}
-------------------------------------------------------------------------------------------F