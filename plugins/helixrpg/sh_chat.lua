-- [[ COMMANDS ]] --

ix.chat.Register("rollstat", {
    format = "** %s has rolled %d out of %d on %s.",
    formatWithBonus = "** %s has rolled %d (%d + %d) out of %d on %s.",
    color = Color(160, 91, 192),
    CanHear = ix.config.Get("chatRange", 280),
    deadCanChat = true,
    OnChatAdd = function(self, speaker, text, bAnonymous, data)
        local formatAttribute = "** %s has rolled %d (%d + %d) out of %d on their %s roll"
        local formatAttributeBoost = "** %s has rolled %d (%d + %d + %d☆) out of %d on their %s roll"
		local formatAttributeSkill = "** %s has rolled %d (%d + %d + %d) out of %d on their %s and %s roll"
		local formatAttributeSkillBoost = "** %s has rolled %d (%d + %d + %d + %d☆) out of %d on their %s and %s roll"
        local critSuccess = "a critical success."
        local critFailure = "a critical failure."

		
    
        local message
        if data.hasAttr and not data.hasSkill and data.bonus == 0 then
            message = string.format(formatAttribute, speaker:Name(), tonumber(text) + data.attrVal, tonumber(text), data.attrVal, data.numSides, data.attrName)
		elseif data.hasAttr and not data.hasSkill and data.bonus ~= 0 then
            message = string.format(formatAttributeBoost, speaker:Name(), tonumber(text) + data.attrVal + data.bonus, tonumber(text), data.attrVal, data.bonus, data.numSides, data.attrName)
		elseif not data.hasAttr and data.hasSkill and data.bonus == 0 then
            message = string.format(formatAttribute, speaker:Name(), tonumber(text) + data.skillVal, tonumber(text), data.skillVal, data.numSides, data.skillName)
		elseif not data.hasAttr and data.hasSkill and data.bonus ~= 0 then
			message = string.format(formatAttributeBoost, speaker:Name(), tonumber(text) + data.skillVal + data.bonus, tonumber(text), data.skillVal, data.bonus, data.numSides, data.skillName)
		elseif data.hasAttr and data.hasSkill and data.bonus == 0 then
			message = string.format(formatAttributeSkill, speaker:Name(), tonumber(text) + data.attrVal + data.skillVal, tonumber(text), data.attrVal, data.skillVal, data.numSides, data.attrName, data.skillName)
		elseif data.hasAttr and data.hasSkill and data.bonus ~= 0 then
			message = string.format(formatAttributeSkillBoost, speaker:Name(), tonumber(text) + data.attrVal + data.skillVal + data.bonus, tonumber(text), data.attrVal, data.skillVal, data.bonus, data.numSides, data.attrName, data.skillName)
		end 

        if data.critVal == 1 then
            chat.AddText(self.color, message .. ", ", Color(0, 255, 0), critSuccess)
        elseif data.critVal == -1 then
            chat.AddText(self.color, message .. ", ", Color(255, 0, 0), critFailure)
        else
            chat.AddText(self.color, message .. ".")
        end


    end
})

--[[
	CHAT: rollgeneric
	DESCRIPTION: Highlights generic rolls made with arbitrary dice and bonuses.
]]--

ix.chat.Register("rollgeneric", {
	format = "** %s has rolled %s %s on their roll.", 
	color = Color(255, 185, 50),
	CanHear = ix.config.Get("chatRange", 280),
	deadCanChat = true,
	OnChatAdd = function(self, speaker, text, bAnonymous, data)
		chat.AddText(self.color, string.format(self.format,
			speaker:GetName(), text, data.roll
		))
	end
})

--[[
	CHAT: roll20
	DESCRIPTION: Highlights rolls made with a d20.
]]--

ix.chat.Register("roll20", {
	format = "** %s has rolled %s on their %s roll.",
	color = Color(255, 125, 50),
	CanHear = ix.config.Get("chatRange", 280),
	deadCanChat = true,
	OnChatAdd = function(self, speaker, text, bAnonymous, data)
		chat.AddText(self.color, string.format(self.format,
			speaker:GetName(), text, data.rolltype
		))
	end
})

--[[
	CHAT: roll20attack
	DESCRIPTION: Highlights attack rolls made with a d20.
]]--

ix.chat.Register("roll20attack", {
	format = "** %s has rolled %s on their Attack roll for %s damage.", --"** %s has rolled %s on their Attack roll for %s %s damage."
	color = Color(255, 70, 50),
	CanHear = ix.config.Get("chatRange", 280),
	deadCanChat = true,
	OnChatAdd = function(self, speaker, text, bAnonymous, data)
		chat.AddText(data.color or self.color, string.format(self.format,
			speaker:GetName(), text, data.damage
		))
	end
})

--[[
	CHAT: roll20melee
	DESCRIPTION: Highlights melee attack rolls.
]]--

ix.chat.Register("roll20melee", {
	format = "** %s has rolled %s on their Melee Attack roll.",
	color = Color(255, 125, 50),
	CanHear = ix.config.Get("chatRange", 280),
	deadCanChat = true,
	OnChatAdd = function(self, speaker, text, bAnonymous, data)
		chat.AddText(self.color, string.format(self.format,
			speaker:GetName(), text, data.rolltype
		))
	end
})

--[[
	CHAT: roll20firearms
	DESCRIPTION: Highlights firearm attack rolls.
]]--

ix.chat.Register("roll20firearms", {
	format = "** %s has rolled %s on their Firearms Attack roll.",
	color = Color(255, 125, 50),
	CanHear = ix.config.Get("chatRange", 280),
	deadCanChat = true,
	OnChatAdd = function(self, speaker, text, bAnonymous, data)
		chat.AddText(self.color, string.format(self.format,
			speaker:GetName(), text, data.rolltype
		))
	end
})

--[[
	CHAT: roll20bfirearmsburst
	DESCRIPTION: Highlights firearm attack rolls.
]]--

ix.chat.Register("roll20firearmsburst", {
	format = "** %s has rolled %s on their Firearms Burst Attack roll.",
	color = Color(255, 125, 50),
	CanHear = ix.config.Get("chatRange", 280),
	deadCanChat = true,
	OnChatAdd = function(self, speaker, text, bAnonymous, data)
		chat.AddText(self.color, string.format(self.format,
			speaker:GetName(), text, data.rolltype
		))
	end
})

ix.chat.Register("roll20firearmsburst2", {
	format = "** %s has rolled %s on their Firearms Burst Attack roll.",
	color = Color(255, 125, 50),
	CanHear = ix.config.Get("chatRange", 280),
	deadCanChat = true,
	OnChatAdd = function(self, speaker, text, bAnonymous, data)
		chat.AddText(self.color, string.format(self.format,
			speaker:GetName(), text, data.rolltype
		))
	end
})

ix.chat.Register("roll20firearmsburst3", {
	format = "** %s has rolled %s on their Firearms Burst Attack roll.",
	color = Color(255, 125, 50),
	CanHear = ix.config.Get("chatRange", 280),
	deadCanChat = true,
	OnChatAdd = function(self, speaker, text, bAnonymous, data)
		chat.AddText(self.color, string.format(self.format,
			speaker:GetName(), text, data.rolltype
		))
	end
})
--[[
	CHAT: roll20brawling
	DESCRIPTION: Highlights brawling attack rolls.
]]--

ix.chat.Register("roll20brawling", {
	format = "** %s has rolled %s on their Brawling Attack roll.",
	color = Color(255, 125, 50),
	CanHear = ix.config.Get("chatRange", 280),
	deadCanChat = true,
	OnChatAdd = function(self, speaker, text, bAnonymous, data)
		chat.AddText(self.color, string.format(self.format,
			speaker:GetName(), text, data.rolltype
		))
	end
})