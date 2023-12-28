//this will force exit level to MAPB0 when the Egg Animus is defeated. If you intend to use the egg animus outside of mrce, make sure to edit line 13 to suit your needs
//the second phase in the soc with the rest of the boss. Or you could adapt this script for your own use, I don't care.
//The purpose of this script is to skip the score tally screen and move straight to Dimension Warp when the boss is defeated.

local disruption = 7 * TICRATE  --initialize animation ticker
local rndclr = 36
addHook("BossThinker", function(mo)
	if not (mo.valid) then return end  --if object was nuked by unexpected outside influence, then prevent console errors
	if mo.health <= 0 then --if he ded
		disruption = $ - 1 --start animation ticker
		if disruption <= 0 then --if ticker reaches 0
			disruption = 10 * TICRATE  --reset ticker
			if not modeattacking then
				G_SetCustomExitVars(164,1)
			end
			G_ExitLevel()  --send us to dwz
		end
	end
end, MT_EGGANIMUS_EX)

addHook("MapLoad", function(p, v)
	if disruption != 7 * TICRATE then  --if ticker got cut off early
		disruption = 7 * TICRATE  --reset it
	end
	rndclr = 36
end)

addHook("ThinkFrame", function()
	if mapheaderinfo[gamemap].lvlttl != "Mystic Realm" then return end
	if disruption == 106
	or disruption == 71
	or disruption == 36 then  --just before each screen flash
		rndclr = P_RandomRange(21, #skincolors)  --randomize the flash color
	end

	for p in players.iterate() do
		if p.riftbreak == nil
		or disruption > 5 * TICRATE then
			p.riftbreak = 0
		end
		if disruption < 5*TICRATE and disruption > 0 then
			p.viewrollangle = p.riftbreak
		end
		if disruption == 6 * TICRATE then
			S_StartSound(nil, sfx_rumble)
			P_StartQuake(70*FRACUNIT, 110)
		end
		if disruption <= 6 * TICRATE
		and disruption >= 17 then
			p.powers[pw_nocontrol] = 1
			p.mo.state = S_PLAY_EDGE
		end
		if disruption == 3 * TICRATE then
			S_StartSound(nil, sfx_rumble)
			S_StartSound(nil,  sfx_rail1)
			p.riftbreak = P_RandomRange(-70,70)*ANG1
			P_StartQuake(70*FRACUNIT, 110)
		end
		if disruption == 2 * TICRATE then
			S_StartSound(nil,  sfx_rail1)
			p.riftbreak = P_RandomRange(-70,70)*ANG1
		end
		if disruption == 1 * TICRATE then
			S_StartSound(nil,  sfx_rail1)
			p.riftbreak = P_RandomRange(-70,70)*ANG1
		end
		if disruption == 16 and p.mo.skin != "adventuresonic" and p.mo.skin != "sms" then
			S_StartSound(p.mo,  sfx_s3k46)
			P_DoSuperTransformation(p, true)  --super transform before it's too late
		end
		if disruption == 10 then
			S_StartSound(nil,  sfx_s3k4e)  --right before level warp, do a big blast
		end
	end
end)

addHook("ShouldDamage", function(target, inflictor, source, damage, damagetype)
	if disruption > 6*TICRATE then return end
	if mapheaderinfo[gamemap].lvlttl != "Mystic Realm" then return end
	if target.player and disruption <= 6*TICRATE then
		return false
	end
end, MT_PLAYER)

hud.add(function(v,p)  --FlashPal big stinky. Invert screen with big subtractive blend instead
	if mapheaderinfo[gamemap].lvlttl != "Mystic Realm" then return end
	if disruption > 6*TICRATE then return end
	if (disruption <= 105 and disruption >= 90)
	or (disruption <= 70 and disruption >= 55)
	or (disruption <= 35 and disruption >= 20) then
		v.draw(0, 0, v.cachePatch("BLNDWAL"), V_30TRANS|V_SUBTRACT|V_SNAPTOTOP|V_SNAPTOLEFT, v.getColormap(TC_DEFAULT, rndclr))
	end
end, "game")

addHook("NetVars", function(net)
	disruption = net($)  --net sync that shit
end)

--⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⡿⠟⠛⠛⠛⠋⠉⠉⠉⠉⠉⠉⠉⠉⠉⠉⠉⠉⠉⠙⠛⠛⠛⠿⠻⠿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿
--⣿⣿⣿⣿⣿⣿⣿⣿⣿⡿⠋⠀⠀⠀⠀⠀⡀⠠⠤⠒⢂⣉⣉⣉⣑⣒⣒⠒⠒⠒⠒⠒⠒⠒⠀⠀⠐⠒⠚⠻⠿⠿⣿⣿⣿⣿⣿⣿⣿⣿
--⣿⣿⣿⣿⣿⣿⣿⣿⠏⠀⠀⠀⠀⡠⠔⠉⣀⠔⠒⠉⣀⣀⠀⠀⠀⣀⡀⠈⠉⠑⠒⠒⠒⠒⠒⠈⠉⠉⠉⠁⠂⠀⠈⠙⢿⣿⣿⣿⣿⣿
--⣿⣿⣿⣿⣿⣿⣿⠇⠀⠀⠀⠔⠁⠠⠖⠡⠔⠊⠀⠀⠀⠀⠀⠀⠀⠐⡄⠀⠀⠀⠀⠀⠀⡄⠀⠀⠀⠀⠉⠲⢄⠀⠀⠀⠈⣿⣿⣿⣿⣿
--⣿⣿⣿⣿⣿⣿⠋⠀⠀⠀⠀⠀⠀⠀⠊⠀⢀⣀⣤⣤⣤⣤⣀⠀⠀⠀⢸⠀⠀⠀⠀⠀⠜⠀⠀⠀⠀⣀⡀⠀⠈⠃⠀⠀⠀⠸⣿⣿⣿⣿
--⣿⣿⣿⣿⡿⠥⠐⠂⠀⠀⠀⠀⡄⠀⠰⢺⣿⣿⣿⣿⣿⣟⠀⠈⠐⢤⠀⠀⠀⠀⠀⠀⢀⣠⣶⣾⣯⠀⠀⠉⠂⠀⠠⠤⢄⣀⠙⢿⣿⣿
--⣿⡿⠋⠡⠐⠈⣉⠭⠤⠤⢄⡀⠈⠀⠈⠁⠉⠁⡠⠀⠀⠀⠉⠐⠠⠔⠀⠀⠀⠀⠀⠲⣿⠿⠛⠛⠓⠒⠂⠀⠀⠀⠀⠀⠀⠠⡉⢢⠙⣿
--⣿⠀⢀⠁⠀⠊⠀⠀⠀⠀⠀⠈⠁⠒⠂⠀⠒⠊⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⡇⠀⠀⠀⠀⠀⢀⣀⡠⠔⠒⠒⠂⠀⠈⠀⡇⣿
--⣿⠀⢸⠀⠀⠀⢀⣀⡠⠋⠓⠤⣀⡀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠄⠀⠀⠀⠀⠀⠀⠈⠢⠤⡀⠀⠀⠀⠀⠀⠀⢠⠀⠀⠀⡠⠀⡇⣿
--⣿⡀⠘⠀⠀⠀⠀⠀⠘⡄⠀⠀⠀⠈⠑⡦⢄⣀⠀⠀⠐⠒⠁⢸⠀⠀⠠⠒⠄⠀⠀⠀⠀⠀⢀⠇⠀⣀⡀⠀⠀⢀⢾⡆⠀⠈⡀⠎⣸⣿
--⣿⣿⣄⡈⠢⠀⠀⠀⠀⠘⣶⣄⡀⠀⠀⡇⠀⠀⠈⠉⠒⠢⡤⣀⡀⠀⠀⠀⠀⠀⠐⠦⠤⠒⠁⠀⠀⠀⠀⣀⢴⠁⠀⢷⠀⠀⠀⢰⣿⣿
--⣿⣿⣿⣿⣇⠂⠀⠀⠀⠀⠈⢂⠀⠈⠹⡧⣀⠀⠀⠀⠀⠀⡇⠀⠀⠉⠉⠉⢱⠒⠒⠒⠒⢖⠒⠒⠂⠙⠏⠀⠘⡀⠀⢸⠀⠀⠀⣿⣿⣿
--⣿⣿⣿⣿⣿⣧⠀⠀⠀⠀⠀⠀⠑⠄⠰⠀⠀⠁⠐⠲⣤⣴⣄⡀⠀⠀⠀⠀⢸⠀⠀⠀⠀⢸⠀⠀⠀⠀⢠⠀⣠⣷⣶⣿⠀⠀⢰⣿⣿⣿
--⣿⣿⣿⣿⣿⣿⣧⠀⠀⠀⠀⠀⠀⠀⠁⢀⠀⠀⠀⠀⠀⡙⠋⠙⠓⠲⢤⣤⣷⣤⣤⣤⣤⣾⣦⣤⣤⣶⣿⣿⣿⣿⡟⢹⠀⠀⢸⣿⣿⣿
--⣿⣿⣿⣿⣿⣿⣿⣧⡀⠀⠀⠀⠀⠀⠀⠀⠑⠀⢄⠀⡰⠁⠀⠀⠀⠀⠀⠈⠉⠁⠈⠉⠻⠋⠉⠛⢛⠉⠉⢹⠁⢀⢇⠎⠀⠀⢸⣿⣿⣿
--⣿⣿⣿⣿⣿⣿⣿⣿⣿⣦⣀⠈⠢⢄⡉⠂⠄⡀⠀⠈⠒⠢⠄⠀⢀⣀⣀⣰⠀⠀⠀⠀⠀⠀⠀⠀⡀⠀⢀⣎⠀⠼⠊⠀⠀⠀⠘⣿⣿⣿
--⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣷⣄⡀⠉⠢⢄⡈⠑⠢⢄⡀⠀⠀⠀⠀⠀⠀⠉⠉⠉⠉⠉⠉⠉⠉⠉⠉⠁⠀⠀⢀⠀⠀⠀⠀⠀⢻⣿⣿
--⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣷⣦⣀⡈⠑⠢⢄⡀⠈⠑⠒⠤⠄⣀⣀⠀⠉⠉⠉⠉⠀⠀⠀⣀⡀⠤⠂⠁⠀⢀⠆⠀⠀⢸⣿⣿
--⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣷⣦⣄⡀⠁⠉⠒⠂⠤⠤⣀⣀⣉⡉⠉⠉⠉⠉⢀⣀⣀⡠⠤⠒⠈⠀⠀⠀⠀⣸⣿⣿
--⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣷⣶⣤⣄⣀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣰⣿⣿⣿
--⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣶⣶⣶⣶⣤⣤⣤⣤⣀⣀⣤⣤⣤⣶⣾⣿⣿⣿⣿⣿

addHook("MobjSpawn", function(m)
    m.samusHP = 32 --1 samusHP = 1 PowerBeam shot. Missiles and charge shots bypass SamusHP and take regular HP.
    m.spazresist = true
    m.iceresist = true --Ice is reflected. Charge Shots bypass resistances.
	m.waveresist = true
	m.plasmaresist = true
end, MT_EGGANIMUS)

addHook("MobjSpawn", function(m)
    m.samusHP = 32 --1 samusHP = 1 PowerBeam shot. Missiles and charge shots bypass SamusHP and take regular HP.
    m.spazresist = true
    m.iceresist = true --Ice is reflected. Charge Shots bypass resistances.
    m.missileresist = true --Missiles are reflected.
	m.waveresist = true
	m.plasmaresist = true
end, MT_EGGANIMUS_EX)