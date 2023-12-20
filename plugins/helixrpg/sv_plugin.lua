function PLUGIN:PlayerSpawn(client)
    local character = client:GetCharacter()
    if not character then return end
    local backgroundTable = character:GetLineage()
    client:SetShieldPoints(0, false)
    client:SetWoundSlots(self.DefaultWounds + character:GetAttribute("con", 0), false)
    client:SetMaxWounds(self.DefaultWounds + character:GetAttribute("con", 0), false)
    if not character:GetData("CharacterCreationSet", false) then
        character:SetData("Lineage", backgroundTable)
        local feats = {}
        for featID, _ in pairs(character:GetFeats()) do
            local feat = ix.feats.list[featID]
            if feat then
                table.insert(feats, feat.name)
            end
        end

        character:SetData("Feats", feats)
        character:SetData("CharacterCreationSet", false)
    end
end

function PLUGIN:OnCharacterCreated(client, character)
    ix.lineages.Setup(client)
end