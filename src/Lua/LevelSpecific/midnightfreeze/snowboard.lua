--snowboards
freeslot(
"MT_SNOWBOARD",
"S_SNOWBOARD"
)
addHook("PlayerThink", function(p)
	if not p.realmo then return end
	if p.spectator then return end
	local x = p.mrce
	local sb = x.snowboard
	local momangle = R_PointToAngle2(0,0,p.rmomx,p.rmomy)
	if sb == true and p.playerstate == PST_LIVE then
		if not (p.pflags & PF_SPINNING) then
			p.pflags = $|PF_SPINNING
		end
		if not P_IsObjectOnGround(p.mo) and not (p.pflags & PF_THOKKED) then
			p.pflags = $|PF_THOKKED
		end
		if p.spinitem then
			p.spinitem = 0
		end
		if x.realspeed > 100*FRACUNIT then
			P_Thrust(p.mo, momangle+ANGLE_180, x.realspeed - 100*FRACUNIT)
		end
		--p.drawangle = momangle + (90*ANG1)
		p.mo.state = S_PLAY_FALL
	    if (p.cmd.sidemove != 0) then
			if P_IsObjectOnGround(p.mo) then
				p.mo.movefactor = $ * 3
			else
				p.mo.movefactor = $  / 3
			end
		end
		if x.spinkick > 0 then
			x.spinkick = $ - 1
			if x.realspeed < 28*FRACUNIT and P_IsObjectOnGround(p.mo) then
				if x.realspeed > 7*FRACUNIT then
					P_InstaThrust(p.mo, momangle, 30*FRACUNIT)
				else
					P_InstaThrust(p.mo, p.mo.angle, 30*FRACUNIT)
				end
			end
		end
		if x.spin == 2 then
			x.spinkick = 7
		end
	end
end)

mobjinfo[MT_SNOWBOARD] = {
	doomednum = 3114,
	spawnstate = S_SNOWBOARD,
	radius = 28*FRACUNIT,
	height = 38*FRACUNIT,
	flags = MF_SPECIAL
}

states[S_SNOWBOARD] = {
	sprite = SPR_KYST,
	frame = A,
}
addHook("SpinSpecial", function(p)
	if not p.realmo then return end
	if p.spectator then return end
	if p.mrce.snowboard then
		return true
	end
end)



addHook("TouchSpecial", function(mo, toucher)
	if mo and mo.valid and toucher and toucher.valid and toucher.player and toucher.player.mrce and not toucher.player.mrce.snowboard then
		toucher.player.mrce.snowboard = true
		return true
	end
end, MT_SNOWBOARD)