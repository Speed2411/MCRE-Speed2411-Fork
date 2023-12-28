local function eggSpawn(mo)
	mo.rotatespeed = mo.info.speed
	mo.rotating = true
	mo.timer = mo.info.reactiontime
	mo.shield = nil
end

local function eggThink(mo)
	if mo.health <= 0 then return end
	if not mo.target then
		P_LookForPlayers(mo, 2000*FRACUNIT, true, false)
	end
	if not mo.tracer then
		A_FindTracer(mo, MT_AXIS, 0)
		return
	end

	if (mo.rotating) then
		P_AxisMovement(mo)
	end

	if mo.state == S_EGGBALLER_IDLE then
		mo.timer = $ - 1
		mo.rotatespeed = mo.info.speed + (mo.info.spawnhealth - mo.health) * 3 * FRACUNIT / 2

		if (mo.health <= mo.info.damage) then
			if (mo.timer == mo.info.reactiontime - (TICRATE + TICRATE/7)) then --futureproofing!
				S_StartSound(nil, sfx_s3kd8s)
			end
			if (mo.timer == TICRATE/2) then
				--mo.rotating = false
				mo.timer = mo.info.reactiontime - (mo.info.spawnhealth - mo.health) * TICRATE/8
				mo.state = S_EGGBALLER_PINCH1
			end
		else
			if (mo.timer <= TICRATE) then
				mo.angle = R_PointToAngle2(0,0,mo.momx, mo.momy)
				if mo.timer == TICRATE then
					S_StartSound(nil, sfx_s3k79)
				end
				if not mo.timer then
					A_FaceTarget(mo)
					local miss = P_SpawnMissile(mo, mo.target, MT_EGGBALLER_FIRE)
					miss.tracer = mo.target
					miss.momz = 8*FRACUNIT
					mo.timer = mo.info.reactiontime - (mo.info.spawnhealth - mo.health) * TICRATE/8
				end
			end
		end
	elseif mo.state == S_EGGBALLER_HURT2 then
		A_FaceTarget(mo)
		if not (mo.tics % 6) then
			local miss = P_SpawnMissile(mo, mo.target, MT_EGGBALLER_FIRE)
			miss.tracer = mo.target
			miss.momz = 8*FRACUNIT
		end
	elseif mo.state == S_EGGBALLER_PINCH2 then
		if not (mo.tics % 4) then
			A_FaceTarget(mo)
		end
	end
end

local function eggHurt(mo, inf, src, dmg, dtype)
	S_StartSound(mo, mo.info.painsound)
	mo.timer = mo.info.reactiontime
	mo.rotatespeed = 0
end


addHook("MobjSpawn", eggSpawn, MT_EGGBALLER)
addHook("MobjThinker", eggThink, MT_EGGBALLER)
addHook("MobjDamage", eggHurt, MT_EGGBALLER)

addHook("MobjSpawn", function(m)
	m.iceweak = true
	m.plasmaresist = true
end, MT_EGGBALLER)


local function fireThink(mo)
	if not (leveltime % 4) then
		P_SpawnGhostMobj(mo)
	end
	if (mo.type == MT_EGGBALLER_FIRE) then
		if (P_IsObjectOnGround(mo)) then
			mo.momz = 8*FRACUNIT
			A_FlameParticle(mo)
			A_FaceTracer(mo)
			if (mo.tics <= 3*TICRATE/2) then
				local speed = R_PointToDist2(0,0,mo.momx, mo.momy)
				P_InstaThrust(mo, mo.angle, 5*speed/6)
			end
		end
	elseif (mo.type == MT_EGGBALLER_SHIELD) then
		P_MoveOrigin(mo, mo.target.x, mo.target.y, mo.target.z)
		if not (leveltime % 16) then
			if not mo.target.target then return end
			--DON'T make them chase the player, it goes whack
			local miss = P_SpawnMissile(mo, mo.target.target, MT_EGGBALLER_FIRE)
			miss.scale = FRACUNIT
			miss.momz = 2*FRACUNIT
		end
		if mo.target.state == S_EGGBALLER_HURT1
		or mo.target.health <= 0 then
			P_RemoveMobj(mo)
		end
	end
end

addHook("MobjThinker", fireThink, MT_EGGBALLER_FIRE)
addHook("MobjThinker", fireThink, MT_EGGBALLER_SHIELD)
