//can i? :pleading_face:
//~xelork

freeslot("MT_MFZWINDSPAWNER", "MT_MFZWINDSNOW")

freeslot("S_MFZWINDSNOW")

sfxinfo[sfx_s3kcel].flags = $|SF_NOMULTIPLESOUND

mobjinfo[MT_MFZWINDSPAWNER] = {
	--$Category "Mystic Realm - Midnight Freeze Zone"
	--$Name Wind Particle Generator Start
	--$Sprite SNO1A0
	--$AngleText Angle/Tag
	doomednum = 36,
	spawnstate = S_INVISIBLE,
	flags = MF_NOGRAVITY|MF_NOCLIP|MF_NOCLIPHEIGHT|MF_SCENERY,
}

mobjinfo[MT_MFZWINDSNOW] = {
	spawnstate = S_MFZWINDSNOW,
	flags = MF_NOGRAVITY|MF_NOCLIP|MF_NOCLIPHEIGHT|MF_SCENERY,
}

states[S_MFZWINDSNOW] = {
	sprite = SPR_SNO1,
	frame = A,
	tics = -1,
	nextstate = S_NULL,
}

/*
ok so this is how the data works:

object angle = object tag (every 360 degrees is a new tag) and particles direction
linedef tag must be the same as object tag for them to work together
and linedef action must be 6, to prevent conflict

control sector height = wind max distance in fracunits
linedef length = wind speed in fracunits
control sector special = wind spawn intermission in tics
control sector brightness = number of particles to spawn at once

linedef frontside x = second obj x in fracunits
linedef frontside y = second obj y in fracunits
control sector floor height = second obj z

the two objects will connect and create an "invisible linedef" that will generate the particles
the particles will fly, following the object angle, until they reach their max distance, specified by control sector height

YOU MUST CREATE AN INVISIBLE FOF AROUND THE SNOWING AREA WITH A LINEDEF EXECUTOR TO CALL THE LUA FUNCTION "SNOSFX" FOR THE SOUND!!!!!!!!!!!!!!!!!

thats it i guess
*/

addHook("PlayerThink", function(p)
--p.pflags = $ & PF_INVIS
	if p.realmo.snowing == nil then
		p.realmo.snowing = 0
	elseif (p.realmo.snowing) then
		p.realmo.snowing = $ - 1
	else
		S_StopSoundByID(p.realmo, sfx_s3kcel)
	end
end)

addHook("MapThingSpawn", function(mo, mt)
	local trueangle = FixedAngle(mt.angle*FRACUNIT)
	mo.tag = mt.angle/360+1
	for ld in lines.iterate do
		if ld.special == 6
		and ld.tag == mo.tag then
			local ldd = R_PointToDist2(ld.v1.x, ld.v1.y, ld.v2.x, ld.v2.y)
			local ldsd = ld.frontside
			local ldst = ld.frontsector
			local target = P_SpawnMobj(ldsd.textureoffset, ldsd.rowoffset, ldst.floorheight, MT_MFZWINDSPAWNER)
			target.flags = MF_NOTHINK
			mo.target = target
			mo.windspeed = ldd/FRACUNIT
			mo.windmaxlen = abs(ldst.ceilingheight-ldst.floorheight)/FRACUNIT
			mo.timer = ldst.special
			mo.fuse = mo.timer
			mo.windamount = ldst.lightlevel
			mo.targetangle = R_PointToAngle2(max(mo.x, target.x), max(mo.y, target.y), min(mo.x, target.x), min(mo.y, target.y))
		end
	end
end, MT_MFZWINDSPAWNER)

addHook("MobjFuse", function(mo)
	for i = 1, mo.windamount, 1 do
		local rx = P_RandomRange(mo.x/FRACUNIT, mo.target.x/FRACUNIT)*FRACUNIT
		local ry = P_RandomRange(mo.y/FRACUNIT, mo.target.y/FRACUNIT)*FRACUNIT
		local rz = P_RandomRange(mo.z/FRACUNIT, mo.target.z/FRACUNIT)*FRACUNIT
		if not (R_PointToAngle2(mo.x, mo.y, rx, ry) < mo.targetangle) then
			local wind = P_SpawnMobj(rx, ry, rz, MT_MFZWINDSNOW)
			local windspeed = P_RandomRange(mo.windspeed-8, mo.windspeed)
			wind.frame = FF_FULLBRIGHT|P_RandomRange(0, 2)
			wind.momx = FixedMul(cos(mo.angle),(windspeed*FRACUNIT))
			wind.momy = FixedMul(sin(mo.angle),(windspeed*FRACUNIT))
			wind.tics = mo.windmaxlen/windspeed
		end
	end
	mo.fuse = mo.timer
	return true
end, MT_MFZWINDSPAWNER)

/*
	Additional, incomplete optimizations
	The PostThinkFrame hook spawns snow particles directly around the consoleplayer
	This would help combat the weakness of the second MobjFuse hook,
	which looks for players before spawning anything. It works well for small areas,
	but not for larger ones

addHook("PostThinkFrame", function()
	if leveltime%2 and consoleplayer and consoleplayer.realmo and consoleplayer.realmo
	and consoleplayer.realmo.snowing and consoleplayer.realmo.snowing > 0 then
		local rx = P_RandomRange(consoleplayer.realmo.x/FRACUNIT - 128, (consoleplayer.realmo.x/FRACUNIT + 128))*FRACUNIT
		local ry = P_RandomRange(consoleplayer.realmo.y/FRACUNIT - 128, (consoleplayer.realmo.y/FRACUNIT + 128))*FRACUNIT
		local rz = P_RandomRange(consoleplayer.realmo.z/FRACUNIT - 128, (consoleplayer.realmo.z/FRACUNIT + 128))*FRACUNIT

		local wind = P_SpawnMobj(rx, ry, rz, MT_MFZWINDSNOW)
		local windspeed = P_RandomRange(12, 16)
		wind.frame = FF_FULLBRIGHT|P_RandomRange(0, 2)
		wind.momx = FixedMul(cos(consoleplayer.realmo.angle+ANGLE_90),(windspeed*FRACUNIT))
		wind.momy = FixedMul(sin(consoleplayer.realmo.angle),(windspeed*FRACUNIT))
		wind.tics = 256/windspeed
	end
end)

addHook("MobjFuse", function(mo)
	if not (searchBlockmap("objects", function(amo, pmo)
		if not pmo.valid then return nil end
		if pmo.player then return true else return nil end
	end, mo, mo.x-1024*FRACUNIT, mo.x+1024*FRACUNIT, mo.y-1024*FRACUNIT, mo.y+1024*FRACUNIT))
		for i = 1, mo.windamount
			local rx = P_RandomRange(mo.x/FRACUNIT, mo.target.x/FRACUNIT)*FRACUNIT
			local ry = P_RandomRange(mo.y/FRACUNIT, mo.target.y/FRACUNIT)*FRACUNIT
			local rz = P_RandomRange(mo.z/FRACUNIT, mo.target.z/FRACUNIT)*FRACUNIT
			if not (R_PointToAngle2(mo.x, mo.y, rx, ry) < mo.targetangle)
				local wind = P_SpawnMobj(rx, ry, rz, MT_MFZWINDSNOW)
				local windspeed = P_RandomRange(mo.windspeed-8, mo.windspeed)
				wind.frame = FF_FULLBRIGHT|P_RandomRange(0, 2)
				wind.momx = FixedMul(cos(mo.angle),(windspeed*FRACUNIT))
				wind.momy = FixedMul(sin(mo.angle),(windspeed*FRACUNIT))
				wind.tics = mo.windmaxlen/windspeed
			end
		end
	end
	mo.fuse = mo.timer
	return true
end, MT_MFZWINDSPAWNER)
*/

-------------------------------------
-- Linedef type 541 Recoded - Barrels O' Fun
-------------------------------------
local function MFZWind(l, mo, sfx)

if sfx == true and mo.player then
	S_StartSound(mo.player.realmo, sfx_s3kcel, mo.player)
	mo.player.realmo.snowing = 17
end

	local strength = R_PointToDist2(l.v2.x, l.v2.y, l.v1.x, l.v1.y)
	local length = strength

	if (l.flags & ML_EFFECT6) then
		strength = sides[l.sidenum[0]].textureoffset
	end

	local hspeed = strength
	local dx = FixedMul(FixedDiv(l.dx, length), hspeed)
	local dy =  FixedMul(FixedDiv(l.dy, length), hspeed)

-------------------------------------
--P_ConvertBinaryLinedefTypes section
-------------------------------------

	local args4 = 0
	if (l.flags & ML_MIDSOLID) then
		args4 = $ | 1
	end

	if (!(l.flags & ML_NOCLIMB)) then
		args4 = $ | 2
	end

-------------------------------------
-- Add_Pusher / T_Pusher section
-------------------------------------

	if (mo.flags & (MF_NOGRAVITY | MF_NOCLIP) -- Of things that have Noclip and No Gravity, only bubbles get pushed
	and not (mo.type == MT_SMALLBUBBLE
	or mo.type == MT_MEDIUMBUBBLE
	or mo.type == MT_EXTRALARGEBUBBLE)) then
		return
	end

	if (not ((mo.flags & MF_PUSHABLE) or ((mo.info.flags & MF_PUSHABLE) and mo.fuse))
	and not (mo.type == MT_PLAYER
	or mo.type == MT_SMALLBUBBLE
	or mo.type == MT_MEDIUMBUBBLE
	or mo.type == MT_EXTRALARGEBUBBLE
	or mo.type == MT_LITTLETUMBLEWEED
	or mo.type == MT_BIGTUMBLEWEED)) then
		return -- Only no fuse Pushables and listed objects get pushed
	end


	if (mo.eflags & MFE_PUSHED) then
		return -- If already pushed, return
	end

	if (mo.player and ((mo.player.powers[pw_carry] == CR_ROPEHANG) or (mo.player.powers[pw_shield] == SH_WHIRLWIND) or (MRCE_isHyper(mo.player)))) then
		return -- Players are immune if hanging on or carrying windshield
	end

	if (mo.player and (mo.state == states[mo.info.painstate]) and (mo.player.powers[pw_flashing] > (flashingtics/4)*3 and mo.player.powers[pw_flashing] <= flashingtics)) then
		return -- Recently hurt players don't get pushed
	end

	local xspeed = dx / 128
	local yspeed = dy / 128
	local windb = l.frontside.sector.floorheight
	local windt = l.frontside.sector.ceilingheight

	if (mo.z + (mo.height >> 1) > windt and !mo.eflags & MFE_VERTICALFLIP) -- Wind gets halved when mobj is halfway past the top (or bottom when flipped) of rover
	or (mo.z + (mo.height >> 1) > windb and mo.eflags & MFE_VERTICALFLIP) then
		xspeed = $/2
		yspeed = $/2
	end

	mo.momx = $ + xspeed
	mo.momy = $ + yspeed

	if (mo.player) then -- Player cmom values

		mo.player.cmomx = $ + xspeed
		mo.player.cmomy = $ + yspeed
		mo.player.cmomx = FixedMul(mo.player.cmomx, 59392)
		mo.player.cmomy = FixedMul(mo.player.cmomy, 59392)

		if (args4 & 1) then -- If Sliding is happening
			local jumped = mo.player.pflags & (PF_JUMPED|PF_NOJUMPDAMAGE)
			P_ResetPlayer (mo.player)

			if jumped then
				mo.player.pflags = $ | (PF_JUMPED|PF_NOJUMPDAMAGE)
			else
				mo.state = mo.info.painstate -- Doesn't get set regularly for some reason so do it here.
			end

			mo.player.pflags = $ | PF_SLIDING
			P_MovePlayer(mo.player)
			mo.angle = R_PointToAngle2(0, 0, xspeed, yspeed);

			if (mo.player.pflags & PF_ANALOGMODE) then
				local angle = mo.player.cmd.angleturn << 16
				if (mo.angle - angle > ANGLE_180) then
					mo.angle = (angle - (angle - mo.angle) / 8)
				else
					mo.angle = (angle + (mo.angle - angle) / 8)
				end
			end
		end
	end

		if (mo.type == MT_LITTLETUMBLEWEED or mo.type == MT_BIGTUMBLEWEED) then
			mo.momz = $ + P_AproxDistance(xspeed, yspeed) >> 2
		end


		if not (args4 & 2) then
			mo.eflags = $ | MFE_PUSHED
		end

end

-------------------------------------
--Table unload/sync
-------------------------------------
local windlist = {}
addHook("MapChange", function()
windlist = {}
end)
addHook("NetVars", function(network)
	windlist = network(windlist)
end)

-------------------------------------
--Linedef Execute / ThinkFrame SNOSFX
-------------------------------------
addHook("LinedefExecute", function(l, mo)

	local tag = l.frontside.sector.tag
	local windb = l.frontside.sector.floorheight
	local windt = l.frontside.sector.ceilingheight
	for rover in sectors.tagged(l.tag) do
		for mobj in rover.thinglist() do
			if (mobj.eflags & MFE_VERTICALFLIP and not ((windb > mobj.z + mobj.height) or windt < (mobj.z + (mobj.height >> 1))))
			or not ((windt < mobj.z) or (windb > (mobj.z + (mobj.height >> 1)))) then -- Height Check
				MFZWind(l, mobj, true)
			end
		end
	end
	if !leveltime then-- if level just started
		if windlist then -- If table exists (it should)
			for _,ltag in ipairs(windlist) do -- iterate through table
				if l.tag == ltag then -- if tag is in table, return
				return
				end
			end
		end
		windlist[#windlist+1]=l.tag -- Append tag to wind list
	end
end, "SNOSFX")


addHook("ThinkFrame", function()
	if #windlist then -- If table is being used
		for _,ltag in ipairs(windlist) do -- Iterate it.
			P_LinedefExecute(ltag)
		end
	end
end)