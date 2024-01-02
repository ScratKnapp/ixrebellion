
-- @module ix.feats

ix.feats = ix.feats or {}
ix.feats.list = ix.feats.list or {}

function ix.feats.LoadFromDir(directory)
	for _, v in ipairs( file.Find( directory.."/*.lua", "LUA" ) ) do
		local niceName = v:sub(4, -5) -- Trims out "sh_" and ".lua" from the name.

		FEAT = ix.feats.list[niceName] or {} -- Adds the feat to the feat list, or keeps the feat if it was alreaded loaded in.

		if (PLUGIN) then
			FEAT.plugin = PLUGIN.uniqueID
		end

		ix.util.Include(directory.."/"..v) -- Includes the feat file.

		FEAT.name = FEAT.name or "Unknown"
		FEAT.description = FEAT.description or "No description available."
		FEAT.icon = FEAT.icon or "icon16/bomb.png"

		for k, v in pairs(FEAT) do
			if isfunction(v) then
				HOOKS_CACHE[k] = HOOKS_CACHE[k] or {}
				HOOKS_CACHE[k][FEAT] = v
			end
		end

		ix.feats.list[niceName] = FEAT

		FEAT = nil -- Clears the FEAT table so we can cleanly read in a new one.
	end
end

function ix.feats.Setup(client)
	local character = client:GetCharacter()

	if (character) then
		for k, v in pairs(ix.feats.list) do
			if (v.OnSetup) then
				v:OnSetup(client, character:GetFeat(k, false)) -- If there's an OnSetup() function, call it.
			end
		end
	end
end

do
	
	-- Character meta for feats
	-- @classmod Character

	local charMeta = ix.meta.character

	if (SERVER) then

		-- Network string for feat updates
		util.AddNetworkString("ixFeatUpdate")

		-- Sets the state of the given feat on a character to true or false.
		-- @realm: Server
		-- @string: key - The name of the feat to set.
		-- @bool: value - The state to assign to the feat.
		function charMeta:SetFeat(key, value)
			local feat = ix.feats.list[key]
			local client = self:GetPlayer()

			if ( feat ) then
				local featTable = self:GetFeats()

				featTable[key] = value

				if IsValid( client ) then
					net.Start( "ixFeatUpdate" )
						net.WriteUInt( self:GetID(), 32 )
						net.WriteString( key )
						net.WriteBool( value )
					net.Send( client )
				end

				self:SetFeats(featTable)
			end
		end

		-- Adds a feat to the character.
		-- @realm: Server
		-- @string: key - The name of the feat to add to the character.
		function charMeta:AddFeat(key)
			self:SetFeat(key, true)
		end

		-- Remove a feat from the character.
		-- @realm: Server
		-- @string: key - The name of the feat to remove from the character
		function charMeta:RemoveFeat(key)
			self:SetFeat(key, nil)
		end

		-- Check if a character has a feat.
		-- @realm: Server
		-- @string: key - The name of the feat to check.
		-- @return: True if the character has the feat, false if they do not.
		function charMeta:HasFeat(key)
			return self:GetFeats()[key] and true or false
		end

		-- Check if a character has a feat.
		-- @realm: Server
		-- @string: key - The name of the feat to check.
		-- @return: True if the character has the feat, false if they do not, and nil if it does not exist.
		-- @treturn: The feat's table.
		function charMeta:GetFeat(key)
			return self:GetFeats()[key]
		end
	else
		net.Receive( "ixFeatUpdate", function()
			local id = net.ReadUInt(32)
			local character = ix.char.loaded[id]

			if ( character ) then
				local key = net.ReadString()
				local value = net.ReadBool()

				character:GetSkills()[key] = value
			end
		end)
	end

end

do
	
	ix.char.RegisterVar("feats", {   
		field = "feats",
		fieldType = ix.type.text,
		default = {},
		index = 6,
		category = "feats",
		isLocal = true,
		OnDisplay = function(self, container, payload)
			local maximum = hook.Run("GetDefaultFeatPoints", LocalPlayer(), payload) or 3

			if (maximum < 1) then
				return
			end

			local feats = container:Add("Panel")
			feats:Dock(FILL)

			local barPanel = feats:Add("DPanel")
			barPanel:Dock(TOP)

			local y = 0
			local total = 0

			payload.feats = {}

			-- total spendable feat points
			local totalBar = barPanel:Add("ixAttributeBar")
			totalBar:SetMax(maximum)
			totalBar:SetValue(maximum)
			totalBar:Dock(TOP)
			totalBar:DockMargin(2, 2, 2, 2)
			totalBar:SetText(L("attribPointsLeft"))
			totalBar:SetReadOnly(true)
			totalBar:SetColor(Color(20, 120, 20, 255))

			y = totalBar:GetTall() + 4

			barPanel:SetTall(y)

			---

			local featScrollPanel = feats:Add("DScrollPanel")
			featScrollPanel:DockMargin(2, 2, 2, 2)
			featScrollPanel:Dock(FILL)
			featScrollPanel.Paint = function(panel, width, height)
				derma.SkinFunc("DrawImportantBackground", 0, 0, width, height, Color(255, 255, 255, 25))
			end

			local featSelectList = featScrollPanel:Add( "ixFeatList" )
			featSelectList:SetColumns( 8 )
			featSelectList:Dock(FILL)

			function featSelectList:AllowPicking( state )
				for k, v in pairs( featSelectList:GetFeatList() ) do
					if !v:GetActivated() then
						v:SetSelectable(state)
					end
				end
			end

			for k, v in pairs( ix.feats.list ) do
				if not v.noStartSelection then

					local feat = featSelectList:AddFeat( v, false, true )

					function feat:OnActivated()
						totalBar:SetValue( totalBar.value - 1 )

						payload.feats[k] = true

						if totalBar.value <= 0 then
							featSelectList:AllowPicking( false )
						end
					end

					function feat:OnDeactivated()
						totalBar:SetValue( totalBar.value + 1 )

						payload.feats[k] = nil

						if totalBar.value > 0 then
							featSelectList:AllowPicking( true )
						end
					end
				end
			end

			return feats
		end,
		OnValidate = function(self, value, data, client)
			if (value != nil) then
				if (istable(value)) then
					local count = table.Count( value )

					if (count > (hook.Run("GetDefaultSkillPoints", client, count) or 10)) then
						return false, "unknownError"
					end
				else
					return false, "unknownError"
				end
			end
		end,
		ShouldDisplay = function(self, container, payload)
			return !table.IsEmpty(ix.feats.list)
		end
	})

	hook.Add( "DoPluginIncludes", "HRPGLoadFeats", function( path, PLUGIN )
		ix.feats.LoadFromDir(path.."/feats") 
	end)

end