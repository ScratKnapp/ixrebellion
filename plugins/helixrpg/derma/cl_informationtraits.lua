do
	hook.Add( "CreateCharacterInfoCategory", "FeatsCharacterInfo", function( PANEL )

		-- no need to update since we aren't showing the attributes panel
		local character = LocalPlayer().GetCharacter and LocalPlayer():GetCharacter()

		if (character) then
			PANEL.feats = PANEL:Add("ixCategoryPanel")
			PANEL.feats:SetText("Feats")
			PANEL.feats:Dock(TOP)
			PANEL.feats:DockMargin(0, 0, 0, 8)

			PANEL.tile = PANEL.feats:Add("DIconLayout")
			PANEL.tile:Dock( TOP )
			PANEL.tile:SetSpaceY( 2 )
			PANEL.tile:SetSpaceX( 2 )

			local featTable = character:GetFeats()

			--PrintTable( featTable )

			local featCount, rowCount, tileSize = 0, 0, 0

			tileSize = ( PANEL:GetWide() - 16 ) / 8

			for k, _ in SortedPairs(featTable) do
				local featData = ix.feats.list[k]

				local ListItem = PANEL.tile:Add( "ixFeatIcon" )
				ListItem:SetSize( tileSize, tileSize )
				ListItem:SetImage( featData.icon or "icon16/bomb.png")
				ListItem:SetActivated(true)
				ListItem:SetSelectable(false)
				ListItem:SetHelixTooltip(function(tooltip)
					local title = tooltip:AddRow("name")
					title:SetImportant()
					title:SetText(featData.name)
					title:SizeToContents()
					title:SetMaxWidth(math.max(title:GetMaxWidth(), ScrW() * 0.5))

					local description = tooltip:AddRow("description")
					description:SetText(featData.description)
					description:SizeToContents()
				end)

				featCount = featCount + 1
			end

			--[[for i=1, 3 do 
				for k, v in SortedPairsByMemberValue(ix.feats.list, "name") do -- Make a loop to create a bunch of panels inside of the DIconLayout
					local ListItem = PANEL.tile:Add( "ixFeatIcon" ) -- Add DPanel to the DIconLayout
					ListItem:SetSize( tileSize, tileSize ) -- Set the size of it
					ListItem:SetImage( v.icon or "icon16/bomb.png")
					ListItem:SetHelixTooltip(function(tooltip)
						local title = tooltip:AddRow("name")
						title:SetImportant()
						title:SetText(v.name)
						title:SizeToContents()
						title:SetMaxWidth(math.max(title:GetMaxWidth(), ScrW() * 0.5))

						local description = tooltip:AddRow("description")
						description:SetText(v.description)
						description:SizeToContents()
					end)
					-- You don't need to set the position, that is done automatically.
					featCount = featCount + 1
				end
			end]]--

			rowCount = math.ceil( featCount / 8 )

			PANEL.tile:SetTall( ( 2 * ( rowCount - 1 ) ) + ( rowCount * tileSize ) )

			PANEL.feats:SizeToContents()
		end

	end)
end