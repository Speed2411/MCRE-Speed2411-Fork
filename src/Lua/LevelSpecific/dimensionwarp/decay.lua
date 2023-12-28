local debug = 0
local rumbletimer = true
local inverttimer = 0

addHook("ThinkFrame", function()
	if debug == 1 then
		print(mapheaderinfo[gamemap].lvlttl)
	end
	if mapheaderinfo[gamemap].lvlttl != "Dimension Warp" then return end
	rumbletimer = P_RandomChance(FRACUNIT/2)
	inverttimer = $ - 1
	if rumbletimer and inverttimer == 0 then
		P_StartQuake(50*FRACUNIT, 175)
		P_FlashPal(player, 5, 8)
		if not (S_SoundPlaying(p.mo, sfx_rumble)) then
			S_StartSound(p.mo, sfx_rumble)
		end
		inverttimer = 28 * TICRATE
	end
end)