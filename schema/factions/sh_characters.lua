
FACTION.name = "Characters"
FACTION.description = "Player Characters."
FACTION.color = Color(90, 30, 30, 255)
FACTION.isDefault = true
FACTION.canSeeWaypoints = true
FACTION.canAddWaypoints = true
FACTION.canRemoveWaypoints = true
FACTION.canUpdateWaypoints = true

function FACTION:OnCharacterCreated(client, character)
	local id = Schema:ZeroNumber(math.random(1, 99999), 5)
	local inventory = character:GetInventory()

	character:SetData("cid", id)

	inventory:Add("suitcase", 1)
  	inventory:Add("flashlight", 1)
	inventory:Add("cid", 1, {
		name = character:GetName(),
		id = id
	})
end

FACTION_CITIZEN = FACTION.index
