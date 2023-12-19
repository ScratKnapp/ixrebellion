local PANEL = {}
function PANEL:Init()
    self.LineageList = {}
    self.LineageCount = 0
    self.Columns = 8
    self.Updated = false
    self.ResizeParent = true
    self:Dock(FILL)
    self.Updated = false
end

function PANEL:Think()
    if not self.Updated then
        self:FormatToContents()
    end
end

function PANEL:Clear()
    for k, v in pairs(self.LineageList) do
        v:Remove()
        self.LineageList[k] = nil
    end
end

function PANEL:SizeToParent()
    local parent = self:GetParent()
    local w, h = parent:GetSize()
    local ml, mu, mr, md = self:GetDockMargin()
    local marginX, marginY = ml + mr, mu + md
    w, h = w - marginX, h - marginY
    self:SetSize(w, h)
end

function PANEL:SizeParentY(height)
    if not self.ResizeParent then return end
    local parent = self:GetParent()
    local _, mu, _, md = self:GetDockMargin()
    local marginY = mu + md
    if parent:GetTall() < height then
        parent:SetTall(height + marginY)
    end
end

function PANEL:FormatToContents()
    local lineageCount = table.Count(self.LineageList)
    local rowCount = math.ceil(lineageCount / self.Columns)
    local gapX, gapY = 0, 0
    local w, h = self:GetSize()
    local tileSize = math.floor((w - gapX) / self.Columns)
    local panelHeight = (rowCount * tileSize) + gapY
    self:SizeToParent()
    for k, v in pairs(self.LineageList) do
        v:SetSize(tileSize, tileSize)
    end

    self:SizeParentY(panelHeight)
    self.Updated = true
end

function PANEL:AddLineage(data, bActive, bSelectable)
    bActive = bActive or false
    bSelectable = bSelectable or false
    self.LineageList[data.name] = self:Add("ixLineageIcon")
    self.LineageList[data.name]:SetImage(data.icon or "icon16/bomb.png")
    self.LineageList[data.name]:SetActivated(bActive)
    self.LineageList[data.name]:SetSelectable(bSelectable)
    self.LineageList[data.name]:SetHelixTooltip(
        function(tooltip)
            local title = tooltip:AddRow("name")
            title:SetImportant()
            title:SetText(data.name)
            title:SizeToContents()
            title:SetMaxWidth(math.max(title:GetMaxWidth(), ScrW() * 0.5))
            local description = tooltip:AddRow("description")
            description:SetText(data.description)
            description:SizeToContents()
        end
    )

    self.LineageCount = self.LineageCount + 1
    self.Updated = false

    return self.LineageList[data.name]
end

function PANEL:AllowParentResize(state)
    self.ResizeParent = state
end

function PANEL:SetColumns(columns)
    self.Columns = columns
    self.Updated = false
end

function PANEL:GetColumns(columns)
    return self.Columns
end

function PANEL:GetLineageList()
    return self.LineageList
end

vgui.Register("ixLineageList", PANEL, "DIconLayout")