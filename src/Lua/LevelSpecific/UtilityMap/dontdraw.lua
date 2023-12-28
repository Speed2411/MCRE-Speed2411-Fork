addHook("PlayerThink", function(player)
	if gamemap > 96 and gamemap < 101 then
		player.momx = 0
		player.momy = 0
		player.momz = 0
		player.mo.flags2 = $|MF2_DONTDRAW
		player.powers[pw_nocontrol] = 2
	end
end)

addHook("ThinkFrame", function()
	if gamemap == 100 or gamemap == 99 or gamemap == 98 or gamemap == 97 then
		hud.disable("lives")
		hud.disable("score")
		hud.disable("rings")
		hud.disable("time")
	end
end)

addHook("MapLoad", function(map)
	if gamemap == 99 and CV_FindVar("touch_inputs") then
		G_SetCustomExitVars(101,1)
		G_ExitLevel()
	end
end)
	