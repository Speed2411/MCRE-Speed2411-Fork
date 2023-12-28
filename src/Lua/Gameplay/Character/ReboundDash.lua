--This addon is marked as reusable, so do what you want with it. ~Krabs

--Dash
local DASHLENGTH = 24
local DASHZPERCENT = 50

--Factors
local WATERFACTOR = FRACUNIT * 2/3
local SUPERFACTOR = FRACUNIT * 5/3

--Wall bounce vertical
local WALLBOUNCEZ = 12 * FRACUNIT
local WEAKWALLBOUNCEZ = 4 * FRACUNIT
local NOCLWALLBOUNCEZ = 3 * FRACUNIT
local SECONDBOUNCEZMULT = 120

--Wall bounce thrust based on direction of the wall
local WALLTHRUST = 5 * FRACUNIT
local WEAKWALLTHRUST = FRACUNIT / 5
local NOCLIMBWALLTHRUST = 3 * FRACUNIT

--Wall bounce reflected speed accross the wall
local BOUNCEPERCENT = 16
local WEAKBOUNCEPERCENT = 3

--Badnik bounce
local BADNIKZMULT = 120
local BADNIKSPEED = 80
local BADNIKBUMP = 20

--hyper smoke
local colors = {SKINCOLOR_EMERALD, SKINCOLOR_PURPLE, SKINCOLOR_BLUE, SKINCOLOR_CYAN, SKINCOLOR_ORANGE, SKINCOLOR_RED, SKINCOLOR_GREY}
local function newGunLook(player, checkrange, superman, allowhazards, spanxy, spanxyz) --modified from krab's battlemod
	local twod = (twodlevel or player.mo.flags2 & MF2_TWOD)
	local ringdist, span2d
	if not(twod) then
		ringdist = checkrange*2*FRACUNIT
		span2d = spanxy
	else
		ringdist = checkrange*FRACUNIT
		span2d = spanxy - ANG10
	end
	local maxdist = FixedMul(ringdist, player.mo.scale)
	local closestdist = 0
	local closestmo = nil
	searchBlockmap("objects",function(pmo,mo)
		if not (mo.flags & MF_SHOOTABLE) then return end
		if not (mo.health) then return end -- dead
		if not (mo.player) and not (mo.flags & (MF_ENEMY|MF_BOSS|MF_MONITOR|MF_SPRING)) then return end
		if mo.type == MT_RING_REDBOX and not (player.ctfteam == 1) then return end  //CTF monitor
		if mo.type == MT_RING_BLUEBOX and not (player.ctfteam == 2) then return end
		if (mo.type == MT_EGGMAN_BOX or mo.type == MT_EGGMAN_GOLDBOX) and not allowhazards then return end
		if (mo == pmo) then return end
		if (mo.flags2 & MF2_FRET) then return end
		if (mo.player and (CBW_Battle and CBW_Battle.MyTeam(player,mo.player) or mo.player.spectator)) then return end //Disallow targeting teammates
		local zdist = (pmo.z + pmo.height/2) - (mo.z + mo.height/2) //Do angle/distance checks
		local dist = FixedHypot(pmo.x-mo.x, pmo.y-mo.y)
		local xyz_angle = abs(R_PointToAngle2(0, 0, dist, zdist))
		local xy_angle = abs(R_PointToAngle2(pmo.x + P_ReturnThrustX(pmo, pmo.angle, pmo.radius), pmo.y + P_ReturnThrustY(pmo, pmo.angle, pmo.radius), mo.x, mo.y) - pmo.angle)
		dist = FixedHypot(dist, zdist)
		if (dist > maxdist) then
			return -- out of range
		end
		if (xyz_angle > spanxyz) then
			return -- Don't home outside of desired angle!
		end
		if (twod
		and abs(pmo.y-mo.y) > pmo.radius) then
			return -- not in your 2d plane
		end
		if ((closestmo and closestmo.valid) and (dist > closestdist)) then
			return
		end
		if (xy_angle > span2d) then
			return -- behind back
		end
		if not (P_CheckSight(pmo, mo))
		and not superman then
			return -- out of sight
		end
		closestmo = mo
		closestdist = dist
	end,player.mo,player.mo.x-maxdist,player.mo.x+maxdist,player.mo.y-maxdist,player.mo.y+maxdist)
	return closestmo
end

freeslot("SKINCOLOR_SPEEDYBLUE")
skincolors[SKINCOLOR_SPEEDYBLUE] = {
    name = "Speedy-Blue",
    ramp = {129,130,131,132,134,151,151,153,154,167,156,168,168,169,169,253},
    invcolor = SKINCOLOR_KETCHUP,
    invshade = 9,
    chatcolor = V_BLUEMAP,
    accessible = true
}

--Assign sprites, objects, and sfx
freeslot(
	"SPR_REBO",
	"MT_REBOUND",
	"S_REBOUND",
	"sfx_airdsh",
	"sfx_bounc1",
	"sfx_bounc2",
	"sfx_strdsh",
	"MT_REBOUNDFIREBALL_AURA"
)

--Closed captions
sfxinfo[sfx_airdsh].caption = "Dash"
sfxinfo[sfx_bounc1].caption = "Rebound"
sfxinfo[sfx_bounc2].caption = "Heavy Rebound"
sfxinfo[sfx_s3k82].caption = "/"

--Wallbounce ring effect object
mobjinfo[MT_REBOUND] = {
	doomednum = -1,
	spawnstate = S_REBOUND,
	flags = MF_NOCLIP|MF_SCENERY|MF_NOGRAVITY
}
states[S_REBOUND] = {
	sprite = SPR_REBO,
	frame = TR_TRANS50|FF_PAPERSPRITE|A
}

--FixedLerp
local function FixedLerp(a, b, w)
    return FixedMul((FRACUNIT - w), a) + FixedMul(w, b)
end

--Functions needed to do the bounce calculations (these could also be used to allow bounces off of sloped terrain, but I don't think we need to do that for this ability)
local function SphereToCartesian(alpha, beta)
	local t = {}

	t.x = FixedMul(cos(alpha), cos(beta))
	t.y = FixedMul(sin(alpha), cos(beta))
	t.z = sin(beta)

	return t
end

local function FixedDotProduct3D(a, b)
	return FixedMul(a.x, b.x) + FixedMul(a.y, b.y) + FixedMul(a.z, b.z)
end

local function FixedScalar3D(vect, scalar)
	local vect2 = {}
	vect2.x = FixedMul(vect.x, scalar)
	vect2.y = FixedMul(vect.y, scalar)
	--vect2.z = FixedMul(vect.z, scalar)
	vect2.z = vect.z

	return vect2
end

local function Percent3D(vect, percent)
	local vect2 = {}
	vect2.x = vect.x * percent / 100
	vect2.y = vect.y * percent / 100
	--vect2.z = FixedMul(vect.z, scalar)
	vect2.z = vect.z

	return vect2
end

local function VectAdd3D(vecta, vectb)
	local vsum = {}
	vsum.x = vecta.x + vectb.x
	vsum.y = vecta.y + vectb.y
	vsum.z = vecta.z + vectb.z

	return vsum
end

local function VectorBounce(mo,vmom,vslopenorm,percent)
	local player = mo.player
	if (player == nil) or (player.playerstate != PST_LIVE) then return end

	local vbounce = Percent3D(VectAdd3D(FixedScalar3D(FixedScalar3D(vslopenorm, FixedDotProduct3D(vmom,vslopenorm)), -2 * FRACUNIT), vmom), percent)

	mo.momx = vbounce.x
	mo.momy = vbounce.y
	mo.momz = vbounce.z
end

local function DoWallBounce(mo,player,wallnormangle,walltype,side,reflect,slope)
	--Wall type
	local bouncy = (walltype == 2)
	local hbouncy = (walltype == 3)
	local vbouncy = (walltype == 4)
	local nocl = (walltype == 1)

	--Hold jump button for better bounce, don't hold for small bounce
	local bigbounce = player.holdingjump

	--Calculate angle
	local vwallnorm
	if slope == nil then
		vwallnorm = SphereToCartesian(wallnormangle, 0)
	else
		vwallnorm = slope.normal
	end

	--Noclimb wall
	if nocl then
		bigbounce = false
		S_StartSound(mo,sfx_s3k9e)
	end

	--Bounce stats based on the situation
	local percent = BOUNCEPERCENT
	if not bigbounce then
		percent = WEAKBOUNCEPERCENT
	end
	local bouncez = WEAKWALLBOUNCEZ

	--Hold jump button for better bounce, don't hold for small bounce
	if bigbounce and not nocl then
		bouncez = WALLBOUNCEZ
	elseif nocl then
		bouncez = NOCLWALLBOUNCEZ
	end

	--Screenshake
	if player == consoleplayer and (bigbounce or nocl) then
		local shake = 12
		local shaketics = 3
		if player.powers[pw_super] then
			shake = 18
			shaketics = 5
		end
		P_StartQuake(shake * FRACUNIT, shaketics)
	end

	--mobj momentum vector
	local vmom = {}
	vmom.x = mo.momx
	vmom.y = mo.momy
	vmom.z = mo.momz

	--Reset jump flags
	player.pflags = $ | PF_JUMPED
	player.pflags = $ | PF_STARTJUMP

	local weak = false
	if not bigbounce and not nocl then
		--Weak bump sfx
		S_StartSoundAtVolume(mo,sfx_s3k5d,155)
		weak = true
	end

	--Double dash is allowed after a wall jump
	if player.doubledash == nil or player.hyperbonus > 0 then
		player.doubledash = true
		if player.hyperbonus > 0 then
			player.hyperbonus = $ - 1
			player.pflags = $1 & ~PF_THOKKED
		end
		--1st bounce sfx
		if not weak then
			S_StartSoundAtVolume(mo,sfx_bounc1,175)
		end
	elseif player.hyperbonus == 0 then
		player.doubledash = false
		mo.state = S_PLAY_SPRING
		bouncez = $ * SECONDBOUNCEZMULT / 100
		percent = $ + 12
		player.pflags = $ | PF_NOJUMPDAMAGE
		--2nd bounce sfx
		if not weak then
			S_StartSound(mo,sfx_bounc2)
		end
	end

	--Wallthrust (the strength of momentum applied in the direction of the wall norm)
	local wallth = WALLTHRUST
	if not bigbounce then
		wallth = WEAKWALLTHRUST
	end
	if nocl then
		wallth = NOCLIMBWALLTHRUST
	end

	if (player.powers[pw_shield] == SH_BUBBLEWRAP) or MRCE_isHyper(player) then
		wallth = $ + (FixedHypot(mo.previousx, mo.previousy) / 600)
		if not MRCE_isHyper(player) then
			S_StartSound(mo, sfx_s3k44)
		end
	end

	if (player.powers[pw_shield] == SH_ELEMENTAL) or MRCE_isHyper(player) then
		A_OldRingExplode(mo, MT_FIREBALLTRAIL)
		S_StartSound(mo, sfx_s3k49)
		local meteorquake = MRCE_isHyper(player) and 40*FU or 20*FU
		P_StartQuake(meteorquake, 7)
		--for i = 1, 3, 1 do
			--P_RadiusAttack(mo, mo, 120*FU, DMG_FIRE, false) --doing the attack on this line causes a c stack overflow. for some reason
		--end
	end

	if (player.powers[pw_shield] == SH_ARMAGEDDON) then
		player.reboundarmatime = 5
	end

	if (player.powers[pw_shield] & SH_FORCE) then
		S_StartSound(mo, sfx_ngskid)
	end

	--Wall type
	if bouncy then
		S_StartSound(mo,sfx_s3k87)
		bouncez = $ + 6*FRACUNIT
		percent = $ + 6
	end
	if hbouncy then
		wallth = $ + 40*FRACUNIT
		S_StartSound(mo,sfx_cdfm74)
	end
	if vbouncy then
		wallth = $ / 2
		percent = $ / 4
		bouncez = $ + 11*FRACUNIT
		S_StartSound(mo,sfx_cdfm62)
	end

	--Do the horizontal bounce
	if reflect == 1 then--wall
		VectorBounce(mo,vmom,vwallnorm,percent)

		if slope != nil then--slope bounce
			mo.momz = wallth

		else--wall bounce
			if side == 1 then
				P_Thrust(mo, wallnormangle, FixedMul(wallth, mo.scale))
				player.drawangle = wallnormangle
			else
				P_Thrust(mo, wallnormangle, FixedMul(-wallth, mo.scale))
				player.drawangle = wallnormangle + ANGLE_180
			end
		end
	elseif reflect == 0 then--boss
		percent = $ - 10
		mo.momz = $ + 2 * FRACUNIT
		mo.momx = $ * percent / 100
		mo.momy = $ * percent / 100
		P_Thrust(mo, wallnormangle, wallth)
		player.drawangle = wallnormangle
	elseif reflect == 2 then--badnik/monitor
		local zm = max(0, (player.dashticsleft * 6/10) + 38)//The badnik bounce force reduces based on the dash length
		local bubbbounce = player.powers[pw_shield] == SH_BUBBLEWRAP and (3*BADNIKZMULT/2) or BADNIKZMULT
		bouncez = max(abs(mo.momz * (zm) / 100), $) * bubbbounce / 100
		if bigbounce then
			mo.momx = $ * BADNIKSPEED / 100
			mo.momy = $ * BADNIKSPEED / 100
		else
			mo.momx = $ * BADNIKBUMP / 100
			mo.momy = $ * BADNIKBUMP / 100
		end
	elseif reflect == 3 then--egg colosseum
		mo.momz = $ * 3 / 4
		player.drawangle = wallnormangle
	end

	--Reset stuff
	player.bounceline = nil
	player.dashticsleft = nil
	player.reboundtarget = nil

	--Vertical boost
	if mo.eflags & MFE_UNDERWATER then
		bouncez = FixedMul($, WATERFACTOR)
	end
	if player.powers[pw_super] then
		bouncez = FixedMul($, SUPERFACTOR)
	end
	if (player.powers[pw_shield] == SH_WHIRLWIND) or MRCE_isHyper(player) then
		bouncez = ($ * 4) / 3
		if (player.powers[pw_shield] == SH_WHIRLWIND) then
			S_StartSound(mo,sfx_wdjump)
		end
	end
	bouncez = FixedMul($, mo.scale)
	if mo.eflags & MFE_VERTICALFLIP then
		mo.momz = min($,-bouncez)
	else
		mo.momz = max($,bouncez)
	end

	--Wallbounce dust
	if nocl then
		local dustcount = 6
		while dustcount > 0 do
			dustcount = $ - 1
			local dust = P_SpawnMobjFromMobj(mo, 0, 0, mo.scale * 18, MT_SPINDUST)
			dust.state = S_MINECARTSPARK
			dust.momx = (mo.momx * 3) + (P_RandomRange(-20,20) * FRACUNIT)
			dust.momy = (mo.momy * 3) + (P_RandomRange(-20,20) * FRACUNIT)
			dust.momz = P_RandomRange(-3,3) * FRACUNIT
			dust.scale = FRACUNIT * P_RandomRange(50,125) / 100
			dust.destscale = 0
			dust.angle = P_RandomRange(0,ANGLE_180)
			dust.fuse = 10
		end
	else
		local dustcount = 10
		if not bigbounce then
			dustcount = 5
		end
		while dustcount > 0 do
			dustcount = $ - 1
			local dust = P_SpawnMobjFromMobj(mo, 0, 0, mo.scale * 18, MT_SPINDUST)
			dust.momx = (mo.momx * 2) + (P_RandomRange(-10,10) * FRACUNIT)
			dust.momy = (mo.momy * 2) + (P_RandomRange(-10,10) * FRACUNIT)
			dust.momz = P_RandomRange(-3,3) * FRACUNIT
			dust.scale = FRACUNIT * P_RandomRange(50,125) / 100
			dust.destscale = 0
			if MRCE_isHyper(player) and player.mo.skin != "supersonic" then
				dust.color = colors[P_RandomRange(1, #colors)]
			elseif player.mo.skin == "supersonic" and player.hyper.transformed == true then
				dust.color = colors[P_RandomRange(1, #colors)]
			elseif player.mo.skin == "supersonic" and (player.powers[pw_shield] & SH_FIREFLOWER) then
				dust.color = SKINCOLOR_FIRESTORMSUPER
			else
				dust.color = mo.color
			end
			dust.colorized = true
			dust.state = S_BOSSEXPLODE
		end
	end

	if bigbounce then
		--Wallbounce big puff of smoke
		local boom = P_SpawnMobjFromMobj(mo, 0, 0, 0, MT_SPINDUST)
		boom.state = S_XPLD3
		boom.colorized = true
		if MRCE_isHyper(player) and player.mo.skin != "supersonic" then
			boom.color = colors[P_RandomRange(1, #colors)]
		elseif player.mo.skin == "supersonic" and player.hyper.transformed == true then
			boom.color = colors[P_RandomRange(1, #colors)]
		elseif player.mo.skin == "supersonic" and (player.powers[pw_shield] & SH_FIREFLOWER) then
			boom.color = SKINCOLOR_FIRESTORMSUPER
		else
			boom.color = mo.color
		end
	end
	--hyper nuke
	if MRCE_isHyper(player)
	or (mo.skin == "supersonic" and player.hyper and player.hyper.transformed) then
		P_NukeEnemies(mo, mo, 1000*FRACUNIT)
		S_StartSound(player.mo, sfx_zoom)
		if player.screenflash == true and player == displayplayer then
			P_FlashPal(player, PAL_WHITE, 7)
		end
	elseif (player.powers[pw_shield] == SH_ELEMENTAL) then
		P_RadiusAttack(mo, mo, 240*FU, DMG_FIRE, false)
	end

	--Wallbounce circle effect
	local circle = P_SpawnMobjFromMobj(mo, 0, 0, mo.scale * 19, MT_REBOUND)
	circle.angle = wallnormangle + ANGLE_90
	circle.fuse = 9
	circle.scale = 0
	circle.destscale = 10*FRACUNIT
	circle.color = mo.color
	circle.colorized = true

	if not bigbounce then
		circle.fuse = 6
	end
end


--Rebound dash
addHook("AbilitySpecial", function(player)
	local mo = player.mo
	if not (player.charability == 18) then return end
	if (player.pflags & (PF_THOKKED|PF_SHIELDABILITY)) and player.doubledash != true then return true end

	if player.doubledash == true then
		player.doubledash = false
	end

	--Flags, timers, state
	mo.state = S_PLAY_JUMP
	player.pflags = $1 | PF_JUMPED
	player.pflags = $1 | PF_THOKKED
	player.pflags = $1 & ~(PF_SPINNING|PF_STARTDASH)
	player.dashticsleft = DASHLENGTH * 10
	player.holdingjump = true

	--Screenshake
	if player == consoleplayer and player.powers[pw_super] then
		local shake = 10
		local shaketics = 3
		P_StartQuake(shake * FRACUNIT, shaketics)
	end

	--XY Momentum, timer
	local dashsp = player.actionspd
	if mo.eflags & MFE_UNDERWATER then
		dashsp = FixedMul($, WATERFACTOR)
	end
	if player.powers[pw_super] then
		dashsp = FixedMul($, SUPERFACTOR)
	end

	local momangle = R_PointToAngle2(0,0,player.rmomx,player.rmomy)
	local anglediff = AngleFixed(abs(momangle - mo.angle)) / FRACUNIT
	local pspd = player.mrce.realspeed

	local speedpercentage = max(0, min(100, (100 - (anglediff - 50))))
	pspd = $ * speedpercentage / 100

	if (mo.skin == "supersonic" and (player.powers[pw_shield] & SH_FIREFLOWER)) or (player.powers[pw_shield] == SH_FLAMEAURA) or MRCE_isHyper(player) then
		S_StartSound(player.mo, sfx_s3k43)
		local pspsps = (FixedMul(max(dashsp,pspd), mo.scale) + (player.mrce.realspeed / 4))
		P_InstaThrust(mo, mo.angle, pspsps)
		if MRCE_isHyper(player) and player.dashticsleft > 239 then
			player.normalspeed = $ + (pspsps / 4)
		end
	else
		P_InstaThrust(mo, mo.angle, FixedMul(max(dashsp,pspd), mo.scale))
	end

	//Z momentum
	if mo.eflags & MFE_VERTICALFLIP then
		if mo.momz > 0 then
			mo.momz = $ * DASHZPERCENT / 100
		end
	else
		if mo.momz < 0 then
			mo.momz = $ * DASHZPERCENT / 100
		end
	end

	--Visual and sfx
	player.lockangle = mo.angle
	if player.doubledash != nil and player.hyperbonus == 0 then
		S_StartSound(mo,sfx_strdsh)
	else
		S_StartSound(mo,sfx_airdsh)
	end
	local circle = P_SpawnMobjFromMobj(mo, 0, 0, mo.scale * 24, MT_REBOUND)
	circle.angle = mo.angle + ANGLE_90
	circle.fuse = 7
	circle.scale = FRACUNIT / 3
	circle.destscale = 10*FRACUNIT
	circle.colorized = true
	circle.color = mo.color
	circle.momx = -mo.momx / 2
	circle.momy = -mo.momy / 2

	return true
end)

addHook("ThinkFrame", function()
	for player in players.iterate() do
		local mo = player.mo
		if not (player.charability == 18) then continue end
		if (player == nil) or (player.playerstate != PST_LIVE) then continue end
		if player.spectator then continue end

		if player.prevpflags != nil then
			--Roll after dash
			if P_IsObjectOnGround(mo) and (player.prevpflags & PF_THOKKED) and (player.cmd.buttons & BT_SPIN) and not player.eggsuperflying
			and (FixedHypot(mo.momx, mo.momy) > (5 * mo.scale)) then
				mo.state = S_PLAY_ROLL
				player.pflags = $ | PF_SPINNING
				S_StartSound(mo,sfx_spin)
			end
		end

		--Reset dash counter and timer
		if (P_IsObjectOnGround(mo)) then
			player.doubledash = nil
			player.dashticsleft = nil
			player.holdingjump = nil
			if MRCE_isHyper(player)
			or (player.powers[pw_shield] & SH_FORCE)
			or (player.hyper and player.hyper.transformed) then
				player.hyperbonus = 2 --handles resetting hyper bonus, which allows to rebound 3 times instead of 2 when hyper. setting this to 1 will remove that buff,
			else							--while increasing it will give you more bonus rebounds. setting it to 0 will make you only able to rebound a single time, so don't do that
				player.hyperbonus = 0
			end
		end

		player.prevpflags = player.pflags
	end
end)

local framelist = {0, 1, 3, 4}
addHook("PostThinkFrame", function()
	for player in players.iterate() do
		local mo = player.mo
		if not (player.charability == 18) then continue end
		if (player == nil) or (player.playerstate != PST_LIVE) then continue end
		if player.spectator then continue end

		if (mo.previousx == nil) or (mo.previousy == nil) or (mo.previousz == nil) then
			mo.previousx = mo.x
			mo.previousy = mo.y
			mo.previousz = mo.z
		end

		if (player.mrce.realspeed > 15*FRACUNIT) and (player.pflags & PF_SPINNING) and not (player.pflags & PF_JUMPED) and not player.mrce.snowboard then
			for i = 0, 9, 1 do
				local percent = FRACUNIT * (i * 10) / 100
				local trail = P_SpawnGhostMobj(mo)
				local tx = FixedLerp(mo.x,mo.previousx,percent)
				local ty = FixedLerp(mo.y,mo.previousy,percent)
				local tz = FixedLerp(mo.z + 3*FRACUNIT,mo.previousz + 4*FRACUNIT,percent)
				P_MoveOrigin(trail, tx, ty, tz - 7 * FRACUNIT)
				trail.fuse = 13
				trail.state = S_THOK
				trail.scalespeed = FRACUNIT/12
				trail.scale = FixedMul(((FRACUNIT * 5/6) - (i * FRACUNIT/120)), mo.scale)
				trail.destscale = 0
				trail.frame = TR_TRANS70|A
			end
		end

		if player.doubledash and  mo.state == S_PLAY_JUMP then
			mo.frame = framelist[(leveltime % 4) + 1]
			if player.powers[pw_super] or player.mo.skin == "supersonic" then
				mo.frame = $|FF_FULLBRIGHT
			end
			local g = P_SpawnGhostMobj(mo)
			if player.powers[pw_super] then
				g.frame = 2 | TR_TRANS70|FF_FULLBRIGHT
			else
				g.frame = 2 | TR_TRANS70
			end
			g.tics = 1

			if (leveltime % 3 == 0) then
				S_StartSoundAtVolume(mo, sfx_s3k82, 40)
				g = P_SpawnGhostMobj(mo)
				g.frame = 2 | TR_TRANS90
				g.tics = 5
				g.destscale = 0
			end
		end

		if player.dashticsleft then
			player.drawangle = player.lockangle

			if mo.state != S_PLAY_JUMP then
				player.doubledash = nil
				player.dashticsleft = nil

			else
				--Check if the player is still holding jump
				if player.holdingjump then
					player.holdingjump = (player.cmd.buttons & BT_JUMP)
					local holdingforward
					local fm = player.cmd.forwardmove
					local sm = player.cmd.sidemove

					if player.pflags&PF_ANALOGMODE then --god damn it fuck
						local angleturn = player.cmd.angleturn<<FRACBITS
						local angdiff = player.lockangle - angleturn
						local sine = sin(angdiff)
						local cosine = cos(angdiff)
						local realforward = fm*cosine + sm*sine

						holdingforward = realforward >= 10*FRACUNIT
					else
						holdingforward = (fm >= 10)
					end

					--Short dash by letting go of the button and not holding forward
					if not player.holdingjump and not holdingforward then
						if player.dashticsleft > 10*DASHLENGTH - 30 then
							mo.momx = FixedDiv($, 2 * FRACUNIT)
							mo.momy = FixedDiv($, 2 * FRACUNIT)
						elseif player.dashticsleft > 10*DASHLENGTH - 50 then
							mo.momx = FixedDiv(FixedMul($, 2 * FRACUNIT), 3 * FRACUNIT)
							mo.momy = FixedDiv(FixedMul($, 2 * FRACUNIT), 3 * FRACUNIT)
						elseif player.dashticsleft > 10*DASHLENGTH - 60 then
							mo.momx = FixedDiv(FixedMul($, 3 * FRACUNIT), 4 * FRACUNIT)
							mo.momy = FixedDiv(FixedMul($, 3 * FRACUNIT), 4 * FRACUNIT)
						elseif player.dashticsleft > 10*DASHLENGTH - 70 then
							mo.momx = FixedDiv(FixedMul($, 4 * FRACUNIT), 5 * FRACUNIT)
							mo.momy = FixedDiv(FixedMul($, 4 * FRACUNIT), 5 * FRACUNIT)
						end
					end
				end
				if player.holdingjump then
					--Thok trail (which disappears a bit earlier in order to make sure the player *really* knows they messed up the timing when they hit a wall too late)
					if player.dashticsleft > 80 then
						if (mo.skin == "supersonic" and (player.powers[pw_shield] & SH_FIREFLOWER)) or (player.powers[pw_shield] == SH_FLAMEAURA) or (MRCE_isHyper(player)) then
							if (leveltime % 2 == 0) and not (mo.eflags & MFE_UNDERWATER) then
								local aura = P_SpawnMobjFromMobj(mo,0,0,0,MT_REBOUNDFIREBALL_AURA)
								aura.angle = R_PointToAngle2(0,0,mo.momx,mo.momy)
								if player.powers[pw_super] then
									aura.colorized = true
								end
								aura.color = mo.color
							end
							if MRCE_isHyper(player) then
								MRCE_superSpark(mo, 4, 28, 1, 2*FRACUNIT, true, nil)
							elseif player.powers[pw_super] then
								MRCE_superSpark(mo, 2, 28, 1, 2*FRACUNIT, false, mo.color)
							elseif mo.eflags & MFE_UNDERWATER then
								A_BossScream(mo, 0, MT_MEDIUMBUBBLE)
								A_BossScream(mo, 0, MT_MEDIUMBUBBLE)
							else
								A_BossScream(mo, 0, MT_FIREBALLTRAIL)
							end
						end
						for i = 0, 9, 1 do
							local percent = FRACUNIT * (i * 10) / 100
							local trail = P_SpawnGhostMobj(mo)
							local tx = FixedLerp(mo.x,mo.previousx,percent)
							local ty = FixedLerp(mo.y,mo.previousy,percent)
							local tz = FixedLerp(mo.z + 3*FRACUNIT,mo.previousz + 4*FRACUNIT,percent)
							P_MoveOrigin(trail, tx, ty, tz - 7 * FRACUNIT)
							trail.fuse = 13
							trail.state = S_THOK
							trail.scalespeed = FRACUNIT/12
							trail.scale = (FRACUNIT * 4/5) - (i * FRACUNIT/120)
							trail.destscale = 0
							trail.frame = TR_TRANS70|A
							if mo.scale != FRACUNIT then
								trail.scale = FixedMul(((FRACUNIT * 4/5) - (i * FRACUNIT/120)), mo.scale)
							end
							if player.mrce.glowaura
							or player.powers[pw_super] or (player.powers[pw_shield] == SH_FLAMEAURA) then
								trail.blendmode = AST_ADD
								if (player.powers[pw_shield] == SH_FLAMEAURA) and not player.powers[pw_super] then
									trail.color = SKINCOLOR_KETCHUP
								end
							end
						end
					end
					player.dashticsleft = $ - 10
				else
					--Lesser thok trail (player let go of the jump button, so they can't wallbounce anymore)
					if player.dashticsleft > 80 then
						if mo.skin == "supersonic" and (player.powers[pw_shield] & SH_FIREFLOWER) then
							if (leveltime % 2 == 0) and not (mo.eflags & MFE_UNDERWATER) then
								local aura = P_SpawnMobjFromMobj(mo,0,0,0,MT_REBOUNDFIREBALL_AURA)
								aura.angle = R_PointToAngle2(0,0,mo.momx,mo.momy)
								--aura.color = mo.color
							end
							if MRCE_isHyper(player) then
								MRCE_superSpark(mo, 4, 28, 1, 2*FRACUNIT, true, nil)
							elseif player.powers[pw_super] then
								MRCE_superSpark(mo, 2, 28, 1, 2*FRACUNIT, false, mo.color)
							elseif mo.eflags & MFE_UNDERWATER then
								A_BossScream(mo, 0, MT_MEDIUMBUBBLE)
								A_BossScream(mo, 0, MT_MEDIUMBUBBLE)
							else
								A_BossScream(mo, 0, MT_FIREBALLTRAIL)
							end
						end
						for i = 0, 9, 1 do
							local percent = FRACUNIT * (i * 10) / 100
							local trail = P_SpawnGhostMobj(mo)
							local tx = FixedLerp(mo.x,mo.previousx,percent)
							local ty = FixedLerp(mo.y,mo.previousy,percent)
							local tz = FixedLerp(mo.z + 3*FRACUNIT,mo.previousz + 4*FRACUNIT,percent)
							P_MoveOrigin(trail, tx, ty, tz - 3 * FRACUNIT)
							trail.fuse = 9
							trail.state = S_THOK
							trail.scalespeed = FRACUNIT/15
							trail.scale = (FRACUNIT * 3/5) - (i * FRACUNIT/150)
							trail.destscale = 0
							trail.frame = TR_TRANS80|A
							if player.mo.scale != 1*FRACUNIT then
								trail.scale = FixedMul((FRACUNIT * 3/5) - (i * FRACUNIT/150), player.mo.scale)
							end
							if player.mrce.glowaura
							or player.powers[pw_super] or (player.powers[pw_shield] == SH_FLAMEAURA)  then
								trail.blendmode = AST_ADD
								if (player.powers[pw_shield] == SH_FLAMEAURA) then
									trail.color = SKINCOLOR_KETCHUP
								end
							end
						end
					end
					player.dashticsleft = $ - 15
				end
			end
		end

		--Reset bounceline
		player.bounceline = nil
		mo.previousx = mo.x
		mo.previousy = mo.y
		mo.previousz = mo.z
	end
end)

addHook("MobjLineCollide", function(mo, line)
	if not mo or not mo.valid then return end
	local player = mo.player
	if not (player.charability == 18) then return end
	if (player == nil) or (player.playerstate != PST_LIVE) then return end
	if (not player.dashticsleft) or (player.dashticsleft <= 0) then return end

	--Horizon line
	if line.special == 41 then return end

	--Set the bounceline so we can bounce off it later in case that line actually blocked the player from moving
	local side = P_PointOnLineSide(mo.x,mo.y,line)
	local sector = nil

	--One-sided walls
	if line.backsector == nil then
		player.bounceline = line
		player.bounceside = 0
		return
	end
	if line.frontsector == nil then
		player.bounceline = line
		player.bounceside = 1
		return
	end

	--Which side are we hitting the wall from?
	if side == 1 then
		sector = line.frontsector
	else
		sector = line.backsector
	end

	--Impassible line
	if (line.flags & ML_IMPASSIBLE) and line.frontside.midtexture then
		player.bounceline = line
		player.bounceside = side
		return
	end

	if sector == nil then return end

	--Polyobject
	for i = 0, #sector.lines, 1 do
		local li = sector.lines[i]
		if li == nil then continue end

		if li.special == 20 then--First line of polyobject
			local topheight = sector.ceilingheight
			local bottomheight = sector.floorheight

			if (topheight < mo.z) then
				return
			end

			if (bottomheight > mo.z + mo.height) then
				return
			end

			player.bounceline = line
			player.bounceside = side
			return
		end
	end

	--Standard
	local ceilz = sector.ceilingheight
	if sector.c_slope then
		ceilz = P_GetZAt(sector.c_slope, mo.x, mo.y)
	end
	if (ceilz < mo.z + mo.height) then
		if sector.ceilingpic != "F_SKY1" then
			player.bounceline = line
			player.bounceside = side
		end
		return
	end
	local floorz = sector.floorheight
	if sector.f_slope then
		floorz = P_GetZAt(sector.f_slope, mo.x, mo.y)
	end
	if (floorz > mo.z) then
		player.bounceline = line
		player.bounceside = side
		return
	end

	--FOF
	for rover in sector.ffloors() do
		if not (rover.flags & FF_EXISTS) or not (rover.flags & FF_BLOCKPLAYER) then
			continue
		end

		local topheight = rover.topheight
		local bottomheight = rover.bottomheight

		if (rover.t_slope) then
			topheight = P_GetZAt(rover.t_slope, mo.x, mo.y)
		end
		if (rover.b_slope) then
			bottomheight = P_GetZAt(rover.b_slope, mo.x, mo.y)
		end

		if (topheight < mo.z) then
			continue
		end

		if (bottomheight > mo.z + mo.height) then
			continue
		end

		player.bounceline = line
		player.bounceside = side
		if ((rover.flags & FF_BUSTUP) and not (rover.flags & FF_STRONGBUST))
		or ((rover.flags & FF_BUSTUP) and ((player.powers[pw_shield] == SH_ELEMENTAL) or MRCE_isHyper(player))) then
			player.bustsector = sector
			player.bustrover = rover
		end
		break
	end

	--Solid midtexture
	--TODO: once textures[] is exposed to lua, change this so it properly checks the height of a solid midtexture and decides if it's blocking the player or not.
	if (line.flags & ML_EFFECT4) and line.frontside.midtexture then
		player.bounceline = line
		player.bounceside = side
		return
	end
end, MT_PLAYER)

addHook("MobjDeath", function(enemy, mo)
	if not mo or not mo.valid then return end
	local player = mo.player
	if (player == nil) or (player.playerstate != PST_LIVE) then return end
	if not player.realmo then return false end
	if not (player.charability == 18) then return end
	if (not player.dashticsleft) or (player.dashticsleft <= 0) then return end

	if player.powers[pw_shield] == SH_ATTRACT and player.reboundtarget != nil then
		player.hyperbonus = 1
	end

	if enemy and enemy.valid and (enemy.flags & MF_MONITOR) then
		local wallnormangle = R_PointToAngle2(0, 0, mo.momx, mo.momy)
		DoWallBounce(mo,player,wallnormangle,false,0,2)
	end
end)

addHook("MobjDamage", function(enemy, mo)
	if not mo or not mo.valid then return end
	local player = mo.player
	if (player == nil) or (player.playerstate != PST_LIVE) then return end
	if not player.realmo then return false end
	if player.spectator then return false end
	if not (player.charability == 18) then return end
	if (not player.dashticsleft) or (player.dashticsleft <= 0) then return end

	if player.powers[pw_shield] == SH_ATTRACT and player.reboundtarget != nil then
		player.hyperbonus = 1
	end

	if enemy and enemy.valid and mobjinfo[enemy.type].spawnhealth > 1 and player.powers[pw_shield] == SH_ELEMENTAL then
		enemy.health = $ + 1
	end

	if enemy and enemy.valid and (enemy.flags & MF_ENEMY or enemy.flags & MF_BOSS) then
		local wallnormangle = R_PointToAngle2(0, 0, mo.momx, mo.momy)
		if enemy.type == MT_EGGMOBILE4 then
			DoWallBounce(mo,player,wallnormangle,false,0,3)
		elseif (enemy.info.spawnhealth > 1) then
			DoWallBounce(mo,player,wallnormangle,false,0,0)
		else
			DoWallBounce(mo,player,wallnormangle,false,0,2)
		end

		if (player.powers[pw_shield] == SH_ARMAGEDDON) and enemy.health and enemy.health >= 1 then
			P_DamageMobj(enemy, mo, mo, 1, DMG_NUKE)
			if not MRCE_isHyper(player) then
				S_StartSound(mo, sfx_zoom)
			end
		end
	end
end)

addHook("MobjMoveCollide", function(mo, other)
	if not mo or not mo.valid then return end
	local player = mo.player
	if (player == nil) or (player.playerstate != PST_LIVE) then return end
	if not (player.charability == 18) then return end
	if (not player.dashticsleft) or (player.dashticsleft <= 0) then return end
	if (other.flags & MF_SOLID) and not (other.flags & MF_ENEMY or other.flags & MF_BOSS or other.flags & MF_MONITOR or other.flags & MF_PAIN) and not (other.type == MT_PLAYER) then
		if (mo.z < other.z + other.height) and (mo.z + mo.height >= other.z) then
			if (other.flags & MF_PUSHABLE) then
				other.momx = $ + (mo.momx / 2)
				other.momy = $ + (mo.momy / 2)
				other.momz = 3 * FRACUNIT
			end
			local wallnormangle = R_PointToAngle2(mo.x - mo.momx, mo.y - mo.momy, other.x, other.y)
			DoWallBounce(mo,player,wallnormangle,false,0,1)
			return true
		end
	end
end, MT_PLAYER)

addHook("MobjMoveBlocked", function(mo)//, thing, line
	local player = mo.player
	if (not player.dashticsleft) or (player.dashticsleft <= 0) then return end
	local line = player.bounceline
	if line == nil then return end
	local side = player.bounceside//P_PointOnLineSide(mo.x - mo.momx, mo.y - mo.momy, line)
	if side == nil then return end

	--Noclimb walls result in a super weak bounce
	local nocl = line.flags & ML_NOCLIMB

	--Bouncy walls result in a beeg bounce
	local bouncy = (line.special == 999)
	local hbouncy = (line.special == 998)
	local vbouncy = (line.special == 997)

	--Bustable FOFs are busted
	if player.bustsector and player.bustrover and player.holdingjump then
		EV_CrumbleChain(nil, player.bustrover)
		player.bustsector = nil
		player.bustrover = nil
	end

	local wallnormangle = R_PointToAngle2(line.v1.x, line.v1.y, line.v2.x, line.v2.y) + ANGLE_90

	if bouncy then
		DoWallBounce(mo,player,wallnormangle,2,side,1)
	elseif hbouncy then
		DoWallBounce(mo,player,wallnormangle,3,side,1)
	elseif vbouncy then
		DoWallBounce(mo,player,wallnormangle,4,side,1)
	else
		if nocl and not MRCE_isHyper(player) and not (player.powers[pw_shield] & SH_FORCE) then
			nocl = 1
		end
		DoWallBounce(mo,player,wallnormangle,nocl,side,1)
	end
end, MT_PLAYER)


--FixedLerp
local function FixedLerp(a, b, w)
    return FixedMul((FRACUNIT - w), a) + FixedMul(w, b)
end

local armacolors = {SKINCOLOR_RED, SKINCOLOR_GREY}

addHook("PlayerThink", function(p)
	if not (p and p.mo and p.mo.valid) then return end
	local x = p.mrce
	if p.reboundarmatime then
		local momangle = R_PointToAngle2(0,0,p.rmomx,p.rmomy)
		for i = 1, 2, 1 do
			local sparkle = P_SpawnMobjFromMobj(p.mo, P_RandomRange(-30, 30) * FRACUNIT, P_RandomRange(-30, 30) * FRACUNIT, (P_RandomRange(-30, 30) * FRACUNIT) + (p.mo.height / 3), MT_SUPERSPARK)
			sparkle.momx = (P_RandomRange(-2, 2) * FRACUNIT) + P_ReturnThrustX(p.mo, momangle, x.realspeed)
			sparkle.momy = (P_RandomRange(-2, 2) * FRACUNIT) + P_ReturnThrustY(p.mo, momangle, x.realspeed)
			sparkle.momz =  (P_RandomRange(-2, 2) * FRACUNIT) + p.mo.momz
			sparkle.colorized = true
			sparkle.color = armacolors[P_RandomRange(1, #armacolors)]
			sparkle.fuse = 10
			sparkle.scale = 2 * p.mo.scale / 3
			sparkle.source = p.mo
		end
		p.reboundarmatime = max($ - 1, 0)
	end
	if ((p.powers[pw_shield] == SH_THUNDERCOIN)) and p.dashticsleft != nil and p.dashticsleft == 240 then
		P_SetObjectMomZ(p.mo, 10*FRACUNIT + (max(0, x.realspeed - 8*FRACUNIT)/12), false)
		if not MRCE_isHyper(p) then
			S_StartSound(p.mo, sfx_s3k40)
			for i = 1, 6, 1 do
				local spark = P_SpawnMobjFromMobj(p.mo, 0, 0, 0, MT_SUPERSPARK)
				local speed = 8
				spark.momx = P_RandomRange(-speed, speed) * FRACUNIT
				spark.momy = P_RandomRange(-speed, speed) * FRACUNIT
				spark.momz = P_RandomRange(-speed, speed) * FRACUNIT
			end
		end
	end
	if (p.powers[pw_shield] == SH_ATTRACT) and (p.pflags & PF_JUMPED) and p.reboundtarget == nil and p.dashticsleft == nil then
		p.reboundtarget = newGunLook(p, 400, false, false, ANG30, ANGLE_67h)
	end
	if p.reboundtarget and p.reboundtarget.valid and p.dashticsleft == nil then
		local newangle = abs(R_PointToAngle2(p.mo.x + P_ReturnThrustX(p.mo, p.mo.angle, p.mo.radius), p.mo.y + P_ReturnThrustY(p.mo, p.mo.angle, p.mo.radius), p.reboundtarget.x, p.reboundtarget.y) - p.mo.angle)
		if newangle > ANG30 then
			p.reboundtarget = newGunLook(p, 400, false, false, ANG30, ANGLE_67h)
		end
	end
	if P_IsObjectOnGround(p.mo) or p.dashticsleft == 1 or P_PlayerInPain(p) or (p.doubledash and p.doubledash == false) then p.reboundtarget = nil end
	if p.reboundtarget and p.reboundtarget.valid and (p.doubledash == nil or p.doubledash == true) then
		P_SpawnLockOn(p, p.reboundtarget, S_LOCKON1)
	end
	if p.reboundtarget and p.reboundtarget.valid and p.dashticsleft and p.dashticsleft > 1 then
		local dirang = R_PointToAngle2(p.mo.x, p.mo.y, p.reboundtarget.x, p.reboundtarget.y)
		local attstr = p.actionspd
		local rebounddist = R_PointToDist2(p.mo.x, p.mo.y, p.reboundtarget.x, p.reboundtarget.y)
		if p.powers[pw_super] then
			attstr = FixedMul($, SUPERFACTOR)
		end
		if (p.mo.eflags & MFE_UNDERWATER) then
			attstr = FixedMul($, WATERFACTOR)
		end
		if p.dashticsleft == 240 then
			S_StartSound(mo,sfx_s3k40)
		end
		local reboundfall = p.mo.z - (p.reboundtarget.z + (4 *p.reboundtarget.height / 5))
		if rebounddist > 15*FRACUNIT then
			P_InstaThrust(p.mo, dirang, max(attstr, x.realspeed))
		end
		if abs(reboundfall) > 5*FRACUNIT then
			P_SetObjectMomZ(p.mo, -(reboundfall / 3) + ((rebounddist / 80) + p.reboundtarget.momz), false)
		end
		--print(tostring(reboundfall / FRACUNIT) .. " " .. tostring(attstr / FRACUNIT))
	end
end)

addHook("ThinkFrame", function()
	for p in players.iterate do
		if p.spectator then return end
		if not p.realmo then return end

		if p.mo.skin == "sms" or p.mo.skin == "mario" or p.mo.skin == "luigi" then
			continue
		end

		if p.mrce.glowaura <= 0 then
			continue
		end

		if (p.charability2 == CA2_SPINDASH or p.mo.state == S_PLAY_ROLL or p.mo.state == S_PLAY_SPINDASH) and p.spinitem then
			p.spinitem = 0
		end
		if (p.charability == CA_HOMINGTHOK) and p.thokitem then
			p.thokitem = 0
		end
	end
end)

addHook("PostThinkFrame", function()
	for player in players.iterate() do
		local mo = player.mo
		if not (mo and mo.valid) then continue end
		if (mo.skin == "inazuma") or (mo.skin == "sms")  or (mo.skin == "mario")  or (mo.skin == "luigi") or (mo.skin == "adventuresonic") or (mo.skin == "jana") or (mo.skin == "bowser") or (mo.skin == "skip") or (mo.skin == "blaze") then continue end
		if (player == nil) or (player.playerstate != PST_LIVE) then continue end
		if player.mrce.glowaura <= 0 then continue end
		if player.charability == 18 then continue end

		if (mo.previousx == nil) or (mo.previousy == nil) or (mo.previousz == nil) then
			mo.previousx = mo.x
			mo.previousy = mo.y
			mo.previousz = mo.z
		end

		if (player.mrce.realspeed > 15*FRACUNIT) and (player.pflags & PF_SPINNING) and not player.mrce.snowboard
		or player.homing  then
			for i = 0, 9, 1 do
				local percent = FRACUNIT * (i * 10) / 100
				local trail = P_SpawnMobj(mo.x, mo.y, mo.z, MT_THOK)
				local tx = FixedLerp(mo.x,mo.previousx,percent)
				local ty = FixedLerp(mo.y,mo.previousy,percent)
				local tz = FixedLerp(mo.z + 3*FRACUNIT,mo.previousz + 4*FRACUNIT,percent)
				P_MoveOrigin(trail, tx, ty, tz - 7 * FRACUNIT)
				if (player.mo.skin == "shadow") and player.mo.color == SKINCOLOR_BLACK then
					trail.color = SKINCOLOR_YELLOW
				elseif (player.mo.skin == "metalsonic") and player.mo.color == SKINCOLOR_COBALT then
					trail.color = SKINCOLOR_PURPLE
				else
					trail.color = mo.color
				end
				trail.fuse = 13
				trail.state = S_THOK
				trail.scalespeed = FRACUNIT/12
				trail.scale = (FRACUNIT * 5/6) - (i * FRACUNIT/120)
				trail.destscale = 0
				trail.frame = TR_TRANS70|A
			end
		end

		mo.previousx = mo.x
		mo.previousy = mo.y
		mo.previousz = mo.z
	end
end)

//Begin thokaura
freeslot("MT_FAKETHOK", "MT_FAKESPIN")
freeslot("S_FAKETHOK", "S_FAKESPIN")
freeslot("SPR_FTHK", "SPR_FSPN")

local thok = MT_FAKETHOK
mobjinfo[thok].spawnstate = S_FAKETHOK
mobjinfo[thok].health = 1000
mobjinfo[thok].radius = 20*FRACUNIT
mobjinfo[thok].height = 41*FRACUNIT
mobjinfo[thok].speed = 8
mobjinfo[thok].flags = MF_SCENERY|MF_NOGRAVITY|MF_NOCLIP
mobjinfo[thok].dispoffset = 1

local spin = MT_FAKESPIN
mobjinfo[spin].spawnstate = S_FAKESPIN
mobjinfo[spin].health = 1000
mobjinfo[spin].radius = 20*FRACUNIT
mobjinfo[spin].height = 41*FRACUNIT
mobjinfo[spin].speed = 8
mobjinfo[spin].flags = MF_SCENERY|MF_NOGRAVITY|MF_NOCLIP
mobjinfo[spin].dispoffset = 1

states[S_FAKETHOK].sprite = SPR_FTHK
states[S_FAKETHOK].frame = A|FF_TRANS60
states[S_FAKETHOK].tics = 1
states[S_FAKETHOK].nextstate = S_NULL

states[S_FAKESPIN].sprite = SPR_FSPN
states[S_FAKESPIN].frame = A|FF_TRANS60
states[S_FAKESPIN].tics = 1
states[S_FAKESPIN].nextstate = S_NULL

addHook("ThinkFrame", function(p)
	for p in players.iterate do
		if not p.realmo then return end
		if p.spectator then return end
		if p.mrce.glowaura > 0 then
			if (p.mo.skin == "sonic") or (p.mo.skin == "metalsonic") or (p.mo.skin == "shadow") then
				if (p.mo.state == S_PLAY_JUMP) then
					local fakethok = P_SpawnMobjFromMobj(p.mo, 0*FRACUNIT, 0*FRACUNIT, -3*FRACUNIT, MT_FAKETHOK)
					if (p.mo.skin == "shadow") and (p.mo.color == SKINCOLOR_BLACK) then
						fakethok.color = SKINCOLOR_YELLOW
					elseif (p.mo.skin == "metalsonic") and (p.mo.color == SKINCOLOR_COBALT) then
						fakethok.color = SKINCOLOR_PURPLE
					elseif MRCE_isHyper(p) then
						fakethok.color = SKINCOLOR_WHITE
					else
						fakethok.color = p.mo.color
					end
					if p.mrce.glowaura then
						fakethok.blendmode = AST_ADD
					end
					if (p.mo.flags2 & MF2_OBJECTFLIP) and (p.mo.eflags & MFE_VERTICALFLIP) then
						fakethok.flags2 = $ | MF2_OBJECTFLIP
						fakethok.eflags = $ | MFE_VERTICALFLIP
					end
				end
			end
		end
	end
end)

addHook("ThinkFrame", function(p) --idk why do I need to spawn different ones when jumping/rolling but that's it
	for p in players.iterate do
		if p.spectator then return end
		if not p.realmo then return end
		if p.mrce.glowaura > 0 then
			if (p.mo.skin == "sonic") or (p.mo.skin == "metalsonic") or (p.mo.skin == "shadow") then
				if (p.mo.state == S_PLAY_ROLL) then
					local fakethok = P_SpawnMobjFromMobj(p.mo, 0*FRACUNIT, 0*FRACUNIT, -3*FRACUNIT, MT_FAKETHOK)
					if (p.mo.skin == "shadow") and (p.mo.color == SKINCOLOR_BLACK) then
						fakethok.color = SKINCOLOR_YELLOW
					elseif (p.mo.skin == "metalsonic") and (p.mo.color == SKINCOLOR_COBALT) then
						fakethok.color = SKINCOLOR_PURPLE
					elseif MRCE_isHyper(p) then
						fakethok.color = SKINCOLOR_WHITE
					else
						fakethok.color = p.mo.color
					end
					if p.mrce.glowaura then
						fakethok.blendmode = AST_ADD
					end
					if (p.mo.flags2 & MF2_OBJECTFLIP) and (p.mo.eflags & MFE_VERTICALFLIP) then
						fakethok.flags2 = $ | MF2_OBJECTFLIP
						fakethok.eflags = $ | MFE_VERTICALFLIP
					end
				end
			end
		end
	end
end)

addHook("ThinkFrame", function(p) --for spinning
	for p in players.iterate do
		--print(tonumber(p.hyperbonus))
		if not p.realmo then continue end
		if p.spectator then continue end
		if p.mrce.glowaura > 0 then
			if (p.mo.skin == "sonic") or (p.mo.skin == "metalsonic") or (p.mo.skin == "shadow") then
				if (p.mo.state == S_PLAY_SPINDASH) then
					local fakespin = P_SpawnMobjFromMobj(p.mo, 0*FRACUNIT, 0*FRACUNIT, -3*FRACUNIT, MT_FAKESPIN)
					if (p.mo.skin == "shadow") and (p.mo.color == SKINCOLOR_BLACK) then
						fakespin.color = SKINCOLOR_YELLOW
					elseif (p.mo.skin == "metalsonic") and (p.mo.color == SKINCOLOR_COBALT) then
						fakespin.color = SKINCOLOR_PURPLE
					elseif MRCE_isHyper(p) then
						fakespin.color = SKINCOLOR_WHITE
					else
						fakespin.color = p.mo.color
					end
					if p.mrce.glowaura then
						fakespin.blendmode = AST_ADD
					end
					if (p.mo.flags2 & MF2_OBJECTFLIP) and (p.mo.eflags & MFE_VERTICALFLIP) then
						fakespin.flags2 = $ | MF2_OBJECTFLIP
						fakespin.eflags = $ | MFE_VERTICALFLIP
					end
					fakespin.angle = p.drawangle
				end
			end
		end
	end
end)

addHook("MobjThinker", function(mobj)
	if not (mobj and mobj.valid) then return end
	if mobj.target and mobj.target.player and mobj.target.player.mrce then
		if mobj.target.player.mrce.glowaura then
			mobj.blendmode = AST_ADD
		end
	end
end, MT_THOK)
