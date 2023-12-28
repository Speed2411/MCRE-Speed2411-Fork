local vertical_dash_dist = 25*FRACUNIT

--Handles dashing in 3D
local function Do3DHyperDash(p)
    local pmo = p.mo
    --my god is this code a mess
    local dash_forward = (p.cmd.forwardmove) and not (((p.pflags & PF_USEDOWN) and (p.cmd.forwardmove) or ((p.cmd.forwardmove) and (p.cmd.sidemove))) and not (pmo.state == S_PLAY_FLOAT or pmo.state == S_PLAY_FLOAT_RUN))
    local dash_diagonal = ((p.cmd.forwardmove) and (p.cmd.sidemove)) and not ((p.pflags & PF_USEDOWN) and not (pmo.state == S_PLAY_FLOAT or pmo.state == S_PLAY_FLOAT_RUN))
	local dash_sideward = (p.cmd.sidemove) and not ((p.cmd.forwardmove) and (p.cmd.sidemove))  and not ((p.pflags & PF_USEDOWN) and not (pmo.state == S_PLAY_FLOAT or pmo.state == S_PLAY_FLOAT_RUN))
	local dash_upward = P_GetPlayerControlDirection(p) == 0 and not (p.pflags & PF_USEDOWN)
	local dash_downward = (p.pflags & PF_USEDOWN)
    if dash_forward then
    	P_Thrust(pmo, pmo.angle, p.actionspd)
		pmo.state = S_PLAY_ROLL
    elseif dash_diagonal then
    	P_Thrust(pmo, p.drawangle, p.actionspd)
		pmo.state = S_PLAY_ROLL
	elseif dash_sideward then
    	P_Thrust(pmo, p.drawangle, p.actionspd)
		pmo.state = S_PLAY_ROLL
    elseif dash_upward then
    	P_SetObjectMomZ(pmo, vertical_dash_dist, false)
		p.mrce.floatpause = 15
		pmo.state = S_PLAY_ROLL
		p.pflags = $|PF_JUMPED
	elseif dash_downward then
        P_SetObjectMomZ(pmo, -vertical_dash_dist * 2, false)
		p.mrce.floatpause = 15
		pmo.state = S_PLAY_ROLL
	end
end
--Handles dashing in 2D
--the exact same way it worked in Sonic 3 & Knuckles
local function Do2DHyperDash(player)
    local pmo = player.mo
    local dash_forward = (player.cmd.forwardmove)
	local dash_upward = (player.cmd.forwardmove > 0) and not (player.cmd.forwardmove < 0)
	local dash_downward = (player.cmd.forwardmove < 0) and not (player.cmd.forwardmove > 0)
    if not dash_forward then
		P_Thrust(pmo, pmo.angle, player.actionspd)
		pmo.state = S_PLAY_ROLL
	elseif dash_upward then
        P_SetObjectMomZ(pmo, vertical_dash_dist, false)
		player.mrce.floatpause = 15
		pmo.state = S_PLAY_ROLL
	elseif dash_downward then
        P_SetObjectMomZ(pmo, -vertical_dash_dist, false)
		player.mrce.floatpause = 15
		pmo.state = S_PLAY_ROLL
	end
end


addHook("PlayerThink",  function(p)
	local pmo = p.mo
	if not (pmo and pmo.valid) then return end
	if (p == nil) then return end
	local x = p.mrce
	if p.eggsuperflying == false
	and x.realspeed > 5*p.mo.scale
	and p.powers[pw_super]
	and x.spin and not P_IsObjectOnGround(pmo)
	and not (p.mo.state >= S_PLAY_SUPER_TRANS1 and p.mo.state <= S_PLAY_SUPER_TRANS6)
	and p.charability == 18
	and x.floatpause <= 0
	and P_MobjFlip(p.mo)*p.mo.momz <= 0 then
		if x.realspeed >= FixedMul(p.runspeed, p.mo.scale) then
			p.mo.state = S_PLAY_FLOAT_RUN
		else
			p.mo.state = S_PLAY_FLOAT
		end
		x.glide = 1
		P_SetObjectMomZ(p.mo, 0)
		p.pflags = $&~(PF_STARTJUMP|PF_SPINNING)
	else
		x.glide = 0
	end

	if x.floatpause > 0 then
		if P_IsObjectOnGround(pmo) then
			x.floatpause = 0
		else
			x.floatpause = $ - 1
		end
	end

	if MRCE_isHyper(p) and p.charability == 18
	and x.realspeed < 5*p.mo.scale
	and P_MobjFlip(p.mo)*p.mo.momz <= 0
	and not (p.mo.state >= S_PLAY_SUPER_TRANS1 and p.mo.state <= S_PLAY_SUPER_TRANS6)
	and p.eggsuperflying == false
	and x.floatpause <= 0
	and x.spin and not P_IsObjectOnGround(pmo) then
		if x.realspeed >= FixedMul(p.runspeed, p.mo.scale) then
			p.mo.state = S_PLAY_FLOAT_RUN
		else
			p.mo.state = S_PLAY_FLOAT
		end
		x.glide = 1
		P_SetObjectMomZ(p.mo, -3*FRACUNIT)
		p.pflags = $&~(PF_STARTJUMP|PF_SPINNING)
	else
		x.glide = 0
	end
	if p.charability == 18 and MRCE_isHyper(p)
	and not (p.pflags & PF_THOKKED)
	and not (p.pflags & PF_SHIELDABILITY)then
		if x.c1 == 1 and not P_IsObjectOnGround(pmo) then
			p.pflags = $1 | PF_THOKKED
			S_StartSound(pmo, sfx_s3kb6)
			P_NukeEnemies(pmo, pmo, 1214*FRACUNIT)
			if p.screenflash == true and p == displayplayer then
				P_FlashPal(p, PAL_WHITE, 7)
			end
			if not (pmo.flags2 & MF2_TWOD) then
				Do3DHyperDash(p) --3D Hyper Dash
			else
				Do2DHyperDash(p) --2D Hyper Dash
			end
		end
	end
end)