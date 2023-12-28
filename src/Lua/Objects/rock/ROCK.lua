/* nami made most of this, Krabs made everything to do with wall collision detection 
   helps the rollout rock better handle being on/in goop, & adds fun things
   level header needs Lua.gooprock = true to enable the changes for that map
   you probably want to set flag 8/ambush/non-buoyant on the rollout rock spawner! 
   TODO: (can i just make the default mode work and fix the issues i had with it?)*/

freeslot("SKINCOLOR_ROLLBROWN")
skincolors[SKINCOLOR_ROLLBROWN] = {
	name = "Goop Rock Brown",
	ramp = {52,53,54,55,56,57,58,59,60,69,61,62,63,70,44,45},
	invcolor = SKINCOLOR_KETCHUP,
	invshade = 0,
	chatcolor = V_BROWNMAP,
	accessible = false
}

local enabled = false
local verbose = true

local BOUNCEPERCENT = 33
local WALLTHRUST = 10 * FRACUNIT

local function verbosePrint(string)
	if verbose then print(string) end
end

local function speed(thing)
	return R_PointToDist2(0, 0, thing.momx, thing.momy)
end

local function P_IsObjectOnGoopBottom(mo)
	if P_IsObjectInGoop(mo) then
		if (mo.eflags & MFE_VERTICALFLIP) then
			if (mo.z+mo.height >= mo.ceilingz) then
				return true
			end
		else
			if (mo.z <= mo.floorz) then
				return true
			end
		end
	end
	return false
end

local function P_IsRockOnGoopSurface(mo)
	if P_IsObjectOnGround(mo) then
		if P_MobjFlip(mo) then
			if mo.floorrover and (mo.floorrover.flags & FF_GOOWATER) then
				return true
			end
		else
			if mo.ceilingrover and (mo.ceilingrover.flags & FF_GOOWATER) then
				return true
			end
		end
	end
	return false
end

local function P_CheckMobjCollision(thing, tmthing)
	local h1, h2
	local result = false
	h1 = thing.z + (thing.height * P_MobjFlip(thing))
	h2 = tmthing.z + (tmthing.height * P_MobjFlip(tmthing))
	
	return ((h1 > tmthing.z) and (h1 < h2)) or ((h2 > thing.z) and (h2 < h1))
end

addHook("MapLoad", function()
	enabled = mapheaderinfo[gamemap].gooprock
end)

addHook("MobjSpawn", function(mo)
	mo.mass = 1
end, MT_ROLLOUTROCK)

addHook("PlayerSpawn", function(player)
	player.shutfuckup = 0
	player.prevz = 0
end)

addHook("PlayerThink", function(player)
	if player.shutfuckup > 0 and not(player.playerstate == PST_LIVE and (player.panim == PA_WALK or player.panim == PA_IDLE)) then
		player.shutfuckup = 0
		player.prevz = 0
		if verbose then
			//print("Resetting player state...")
		end
	else
		player.prevz = player.mo.momz
	end
end)

addHook("PreThinkFrame", function()
	if enabled then
		for player in players.iterate() do
			if (player.mo.tracer and player.mo.tracer.type == MT_ROLLOUTROCK) then
				if player.shutfuckup == 1 then
					player.mo.tracer.z = $ + FRACUNIT*P_MobjFlip(player.mo.tracer)
					player.mo.tracer.momz = player.prevz
					player.shutfuckup = 2
					//verbosePrint("Changed ZMOM to " .. FixedInt(player.mo.tracer.momz))
				end
			else
				player.shutfuckup = 0
			end
		end
	end
end, MT_ROLLOUTROCK)

addHook("MobjThinker", function(mo)
	if enabled then
		if not mo.init then
			mo.color = SKINCOLOR_ROLLBROWN
			mo.init = true
		end
		mo.hitline = nil
		mo.hitside = nil
		mo.hitsector = nil
		mo.hitpolyobj = nil
		mo.hitrover = nil
		if P_IsObjectOnGoopBottom(mo) then
			P_SetObjectMomZ(mo, FRACUNIT, false)
		elseif P_IsObjectOnGround(mo) then
			mo.knockedback = false
		end
		if mo.tracer and mo.tracer.player then
			local height = (mo.height + mo.tracer.height)
			if P_MobjFlip(mo) then
				if height + mo.z > mo.ceilingz then
					mo.z = mo.ceilingz - height
					mo.momz = 0
					//verbosePrint("Ceiling clipped (non-flipped)")
				end
			else
				if height - mo.z < mo.ceilingz then
					mo.z = mo.ceilingz + height
					mo.momz = 0
					//verbosePrint("Ceiling clipped (flipped)")
				end
			end
		end
	end
end, MT_ROLLOUTROCK)

/*TODO:
	Check hight difference of opposing sector, adjust bounce params based off that
	(to climb small ledges without losing all of your speed)
	Maybe?: Add ability to bounce off floor
*/

addHook("MobjLineCollide", function(mo, line)
	local case = P_MobjWorldCollide(mo, line)
	if case > 0 then
		if case == 5 then
			if mo.hitrover and (mo.hitrover.flags & FF_BUSTUP) then
				EV_CrumbleChain(nil, mo.hitrover)
				return false
			end
		end
		
		local vmom = {}
		vmom.x = mo.momx
		vmom.y = mo.momy
		vmom.z = mo.momz
		
		local speed = R_PointToDist2(0, 0, vmom.x, vmom.y)
		local wallnormangle = R_PointToAngle2(line.v1.x, line.v1.y, line.v2.x, line.v2.y) + ANGLE_90
		local vwallnorm = SphereToCartesian(wallnormangle, 0)
		local compareheight = nil
		local collidepercent = 100

		
		/*cases:
		0: nothing
		1: one-sided
		2: polyobject
		3: standard, ceiling
		4: standard, floor
		5: fof		*/
		if case > 1 then
			if case == 2 then
				if (mo.eflags & MFE_VERTICALFLIP) then
					compareheight = mo.hitsector.floorheight
				else
					compareheight = mo.hitsector.ceilingheight
				end
			elseif case == 3 and (mo.eflags & MFE_VERTICALFLIP) then
				compareheight = P_GetSectorCeilingZAt(mo.hitsector, mo.x, mo.y)
			elseif case == 4 and not (mo.eflags & MFE_VERTICALFLIP) then
				compareheight = P_GetSectorFloorZAt(mo.hitsector, mo.x, mo.y)
			elseif case == 5 then
				if (mo.eflags & MFE_VERTICALFLIP) then
					compareheight = P_GetFFloorBottomZAt(mo.hitrover, mo.x, mo.y)
				else
					compareheight = P_GetFFloorTopZAt(mo.hitrover, mo.x, mo.y)
				end
			end
		end
		
	//	verbosePrint(tostring(compareheight) .. ", " .. case)
		
		if type(compareheight) == "number" then
			local diff = abs(compareheight - P_MobjFlip(mo)*mo.z) //how much taller are we than what we bonked with?
		//	verbosePrint(FixedInt(compareheight) .. " - " .. FixedInt(P_MobjFlip(mo)*mo.z) .. " = " .. FixedInt(diff))
			collidepercent = min(FixedInt(FixedDiv(diff, mo.height)*100), 100)
			//verbosePrint(collidepercent)
		end
		
		VectorBounce(mo,vmom,vwallnorm,collidepercent)
		if mo.hitside == 1 then
			P_Thrust(mo, wallnormangle, (speed*collidepercent)/200)
		else
			P_Thrust(mo, wallnormangle, -(speed*collidepercent)/200)
		end
		if not mo.knockedback then
			P_SetObjectMomZ(mo, (speed*(100 - collidepercent))/200, true)
			mo.knockedback = true
		end
	end
end, MT_ROLLOUTROCK)

addHook("MobjCollide", function(rock, tmthing)
	if enabled and tmthing and tmthing.valid then
		if (tmthing.flags & MF_ENEMY or tmthing.flags & MF_BOSS) then
			if P_CheckMobjCollision(rock, tmthing) then
				if speed(rock) > FRACUNIT then
					//verbosePrint("Damaged " .. tmthing.info.doomednum)
					P_DamageMobj(tmthing, rock, rock, 1)
				else
					//verbosePrint("Forced collision with mobj " .. tmthing.info.doomednum)
					return true
				end
			end
		elseif (tmthing.player and tmthing.health) and P_IsRockOnGoopSurface(rock) then
			local player = tmthing.player
			if (player.powers[pw_carry] == CR_ROLLOUT) and (player.mo.tracer and player.mo.tracer.type == MT_ROLLOUTROCK) and not player.shutfuckup then
				player.shutfuckup = 1
			end
		end
	end
end, MT_ROLLOUTROCK)
