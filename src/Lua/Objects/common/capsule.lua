freeslot(
	"SPR_CAPJ",
	"MT_GGCAPSULE",
	"S_GGCAPSULE",
	"S_GGCAPSULE_JUNK"
)

mobjinfo[MT_GGCAPSULE] = {
	doomednum = 510,
	spawnstate = S_INVISIBLE,
	painstate = S_GGCAPSULE,
	deathstate = S_GGCAPSULE,
	spawnhealth = 1,
	radius = 72*FRACUNIT,
	height = 144*FRACUNIT,
	flags = MF_NOGRAVITY|MF_NOCLIPTHING
}

states[S_GGCAPSULE] = {SPR_CAPS, A, -1, nil, 0, 0, S_NULL}
states[S_GGCAPSULE_JUNK] = {SPR_CAPJ, A, TICRATE, nil, 0, 0, S_NULL}

local capsuleflags = MF_NOGRAVITY|MF_SPECIAL|MF_SHOOTABLE

addHook("MapThingSpawn", function(mo, mt)
	if (mt.options & MTF_OBJECTSPECIAL) then
		mo.state = S_GGCAPSULE
		mo.flags = capsuleflags
		mo.flags2 = $1|MF2_INVERTAIMABLE
	end

	if (mt.options & MTF_AMBUSH) then
		mo.z = $1 + 80*FRACUNIT
	end

	mo.movefactor = mo.z
end, MT_GGCAPSULE)

addHook("MobjThinker", function(mo)
	if not ((mo.flags == capsuleflags)
	or (mo.health <= 0)) then
		return
	end

	mo.shadowscale = FRACUNIT

	if (mo.extravalue2 > 0) then
		mo.extravalue2 = $1 - 1

		if (mo.extravalue2 & 1) then
			local dustx = P_RandomRange(-64,64) * mo.scale
			local dusty = P_RandomRange(-64,64) * mo.scale
			local dustz = P_RandomRange(8,136) * mo.scale

			local dust = P_SpawnMobjFromMobj(mo, dustx, dusty, dustz, MT_EXPLODE)
			S_StartSound(dust, sfx_s3k3d)
		end

		if (mo.extravalue2 <= 0) then
			for i = 0,3, 1 do
				local junk = P_SpawnMobjFromMobj(mo, 0, 0, 0, MT_BOSSJUNK)
				junk.angle = P_RandomRange(0,15) * ANGLE_22h
				junk.state = S_GGCAPSULE_JUNK
				junk.frame = $1 + i

				local hspd = 4*junk.scale
				local vspd = 8*junk.scale
				if (i >= 2) then
					local temp = hspd
					hspd = vspd
					vspd = temp
				end

				P_Thrust(junk, junk.angle, hspd)
				P_SetObjectMomZ(junk, vspd, true)
			end

			for i = 0,23,1 do
				local flx = P_RandomRange(-64,64) * mo.scale
				local fly = P_RandomRange(-64,64) * mo.scale
				local flz = P_RandomRange(8,136) * mo.scale

				local flickydust = P_SpawnMobjFromMobj(mo, flx, fly, flz, MT_EXPLODE)
				flickydust.state = S_XPLD_EGGTRAP

				A_FlickySpawn(flickydust, 0, 0)
			end

			if marathonmode then
				G_SetCustomExitVars(1101,1)
			end

			for player in players.iterate do
				P_DoPlayerExit(player)
			end

			P_RemoveMobj(mo)
			return
		end
	else
		local pi = 22*FRACUNIT/7
		local speed = 2*TICRATE
		local amp = 16

		local z = mo.movefactor

		if (mo.extravalue1 > 0) then
			z = $1 + ((mo.extravalue1 * mo.extravalue1) * mo.scale)
			mo.extravalue1 = $1 - 1
		end

		mo.z = z + FixedMul(amp * sin((2*pi*speed) * leveltime), mo.scale)
	end
end, MT_GGCAPSULE)

addHook("TouchSpecial", function(mo, toucher)
	if (mo.health > 0) then
		local player = toucher.player

		if (P_PlayerCanDamage(player, mo)) or player.mo.skin == "silver" then
			P_KillMobj(mo, toucher, toucher)
		end

		if (P_MobjFlip(toucher) * toucher.momz < 0)
		and not (player.charability2 == CA2_MELEE and player.panim == PA_ABILITY2) then
			toucher.momz = -$1
		end

		--[[
		if (player.pflags & PF_BOUNCING)
			P_DoAbilityBounce(player, false)
		end
		--]]

		toucher.momx = -$1
		toucher.momy = -$1

		if (player.charability == CA_FLY and player.panim == PA_ABILITY) then
			toucher.momz = (-$1) / 2
		elseif (player.pflags & PF_GLIDING and not P_IsObjectOnGround(toucher)) then
			player.pflags = $1 & ~(PF_GLIDING|PF_JUMPED|PF_NOJUMPDAMAGE)
			toucher.state = S_PLAY_FALL
			toucher.momz = $1 + (P_MobjFlip(toucher) * (player.speed >> 3))
			toucher.momx = 7 * $1 / 8
			toucher.momy = 7 * $1 / 8
		elseif (player.dashmode >= 3*TICRATE
		and (player.charflags & (SF_DASHMODE|SF_MACHINE)) == (SF_DASHMODE|SF_MACHINE)
		and player.panim == PA_DASH) then
			P_DoPlayerPain(player, mo, mo)
		end

		--[[
		if (player.charability == CA_TWINSPIN and player.panim == PA_ABILITY)
			P_TwinSpinRejuvenate(player, player.thokitem)
		end
		--]]
	end

	return true
end, MT_GGCAPSULE)

addHook("MobjDeath", function(mo)
	mo.extravalue2 = 3*TICRATE/2
end, MT_GGCAPSULE)

addHook("ShouldDamage", function(mo, inf, src)
	if (inf and inf.valid) then
		if (inf.type == MT_PLAYER) then
			return true
		end
	end

	if (src and src.valid) then
		if (src.type == MT_PLAYER) then
			return true
		end
	end

	return false
end, MT_GGCAPSULE)

addHook("BossDeath", function(mo)
	if (mo.flags2 & MF2_BOSSNOTRAP) or (modeattacking) then
		return
	end


	if gamemap == 121 and All7Emeralds(emeralds) then return end

	local capsule = nil

	for mo2 in mobjs.iterate() do
		if (mo2 == mo) then
			continue
		end

		if (mo2.flags & MF_BOSS) and (mo2.health > 0) then
			return
		end

		if (capsule == nil) and (mo2.type == MT_GGCAPSULE) then
			capsule = mo2
		end
	end

	if (capsule and capsule.valid) then
		capsule.extravalue1 = TICRATE
		capsule.state = S_GGCAPSULE
		capsule.flags = capsuleflags
		capsule.flags2 = $1|MF2_INVERTAIMABLE
	end
end)
