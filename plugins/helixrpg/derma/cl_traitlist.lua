local PANEL = {}

function PANEL:Init()
	self.FeatList = {}
	self.FeatCount = 0
	self.Columns = 8
	self.Updated = false
	self.ResizeParent = true

	self:Dock(FILL)
	self.Updated = false
end

function PANEL:Think()
	if not self.Updated then self:FormatToContents() end
end

function PANEL:Clear()
	for k, v in pairs( self.FeatList ) do
		v:Remove()
		self.FeatList[k] = nil
	end
end

function PANEL:SizeToParent()
	local parent = self:GetParent()
	local w, h = parent:GetSize()
	local ml, mu, mr, md = self:GetDockMargin()
	local marginX, marginY = ml + mr, mu + md

	w, h = w - marginX, h - marginY

	self:SetSize( w, h )
end

function PANEL:SizeParentY( height )
	if not self.ResizeParent then return end

	local parent = self:GetParent()
	local _, mu, _, md = self:GetDockMargin()
	local marginY = mu+ md

	if parent:GetTall() < height then
		parent:SetTall( height + marginY )
	end
end

function PANEL:FormatToContents()
	local featCount = table.Count( self.FeatList )
	local rowCount = math.ceil( featCount / self.Columns )
	local gapX, gapY = 0, 0
	local w, h = self:GetSize()
	local tileSize = math.floor(( w - gapX ) / self.Columns)
	local panelHeight = ( rowCount * tileSize ) + gapY

	self:SizeToParent()

	for k, v in pairs( self.FeatList ) do
		v:SetSize( tileSize, tileSize )
	end

	self:SizeParentY( panelHeight )

	self.Updated = true
end

function PANEL:AddFeat( data, bActive, bSelectable )
	bActive = bActive or false
	bSelectable = bSelectable or false

	self.FeatList[data.name] = self:Add( "ixFeatIcon" )
	self.FeatList[data.name]:SetImage( data.icon or "icon16/bomb.png" )
	self.FeatList[data.name]:SetActivated( bActive )
	self.FeatList[data.name]:SetSelectable( bSelectable )

	self.FeatList[data.name]:SetHelixTooltip(function(tooltip)
		local title = tooltip:AddRow("name")
		title:SetImportant()
		title:SetText(data.name)
		title:SizeToContents()
		title:SetMaxWidth(math.max(title:GetMaxWidth(), ScrW() * 0.5))

		local description = tooltip:AddRow("description")
		description:SetText(data.description)
		description:SizeToContents()
	end)

	self.FeatCount = self.FeatCount + 1

	self.Updated = false

	return self.FeatList[data.name]
end

function PANEL:AllowParentResize( state )
	self.ResizeParent = state
end

function PANEL:SetColumns( columns )
	self.Columns = columns
	self.Updated = false
end

function PANEL:GetColumns( columns )
	return self.Columns
end

function PANEL:GetFeatList()
	return self.FeatList
end

vgui.Register( "ixFeatList", PANEL, "DIconLayout" )