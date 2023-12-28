freeslot("MT_JCZTREE", "MT_JCZTREE_DECO", "MT_JCZSPECCYEASTER")
freeslot("MT_JCZVINE", "MT_JCZVINESEG", "S_JCZVINE")
freeslot("S_JCZTREE", "SPR_1JCZ", "S_JCZSPECCYEASTER", "SPR_2JCZ")
freeslot("MT_JCZSANDTRESURE", "MT_JCZSANDDUST", "S_JCZSANDTRESURE", "S_JCZSANDTRSPARKLE")

mobjinfo[MT_JCZTREE] = {
//$Category Jade Coast
//$Name Banana Palm Tree
//$Sprite 1JCZA0
//$Arg0 Skew
//$Arg1 Shape
//$Arg2 Banana Count
//$Arg3 Side Deco
	doomednum = 2500,
	spawnstate = S_JCZTREE,
	spawnhealth = 1000,
	reactiontime = 8,
	deathsound = sfx_pop,
	radius = 32*FRACUNIT,
	height = 64*FRACUNIT,
	mass = 100,
	flags = MF_NOCLIP|MF_SCENERY|MF_NOGRAVITY
}

mobjinfo[MT_JCZTREE_DECO] = {
	spawnstate = S_JCZTREE,
	spawnhealth = 1000,
	reactiontime = 8,
	deathsound = sfx_pop,
	radius = 16*FRACUNIT,
	height = 32*FRACUNIT,
	mass = 100,
	flags = MF_NOCLIP|MF_SCENERY|MF_NOGRAVITY|MF_NOTHINK
}

states[S_JCZTREE] = {
	sprite = SPR_1JCZ,
	frame = F
}

/*
mobjinfo[MT_AIZROCK1] = {
//$Category Angel Island
//$Name AIZ ROCK var 1
//$Sprite 2AIZA0
	doomednum = 2501,
	spawnstate = S_INVISIBLE,
	spawnhealth = 1000,
	reactiontime = 8,
	deathsound = sfx_pop,
	radius = 40*FRACUNIT,
	height = 50*FRACUNIT,
	mass = 100,
	flags = MF_SCENERY|MF_SOLID|MF_NOGRAVITY
}
*/

local angle_sidetrunk = ANG1*25
local angle_leafs = (360/4)*ANG1

local function M_Cubic_Bezier(t, p0, p1, p2, p3)
	return FixedMul(FixedMul((FRACUNIT - t),FixedMul((FRACUNIT - t), (FRACUNIT - t))), p0) + 3*FixedMul(FixedMul(FixedMul((FRACUNIT - t), (FRACUNIT - t)), t), p1) + 3*FixedMul(FixedMul((FRACUNIT - t), FixedMul(t, t)), p2) + FixedMul(FixedMul(t, FixedMul(t, t)), p3)
end

local function M_Quad_Bezier(t, p0, p1, p2)
	return FixedMul(FixedMul(FRACUNIT - t, FRACUNIT - t), p0) + 2 * FixedMul(FixedMul(FRACUNIT - t, t), p1) + FixedMul(FixedMul(t, t), p2)
end

local shapes_x = {
	[1] = function(progress, start_p, end_p)
		return ease.inquad(progress, start_p, end_p)
	end,
	[2] = function(progress, start_p, end_p)
		return ease.outsine(progress, start_p, end_p)
	end,
	[3] = function(progress, start_p, end_p)
		return ease.inoutcubic(progress, start_p, end_p)
	end,
	[4] = function(progress, start_p, end_p)
		local mid_point = (start_p-end_p)/2
		return M_Cubic_Bezier(progress, start_p, start_p, end_p, end_p)
	end,
	[5] = function(progress, start_p, end_p)
		local end_new = end_p*3
		local progress_new = progress*2
		local mid_point = start_p+abs(start_p-end_p)
		return M_Quad_Bezier(max(progress_new-FRACUNIT, 0), start_p, mid_point, end_new)+M_Quad_Bezier(min(progress_new, FRACUNIT), start_p, mid_point, end_new)
	end,
}

addHook("MapThingSpawn", function(a, tm)
	local workz, workh, worknh, work, side_work, leafs, banana, workb, kang
	local count = 0
	local offsetxtrunk = 0
	local act_ang = tm.angle*ANG1
	local act_sca = tm.scale
	a.scale = act_sca
	
	local skew_distance = tm.args[0]*FRACUNIT
	local height_log = 36*FRACUNIT
	local radius_log = 20*FRACUNIT
	local shape_id = max(1, min(#shapes_x, tm.args[1]))
	
	local indx = tm.args[3]
	local indy = tm.args[3]-1

	-- translated A_ConnectToGround
	workz = FixedDiv(a.floorz - a.z, a.scale)
	workb = P_SpawnMobjFromMobj(a, 0, 0, workz, MT_JCZTREE_DECO)
	workb.frame = E
	workh = 51*FRACUNIT
	workz = $ + workh
	
	local guess_count = workz/height_log
	local side_angle = 0

	if tm.args[2] > 1 then
		local side_x, side_y = FixedMul(radius_log, cos(side_angle)), FixedMul(radius_log, sin(side_angle))
		side_work = P_SpawnMobjFromMobj(workb, 0, 0, 0, MT_JCZTREE_DECO)
		side_work.frame = C|FF_PAPERSPRITE
		side_work.angle = side_angle
		side_work = P_SpawnMobjFromMobj(workb, 0, 0, 0, MT_JCZTREE_DECO)
		side_work.frame = C|FF_PAPERSPRITE
		side_work.angle = side_angle+ANGLE_180
	end

	kang = act_ang + ANGLE_45
	while (workz < 0) do
		local x, y = FixedMul(offsetxtrunk, cos(act_ang)), FixedMul(offsetxtrunk, sin(act_ang))
		work = P_SpawnMobjFromMobj(a, x, y, workz, MT_JCZTREE_DECO)
		work.frame = D
		work.angle = kang
		
		kang = $ + ANGLE_90
		workz = $ + height_log
		if workz < 0 then
			offsetxtrunk = shapes_x[shape_id]((count*FRACUNIT/guess_count), 0, skew_distance)
		end
		
		if tm.args[3] > 1 and (count % indx)/indy and offsetxtrunk <= radius_log then
			side_work = P_SpawnMobjFromMobj(work, 0, 0, 0, MT_JCZTREE_DECO)
			side_work.frame = C|FF_PAPERSPRITE
			side_work.angle = side_angle
			side_work = P_SpawnMobjFromMobj(work, 0, 0, 0, MT_JCZTREE_DECO)
			side_work.frame = C|FF_PAPERSPRITE
			side_work.angle = side_angle+ANGLE_180
		end
		
		side_angle = $+angle_sidetrunk
		count = $ + 1
	end

	local act_offsxtrunk = FixedMul(offsetxtrunk, a.scale)
	P_SetOrigin(a, a.x+FixedMul(act_offsxtrunk, cos(act_ang)), a.y+FixedMul(act_offsxtrunk, sin(act_ang)), a.z + FixedMul(workz, a.scale))
	a.dispoffset = 48

	if tm.args[2] > 0 then
		for i = 1,min(tm.args[2], 4) do
			local ang = a.angle+i*ANGLE_90
			banana = P_SpawnMobjFromMobj(a, 55*sin(ang), 55*cos(ang), 0, MT_JCZTREE_DECO)
			banana.tracer = a
			banana.flags2 = $|MF2_LINKDRAW				
			banana.frame = G
		end
	end
	
	for i = 1, 2 do
		leafs = P_SpawnMobjFromMobj(a, 0, 0, 90*FRACUNIT, MT_JCZTREE_DECO)
		leafs.frame = J|FF_PAPERSPRITE
		leafs.angle = $+ANGLE_90*i
	end
	
	leafs = P_SpawnMobjFromMobj(a, 0, 0, 76*FRACUNIT, MT_JCZTREE_DECO)
	leafs.frame = I
	leafs.tracer = a
	leafs.flags2 = $|MF2_LINKDRAW	
	leafs.scale = $+a.scale/16
	leafs.dispoffset = -8
	
	a.flags = $|MF_NOTHINK	
end, MT_JCZTREE)


/*
addHook("MapThingSpawn", function(a, tm)
	a.rocktable = {}
	
	local ang = tm.angle*ANG1		
	local buttonspr = {A, B, A, B} 
	for i = 1,4 do
		local angt = ang+i*ANGLE_90
		local button = P_SpawnMobjFromMobj(a, 28*cos(angt),28*sin(angt),0, MT_DUMMYAIZ)
		button.state = S_AIZROCK
		button.angle = angt
		button.frame = buttonspr[i]
		table.insert(a.rocktable, button)
	end

	local topspr = {E, D, E, D} 	
	for i = 1,4 do
		local angt = ang+i*ANGLE_90
		local top = P_SpawnMobjFromMobj(a, 18*cos(angt),18*sin(angt),32*FRACUNIT, MT_DUMMYAIZ)
		top.state = S_AIZROCK
		top.angle = angt
		top.frame = topspr[i]
		table.insert(a.rocktable, top)		
	end	

end, MT_AIZROCK1)

for _,rocc in pairs({
	MT_AIZROCK1,
	MT_AIZROCK2,
	MT_AIZROCK3
	}) do

addHook("MobjDeath", function(a, tm)
	S_StartSound(tm, sfx_s3k59)
	for num, rock in ipairs(a.rocktable) do
		rock.momx = tm.momx/8+4*cos(rock.angle)
		rock.momy =	tm.momy/8+4*sin(rock.angle)
		rock.momz = 8*FRACUNIT
		rock.flags = $ &~ MF_NOGRAVITY
		rock.fuse = 2*TICRATE
		rock.rotate = true
	end
end, rocc)

addHook("MobjCollide", function(a, tm)
	if tm.z <= (a.z + a.height + FRACUNIT*4) and a and a.valid
		if tm.type == MT_PLAYER and (tm.player.pflags & PF_SPINNING)
			P_KillMobj(a, tm)
		elseif a.type == MT_AIZROCK1 and tm.player.pflags & PF_JUMPED and (tm.z >=( a.z + a.height - FRACUNIT*5))
			tm.momz = 10*FRACUNIT		
			P_KillMobj(a, tm)
		end
	end
end, rocc)

end
*/

mobjinfo[MT_JCZSPECCYEASTER] = {
//$Category Jade Coast
//$Name JCZ Speccy Wanted Poster
//$Sprite 2JCZL0
	doomednum = 2499,
	spawnstate = S_JCZSPECCYEASTER,
	spawnhealth = 1,
	reactiontime = 8,
	deathsound = sfx_pop,
	radius = 16*FRACUNIT,
	height = 4*FRACUNIT,
	mass = 100,
	flags = MF_SCENERY|MF_NOGRAVITY|MF_NOCLIP|MF_SPECIAL
}

states[S_JCZSPECCYEASTER] = {
	sprite = SPR_2JCZ,
	frame = L|FF_PAPERSPRITE
}

addHook("TouchSpecial", function(a, t)
	if t.player and t.player.valid and t.player == consoleplayer and not (a.frame & FF_TRANS50) then
		local p = t.player
		p.speccygetbackhereandpayyourrent = p.speccygetbackhereandpayyourrent and $+1 or 1
		a.flags = $ &~ MF_SPECIAL
		a.frame = $|FF_TRANS50
		--print("you got speccy poster")
	end
	return true
end, MT_JCZSPECCYEASTER)

mobjinfo[MT_JCZVINE] = {
//$Category Jade Coast
//$Name Lush vine
//$Sprite 2JCZA0
//$Arg0 Type
	doomednum = 2501,
	spawnstate = S_JCZVINE,
	spawnhealth = 1000,
	reactiontime = 8,
	deathsound = sfx_pop,
	radius = 32*FRACUNIT,
	height = 55*FRACUNIT,
	mass = 100,
	flags = MF_NOCLIP|MF_SCENERY|MF_NOGRAVITY
}

mobjinfo[MT_JCZVINESEG] = {
	spawnstate = S_JCZVINE,
	spawnhealth = 1000,
	reactiontime = 8,
	deathsound = sfx_pop,
	radius = 16*FRACUNIT,
	height = 32*FRACUNIT,
	mass = 100,
	flags = MF_NOCLIP|MF_SCENERY|MF_NOGRAVITY|MF_NOTHINK
}

states[S_JCZVINE] = {
	sprite = SPR_2JCZ,
	frame = A
}

addHook("MapThingSpawn", function(a, tm)
	a.structnow = true
	a.args_frame = min(2, max(0, tm.args[0]))
end, MT_JCZVINE)

addHook("MobjThinker", function(a)
	if a.structnow then
		local workz, workh, work
		-- translated A_ConnectToGround
		local frame_head = D
		local frame_body = A

		a.frame = frame_head+a.args_frame
		workz = FixedDiv(P_CeilingzAtPos(a.x, a.y, a.z, a.height) - a.z, a.scale)
		workh = a.info.height

		if workh ~= a.info.height then
			return
		end

		while (workz > 0) do
			work = P_SpawnMobjFromMobj(a, 0, 0, workz, MT_JCZVINESEG)
			work.frame = frame_body+a.args_frame
			work.height = 0
			workz = $ - workh
		end
		if (workz ~= 0) then
			P_SetOrigin(a, a.x, a.y, a.z + FixedMul(workz, a.scale))
		end
		a.structnow = nil
	end
	a.flags = $|MF_NOTHINK	
end, MT_JCZVINE)

mobjinfo[MT_JCZSANDTRESURE] = {
//$Category Jade Coast
//$Name Sand Mound
//$Sprite 2JCZG0
//$Arg0 Health
	doomednum = 2502,
	spawnstate = S_JCZSANDTRESURE,
	painstate = S_JCZSANDTRESURE,	
	spawnhealth = 1000,
	reactiontime = 8,
	deathsound = sfx_pop,
	radius = 32*FRACUNIT,
	height = 29*FRACUNIT,
	mass = 100,
	flags = MF_NOCLIP|MF_SCENERY|MF_SPECIAL
}

mobjinfo[MT_JCZSANDDUST] = {
	spawnstate = S_JCZSANDTRESURE,
	spawnhealth = 1000,
	reactiontime = 8,
	deathsound = sfx_pop,
	radius = 16*FRACUNIT,
	height = 32*FRACUNIT,
	mass = 100,
	flags = MF_NOCLIP|MF_SCENERY
}

states[S_JCZSANDTRESURE] = {
	sprite = SPR_2JCZ,
	frame = G
}

states[S_JCZSANDTRSPARKLE] = {
	sprite = SPR_2JCZ,
	frame = Q|FF_ANIMATE,
	tics = 15,
	var1 = 4,
	var2 = 3,
	nextstate = S_NULL,
}

addHook("MapThingSpawn", function(a, tm)
	a.extravalue1 = _G[tm.stringargs[0]]
	a.health = max(tm.args[0], 1)
end, MT_JCZSANDTRESURE)

local d_4_angle = (360/16)*ANG1

local function P_SpawnSandDustParticle(a, watersmoke, surrond)
	local side_rad = FixedMul(a.radius, cos(ANGLE_90+a.angle))
	if leveltime & 2 then return end 
	local d_1 = P_SpawnMobjFromMobj(a, side_rad, side_rad, 0, MT_JCZSANDDUST)
	local d_2 = P_SpawnMobjFromMobj(a, -side_rad, -side_rad, 0, MT_JCZSANDDUST)
	d_1.momx = -6*cos(a.angle-ANG10)
	d_1.momy = -6*sin(a.angle-ANG10)
	d_1.momz = 8*a.scale
	d_1.frame = I
	d_1.fuse = 35	
	d_2.momx = -6*cos(a.angle+ANG10)
	d_2.momy = -6*sin(a.angle+ANG10)
	d_2.momz = 8*a.scale
	d_2.frame = I
	d_2.fuse = 35
	if watersmoke and a.eflags & MFE_UNDERWATER and not (leveltime % 6) then
		local d_3 = P_SpawnMobjFromMobj(a, 0, 0, 0, MT_JCZSANDDUST)
		d_3.frame = H
		d_3.flags = $|MF_NOGRAVITY
		d_3.momz = a.scale/4
		d_3.fuse = 30
		d_3.extravalue1 = 1
	end
	if surrond then
		for i = 1, 16 do
			local d_4 = P_SpawnMobjFromMobj(a, 0, 0, 0, MT_JCZSANDDUST)
			d_4.angle = d_4_angle*i
			d_4.momx = 3*cos(d_4.angle)
			d_4.momy = 3*sin(d_4.angle)
			d_4.momz = 3*a.scale
			d_4.frame = I
			d_4.fuse = 15
		end
	end	
end

local get_data

addHook("MobjThinker", function(a, tm)
	if a.extravalue1 then
		local fuse = (30-a.fuse)
		local transp = fuse/4 << FF_TRANSSHIFT
		a.frame = H|transp
		a.scale = $+fuse*(FRACUNIT/256)
	end
end, MT_JCZSANDDUST)

local function Cheap_DamageKill(a, damage)
	if a.health > damage then
		a.health = $-damage
	else
		P_KillMobj(a, nil, nil)
	end
end

addHook("MobjThinker", function(a, tm)
	if a.extravalue1 and not (leveltime % 8) then
		local rand_angle = P_RandomRange(1,360)*ANG1
		local sparkle = P_SpawnMobjFromMobj(a, 
		FixedMul(a.radius, cos(rand_angle)), 
		FixedMul(a.radius, sin(rand_angle)), 
		P_RandomRange(1,32)*FRACUNIT, MT_JCZSANDDUST)
		sparkle.state = S_JCZSANDTRSPARKLE
		sparkle.flags = $|MF_NOGRAVITY
	end
end, MT_JCZSANDTRESURE)


addHook("TouchSpecial", function(a, tm)
	if tm.player and tm.player.valid then
		local p = tm.player
		if p.pflags & PF_JUMPED and a.z+a.height-6*FRACUNIT < tm.z then
			Cheap_DamageKill(a, 10)
			if tm.eflags & MFE_UNDERWATER then
				tm.momz = 4*FRACUNIT				
			else
				tm.momz = 8*FRACUNIT
			end
			P_SpawnSandDustParticle(tm, true, true)
		end	
		
		if (leveltime % 3) then return true end
		if p.pflags & PF_SPINNING and not (p.pflags & PF_STARTDASH) then
			Cheap_DamageKill(a, 6)
			P_SpawnSandDustParticle(tm, true, true)			
		end
		if p.pflags & PF_STARTDASH then
			Cheap_DamageKill(a, 1)
			P_SpawnSandDustParticle(tm, true, true)			
		end	
	end
	return true
end, MT_JCZSANDTRESURE)

addHook("MobjDeath", function(a, tm)
	local d_3 = P_SpawnMobjFromMobj(a, 0, 0, 0, MT_JCZSANDDUST)
	d_3.frame = H
	d_3.flags = $|MF_NOGRAVITY
	d_3.momz = a.scale/4
	d_3.fuse = 35
	d_3.extravalue1 = 1

	if a.extravalue1 then
		P_SpawnMobjFromMobj(a, 0, 0, 0, a.extravalue1)
	end
	P_RemoveMobj(a)	
end, MT_JCZSANDTRESURE)