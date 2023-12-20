-- [[ COMMANDS ]] --
--[[
	COMMAND: /Roll
	DESCRIPTION: Allows the player to roll an arbitrary amount of dice and apply bonuses as needed.
]]
--
ix.command.Add(
	"Roll",
	{
		syntax = "<dice roll>",
		description = "Calculates a dice roll (e.g. 2d6 + 2) and shows the result.",
		arguments = {ix.type.text},
		OnRun = function(self, client, rolltext)
			result, rolltext = ix.dice.Roll(rolltext, client)
			ix.chat.Send(
				client,
				"rollgeneric",
				tostring(result),
				nil,
				nil,
				{
					roll = "( " .. rolltext .. " )"
				}
			)
		end
	}
)

ix.command.Add("RollStat", {
    description = "Leave fate to chance by rolling a random number with an attribute to boost your odds.",
    arguments = {ix.type.string, bit.bor(ix.type.number, ix.type.optional), bit.bor(ix.type.number, ix.type.optional)},
    OnRun = function(self, client, attribute, numDice, numSides)
        numDice = numDice or 1
        numSides = numSides or 20

        local totalValue = 0
        for i = 1, numDice do
            totalValue = totalValue + math.random(1, numSides)
        end

        local attributeTable
        local attributeIndex
        local attrVal = 0

        if attribute then
            for k, v in pairs(ix.attributes.list) do
                if string.lower(v.name) == string.lower(attribute) then
                    attributeTable = v
                    attributeIndex = k
                elseif k == string.lower(attribute) then
                    attributeTable = v
                    attributeIndex = k
                elseif v.alias and table.HasValue(v.alias, string.lower(attribute)) then
                    attributeTable = v
                    attributeIndex = k
                end
            end

            if attributeTable == nil then
                return "That is not a valid attribute!"
            end

            attrVal = client:GetCharacter():GetAttribute(attributeIndex, 0)
        end

        local critVal = 0 // -1 = crit fail, 0 = normal, 1 = crit success
        if totalValue == numDice * numSides then
            critVal = 1
        elseif totalValue == numDice then
            critVal = -1
        end

        ix.chat.Send(client, "rollstat", tostring(totalValue), nil, nil, {
            attrName = attributeTable and attributeTable.name or "",
            attrVal = attrVal,
            critVal = critVal,
            numDice = numDice,
            numSides = numSides
        })

        ix.log.Add(client, "rollstat", totalValue, attributeTable and attributeTable.name or "", attrVal, critVal, {
            attrName = attributeTable and attributeTable.name or "",
            attrVal = attrVal,
            critVal = critVal,
            numDice = numDice,
            numSides = numSides
        })
    end
})
--[[
	COMMAND: /RollStat
	DESCRIPTION: Rolls a d20 and applies modifiers to the dice roll for the stat provided.
]]
--[[
ix.command.Add("RollStat", {
	syntax = "<stat>",
	description = "Rolls and adds a bonus for the stat provided.",
	arguments = {
		ix.type.text
	},
	OnRun = function(self, client, stat)
		local character = client:GetCharacter()
		local statname
		local bonus = 0

		for k, v in pairs(ix.attributes.list) do
			if ix.util.StringMatches(k, stat) or ix.util.StringMatches(v.name, stat) then
				stat = k
				statname = v.name
				bonus = character:GetAttribute(stat, 0)
			end
		end

		if not (statname) then
			for k, v in pairs(ix.skills.list) do
				if ix.util.StringMatches(k, stat) or ix.util.StringMatches(v.name, stat) then
					stat = k
					statname = v.name
					bonus = character:GetSkill(stat, 0)
				end
			end
		end

		if not statname then client:Notify( "Provided stat is invalid." ) return end

		if (character and character:GetAttribute(stat, 0)) then
			local roll = tostring(math.random(1, 20))

			ix.chat.Send(client, "roll20", (roll + bonus).." ( "..roll.." + "..bonus.." )", nil, nil, {
				rolltype = statname
			})
		end
	end
})
--[[
	COMMAND: /RollAttack
	DESCRIPTION: Automatically makes an attack roll based on the weapon that the player is holding.
]]
--
--[[
ix.command.Add(
	"RollAttack",
	{
		syntax = nil,
		description = "Makes an attack roll and adds any modifiers.",
		arguments = nil,
		OnRun = function(self, client, stat)
			local critcolor = Color(255, 30, 30)
			local character = client:GetCharacter()
			local weapon = client:GetActiveWeapon()
			local statTable = weapon.ixItem.HRPGStats or weapon.HRPGStats
			if character and statTable then
				local bonus = character:GetAttribute(statTable.mainAttribute, 0)
				local roll = math.random(1, 20)
				local dmg = calcDice(statTable.rollDamage)
				local chatdata = {
					damage = dmg,
					color = nil
				}

				if roll == 20 then
					chatdata.damage = dmg * 2
					chatdata.color = critcolor
				end

				ix.chat.Send(client, "roll20attack", (roll + bonus) .. " ( " .. roll .. " + " .. bonus .. " )", nil, nil, chatdata)
			end
		end
	}
)
]]
--
--[[
ix.command.Add(
	"GetSkill",
	{
		syntax = "<skill>",
		description = "Gets a skill.",
		arguments = {ix.type.text},
		OnRun = function(self, client, skill)
			--[[for k, v in pairs( ix.skills.list ) do
			print(k)
			print(v)
		end]] 
--[[
			char = client:GetCharacter()
			skilltab = char:GetAttributes()
			if table.IsEmpty(skilltab) then
				print("Skill table is empty")
			else
				for k, v in pairs(skilltab) do
					print(k)
					print(v)
				end
			end
		end
	}
)

if SERVER then
	util.AddNetworkString("ixTestDerma")
else
	net.Receive(
		"ixTestDerma",
		function()
			local frame = vgui.Create("DFrame")
			frame:SetPos(500, 500)
			frame:SetSize(200, 300)
			frame:SetTitle("Frame")
			frame:MakePopup()
			local grid = vgui.Create("DGrid", frame)
			grid:SetPos(10, 30)
			grid:SetCols(5)
			grid:SetColWide(36)
			for i = 1, 30 do
				local but = vgui.Create("DButton")
				but:SetText(i)
				but:SetSize(30, 20)
				grid:AddItem(but)
			end
		end
	)
end
]] -- 

ix.command.Add(
	"DermaTest",
	{
		syntax = "",
		description = "Tests Derma",
		OnRun = function(self, client, skill)
			net.Start("ixTestDerma")
			net.Send(client)
		end
	}
)

--[[
	COMMAND: /RollMeleeAttack
	DESCRIPTION: Rolls a d20 and adds your strength plus your melee skill to the result..
]]
--
ix.command.Add(
	"RollMeleeAttack",
	{
		syntax = nil,
		description = "Rolls a d20 and adds your Strength plus your Melee skill modifiers to the result.",
		arguments = nil,
		OnRun = function(self, client, stat)
			local character = client:GetCharacter()
			local statname
			local bonus = character:GetAttribute("str", 0)
			local bonus2 = character:GetSkill("melee", 0)
			local roll = math.random(1, 20)
			ix.chat.Send(
				client,
				"roll20melee",
				(roll + bonus + bonus2) .. " ( " .. roll .. " + " .. bonus .. " + " .. bonus2 .. " )",
				nil,
				nil,
				{
					rolltype = statname
				}
			)
		end
	}
)

ix.command.Add(
	"GiveWoundHP",
	{
		arguments = {ix.type.player, ix.type.number},
		OnRun = function(self, client, target, points)
			target:SetWoundSlots(points, false)
			local newpoints = target:GetWoundSlots()
			ix.chat.Send(client, "effectannounce", client:GetCharacter():GetName() .. " has given " .. target:GetName() .. " " .. points.. " Wound Points. They now have " .. newpoints)
			ix.log.Add(client, "givehealth", target, points)
		end
	}
)

ix.command.Add(
	"GiveShieldHP",
	{
		arguments = {ix.type.player, ix.type.number},
		OnRun = function(self, client, target, points)
			target:SetShieldPoints(points, false)
			local newpoints = target:GetShieldPoints()
			ix.chat.Send(client, "effectannounce", client:GetCharacter():GetName() .. " has given " .. target:GetName() .. " " .. points.. " Shield Points. They now have " .. newpoints)
			ix.log.Add(client, "giveshields", target, points)
		end
	}
)

ix.command.Add(
	"SelfGiveWoundHP",
	{
		arguments = {ix.type.number},
		OnRun = function(self, client, points)
			client:SetWoundSlots(points, false)
			local newpoints = client:GetWoundSlots()
			ix.chat.Send(client, "effectannounce", client:GetCharacter():GetName() .. " has given themselves " .. points.. " Wound Points and now has " .. newpoints)
			ix.log.Add(client, "giveselfhealth", points)
		end
	}
)

ix.command.Add(
	"SelfGiveShieldHP",
	{
		arguments = {ix.type.number},
		OnRun = function(self, client, points)
			client:SetShieldPoints(points, false)
			local newpoints = client:GetShieldPoints()
			ix.chat.Send(client, "effectannounce", client:GetCharacter():GetName() .. " has given themselves " .. points.. " Shield Points and now has " .. newpoints)
			ix.log.Add(client, "giveselfshields", points)
		end
	}
)

ix.command.Add(
	"TakeWoundHP",
	{
		arguments = {ix.type.player, ix.type.number},
		OnRun = function(self, client, target, points)
			target:SetWoundSlots(points, true)
			local newpoints = target:GetWoundSlots()
			ix.chat.Send(client, "effectannounce", client:GetCharacter():GetName() .. " has has taken " .. points .. " Health Points from " .. target:GetName() .. ". They now have " .. newpoints)
			ix.log.Add(client, "takehealth", target, points)
		end
	}
)

ix.command.Add(
	"SelfTakeWoundHP",
	{
		arguments = {ix.type.number},
		OnRun = function(self, client, points)
			client:SetWoundSlots(points, true)
			local newpoints = client:GetWoundSlots()
			ix.chat.Send(client, "effectannounce", client:GetCharacter():GetName() .. " has removed " .. points.. " of their Wound Points and now has " .. newpoints)
			ix.log.Add(client, "takeselfhealth", points)
		end
	}
)

ix.command.Add(
	"TakeShieldHP",
	{
		arguments = {ix.type.player, ix.type.number},
		OnRun = function(self, client, target, points)
			target:SetShieldPoints(points, true)
			local newpoints = target:GetShieldPoints()
			ix.chat.Send(client, "effectannounce", client:GetCharacter():GetName() .. " has has taken " .. points .. " Shield Points from " .. target:GetName() .. ". They now have " .. newpoints)
			ix.log.Add(client, "takeshields", target, points)
		end
	}
)

ix.command.Add(
	"SelfTakeShieldHP",
	{
		arguments = {ix.type.number},
		OnRun = function(self, client, points)
			client:SetShieldPoints(points, true)
			local newpoints = client:GetShieldPoints()
			ix.chat.Send(client, "effectannounce", client:GetCharacter():GetName() .. " has removed " .. points.. " of their Shield Points and now has " .. newpoints)
			ix.log.Add(client, "takeselfshields", points)
		end
	}
)

ix.command.Add(
	"ViewCharacterSheet",
	{
		arguments = {ix.type.player},
		OnRun = function(self, client, target)
			net.Start("ViewSheet")
			net.WriteEntity(target)
			net.Send(client)
		end
	}
)

--[[
	COMMAND: /RollFirearmsAttack
	DESCRIPTION: Rolls a d20 and adds your dexterity plus your marksmanship skill to the result..
]]
--
ix.command.Add(
	"RollFirearmsAttack",
	{
		syntax = nil,
		description = "Rolls a d20 and adds your Dexterity plus your Marksmanship modifiers to the result.",
		arguments = nil,
		OnRun = function(self, client, stat)
			local character = client:GetCharacter()
			local statname
			local bonus = character:GetAttribute("dex", 0)
			local bonus2 = character:GetSkill("marksmanship", 0)
			local roll = math.random(1, 20)
			ix.chat.Send(
				client,
				"roll20firearms",
				(roll + bonus + bonus2) .. " ( " .. roll .. " + " .. bonus .. " + " .. bonus2 .. " )",
				nil,
				nil,
				{
					rolltype = statname
				}
			)
		end
	}
)

ix.command.Add(
	"RollFirearmsBurstAttack",
	{
		syntax = nil,
		description = "Rolls a d20 and adds your Dexterity plus your Marksmanship modifiers to the result.",
		arguments = nil,
		OnRun = function(self, client, stat)
			local character = client:GetCharacter()
			local statname
			local bonus = character:GetAttribute("dex", 0)
			local bonus2 = character:GetSkill("marksmanship", 0)
			local roll = math.random(1, 20)
      		local roll2 = math.random(1, 20)
      		local roll3 = math.random(1, 20)
			ix.chat.Send(
				client,
				"roll20firearmsburst1",
				(roll + bonus + bonus2 - 2) .. " ( " .. roll .. " + " .. bonus .. " + " .. bonus2 .. " - " .. 2 .. "  )",
				nil,
				nil,
				{
					rolltype = statname
				}
			)
      		ix.chat.Send(
				client,
				"roll20firearmsburst2",
				(roll2 + bonus + bonus2 - 4) .. " ( " .. roll2 .. " + " .. bonus .. " + " .. bonus2 .. " - " .. 4 .. " )",
				nil,
				nil,
				{
					rolltype = statname
				}
			)
      		ix.chat.Send(
				client,
				"roll20firearmsburst3",
				(roll3 + bonus + bonus2 - 6) .. " ( " .. roll3 .. " + " .. bonus .. " + " .. bonus2 .. " - " .. 6 .. " )",
				nil,
				nil,
				{
					rolltype = statname
				}
			)
		end
	}
)

--[[
	COMMAND: /RollBrawlingAttack
	DESCRIPTION: Rolls a d20 and adds your strength plus your brawling skill to the result..
]]
--
ix.command.Add(
	"RollBrawlingAttack",
	{
		syntax = nil,
		description = "Rolls a d20 and adds your strength plus your brawling skill to the result.",
		arguments = nil,
		OnRun = function(self, client, stat)
			local character = client:GetCharacter()
			local statname
			local bonus = character:GetAttribute("str", 0)
			local bonus2 = character:GetSkill("brawling", 0)
			local roll = math.random(1, 20)
			ix.chat.Send(
				client,
				"roll20brawling",
				(roll + bonus + bonus2) .. " ( " .. roll .. " + " .. bonus .. " + " .. bonus2 .. " )",
				nil,
				nil,
				{
					rolltype = statname
				}
			)
		end
	}
)

if SERVER then
	util.AddNetworkString("ViewSheet")
end

if (SERVER) then
ix.log.AddType("rollstat", function(client, value, attr, attrVal, critVal, data)
    local format = "%s rolled %d out of %d on %s"
    local formatWithBoost = "%s rolled %d (%d + %d) out of %d on %s"
    local formatWithDice = "%s rolled %d out of %d (%d + %d) on %s"
    local formatWithBoostAndDice = "%s rolled %d (%d + %d) out of %d (%dd%d) on %s"
    local critSuccess = ", a critical success."
    local critFailure = ", a critical failure."

    local message
    if attrVal > 0 and data.numDice > 1 then
        message = string.format(formatWithBoostAndDice, client:Name(), tonumber(value) + tonumber(attrVal), tonumber(value), attrVal, data.numDice * data.numSides, data.numDice, data.numSides, attr)
    elseif attrVal > 0 then
        message = string.format(formatWithBoost, client:Name(), tonumber(value) + tonumber(attrVal), tonumber(value), attrVal, data.numDice * data.numSides, attr)
    elseif data.numDice > 1 then
        message = string.format(formatWithDice, client:Name(), tonumber(value), data.numDice * data.numSides, data.numDice, data.numSides, attr)
    else
        message = string.format(format, client:Name(), tonumber(value), data.numDice * data.numSides, attr)
    end

    if critVal == 1 then
        return message .. critSuccess
    elseif critVal == -1 then
        return message .. critFailure
    else
        return message .. "."
    end
end)

ix.log.AddType("roll", function(client, value, data)
    local format = "%s rolled %d out of %d (%dd%d)"

    local message = string.format(format, client:Name(), tonumber(value), data.numDice * data.numSides, data.numDice, data.numSides)
    return message .. "."
end)
end