--[[
	Egg Decker

	JCZ Boss loosely based on Sonic 3D Blast's
	Green Grove boss

	Attempt 2

	TODO: does this even work? we should check that

	(C) 2022 by ashi
]]

-- Define the boss here
-- States are loosely followed
freeslot(
	"MT_EGGDECKER",
	"S_EGGDECKER_SPAWN",
	"S_EGGDECKER_MAIN",
	"S_EGGDECKER_PAIN",
	"S_EGGDECKER_DEATH",

	"MT_EGGDECKER_BOULDER",
	"S_EGGBOULDER_MAIN",
	"S_EGGBOULDER_DEATH",

	"S_EGGBOULDER_JUNK",

	"SPR_GHBD",
	"SPR_GHBJ"
)

mobjinfo[MT_EGGDECKER] = {
	--$Name Egg Decker
	--$Sprite EGGMA1
	--$Category Mystic Realm Bosses
	doomednum = 1338,
	spawnstate = S_EGGDECKER_SPAWN,
	seestate = S_EGGDECKER_MAIN,
	painstate = S_EGGDECKER_PAIN,
	painsound = sfx_dmpain,
	deathstate = S_EGGMOBILE_DIE1,
	xdeathstate = S_EGGMOBILE_FLEE1,
	deathsound = sfx_cybdth,
	spawnhealth = 8,
	reactiontime = 128,
	speed = 30*FRACUNIT,
	radius = 24*FRACUNIT,
	height = 46*FRACUNIT,
	damage = 20*FRACUNIT,
	flags = MF_SPECIAL|MF_SHOOTABLE|MF_NOGRAVITY|MF_FLOAT|MF_BOSS
}

states[S_EGGDECKER_SPAWN] = {SPR_EGGM, A, 1, nil, 0, 0, S_EGGDECKER_MAIN}
states[S_EGGDECKER_MAIN] = {SPR_EGGM, A, -1, nil, 0, 0, S_EGGDECKER_MAIN}
states[S_EGGDECKER_PAIN] = {SPR_EGGM, V, 35, A_Pain, 0, 0, S_EGGDECKER_MAIN}

mobjinfo[MT_EGGDECKER_BOULDER] = {
	doomednum = -1,
	spawnstate = S_EGGBOULDER_MAIN,
	deathstate = S_EGGBOULDER_DEATH,
	speed = 30*FU,
	flags = MF_PAIN|MF_NOGRAVITY|MF_NOCLIPTHING
}

states[S_EGGBOULDER_MAIN] = {SPR_GHBD, A, -1, nil, 0, 0, S_EGGBOULDER_MAIN}

addHook("MobjSpawn", function(bossmo)
	-- Set the custom state so we know what block to execute
	bossmo.c_state = "spawn_phase1"
	bossmo.anim_timer = TICRATE
	bossmo.bould = {}
	bossmo.movefactor = bossmo.z
	bossmo.bouncecount = 0
end, MT_EGGDECKER)

addHook("MobjSpawn", function(ballmo)
	-- Set our animation timer to 0 here
	-- No reason not to
	ballmo.anim_timer = 0
	ballmo.anim_percent = 0
end, MT_EGGDECKER_BOULDER)

addHook("MobjThinker", function(bossmo)
	-- variables used thorughout the script
	local speed = 2*TICRATE  -- How fast we bob
	local amp = 16 			 -- I have no clue what this does
	local z = bossmo.movefactor  -- I think this is the starting height?

	-- Perform the initial drop in animation
	-- for eggman before doing anything else
	if bossmo.c_state == "spawn_phase1" then
		-- Drop in animation
		if bossmo.anim_timer >= -30 then

			if (bossmo.anim_timer > 0) then -- Drop down into the arena smoothly
				z = $1 + ((bossmo.anim_timer * bossmo.anim_timer) * bossmo.scale)
			elseif (leveltime/5%2) then -- Laugh for a bit
				bossmo.frame = R
			else
				bossmo.frame = S
			end

			-- We use mo.extravalue1 as a timer
			bossmo.anim_timer = $1 - 1
			-- bob in the air for a bit
			bossmo.z = z + FixedMul(amp * sin((2*pi*speed) * leveltime), bossmo.scale) + bossmo.spawnpoint.z
		else -- Opening sequence is done. Let's continue onto the actual boss.
			bossmo.c_state = "spawn_phase2"
			bossmo.anim_timer = 0
			-- Define our Z Limit to prevent eggman from somehow lowering during the boss.
			bossmo.zlimit = bossmo.z
		end
		return
	elseif bossmo.c_state == "spawn_phase2" then
		-- Check our timer
		if bossmo.anim_timer == 100 then
			bossmo.c_state = "follow"
		end

		-- Now we spawn the boulders
		for i=1,2 do
			if bossmo.bould[i] == nil
			and bossmo.c_state != "attack" then
				-- Spawn the first boulder
				bossmo.bould[i] = P_SpawnMobjFromMobj(bossmo, bossmo.x, bossmo.y, bossmo.z, MT_EGGDECKER_BOULDER)
				bossmo.bould[i].target = bossmo -- Set our target to bossmo
				if i == 1 then
					bossmo.bould[i].verticalAngle = 0 -- How far along we begin with our rotation.
				elseif i == 2 then
					bossmo.bould[i].verticalAngle = ANGLE_180
				end
			end
		end
		local speed = 2*TICRATE
		local amp = 16

		-- Bob up and down in the air for a bit.
		bossmo.z = bossmo.movefactor + FixedMul(amp * sin((2*pi*speed) * leveltime), bossmo.scale)

		-- Increment the timer
		bossmo.anim_timer = $ + 1
		-- Do not run any further code until we are done
		print(bossmo.anim_timer)
		return
	elseif bossmo.c_state == "follow" then
		-- Always point at the player
		bossmo.angle = R_PointToAngle2(bossmo.x, bossmo.y, bossmo.target.x, bossmo.target.y)
		-- Define our values we use to chase the player
		local dist = P_AproxDistance(bossmo.target.x - bossmo.x,
									 bossmo.target.x - bossmo.y)
		local speedmul = FixedMul(bossmo.info.damage, bossmo.scale)

		-- Never let distance go below 0. Bad things happen.
		if (dist < 1) then
			dist = 1
		end

		-- Chase the player around
		bossmo.momx = FixedMul(FixedDiv(bossmo.target.x - bossmo.x, dist), speedmul)
		bossmo.momy = FixedMul(FixedDiv(bossmo.target.y - bossmo.y, dist), speedmul)

		-- Don't let the boss dip down to the player's Z
		bossmo.z = bossmo.zlimit

		-- If the player enters a certain distance execute attack mode
		if R_PointToDist2(bossmo.x, bossmo.y, bossmo.target.x, bossmo.target.y) <= 10000000 then
			bossmo.c_state = "attack"
		end
	elseif bossmo.c_state == "attack" then
		-- Remove all remaining momentum
		bossmo.momz = 0
		bossmo.momx = 0
		bossmo.momy = 0

		-- Bob in the air
		bossmo.z = z + FixedMul(amp * sin((2*pi*speed) * leveltime), bossmo.scale) + bossmo.spawnpoint.z

		-- Gather the boulders after a certain amount of time
		if bossmo.atk_timer == 300 then
			bossmo.c_state = "recall"
		end
	elseif bossmo.c_state == "pain" then
		-- Reset the bouncecount
		bossmo.bouncecount = 0

		-- Run a timer for a bit then move out of painstate
		bossmo.anim_timer = $ + 1
		if bossmo.anim_timer == 100 then
			--bossmo.flags = $ & ~(MF_)
		end
	end
end, MT_EGGDECKER)

addHook("MobjThinker", function(ballmo)
	local bossmo = ballmo.target -- For neatness and readability

	if bossmo.c_state == "spawn_phase2" then
		if ballmo.anim_percent < 65520 then
			-- Variables used in our easing functions
			ballmo.anim_capped = max(min(ballmo.anim_timer, TICRATE), 0)
			ballmo.anim_percent = FU / TICRATE * ballmo.anim_capped

			-- Actually perform said animation
			ballmo.z = ease.outback(ballmo.anim_percent, bossmo.spawnpoint.z+(300*FU), bossmo.spawnpoint.z+(20*FU))
		end

		-- Increment the timer
		ballmo.anim_timer = $ + 1
		-- Don't do anything until we finish the spawn animation
		return
	elseif bossmo.c_state == "follow" then
		local verticalAngle = R_PointToAngle2(FixedHypot(ballmo.x,ballmo.y),ballmo.z,FixedHypot(bossmo.x,bossmo.y),bossmo.z)

		-- This helps us determine how far along we are on the rotation
		ballmo.verticalAngle = $1 + ballmo.info.speed*FU

		-- Where we calculate everything required to get the boulders to rotate around eggman
		local x = bossmo.x + bossmo.info.reactiontime*cos(ballmo.verticalAngle)/FU*cos(bossmo.angle)
		local y = bossmo.y + bossmo.info.reactiontime*cos(ballmo.verticalAngle)/FU*sin(bossmo.angle)
		local z = bossmo.z + sin(ballmo.verticalAngle)*bossmo.info.reactiontime

		-- Teleport to those coordinates.
		P_MoveOrigin(ballmo, x, y, z)
	elseif bossmo.c_state == "attack" then
		-- Remove MF_NOGRAVITY|MF_NOCLIPTHING to properly fall
		ballmo.flags = $ & ~(MF_NOGRAVITY|MF_NOCLIPTHING)

		-- Increment the bouncecount
		bossmo.bouncecount = $ + 1
		ballmo.angle = R_PointToAngle2(ballmo.x, ballmo.y, bossmo.target.x, bossmo.target.y)
		if bossmo.bouncecount == 1 then							-- This is where we handle the bounce mechanic
																-- Decrease the bounce height for every bounce
  			P_SetObjectMomZ(ballmo, 10 * FRACUNIT, false)
  		elseif bossmo.bouncecount == 2 then
  			P_SetObjectMomZ(ballmo, 8 * FRACUNIT, false)
  		elseif bossmo.bouncecount == 3 then
  			P_SetObjectMomZ(ballmo, 4 * FRACUNIT, false)
  		end
  		S_StartSound(nil, sfx_pstop)
  		P_InstaThrust(ballmo, ballmo.angle, 20 * FRACUNIT)
	elseif bossmo.c_state == "hitback" then
		-- Reactivate MF_NOGRAVITY|MF_NOCLIPTHING
		ballmo.flags = $ | (MF_NOGRAVITY|MF_NOCLIPTHING)

		-- perform our hitback animation
		if ballmo.hitback then
			if ballmo.anim_percent != 65520 then
				-- record our previous position for the animation
				if ballmo.prevpos[1] == nil then
					ballmo.prevpos[1] = ballmo.x
					ballmo.prevpos[2] = ballmo.y
					ballmo.prevpos[3] = ballmo.z
				end

				ballmo.anim_capped = max(min(bossmo.anim_timer, TICRATE), 0)
				ballmo.anim_percent = FU / TICRATE * ballmo.anim_capped

				P_MoveOrigin(ballmo, ease.linear(animate_percentage, ballmo.prevpos[1], bossmo.x),
    								   ease.linear(animate_percentage, ballmo.prevpos[2], bossmo.y),
    								   ease.outback(animate_percentage, ballmo.prevpos[3], bossmo.z))
    			bossmo.anim_timer = $ + 1
			else
				-- Damage the boss and play the sound effect
    			P_DamageMobj(bossmo, bossmo.target, bossmo.target)
    			S_StartSound(nil, sfx_dmpain)
    			-- Reset our variables
    			bossmo.bouncecount = 0
    			bossmo.anim_timer = 0
    			bossmo.atk_timer = 0
    			ballmo.prevpos = {nil,nil,nil}
    			ballmo.hitback = false
    			-- Change our state
    			bossmo.c_state = "pain"
    			return
    		end
		end
	end
end, MT_EGGDECKER_BOULDER)

-- Collision code for the boulders
addHook("MobjMoveCollide", function(thing, tmthing)
	-- MobjMoveCollide doesn't give us Z checks so we need our own
	if (thing.z > (tmthing.z + tmthing.height))
    or ((thing.z + thing.height) < tmthing.z) then
    	return false -- Out of range. DO NOT override default behavior.
    end

    -- Do not reexecute collision code if one was hit already.
    for i=1,2 do
    	if thing.target.bould[i].hitback then
    		return false
    	end
    end

	if tmthing.player then -- Are we colliding with the player?
		if P_PlayerCanDamage(tmthing.player, thing.target) -- Is the player able to damage the boss?
		and thing.target.bouncecount == 3
		and thing.target.c_state == "attack" then
			thing.bounceback = true
			S_StartSound(nil, sfx_mswing)
			return true -- Override deafult behavior
		else
			P_DamageMobj(tmthing, thing, thing) -- Damage the player
		end
	end
end, MT_EGGDECKER_BOULDER)