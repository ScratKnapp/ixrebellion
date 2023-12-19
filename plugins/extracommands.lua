PLUGIN.name = "Extra Commands"
PLUGIN.author = "Luna"
PLUGIN.desc = "A few useful commands."

/*

*/

ix.command.Add("Event", {
	description = "@cmdEvent",
	arguments = ix.type.text,
	adminOnly = true,
	OnRun = function(self, client, text)
		ix.chat.Send(client, "event", text)
	end
})

ix.command.Add("clearitems", {
	adminOnly = true,
	alias = {"removeitems", "cleanitems"},
	OnRun = function(self, client, arguments)

		for k, v in pairs(ents.FindByClass("ix_item")) do
			v:Remove()
		end

		client:Notify("All items have been cleaned up from the map.")
	end
})

ix.command.Add("clearnpcs", {
	adminOnly = true,
	alias = {"removenpcs", "cleannpcs"},
	OnRun = function(self, client, arguments)

	for k, v in pairs( ents.GetAll( ) ) do
	if IsValid( v ) and ( v:IsNPC() or baseclass.Get( v:GetClass() ).Base == 'base_nextbot' or baseclass.Get( v:GetClass() ).Base == 'nz_base' or  baseclass.Get( v:GetClass() ).Base == 'nz_risen' ) and !IsFriendEntityName( v:GetClass() ) then

		  v:Remove()

	   end
    end
	client:Notify("All NPCs and Nextbots have been cleaned up from the map.")

	end
})

ix.command.Add("spawnitem", {
	description = "Spawns an item where you look",
	adminOnly = true,
	arguments = {
		ix.type.string,
	},
	OnRun = function(self, client, itemIDToSpawn)

		if (IsValid(client) and client:GetChar()) then
			local uniqueID = itemIDToSpawn:lower()
			if (!ix.item.list[uniqueID]) then
				for k, v in SortedPairs(ix.item.list) do
					if (ix.util.StringMatches(v.name, uniqueID)) then
						uniqueID = k
						break
					end
				end
			end

			if(!ix.item.list[uniqueID]) then
				client:Notify("No item exists with this unique ID.")
				return
			end

            local aimPos = client:GetEyeTraceNoCursor().HitPos

            aimPos:Add(Vector(0, 0, 10))

            ix.item.Spawn(uniqueID, aimPos)

		end
	end
})


-- Credit goes to SmithyStanley

ix.command.Add("coinflip", {
	OnRun = function(self, client, arguments)
		local coinSide = math.random(0, 1)
		if (coinSide > 0) then
			ix.chat.Send(client, "iteminternal", "flips a coin, and it lands on heads.")
		else
			ix.chat.Send(client, "iteminternal", "flips a coin, and it lands on tails.")
		end
	end,
})


ix.command.Add("suicide", {
	alias = {"unstuck", "respawn"},
	description = "Kill yourself, use if stuck somewhere.",
	OnRun = function(self, client)
		client:Kill()
	end
})
