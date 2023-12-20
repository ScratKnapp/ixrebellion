local PLUGIN = PLUGIN
-- [[ HOOKS ]] --
function PLUGIN:GetMaximumAttributePoints()
	return ix.config.Get("maxAttributes", 5)
end

function PLUGIN:GetMaximumSkillPoints()
	return ix.config.Get("maxSkills", 10)
end

function PLUGIN:GetDefaultFeatPoints()
	return ix.config.Get("maxFeats", 3)
end

function PLUGIN:GetDefaultAttributePoints(client)
	return ix.config.Get("startingAttributePoints", 10)
end

function PLUGIN:GetDefaultSkillPoints(client)
	return ix.config.Get("startingSkillPoints", 20)
end

function PLUGIN:PlayerDeath(victim, inflictor, attacker)
	local character = victim:GetCharacter()
	local bonus = character:GetAttribute("con", 0)
	local roll = tostring(math.random(0, 20))
	local receivers = {}
	for _, v in ipairs(player.GetAll()) do
		if v:IsAdmin() or v:IsSuperAdmin() then
			table.insert(receivers, v)
		end
	end

	ix.chat.Send(
		victim,
		"roll",
		(roll + bonus) .. " ( " .. roll .. " + " .. bonus .. " ) for their Injury Saving Throw",
		nil,
		receivers,
		{
			max = maximum
		}
	)
end

local playerMeta = FindMetaTable("Player")
function playerMeta:SetShieldPoints(points, take)
	local currentPoints = self:GetShieldPoints()
	if take then
		newpoints = math.max(0, currentPoints - points)
	else
		newpoints = math.min(PLUGIN.MaxShields, currentPoints + points)
	end
	self:SetNWInt("ShieldPoints", newpoints)
end

function playerMeta:GetShieldPoints()
	return self:GetNWInt("ShieldPoints", 0)
end

function playerMeta:SetWoundSlots(points, take)
	local currentSlots = self:GetWoundSlots()
	if take then
		newSlots = math.max(0, currentSlots - points)
	else
		newSlots = math.min(self:GetMaxWounds(), currentSlots + points)
	end

	
	self:SetNWInt("WoundSlots", newSlots)
end

function playerMeta:GetWoundSlots()
	return self:GetNWInt("WoundSlots", PLUGIN.DefaultWounds)
end

function playerMeta:SetMaxWounds(points)

	if points > PLUGIN.MaxWounds then points = PLUGIN.MaxWounds end
	if points < 0 then points = PLUGIN.DefaultWounds end 

	self:SetNWInt("MaxWounds", points)
end

function playerMeta:GetMaxWounds()
	return self:GetNWInt("MaxWounds", PLUGIN.MaxWounds)
end


ix.chat.Register(
	"effectannounce",
	{
		CanHear = 1000,
		OnChatAdd = function(self, speaker, text)
			chat.AddText(Color(255, 150, 0), text)
		end,
		indicator = "chatPerforming"
	}
)

if (SERVER) then
    ix.log.AddType("giveselfshields", function(client, points)
		newpoints = client:GetShieldPoints()
        return string.format("%s has given themselves %s Shield points, and now has %s. ", client:Name(), points, newpoints)
    end)

	ix.log.AddType("takeselfshields", function(client, points)
		newpoints = client:GetShieldPoints()
        return string.format("%s has taken away %s of their Shield points, and now has %s. ", client:Name(), points, newpoints)
    end)

	ix.log.AddType("giveselfhealth", function(client, points)
		newpoints = client:GetWoundSlots()
		return string.format("%s has given themselves %s Wound points, and now has %s. ", client:Name(), points, newpoints)
    end)

	ix.log.AddType("takeselfhealth", function(client, points)
		newpoints = client:GetWoundSlots()
        return string.format("%s has taken away %s of their Health points, and now has %s. ", client:Name(), points, newpoints)
    end)

	ix.log.AddType("giveshields", function(client, target, points)
		newpoints = target:GetShieldPoints()
		return string.format("%s has given %s %s Shield points. They now have %s. ", client:GetCharacter():GetName(), target:Name(), points, newpoints)
    end)

	ix.log.AddType("takeshields", function(client, target, points)
		newpoints = target:GetShieldPoints()
        return string.format("%s has taken  %s Shield points from %s. They now have %s ", client:GetCharacter():GetName(), points, target:GetName(), newpoints)
    end)

	ix.log.AddType("givehealth", function(client, target, points)
		newpoints = target:GetWoundSlots()
		return string.format("%s has given %s %s Health points. They now have %s. ", client:GetCharacter():GetName(), target:Name(), points, newpoints)
    end)

	ix.log.AddType("takehealth", function(client, target, points)
		newpoints = target:GetWoundSlots()
        return string.format("%s has taken  %s Health points from %s. They now have %s ", client:GetCharacter():GetName(), points, target:GetName(), newpoints)
    end)





end