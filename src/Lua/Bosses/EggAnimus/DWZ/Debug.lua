-- Debug code for testing
addHook('PlayerThink', function(player)
	if gamemap == 139 
	and mapheaderinfo[gamemap].animus_debug == 1 then
		player.rings = 200
		if mrce_hyperunlocked != true then
			mrce_hyperunlocked = true
		end
	end
end)