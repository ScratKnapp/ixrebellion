-- @module ix.lineages
ix.lineages = ix.lineages or {}
ix.lineages.list = ix.lineages.list or {}
function ix.lineages.LoadFromDir(directory)
	for _, v in ipairs(file.Find(directory .. "/*.lua", "LUA")) do
		local niceName = v:sub(4, -5)
		LINEAGE = ix.lineages.list[niceName] or {}
		if PLUGIN then
			LINEAGE.plugin = PLUGIN.uniqueID
		end

		ix.util.Include(directory .. "/" .. v)
		LINEAGE.name = LINEAGE.name or "Unknown"
		LINEAGE.description = LINEAGE.description or "No description available."
		ix.lineages.list[niceName] = LINEAGE
		LINEAGE = nil
	end
end

function ix.lineages.Setup(client)
	local character = client:GetCharacter()
	if character then
		for k, v in pairs(ix.lineages.list) do
			if v.OnSetup then
				v:OnSetup(client, character:GetLineage(k, false))
			end
		end
	end
end

do
	-- Character meta for feats
	-- @classmod Character
	local charMeta = ix.meta.character
	if SERVER then
		-- Network string for feat updates
		util.AddNetworkString("ixLineageUpdate")
		-- Assigns the given lineage to the character.
		-- @realm: Server
		-- @string: key - The name of the lineage to set.
		function charMeta:SetLineage(key)
			local lineage = ix.lineages.list[key]
			local client = self:GetPlayer()
			if lineage then
				local lineageTable = self:GetLineages() or {}
				for k, v in pairs(lineageTable) do
					lineageTable[k] = false
				end

				lineageTable[key] = true
				if IsValid(client) then
					net.Start("ixLineageUpdate")
					net.WriteUInt(self:GetID(), 32)
					net.WriteString(key)
					net.WriteBool(true)
					net.Send(client)
				end

				self:SetLineages(lineageTable)
			end
		end

		-- Find a character's lineage.
		-- @realm: Server
		-- @return: The name of the character's lineage.
		function charMeta:GetLineage()
			local lineageTable = self:GetLineages()
			for k, v in pairs(lineageTable) do
				if v then return k end
			end

			return false
		end
	else
		net.Receive(
			"ixFeatUpdate",
			function()
				local id = net.ReadUInt(32)
				local character = ix.char.loaded[id]
				if character then
					local key = net.ReadString()
					local value = net.ReadBool()
					local lineageTable = character:GetLineages()
					for k, v in pairs(lineageTable) do
						lineageTable[k] = false
					end

					lineageTable[key] = value
				end
			end
		)
	end
end

do
	ix.char.RegisterVar(
		"lineage",
		{
			field = "lineage",
			fieldType = ix.type.string,
			default = "none",
			index = 6,
			category = "lineages",
			isLocal = true,
			OnDisplay = function(self, container, payload)
				payload.lineage = "none"
				local bgFeats = {}
				local function addFeat(feat)
					bgFeats[feat] = true
					payload.feats[feat] = true
				end

				local function clearFeats()
					for _, v in pairs(bgFeats) do
						payload.feats[v] = nil
						bgFeats = {}
					end
				end

				local main = container:Add("Panel")
				main:DockMargin(0, 0, 4, 0)
				main:Dock(FILL)
				local bginfoHeight = ScrH() * 0.2
				local bginfo = main:Add("Panel")
				bginfo:SetTall(bginfoHeight)
				bginfo:Dock(TOP)
				local bgpicture = bginfo:Add("DPanel")
				bgpicture:DockMargin(2, 2, 2, 2)
				bgpicture:SetSize(bginfoHeight, bginfoHeight)
				bgpicture:Dock(RIGHT)
				local bgpictureIcon = bgpicture:Add("DImage")
				bgpictureIcon:SetImage("icon16/help.png")
				bgpictureIcon:DockMargin(16, 16, 16, 16)
				bgpictureIcon:Dock(FILL)
				local bginfoLeft = bginfo:Add("Panel")
				bginfoLeft:SetTall(bginfoHeight)
				bginfoLeft:Dock(FILL)
				local bgpanel = bginfoLeft:Add("DPanel")
				bgpanel:DockMargin(2, 2, 2, 2)
				bgpanel:Dock(TOP)
				local bgdropdown = bgpanel:Add("DComboBox")
				bgdropdown:Dock(FILL)
				for k, v in SortedPairsByMemberValue(ix.lineages.list, "name") do
					bgdropdown:AddChoice(L(v.name), v)
				end

				local descPanel = bginfoLeft:Add("DPanel")
				descPanel:DockMargin(2, 2, 2, 2)
				descPanel:Dock(FILL)
				local descScroll = descPanel:Add("DScrollPanel")
				descScroll:Dock(FILL)
				local descLabel = descPanel:Add("DLabel")
				descLabel:DockMargin(2, 2, 2, 2)
				descLabel:Dock(TOP)
				descLabel:SetWrap(true)
				descLabel:SetTextInset(4, 0)
				descLabel:SetText("")
				local bgfeatPanel = main:Add("DPanel")
				bgfeatPanel:DockMargin(2, 2, 2, 2)
				bgfeatPanel:Dock(TOP)
				local bgfeatList = bgfeatPanel:Add("ixFeatList")
				bgfeatList:DockMargin(32, 32, 32, 32)
				bgfeatList:SetColumns(6)
				function bgdropdown:OnSelect(index, value, data)
					descLabel:SetText(data.description)
					descLabel:SizeToContents()
					bgpictureIcon:SetImage(data.icon or "icon16/help.png")
					payload.lineage = L(data.name)
					clearFeats()
					bgfeatList:Clear()
					for k, v in pairs(data.feats) do
						local feats = ix.feats.list
						addFeat(v)
						bgfeatList:AddFeat(feats[v], true, false)
					end
				end

				return main
			end,
			OnValidate = function(self, value, data, client)
				if value ~= nil then
					if not isstring(value) then return false, "unknownError" end
				end
			end,
			ShouldDisplay = function(self, container, payload) return not table.IsEmpty(ix.feats.list) end
		}
	)

	hook.Add(
		"DoPluginIncludes",
		"HRPGLoadLineages",
		function(path, PLUGIN)
			ix.lineages.LoadFromDir(path .. "/lineages")
		end
	)
end