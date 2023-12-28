/*math helpers*/
--FixedLerp
local function FixedLerp(a, b, w)
    return FixedMul((FRACUNIT - w), a) + FixedMul(w, b)
end

rawset(_G, "FixedLerp", FixedLerp)

--Functions needed to do the bounce calculations (these could also be used to allow bounces off of sloped terrain, but I don't think we need to do that for this ability)
local function SphereToCartesian(alpha, beta)
	local t = {}

	t.x = FixedMul(cos(alpha), cos(beta))
	t.y = FixedMul(sin(alpha), cos(beta))
	t.z = sin(beta)

	return t
end

rawset(_G, "SphereToCartesian", SphereToCartesian)

local function FixedDotProduct3D(a, b)
	return FixedMul(a.x, b.x) + FixedMul(a.y, b.y) + FixedMul(a.z, b.z)
end

rawset(_G, "FixedDotProduct3D", FixedDotProduct3D)

local function FixedScalar3D(vect, scalar)
	local vect2 = {}
	vect2.x = FixedMul(vect.x, scalar)
	vect2.y = FixedMul(vect.y, scalar)
	vect2.z = FixedMul(vect.z, scalar)
	
	return vect2
end

rawset(_G, "FixedScalar3D", FixedScalar3D)

local function Percent3D(vect, percent)
	local vect2 = {}
	vect2.x = vect.x * percent / 100
	vect2.y = vect.y * percent / 100
	vect2.z = vect.z * percent / 100
	
	return vect2
end

rawset(_G, "Percent3D", Percent3D)

local function VectAdd3D(vecta, vectb)
	local vsum = {}
	vsum.x = vecta.x + vectb.x
	vsum.y = vecta.y + vectb.y
	vsum.z = vecta.z + vectb.z
	
	return vsum
end

rawset(_G, "VectAdd3D", VectAdd3D)

local function VectorBounce(mo,vmom,vslopenorm,percent)
	local player = mo.player
	if (player == nil) or (player.playerstate != PST_LIVE) then return end
	
	local vbounce = Percent3D(VectAdd3D(FixedScalar3D(FixedScalar3D(vslopenorm, FixedDotProduct3D(vmom,vslopenorm)), -2 * FRACUNIT), vmom), percent)
	
	mo.momx = vbounce.x
	mo.momy = vbounce.y
	mo.momz = vbounce.z
end

rawset(_G, "VectorBounce", VectorBounce)

/*reimplementations of c functions*/
// Returns the height of the sector floor at (x, y)
local function P_GetSectorFloorZAt(sector, x, y)
	if sector.f_slope then
		return P_GetZAt(sector.f_slope, x, y)
	else
		return sector.floorheight
	end
end

rawset(_G, "P_GetSectorFloorZAt", P_GetSectorFloorZAt)

// Returns the height of the sector ceiling at (x, y)
local function P_GetSectorCeilingZAt(sector, x, y)
	if sector.c_slope then
		return P_GetZAt(sector.c_slope, x, y)
	else
		return sector.ceilingheight
	end
end

rawset(_G, "P_GetSectorCeilingZAt", P_GetSectorCeilingZAt)

// Returns the height of the FOF top at (x, y)
local function P_GetFFloorTopZAt(ffloor, x, y)
	if ffloor.t_slope then
		return P_GetZAt(ffloor.t_slope, x, y)
	else
		return ffloor.topheight
	end
end

rawset(_G, "P_GetFFloorTopZAt", P_GetFFloorTopZAt)

// Returns the height of the FOF bottom  at (x, y)
local function P_GetFFloorBottomZAt(ffloor, x, y)
	if ffloor.b_slope then
		return P_GetZAt(ffloor.b_slope, x, y)
	else
		return ffloor.bottomheight
	end
end

rawset(_G, "P_GetFFloorBottomZAt", P_GetFFloorBottomZAt)


/*custom functions*/
/*returns:
0: nothing
1: one-sided
2: polyobject
3: standard, ceiling
4: standard, floor
5: fof
*/

local function P_MobjWorldCollide(mo, line)
	if not mo or not mo.valid then return 0 end
	
	--Horizon line
	if line.special == 41 then return 0 end
	
	--Set the hitline so we can bounce off it later in case that line actually blocked the player from moving
	local side = P_PointOnLineSide(mo.x,mo.y,line)
	local sector = nil
	
	--One-sided walls
	if line.backsector == nil then
		mo.hitline = line
		mo.hitside = 0
		return 1
	end
	if line.frontsector == nil then
		mo.hitline = line
		mo.hitside = 1
		return 1
	end
	
	--Which side are we hitting the wall from?
	if side == 1 then
		sector = line.frontsector
	else
		sector = line.backsector
	end
	
	--Impassible line
	if (line.flags & ML_IMPASSIBLE) and line.frontside.midtexture then
		mo.hitline = line
		mo.hitside = side
		return 1
	end
	
	if sector == nil then return 1 end
	
	--Polyobject
	for i = 0, #sector.lines do
		local li = sector.lines[i]
		if li == nil then continue end
		
		if li.special == 20 then--First line of polyobject
			local topheight = sector.ceilingheight
			local bottomheight = sector.floorheight
			
			if (topheight < mo.z) then
				return 0
			end

			if (bottomheight > mo.z + mo.height) then
				return 0
			end

			mo.hitline = line
			mo.hitside = side
			mo.hitpolyobj = li.polyobj
			return 2
		end
	end
	
	--Standard
	local ceilz = sector.ceilingheight
	if sector.c_slope then
		ceilz = P_GetZAt(sector.c_slope, mo.x, mo.y)
	end
	if (ceilz < mo.z + mo.height) then
		if sector.ceilingpic != "F_SKY1" then
			mo.hitline = line
			mo.hitside = side
			mo.hitsector = sector
		end
		return 3
	end
	local floorz = sector.floorheight
	if sector.f_slope then
		floorz = P_GetZAt(sector.f_slope, mo.x, mo.y)
	end
	if (floorz > mo.z) then
		mo.hitline = line
		mo.hitside = side
		mo.hitsector = sector
		return 4
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
	
		mo.hitline = line
		mo.hitside = side
		mo.hitsector = sector
		mo.hitrover = rover
		return 5
	end
	
	return 0
end

rawset(_G, "P_MobjWorldCollide", P_MobjWorldCollide)

local function P_CheckMobjSolid(mo, other)
	return (other and other.valid) and (other.flags & MF_SOLID)
	and not (other.flags & MF_ENEMY or other.flags & MF_BOSS or other.flags & MF_MONITOR or other.flags & MF_PAIN)
	and not (other.type == MT_PLAYER)
end

rawset(_G, "P_CheckMobjSolid", P_CheckMobjSolid)

/*
		elseif (tmthing.flags & MF_SOLID and P_CheckMobjCollision(rock, tmthing))
			local wallnormangle
			
			if (rock.y + rock.radius <= tmthing.y - tmthing.radius)
				wallnormangle = ANGLE_180
				verbosePrint("180 degrees")
			elseif (rock.y - rock.radius >= tmthing.y + tmthing.radius)
				wallnormangle = ANGLE_270
				verbosePrint("270 degrees")
			elseif (rock.x + rock.radius <= tmthing.x - tmthing.radius)
				wallnormangle = ANGLE_MAX
				verbosePrint("0 degrees")
			elseif (rock.x - rock.radius >= tmthing.x + tmthing.radius)
				wallnormangle = ANGLE_90
				verbosePrint("90 degrees")
			else
				verbosePrint("degree machine broke")
				return //huh?? fuck whatever's going on here, abort
			end
*/