local firinginterval = 50

--mo.tentacles[mo.tentaclepurple1[1]]
--mo.tentacles[mo.tentacleyellow[1]]
--mo.tentacles[mo.tentaclepurple2[1]]
--mo.tentacles[mo.tentacleend[1]]

addHook("MobjSpawn", function(mo)
	mo.tentaclepurple1 = {}
	mo.tentacleyellow = {}
	mo.tentaclepurple2 = {}
	mo.tentacleend = {}

	mo.anglecounter = ANG1
	mo.firingcounter = firinginterval
	mo.fired = 0
	for i=1,4 do
		mo.tentaclepurple1[i] = P_SpawnMobj(
			mo.x,
			mo.y,
			mo.z,
			MT_OCTOOP_ALT_TENTACLE_PURPLE
		)

		mo.tentacleyellow[i] = P_SpawnMobj(
			mo.x,
			mo.y,
			mo.z,
			MT_OCTOOP_ALT_TENTACLE_YELLOW
		)

		mo.tentaclepurple2[i] = P_SpawnMobj(
			mo.x,
			mo.y,
			mo.z,
			MT_OCTOOP_ALT_TENTACLE_PURPLE
		)

		mo.tentacleend[i] = P_SpawnMobj(
			mo.x,
			mo.y,
			mo.z,
			MT_OCTOOP_ALT_TENTACLE_END
		)

		mo.tentaclepurple1[i].target = mo
		mo.tentacleyellow[i].target = mo
		mo.tentaclepurple2[i].target = mo
		mo.tentacleend[i].target = mo
	end
end, MT_OCTOOP_ALT)

addHook("MobjThinker", function(mo)
	mo.anglecounter = $ + (ANG1*2)

	if P_LookForPlayers(mo, 2048*FRACUNIT) then
		mo.angle = R_PointToAngle2(mo.x, mo.y, mo.target.x, mo.target.y)

		if mo.fired == 0 then
			mo.firingcounter = $ - 1
		end

		if mo.firingcounter == 0 then
			mo.projectile = P_SpawnMobj(
				mo.x,
				mo.y,
				mo.z,
				MT_OCTOOP_FIREDGOOP
			)
			mo.projectile.target = mo
			mo.projectile.scale = $ / 2
			mo.projectile.tracer = mo.target

			local hdist = R_PointToDist2(mo.x, mo.y, mo.target.x, mo.target.y)

			mo.projectile.momx = FixedMul(FRACUNIT+(hdist/30), cos(mo.angle))
			mo.projectile.momy = FixedMul(FRACUNIT+(hdist/30), sin(mo.angle))

			S_StartSound(mo, sfx_gspray)

			mo.fired = 1
		end
	end

	if mo.fired == 1 then
		mo.firingcounter = firinginterval
		mo.fired = 0
	end

	for i=1,4 do
		if mo.valid
		and mo.tentaclepurple1[i].valid
		and mo.tentacleyellow[i].valid
		and mo.tentaclepurple2[i].valid
		and mo.tentacleend[i].valid then
			P_TeleportMove(
				mo.tentaclepurple1[i],
				mo.x+FixedMul(20*FRACUNIT, cos((ANGLE_90*i)+mo.anglecounter)),
				mo.y+FixedMul(20*FRACUNIT, sin((ANGLE_90*i)+mo.anglecounter)),
				mo.z+FixedMul(5*FRACUNIT, sin(-mo.anglecounter))
			)

			P_TeleportMove(
				mo.tentacleyellow[i],
				mo.x+FixedMul(40*FRACUNIT, cos((ANGLE_90*i)+mo.anglecounter)),
				mo.y+FixedMul(40*FRACUNIT, sin((ANGLE_90*i)+mo.anglecounter)),
				mo.z+FixedMul(25*FRACUNIT, sin(-mo.anglecounter))
			)

			P_TeleportMove(
				mo.tentaclepurple2[i],
				mo.x+FixedMul(60*FRACUNIT, cos((ANGLE_90*i)+mo.anglecounter)),
				mo.y+FixedMul(60*FRACUNIT, sin((ANGLE_90*i)+mo.anglecounter)),
				mo.z+FixedMul(55*FRACUNIT, sin(-mo.anglecounter))
			)

			P_TeleportMove(
				mo.tentacleend[i],
				mo.x+FixedMul(70*FRACUNIT, cos((ANGLE_90*i)+mo.anglecounter)),
				mo.y+FixedMul(70*FRACUNIT, sin((ANGLE_90*i)+mo.anglecounter)),
				mo.z+FixedMul(65*FRACUNIT, sin(-mo.anglecounter))
			)
		end
	end

	mo.z = $ + sin(mo.anglecounter)
end, MT_OCTOOP_ALT)

addHook("MobjDeath", function(mo)
	for i=1,4 do
		P_KillMobj(mo.tentaclepurple1[i])
		P_KillMobj(mo.tentacleyellow[i])
		P_KillMobj(mo.tentaclepurple2[i])
		P_KillMobj(mo.tentacleend[i])
	end
end, MT_OCTOOP_ALT)

addHook("MobjThinker", function(mo)
	mo.rollangle = $ + (ANGLE_45)
end, MT_OCTOOP_FIREDGOOP)