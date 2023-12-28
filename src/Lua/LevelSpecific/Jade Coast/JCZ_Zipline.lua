freeslot("MT_JCZZIPLINE", "S_JCZZIPLINE")

mobjinfo[MT_JCZZIPLINE] = {
//$Category Jade Coast
//$Name Zipline
//$Sprite 2JCZJ0
	doomednum = 2498,
	spawnstate = S_JCZZIPLINE,
	spawnhealth = 1000,
	reactiontime = 8,
	deathsound = sfx_pop,
	speed = 16*FRACUNIT,	
	radius = 24*FRACUNIT,
	height = 24*FRACUNIT,
	mass = 100,
	flags = MF_NOGRAVITY|MF_NOCLIP|MF_SPECIAL
}

states[S_JCZZIPLINE] = {
	sprite = SPR_2JCZ,
	frame = J
}

local reset_pathway = false
local path_ways = {}

addHook("MapLoad", function()
	reset_pathway = true
end)

addHook("MapThingSpawn", function(a, tm)
	if reset_pathway == true then 
		path_ways = {}
		reset_pathway = false
	end

	local path = max(tm.args[0]+1, 1)
	if not path_ways[path] then
		path_ways[path] = {}
	end
	table.insert(path_ways[path], {point = tm.args[1], x = a.x, y = a.y, z = a.z, angle = a.angle, special = tm.args[2]})
end, MT_TUBEWAYPOINT)

local function M_Quad_Bezier(t, p0, p1, p2)
	return FixedMul(FixedMul(FRACUNIT - t, FRACUNIT - t), p0) + 2 * FixedMul(FixedMul(FRACUNIT - t, t), p1) + FixedMul(FixedMul(t, t), p2)
end

local function P_PathingFixedRotate(t, angle, next_angle)
	local dif = next_angle/ANG1 - angle/ANG1
	local absi = abs(dif)
	if absi > 180 and absi <= 360 then
		dif = dif > 0 and ($ - 360) or ($ + 360)
	end
	return angle + FixedAngle(FixedMul(AngleFixed(dif*ANG1), t))
end

-- Edit of Homing Attack for previously Bone Train
local function P_HomingMomentumToPoint(a, point, flipObj, curve) // Home in on your target
	// change slope
	local zdist = point.z - a.z
	local dist = P_AproxDistance(point.x - a.x, point.y - a.y)
	local dddist = P_AproxDistance(dist, zdist)
	local jaw = R_PointToAngle2(0, 0, dist, zdist)
	
	a.velocity = a.velocity ~= nil and min(a.velocity+sin(InvAngle(2*jaw))+(a.velocity > 0 and FRACUNIT/96 or FRACUNIT/96), 48*FRACUNIT) or 0
	local ns = FixedMul(max(a.velocity+12*FRACUNIT, 12*FRACUNIT), a.scale)

	if dddist <= ns then
		return flipObj and 0 or FRACUNIT
	end	

	local progress = FixedDiv(ns, dddist)

	if curve then
		a.momx = M_Quad_Bezier(progress, a.x, a.x+dist, point.x)
		a.momy = M_Quad_Bezier(progress, a.y, a.y+dist, point.y)
		a.momz = M_Quad_Bezier(progress, a.z, a.z+zdist, point.z)
	else
		a.momx = FixedMul(FixedDiv(point.x - a.x, dddist), ns)
		a.momy = FixedMul(FixedDiv(point.y - a.y, dddist), ns)
		a.momz = FixedMul(FixedDiv(zdist, dddist), ns)
	end
	a.angle = P_PathingFixedRotate(progress, a.angle, point.angle)
	
	return (dddist <= ns)
end

addHook("MapThingSpawn", function(a, tm)
	if not (tm and not a.copy) then return end
	a.pathid = tm.args[0]+1
	a.trstate = "stay"
	a.extravalue1 = 1
end, MT_JCZZIPLINE)

local function P_ResetZiplineVars(a)
	a.rollangle = 0
	a.spritexoffset = 0
	a.spriteyoffset = 0
end

addHook("MobjThinker", function(a)
	if not path_ways[a.pathid] then return end
	if not a.path then
		a.path = path_ways[a.pathid]
		table.sort(a.path, function(o, n) return o.point < n.point end)
	end
	
	local point_list = a.path
	--print("I can exist!")
	
	if a.thinktics then
		a.thinktics = $-1
		if a.thinktics == 1 then
			a.thinktics = nil
			a.trstate = "gotofirst"
		end
		return
	end
	
	
	if a.trstate == "gotofirst" then
		local first_point = point_list[1]
		local fresh_copy = P_SpawnMobjFromMobj(a, 0, 0, 0, MT_JCZZIPLINE)
		P_SetOrigin(fresh_copy, first_point.x, first_point.y, first_point.z)
		fresh_copy.angle = first_point.angle
		fresh_copy.pathid = a.pathid
		fresh_copy.trstate = "stay"
		fresh_copy.extravalue1 = 1
		fresh_copy.copy = true
		a.fuse = TICRATE/2
		a.flags = $ &~ MF_NOGRAVITY
		a.momz = a.momz/2
		a.momx = 2*a.momx/3
		a.momy = 2*a.momy/3
		if a.owner and a.owner.tracer == a then
			P_ResetPlayer(a.owner.player)
			a.owner.momx, a.owner.momy, a.owner.momz = a.momx, a.momy, a.momz/8
			a.owner.state = S_PLAY_FALL
		end
		a.trstate = "dummy"
	end

	if a.trstate == "run" then		
		if a.owner and a.owner.tracer == a then
			a.owner.player.drawangle = a.angle
		end
	
		if P_HomingMomentumToPoint(a, point_list[a.extravalue1], false) then
			--print("Point reached!")
			if a.extravalue1 == #point_list then
				a.thinktics = 16
				a.trstate = "finished"
			else
				a.extravalue1 = $+1
			end
		end
	end
end, MT_JCZZIPLINE)

addHook("TouchSpecial", function(a, t)
	if not (t and t.player and t.valid and t.player.valid) then return true end
	local p = t.player

	if a.trstate == "finished" or a.trstate == "gotofirst" or a.trstate == "dummy" then
		p.powers[pw_carry] = CR_NONE
		p.powers[pw_ignorelatch] = 12		
		t.tracer = nil
		P_ResetPlayer(p)
		t.momx, t.momy, t.momz = a.momx, a.momy, a.momz
		return true
	end

	if P_MobjFlip(t)*t.momz > 0 or p.powers[pw_carry] then
		return true
	end
	
	if (t.z > a.z + a.height/2)
		return true
	end

	if (t.z + t.height/2 < a.z)
		return true
	end

	if not (p.powers[pw_ignorelatch] and a.owner) then
		P_ResetPlayer(p)
		t.angle = a.angle		
		t.tracer = a
		a.owner = t

		p.powers[pw_carry] = CR_GENERIC
		a.trstate = "run"
		a.velocity = P_AproxDistance(t.momx, t.momy)		
	end
	return true
end, MT_JCZZIPLINE)