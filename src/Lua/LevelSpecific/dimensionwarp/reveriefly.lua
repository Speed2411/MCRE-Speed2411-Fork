--Egg Reverie Zone Super Sonic by Frostiikin. Feel free to use & edit this anywhere as long as you give the proper credits.
--Bug Fixes, comments, and code cleanup courtesy of Dabir, Thanks for cleaning up my shoddy code lmfao
freeslot(
"sfx_spdash")
sfxinfo[sfx_spdash].caption = "Super Dash"
addHook("PlayerThink",  function(p)
    -- Only Sonic can be Super Sonic
    if not (p.mo and p.mo.valid and (p.mo.skin == "sonic" or p.mo.skin == "supersonic" or p.mo.skin == "metalsonic" or p.mo.skin == "tails" or p.mo.skin == "knuckles")) then
        return
    end

    -- Only Super people can be Super Sonic
    if not p.powers[pw_super] then
        -- Non-super people can't be super-flying
        p.eggsuperflying = false
		p.thrustfactor = skins[p.mo.skin].thrustfactor
		p.mo.flags = $ & ~MF_NOGRAVITY
        return
    end

    -- Not not Sonic, not not Super, must be Super Sonic!

    -- Can't go flying if you're in a minecart or a zoom tube
    if p.mo.state == S_PLAY_RIDE or p.powers[pw_carry] == CR_ZOOMTUBE then
        return
    end

    -- Definitely flying, so initialise/confirm flying-related variables
    p.eggsuperflying = $ or false  -- Boolean for whether Super Sonic is flying
    p.eggflystart = $ or false -- Boolean for whether Super Sonic just started flying
    p.eggflyboost = $ or false  -- Boolean for whether Super Sonic can boost this tic
    p.eggboostcost = 5  -- How many rings it costs to boost
    p.eggmaxvert = 22*FRACUNIT  -- Maximum vertical flying speed in either direction
	p.eggboostcooldown = $ or 0
//  p.eggoldability = $ or CA_NONE -- Storage for non-super jump ability

    -- If you still have a jump ability, take it away and remember what it was
//    if p.charability != CA_NONE
//        p.charability, p.eggoldability = CA_NONE, $1
//    end

    -- You stop flying when you touch the ground
    if P_IsObjectOnGround(p.mo) then
        p.eggsuperflying = false
		p.thrustfactor = skins[p.mo.skin].thrustfactor
//    else
    -- Prevent rolling when holding spin and touching ground while flying.
//        p.pflags = $ | PF_THOKKED
    end

    -- If you're not flying right now, we're done here.
    if not p.eggsuperflying then
		p.mo.flags = $ & ~MF_NOGRAVITY
        return
    end

    -- Gravity doesn't apply when you're flying
   p.mo.flags = $ | MF_NOGRAVITY

	if p.mo.flags & MF_NOGRAVITY then
		p.thrustfactor = 2*skins[p.mo.skin].thrustfactor
	else
		p.thrustfactor = skins[p.mo.skin].thrustfactor
	end

    -- You can't fall when you're flying
    if p.mo.state == S_PLAY_FALL
	and p.mo.skin == "sonic" or p.mo.skin == "supersonic" or p.mo.skin == "metalsonic" then
        p.mo.state = S_PLAY_FLOAT
    end

	if p.speed >= FixedMul(p.runspeed, p.mo.scale) then
		if p.mo.skin == "sonic" or p.mo.skin == "supersonic" or p.mo.skin == "metalsonic" then
			if p.dashmode > 3*TICRATE then
				p.mo.state = S_PLAY_DASH
			else
				p.mo.state = S_PLAY_FLOAT_RUN
			end
		elseif p.charability == CA_GLIDEANDCLIMB then
			p.mo.state = S_PLAY_GLIDE
		else
			p.mo.state = S_PLAY_RUN
		end
	else
		if p.mo.skin == "sonic" or p.mo.skin == "supersonic" or p.mo.skin == "metalsonic"then
			p.mo.state = S_PLAY_FLOAT
		else
			p.mo.state = S_PLAY_FALL
		end
	end

    -- You're not jumping or spinning when you're flying
	p.pflags = $ & ~PF_JUMPED & ~PF_SPINNING

    -- You have to let go of jump after you start floating before you can ascend
    if not (p.cmd.buttons & BT_SPIN) then
        p.eggflystart = false
    end

	--Prevent stored momentum when initiating hover
	if p.eggflystart == true and p.eggflymode == 1 then
		P_SetObjectMomZ(p.mo, 0*FRACUNIT)
	end

    -- You have to let go of either jump or spin after boosting before you can boost again
    if not (p.cmd.buttons & BT_USE) or not (p.cmd.buttons & BT_JUMP) then
        p.eggflyboost = true
    end

    -- If you're holding jump and not spin, accelerate up
    if (p.cmd.buttons & BT_JUMP) and not (p.cmd.buttons & BT_USE) and not p.eggflystart or (p.cmd.buttons & BT_JUMP) and not (p.cmd.buttons & BT_USE) and p.eggflymode == 2 then
        P_SetObjectMomZ(p.mo, (5/3)*FRACUNIT, true) -- Accelerate up
    end

    -- If you're holding spin and not jump, accelerate down
    if (p.cmd.buttons & BT_USE) and not (p.cmd.buttons & BT_JUMP) then
        P_SetObjectMomZ(p.mo, -(5/3)*FRACUNIT, true)
    end

    -- Cap the max flying speed at both ends
    p.mo.momz = max(min(p.eggmaxvert, p.mo.momz), 0-p.eggmaxvert)

	if MRCE_isHyper(p) then
		p.eggboostcost = 2
	else
		p.eggboostcost = 5
	end

	if p.eggboostcooldown != 0 then
		p.eggboostcooldown = $ - 1
	end

    -- If you're holding both, and you're allowed to boost, and you can pay for it, boost
    if (p.cmd.buttons & BT_JUMP) and (p.cmd.buttons & BT_USE)
    and p.eggflyboost and p.rings >= p.eggboostcost and p.eggboostcooldown == 0 then
        p.rings = $ - p.eggboostcost
        P_InstaThrust(p.mo, p.mo.angle, 150*FRACUNIT)
		if p.screenflash == true then
			P_FlashPal(p, PAL_WHITE, 10)
		end
		P_NukeEnemies(p.mo, p.mo, 384*FRACUNIT)
        S_StartSound(p.mo, sfx_spdash)
		p.eggboostcooldown = 2 * TICRATE
        p.eggflyboost = false -- Can't boost if you've just boosted
    end

    -- If you're holding neither, come to a halt
    if not (p.cmd.buttons & BT_JUMP) and not (p.cmd.buttons & BT_USE) then
        p.mo.momz = abs($)>FRACUNIT and $*9/10 or 0
    end
end)

addHook("JumpSpinSpecial", function(p)
	if p.mo and p.mo.valid then
		if not p.powers[pw_super]
		or (mapheaderinfo[gamemap].lvlttl != "Dimension Warp" and (p.mrce.flycheat == false or p.mrce.flycheat == nil)) then
			return
		end
		if p.mo.skin == "sonic" or p.mo.skin == "supersonic" or p.mo.skin == "metalsonic" or p.mo.skin == "tails" or p.mo.skin == "knuckles" and not p.eggsuperflying then
			p.eggsuperflying = true
			p.eggflystart = true
			if p.mo.skin == "sonic" or p.mo.skin == "supersonic" or p.mo.skin == "metalsonic" then
				p.mo.state = S_PLAY_FLOAT
			else
				p.mo.state = S_PLAY_RUN
			end
			p.pflags = $1 | PF_THOKKED
			return true
		end
		return false
	end
end)