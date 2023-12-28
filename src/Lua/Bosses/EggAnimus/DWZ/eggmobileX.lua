//this will force exit level to the credits when the final boss is defeated. If you intend to use this boss outside of mrce, do not include this script, and freeslot
//him in the soc with the rest of the boss. Or you could adapt this script for your own use, I don't care.
//The purpose of this script is to skip the score tally screen and move straight to the credits when the boss is defeated.

local disruption = 3 * TICRATE

freeslot(
"MT_URING"
)

addHook("BossThinker", function(mo)
if not (mo.valid) then return end
	if mo.health <= 0 and disruption > 1 then
		disruption = $ - 1
		if disruption <= 1 then
			if marathonmode & MA_NOCUTSCENES then
				G_SetCustomExitVars(1101,1)
			elseif not modeattacking then
				G_SetCustomExitVars(98,1)
			end
			disruption = 5000
			G_ExitLevel()
		end
	end
end, MT_XBOSS)

addHook("MapLoad", function(p, v)
	if disruption != 3 * TICRATE then  --if ticker got cut off early
		disruption = 3 * TICRATE  --reset it
	end
end)

addHook("MobjThinker", function(mobj)
    if not mobj and mobj.valid then return end
    if mapheaderinfo[gamemap].lvlttl != "Dimension Warp" then return end
	if netgame
	or not ultimatemode then
		P_RemoveMobj(mobj)
	end
end, MT_URING)

addHook("NetVars", function(net)
	disruption = net($)  --net sync that shit
end)