--manage second quest stuff. mostly triggering linedefs and swapping textures and such, might add encore support later too
--obviously this is all just here to be here, not expecting anyone to use it yet lol, though due to the nature of how the levels are to be built for this, it might be something to keep in mind

--[[
	with texture changes 'n stuff I feel like we should make like 
	a table for each zone that lists what textures get changed to what.

	that would allow zones that share textures to have different remaps
	for said textures. it would also be great for organization.
]]

addHook("MapLoad", function(p, v)
	if mrce_secondquest and gamemap > 100 and gamemap < 168 then  --if second quest is active, saved in my misc script since luabanks
		P_LinedefExecute(5003)
	elseif gamemap > 100 and gamemap < 168 then --we're on main quest instead, do the same for effects that shouldn't occur in second quest
		P_LinedefExecute(5004)
	end
end)

addHook("GameQuit", function()
	mrce_secondquest = false
end)

addHook("MobjSpawn", function(mobj)
	if mrce_secondquest and P_RandomChance(FRACUNIT/3) then
		mobj.fuse = 1
		P_SpawnMobjFromMobj(mobj, 0, 0, 0, MT_ULTRABUZZ)
	end
end, MT_REDBUZZ)

addHook("MobjFuse", function(mobj)
	if mrce_secondquest then
		P_RemoveMobj(mobj)
	end
end, MT_REDBUZZ)

addHook("MobjSpawn", function(mobj)
	if mrce_secondquest and P_RandomChance(FRACUNIT/6) then
		mobj.fuse = 1
		P_SpawnMobjFromMobj(mobj, 0, 0, 0, MT_ULTRABUZZ)
	end
end, MT_GOLDBUZZ)

addHook("MobjFuse", function(mobj)
	if mrce_secondquest then
		P_RemoveMobj(mobj)
	end
end, MT_GOLDBUZZ)

COM_AddCommand("mr_secondquest", function(p)
	if p == consoleplayer then
		if netgame then
			if p == server
			or IsPlayerAdmin(p) then
				if not mrce_secondquest then
					mrce_secondquest = true
					CONS_Printf(p, "Second Quest has been enabled")
				else
					mrce_secondquest = false
					CONS_Printf(p, "Second Quest has been disabled")
				end
				G_SetCustomExitVars(gamemap, 1)
				G_ExitLevel()
			else
				CONS_Printf(p, "You must be an admin to do that")
			end
		else
			CONS_Printf(p, "That only works in netgames")
		end
	end
end)