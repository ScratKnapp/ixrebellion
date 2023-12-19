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
function playerMeta:SetShieldPoints(points, take, noWarn)
	noWarn = noWarn or true
	local currentPoints = self:GetShieldPoints()
	if take then
		currentPoints = math.max(0, currentPoints - points)
	else
		currentPoints = math.min(PLUGIN.MaxShields, currentPoints + points)
	end

	if not noWarn then
		ix.chat.Send(self, "effectannounce", take and "Took " or "Added " .. points .. " to Shield")
	end

	self:SetNWInt("ShieldPoints", currentPoints)
end

function playerMeta:GetShieldPoints()
	return self:GetNWInt("ShieldPoints", 0)
end

function playerMeta:SetWoundSlots(points, take, noWarn)
	local currentSlots = self:GetWoundSlots()
	if take then
		currentSlots = math.max(0, currentSlots - points)
	else
		currentSlots = math.min(PLUGIN.MaxWounds, currentSlots + points)
	end

	if not noWarn then
		ix.chat.Send(self, "effectannounce", take and "Took " or "Added " .. points .. " to Wound")
	end

	self:SetNWInt("WoundSlots", currentSlots)
end

function playerMeta:GetWoundSlots()
	return self:GetNWInt("WoundSlots", PLUGIN.DefaultWounds)
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