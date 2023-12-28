//	DISPLAY OF EMERALDS
//	Scripted by AceLite
//	Contributed from Sonic Adventure Style Pack
//

local emerald = {EMERALD1, EMERALD2, EMERALD3, EMERALD4, EMERALD5, EMERALD6, EMERALD7}

-- random rotating rocks + add there damn 8th Peaceful Ruby.
hud.add(function(v)
	local p = displayplayer
	if multiplayer then	
		hud.enable("coopemeralds")
		if mrce_hyperunlocked or p.mrce and p.mrce.hypercheat then
			v.drawScaled(200*FRACUNIT, 9*FRACUNIT, (FRACUNIT/2), v.cachePatch("CHAOS8"))
		end
	else
		hud.disable("coopemeralds")
		
		// No display in ingame tally >:(
		if bonus_t.display then return end
		
		//Off loading local variables for optimalization purposes
		local circlesplit = (360/#emerald)*ANG1
		local leveltimeang = ANGLE_225+(All7Emeralds(emeralds) and leveltime*ANG1 or 0)
		
		-- Vanilla Emeralds
		for id,k in ipairs(emerald) do
			// IF check compares from table whenever or not emerald is in player's possession
			if emeralds & k then
				local posang = id*circlesplit+leveltimeang
				
				local patch = v.cachePatch("CHAOS"..id)
				v.draw((34*cos(posang)/FRACUNIT)+150, (34*sin(posang)/FRACUNIT)+78, patch)
			end
		end
		
		-- "Master Emerald"
		if mrce_hyperunlocked or (p.mrce and p.mrce.hypercheat and not p.bot) then
			v.drawScaled(150*FRACUNIT, 78*FRACUNIT, (FRACUNIT*(3/2)), v.cachePatch("CHAOS8"))
		end
	end
end, "scores")
