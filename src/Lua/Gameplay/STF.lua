--[[ Super Tails' Flickies v1.3
Author: birbhorse (aka EeveeEuphoria)
Sprites: Sonic Team Jr. (with modifications by author, to allow for coloration)
Shoutouts: gregory_house for making the original Super Flickies mod. I was already a ways in developing this when I discovered this already existed! The code used here is from how the flickies are arranged, and the general flow of the code is derrived from them.
And to MotorRoach for their Flicky character mod, I didn't use their sprites, but I did learn how to give the flicky sprites the abillity to be colored.

TO-DO LIST:
	- [x] 2.2.1 changes, use PlayerThink instead of mobjthinker, remove "end, MT_PLAYER)"
		- [x] also use "gaybird.shadowscale = 2*FRACUNIT/3"
	- Fix Fang's boss fight from letting the birds attack him when he's in the box.
		- Goes up to S_FANG_INTRO9, when at that state, he's ready to be b o p p ' d. Also include the SETUP state.

CHANGELOG:
	- NOTE TO SELF: POST srb20130.gif FOR USE AS THE NEW GIF FOR STF
	- This is now only usable in SRB2 v2.2.1 and above! Update SRB2 before using this! Also yes this is v1.3, not v1.2.1, there's a lot more changes than expected.
	- Added drop shadows to the flickies.
	- Made it so the flickies only go out to m u r d e r when the player is completely done with their super transformation animation.
	- Reduced redudancy in code by a lot.
	- Removed unused frames.
	- The birds will not attack the ACZ boss if they're still in the box.
	- Fixed a bug where the birds don't actually animate.
	- Fixed the birds not disappearing when going above the ceiling (thankfully i had a failsafe in there)
	- Fixed problem where if Tails went super again before the birds disappeared, the birds might not spawn correctly.

]]

rawset(_G, "STFModLoaded", true) -- detection of this mod, if needed for any reason

local STFDebug

freeslot(
"MT_TLBRD",
"MT_TLHME",
"S_TAILSBIRD1",
"S_TAILSBIRD2",
"S_TAILSBIRD3",
"S_TAILSBIRD4",
"S_TAILSBIRDHOUSE",
"SPR_FLTS"
)

states[S_TAILSBIRD1] = {
	sprite = SPR_FLTS,
	frame = FF_FULLBRIGHT|A,
	tics = 6,
	nextstate = S_TAILSBIRD2
}

states[S_TAILSBIRD2] = {
	sprite = SPR_FLTS,
	frame = FF_FULLBRIGHT|C,
	tics = 6,
	nextstate = S_TAILSBIRD3
}

states[S_TAILSBIRD3] = {
	sprite = SPR_FLTS,
	frame = FF_FULLBRIGHT|B,
	tics = 6,
	nextstate = S_TAILSBIRD4
}

states[S_TAILSBIRD4] = {
	sprite = SPR_FLTS,
	frame = FF_FULLBRIGHT|C,
	tics = 6,
	nextstate = S_TAILSBIRD1
}

states[S_TAILSBIRDHOUSE] = {
	sprite = SPR_NULL,
	frame = A,
	tics = -1,
	nextstate = S_TAILSBIRDHOUSE
}

mobjinfo[MT_TLBRD] = {
	doomednum = -1,
	spawnstate = S_TAILSBIRD1,
	--speed = 40*FRACUNIT,
	height = 25*FRACUNIT,
	radius = 13*FRACUNIT,
	flags = MF_RUNSPAWNFUNC|MF_NOCLIP|MF_NOCLIPHEIGHT|MF_NOGRAVITY
}

mobjinfo[MT_TLHME] = {
	doomednum = -1,
	spawnstate = S_TAILSBIRDHOUSE,
	speed = 10*FRACUNIT,
	height = 50,
	flags = MF_RUNSPAWNFUNC|MF_NOCLIP|MF_NOCLIPHEIGHT|MF_NOGRAVITY
}

local STFCheckSpeed = 6
local STFAttackNum = 4
local STFSuperTails = "on"
local STFSearchType = "aggressive"

-- [[[ Commands ]]] --
-- A lot of this stuff is just code carried over from MMT, because...uh, laziness, and comfort.

local commandDescription = {
["STFCheckSpeed"] = "*\x85 STFCheckSpeed \x81<num>\x80: Adjusts the speed in which checks are performed on the map for enemies, for STFSearchType aggressive. Set to a higher number for slower computers.",
["STFAttackNum"] = "*\x85 STFAttackNum \x81<1, 2, 3, 4>\x80: Changes the number of flickies that are allowed to attack enemies simultaneously.",
["STFSearchType"] = "*\x85 STFSearchType \x81<slow/aggressive>\x80: Changes search type, slow is less accurate but less CPU-demanding."
}

local function cmdDesc(tbl, key)
    for k, v in pairs(tbl) do
        if k == key then
			return v
		end
    end
    return nil
end

local function stfcheckspeed(player, arg1)
local cmdname = "STFCheckSpeed"
	if STFSearchType == "slow" then
		CONS_Printf(player, "\x85 ERROR:\x80 Can not use while STFSearchType is set to slow!")
		return
	end
	if tonumber(arg1) then
		arg1 = tonumber(arg1)
	end
	if tonumber(arg1) and arg1 > 0 and arg1 < TICRATE+1 then
		STFCheckSpeed = tonumber(arg1)
		CONS_Printf(player, "*\x8A ".. cmdname .."\x80 is set to \x87" .. arg1)
	else
		CONS_Printf(player, cmdDesc(commandDescription, cmdname))
		CONS_Printf(player, "*\x8A " .. cmdname .. "\x80 is set to \x87" +STFCheckSpeed)
		CONS_Printf(player, "*\x8E Options:\x80 Values go between 1 and " .. TICRATE .. ", default is 6.")
	end
end

local function stfattacknum(player, arg1)
local cmdname = "STFAttackNum"
	if tonumber(arg1) then
		arg1 = tonumber(arg1)
	end
	if tonumber(arg1) and arg1 > 0 and arg1 < 4 then
		STFAttackNum = tonumber(arg1)
		CONS_Printf(player, "*\x8A ".. cmdname .."\x80 is set to \x87" .. arg1)
	else
		CONS_Printf(player, cmdDesc(commandDescription, cmdname))
		CONS_Printf(player, "*\x8A " .. cmdname .. "\x80 is set to \x87" +STFAttackNum)
		CONS_Printf(player, "*\x8E Options:\x80 Values go between 1 and 4, default is 4.")
	end
end

local function stfsearchtype(player, arg1)
local cmdname = "STFSearchType"
	if arg1 == "aggressive" or arg1 == "slow" then
		STFSearchType = arg1
		CONS_Printf(player, "*\x8A ".. cmdname .."\x80 is set to \x87" .. arg1)
	else
		CONS_Printf(player, cmdDesc(commandDescription, cmdname))
		CONS_Printf(player, "*\x8A " .. cmdname .. "\x80 is set to \x87" +STFSearchType)
		CONS_Printf(player, "*\x8E Options:\x80 \"slow\", \"aggressive\".")
	end
end

COM_AddCommand("STFCheckSpeed", stfcheckspeed, 1)
COM_AddCommand("STFAttackNum", stfattacknum, 1)
COM_AddCommand("STFSearchType", stfsearchtype, 1)


-- [[[ Player Thinker ]]] --

addHook("PlayerThink", function(player)
if player.spectator then return end
if not player.realmo then return end

if not player.STFMod then
	player.STFMod = {}
end

-- [[ Give player super, if MMT isn't loaded! ]] --
if player.STFMod.birdangle == nil then
	player.STFMod.birdangle = 0
	player.STFMod.birdheightangle = 0
	player.STFMod.birdheight = 0
end

-- [[ Spawn The Birb ]] --
	if (player.mo.skin == "tails") and player.powers[pw_super] and not player.STFMod.birdsSummoned and (mapheaderinfo[gamemap].lvlttl != "Dimension Warp") --when player is super, but birds are not out
	or (player.mo.skin == "hms123311") and player.powers[pw_super] and not player.STFMod.birdsSummoned and MRCE_isHyper(player)
	or (player.mo.skin == "fhms123311") and player.powers[pw_super] and not player.STFMod.birdsSummoned and MRCE_isHyper(player) then
		player.STFMod.birdMissionTime = 0
		player.STFMod.CoolDownBirdTimer = 0
		player.STFMod.bird1target = "none"
		player.STFMod.bird2target = "none"
		player.STFMod.bird3target = "none"
		player.STFMod.bird4target = "none"

		local function SummonMe(bird, number)
			bird = P_SpawnMobj(player.mo.x, player.mo.y, player.mo.ceilingz-(2*FRACUNIT), MT_TLBRD)
			bird.number = number
			bird.color = 79
			bird.idle = true
			bird.tailsdude = player.mo
			bird.shadowscale = 2*FRACUNIT/3
			bird.colorized = player.mo.colorized
			bird.blendmode = player.mo.blendmode

		end

		SummonMe(player.STFMod.bird1, 1)
		SummonMe(player.STFMod.bird2, 2)
		SummonMe(player.STFMod.bird3, 3)
		SummonMe(player.STFMod.bird4, 4)
		player.STFMod.birdhome = P_SpawnMobj(player.mo.x, player.mo.y, player.mo.z, MT_TLHME)
		player.STFMod.birdhome.tailsdude = player.mo
		player.STFMod.birdsSummoned = true
		player.STFMod.birdsReady = false
	end

-- [[ The Good Birb Stuff, contains logic for the movement when idle, and the detection of enemies ]] --
	if player.powers[pw_super] and player.STFMod.birdsSummoned then
		-- [ Bird Home ] --
		if (player.mo.eflags & MFE_VERTICALFLIP) or (player.mo.flags2 & MF2_OBJECTFLIP) then
			P_MoveOrigin(player.STFMod.birdhome, player.mo.x+player.mo.momx, player.mo.y+player.mo.momy, player.mo.momz + (player.mo.z-(player.mo.height/2)-25*FRACUNIT))
		else
			P_MoveOrigin(player.STFMod.birdhome, player.mo.x+player.mo.momx, player.mo.y+player.mo.momy, player.mo.momz + (player.mo.z+(player.mo.height/2)+20*FRACUNIT))
		end

		-- [ Bobbing ] -- Todo: Duplicate the GayBirdH thing 3 times to make different ones for each individual birb.
		if player.STFMod.gaybirdtimer == nil then
			player.STFMod.gaybirdtimer = 0
			player.STFMod.GayBirdH = 40*FRACUNIT
		else
			player.STFMod.gaybirdtimer = $+1
		end
		if player.STFMod.gaybirdtimer < 40 then
			player.STFMod.GayBirdH = $+(3/FRACUNIT)
		elseif player.STFMod.gaybirdtimer < 80 then
			player.STFMod.GayBirdH = $-(3/FRACUNIT)
		else
			player.STFMod.gaybirdtimer = 0
		end

		-- [ Player Flip ] --
		if (player.mo.eflags & MFE_VERTICALFLIP) or (player.mo.flags2 & MF2_OBJECTFLIP) then
			player.STFMod.GayBirdHFlip = (-player.STFMod.GayBirdH)
		else
			player.STFMod.GayBirdHFlip = 0
		end

		-- [ Floating Stuffs ] --
		player.STFMod.birdangle = $+5*FRACUNIT
		player.STFMod.birdheightangle = $+7*FRACUNIT
		player.STFMod.birdheight = player.mo.z+player.STFMod.GayBirdH+player.STFMod.GayBirdHFlip -- add timer to make this bob up and down
		player.STFMod.birddistance = 45

		-- [ Search Cooldown Timer ] --
		if player.STFMod.CoolDownBirdTimer > 0 then
			player.STFMod.CoolDownBirdTimer = $ - 1
		end
	end

	if player.STFMod.birdsSummoned then
		-- [ Distance between player and target enemy ] --
		if player.STFMod.bird1MissionTime and player.STFMod.bird1target.valid then
			player.STFMod.target1distance = R_PointToDist2(player.STFMod.bird1target.x, player.STFMod.bird1target.y, player.mo.x, player.mo.y)/FRACUNIT
		end
		if player.STFMod.bird2MissionTime and player.STFMod.bird2target.valid then
			player.STFMod.target2distance = R_PointToDist2(player.STFMod.bird2target.x, player.STFMod.bird2target.y, player.mo.x, player.mo.y)/FRACUNIT
		end
		if player.STFMod.bird3MissionTime and player.STFMod.bird3target.valid then
			player.STFMod.target3distance = R_PointToDist2(player.STFMod.bird3target.x, player.STFMod.bird3target.y, player.mo.x, player.mo.y)/FRACUNIT
		end
		if player.STFMod.bird4MissionTime and player.STFMod.bird4target.valid then
			player.STFMod.target4distance = R_PointToDist2(player.STFMod.bird4target.x, player.STFMod.bird4target.y, player.mo.x, player.mo.y)/FRACUNIT
		end

		-- [ Keep Up With Da Player ] --
		player.STFMod.bird1 = { x =  player.mo.x+cos(FixedAngle(player.STFMod.birdangle))*player.STFMod.birddistance, y = player.mo.y+sin(FixedAngle(player.STFMod.birdangle))*player.STFMod.birddistance, z = player.STFMod.birdheight+sin(FixedAngle(2*player.STFMod.birdheightangle))*5 }
		player.STFMod.bird2 = { x =  player.mo.x+cos(FixedAngle(player.STFMod.birdangle+90*FRACUNIT))*player.STFMod.birddistance, y = player.mo.y+sin(FixedAngle(player.STFMod.birdangle+90*FRACUNIT))*player.STFMod.birddistance, z = player.STFMod.birdheight+sin(FixedAngle(2*player.STFMod.birdheightangle))*5 }
		player.STFMod.bird3 = { x =  player.mo.x+cos(FixedAngle(player.STFMod.birdangle+180*FRACUNIT))*player.STFMod.birddistance, y = player.mo.y+sin(FixedAngle(player.STFMod.birdangle+180*FRACUNIT))*player.STFMod.birddistance, z = player.STFMod.birdheight+sin(FixedAngle(2*player.STFMod.birdheightangle))*5 }
		player.STFMod.bird4 = { x =  player.mo.x+cos(FixedAngle(player.STFMod.birdangle+270*FRACUNIT))*player.STFMod.birddistance, y = player.mo.y+sin(FixedAngle(player.STFMod.birdangle+270*FRACUNIT))*player.STFMod.birddistance, z = player.STFMod.birdheight+sin(FixedAngle(2*player.STFMod.birdheightangle))*5 }


		-- { Searches ] --

		local function searchingtime(mobj)
			if (R_PointToDist2(mobj.x, mobj.y, player.mo.x, player.mo.y) < 512*FRACUNIT) and (abs(mobj.z - player.mo.z) < 512*FRACUNIT)
			and (((mobj.flags & MF_ENEMY) or (mobj.flags & MF_BOSS)))
			and not (mobj.flags2 & MF2_FRET)
			and not (mobj.type == MT_TURRET)
			and not ((mobj.type == MT_EGGMOBILE4) and (mobj.health >= 4) and (mobj.state == S_EGGMOBILE4_STND)) -- CEZ 3 Boss
			and ((mobj.flags & MF_SPECIAL) or mobj.type == MT_DETON or mobj.type == MT_EGGGUARD) -- detects if enemy can actually be hit, or if it's a deton
			and P_CheckSight(player.mo, mobj) -- checks to see if not obscured by wall
			and not ((mobj.type == MT_FANG) and (mobj.state == S_FANG_SETUP) or (mobj.state == S_FANG_INTRO0) or (mobj.state == S_FANG_INTRO1) or (mobj.state == S_FANG_INTRO2) or (mobj.state == S_FANG_INTRO3) or (mobj.state == S_FANG_INTRO4) or (mobj.state == S_FANG_INTRO5) or (mobj.state == S_FANG_INTRO6) or (mobj.state == S_FANG_INTRO7) or (mobj.state == S_FANG_INTRO8)) -- fang boss, makes sure he's not in the box
			and mobj.health > 0 then
				return true
			else
				return false
			end
		end

		local function sendthemout(searchtype)
			if player.STFMod.bird1target == "none" and not (player.STFMod.bird2target == searchtype or player.STFMod.bird3target == searchtype or player.STFMod.bird4target == searchtype)
			and STFAttackNum >= 1 then
				player.STFMod.bird1target = searchtype
			elseif player.STFMod.bird2target == "none" and not (player.STFMod.bird1target == searchtype or player.STFMod.bird3target == searchtype or player.STFMod.bird4target == searchtype)
			and STFAttackNum >= 2 then
				player.STFMod.bird2target = searchtype
			elseif player.STFMod.bird3target == "none" and not (player.STFMod.bird1target == searchtype or player.STFMod.bird2target == searchtype or player.STFMod.bird4target == searchtype)
			and STFAttackNum >= 3 then
				player.STFMod.bird3target = searchtype
			elseif player.STFMod.bird4target == "none" and not (player.STFMod.bird2target == searchtype or player.STFMod.bird3target == searchtype or player.STFMod.bird1target == searchtype)
			and STFAttackNum >= 4 then
				player.STFMod.bird4target = searchtype
			end
--			DebugPrint("ENEMY SPOTTED, IT'S: " +searchtype.type .. " WITH A STATE OF: " .. searchtype.state .. " AND HEALTH OF: " .. searchtype.health .. " AND FLAG VALUES: " .. searchtype.flags .. " " .. searchtype.flags2 .. " " .. searchtype.eflags)
		end

		if STFSearchType == "slow" and player.STFMod.birdsReady then
			player.STFMod.SearchTime = P_LookForEnemies(player, false, false)
			if player.STFMod.SearchTime then
				if searchingtime(player.STFMod.SearchTime) then
					-- [ Send the Birbs ] --
					sendthemout(player.STFMod.SearchTime)
				end
			end
		end
		-- [ o.g. Break The Targets ] --
		if STFSearchType == "aggressive" and player.STFMod.CoolDownBirdTimer == 0 and player.STFMod.birdsReady then
			player.STFMod.CoolDownBirdTimer = STFCheckSpeed
			for mobj in mobjs.iterate() do
				if searchingtime(mobj) then
				-- [ Send the Birbs ] --
					sendthemout(mobj)
				end
			end

	-- [ end of BirdsSummoned ] --
	end
		-- [ Assign Birb on a mission] --
		if player.STFMod.bird1target != "none" and not player.STFMod.bird1MissionTime and player.STFMod.bird1target.valid then
			player.STFMod.bird1MissionTime = true
--			DebugPrint("SENDING OUT: FIRST BIRB")
		end
		if player.STFMod.bird2target != "none" and not player.STFMod.bird2MissionTime and player.STFMod.bird2target.valid then
			player.STFMod.bird2MissionTime = true
--			DebugPrint("SENDING OUT: SECOND BIRB")
		end
		if player.STFMod.bird3target != "none" and not player.STFMod.bird3MissionTime and player.STFMod.bird3target.valid then
			player.STFMod.bird3MissionTime = true
--			DebugPrint("SENDING OUT: THIRD BIRD")
		end
		if player.STFMod.bird4target != "none" and not player.STFMod.bird4MissionTime and player.STFMod.bird4target.valid then
			player.STFMod.bird4MissionTime = true
--			DebugPrint("SENDING OUT: FINAL BIRD")
		end
	end

	if not player.powers[pw_super] and player.STFMod.birdsSummoned then --when player is no longer super, but birds are still out
		player.STFMod.birdsSummoned = false
		player.STFMod.bird1 = nil
		player.STFMod.bird2 = nil
		player.STFMod.bird3 = nil
		player.STFMod.bird4 = nil
	end
end)


-- [[ Bird Thinker ]] --
addHook("MobjThinker", function(gaybird) -- figure out how to sync their pulses with the character's pulses
local player = gaybird.tailsdude.player

-- [ Local functions ] --
local function attacc(mission, distance, target, number)
	if mission and distance and target.valid then
		--DebugPrint("I've been summoned, I am: " .. gaybird.number)
		gaybird.idle = false
		if target != "none" then
			gaybird.target = target
		end
		if gaybird.target and gaybird.target.valid and gaybird.target.health > 0 and not (gaybird.target.flags2 & MF2_FRET)
		and distance < 768 then
			A_HomingChase(gaybird, 40*FRACUNIT, 0)
			if (R_PointToDist2(gaybird.target.x, gaybird.target.y, gaybird.x, gaybird.y))/FRACUNIT < 30 and (abs((gaybird.target.z - gaybird.z)/FRACUNIT) < 30) then
				if gaybird.target.health > 1 then
					P_DamageMobj(gaybird.target, gaybird, player.mo, 1)
				else
					P_KillMobj(gaybird.target, gaybird, player.mo, DMG_INSTAKILL)
				end
			end
		else
			target = "none"
			gaybird.target = nil
			distance = nil
			mission = false
			gaybird.returninghome = true
--			DebugPrint("Enemy is gone, or mission has failed! Number: " .. number)
		end
	end
end

local function hovertime(opposition, division)
	gaybird.angle = R_PointToAngle2(gaybird.x, gaybird.y, opposition.x, opposition.y)+45*FRACUNIT
	gaybird.momx = (opposition.x - gaybird.x)/division
	gaybird.momy = (opposition.y - gaybird.y)/division
	gaybird.momz = (opposition.z - gaybird.z)/division
end

local function returning(target, distance, mission)
	target = "none"
	distance = nil
	mission = false
end


if not gaybird.GoAway and player.STFMod.bird1 and player.STFMod.bird2 and player.STFMod.bird3 and player.STFMod.bird4 then
-- [ Colors and States ] --
	if gaybird.timer == nil then
		gaybird.timer = 0 + (gaybird.number*2) --offset the color
	else
		gaybird.timer = $+1
	end
	if gaybird.timer == 1 then
		gaybird.color = SKINCOLOR_SUPERGOLD1
	elseif gaybird.timer == 3 then
		gaybird.color = SKINCOLOR_SUPERGOLD2
	elseif gaybird.timer == 5 then
		gaybird.color = SKINCOLOR_SUPERGOLD3
	elseif gaybird.timer == 7 then
		gaybird.color = SKINCOLOR_SUPERGOLD4
	elseif gaybird.timer == 9 then
		gaybird.color = SKINCOLOR_SUPERGOLD5
	elseif gaybird.timer == 11 then
		gaybird.color = SKINCOLOR_SUPERGOLD4
	elseif gaybird.timer == 13 then
		gaybird.color = SKINCOLOR_SUPERGOLD3
	elseif gaybird.timer == 15 then
		gaybird.color = SKINCOLOR_SUPERGOLD2
	elseif gaybird.timer == 17 then
		gaybird.timer = 0
	end
	if not gaybird.setstate then
		if gaybird.number == 1 then
			gaybird.state = S_TAILSBIRD1
		elseif gaybird.number == 2 then
			gaybird.state = S_TAILSBIRD2
		elseif gaybird.number == 3 then
			gaybird.state = S_TAILSBIRD3
		elseif gaybird.number == 4 then
			gaybird.state = S_TAILSBIRD4
		end
		gaybird.setstate = true
	end

-- [ player flip, bird flip ] --

	if (player.mo.eflags & MFE_VERTICALFLIP) then
		gaybird.flags2 = $1 | MF2_OBJECTFLIP
		else
		gaybird.flags2 = $ & ~MF2_OBJECTFLIP
	end

-- [ get the birbs ready to attack ] --
	if not player.STFMod.birdsReady and abs((player.mo.z-gaybird.z)/FRACUNIT) <91
	and (player.mo.state != S_PLAY_SUPER_TRANS1) and (player.mo.state != S_PLAY_SUPER_TRANS2) and (player.mo.state != S_PLAY_SUPER_TRANS3) and (player.mo.state != S_PLAY_SUPER_TRANS4) and (player.mo.state != S_PLAY_SUPER_TRANS5) and (player.mo.state != S_PLAY_SUPER_TRANS6) then
		player.STFMod.birdsReady = true
	end


-- [[ It begins ]] --

-- [ Hover near player ] --
	if gaybird.idle then--and player.STFMod.bird1target == "none"
		if gaybird.number == 1 and not player.STFMod.bird1MissionTime then
			hovertime(player.STFMod.bird2, 2)
		elseif gaybird.number == 2 and not player.STFMod.bird2MissionTime then
			hovertime(player.STFMod.bird3, 3)
		elseif gaybird.number == 3 and not player.STFMod.bird3MissionTime then
			hovertime(player.STFMod.bird4, 4)
		elseif gaybird.number == 4 and not player.STFMod.bird4MissionTime then
			hovertime(player.STFMod.bird1, 5)
		end
	end

	-- [ Target Enemy ] --

	if not gaybird.returninghome then
		if gaybird.number == 1 then
			attacc(player.STFMod.bird1MissionTime, player.STFMod.target1distance, player.STFMod.bird1target, 1)
		elseif gaybird.number == 2 then
			attacc(player.STFMod.bird2MissionTime, player.STFMod.target2distance, player.STFMod.bird2target, 2)
		elseif gaybird.number == 3 then
			attacc(player.STFMod.bird3MissionTime, player.STFMod.target3distance, player.STFMod.bird3target, 3)
		elseif gaybird.number == 4 then
			attacc(player.STFMod.bird4MissionTime, player.STFMod.target4distance, player.STFMod.bird4target, 4)
		end
	end

	-- [ Return back to player ] --
	if gaybird.returninghome then
		gaybird.idle = false
		gaybird.target = player.STFMod.birdhome
		gaybird.DistanceFromPlayer = R_PointToDist2(gaybird.target.x, gaybird.target.y, gaybird.x, gaybird.y)/FRACUNIT
		gaybird.SpeedPlus = gaybird.DistanceFromPlayer / 70
		if gaybird.SpeedPlus < 10 then
			gaybird.SpeedPlus = 10
		end
		if gaybird.imlost then
			A_HomingChase(gaybird, 10*gaybird.SpeedPlus*FRACUNIT, 0)
		else
			A_HomingChase(gaybird, 6*gaybird.SpeedPlus*FRACUNIT, 0)
		end
		if gaybird.target and (R_PointToDist2(gaybird.target.x, gaybird.target.y, gaybird.x, gaybird.y))/FRACUNIT < 45 then
			gaybird.target = nil
			gaybird.returninghome = false
			gaybird.imlost = false
			if gaybird.number == 1 then -- for some reason, returning function does not work here
				player.STFMod.bird1target = "none"
				player.STFMod.bird1MissionTime = false
				player.STFMod.target1distance = nil
			elseif gaybird.number == 2 then
				player.STFMod.bird2target = "none"
				player.STFMod.bird2MissionTime = false
				player.STFMod.target2distance = nil
			elseif gaybird.number == 3 then
				player.STFMod.bird3target = "none"
				player.STFMod.bird3MissionTime = false
				player.STFMod.target3distance = nil
			elseif gaybird.number == 4 then
				player.STFMod.bird4target = "none"
				player.STFMod.bird4MissionTime = false
				player.STFMod.target4distance = nil
			end
			gaybird.idle = true
--			DebugPrint("back home, number: " +gaybird.number)
		end
	end

-- [ bird is travelling dimensions when they're supposed to be idle ] --
-- this shouldn't be a problem anymore, but this is just for in case it comes up in some Wild situation
	gaybird.idleplayerdistance = R_PointToDist2(player.mo.x, player.mo.y, gaybird.x, gaybird.y)/FRACUNIT
	if gaybird.idleplayerdistance > 1690 and gaybird.idle then
		if gaybird.number == 1 then
			returning(player.STFMod.bird1target, player.STFMod.target1distance, player.STFMod.bird1MissionTime)
		elseif gaybird.number == 2 then
			returning(player.STFMod.bird2target, player.STFMod.target2distance, player.STFMod.bird2MissionTime)
		elseif gaybird.number == 3 then
			returning(player.STFMod.bird3target, player.STFMod.target3distance, player.STFMod.bird3MissionTime)
		elseif gaybird.number == 4 then
			returning(player.STFMod.bird4target, player.STFMod.target4distance, player.STFMod.bird4MissionTime)
		end
		gaybird.returninghome = true
		gaybird.imlost = true
--		DebugPrint("Too far away, forcing self to return! Number is: " .. gaybird.number)
	end


	gaybird.playerceiling = player.mo.ceilingz
end

-- [[ Player is no longer super, disperse. ]] --
	if not player.powers[pw_super] then
		gaybird.TimeToLeave = true
	end
	if gaybird.TimeToLeave then
		gaybird.GoAway = true
		gaybird.color = SKINCOLOR_CORNFLOWER
		if not gaybird.DisperseTimer then
			gaybird.DisperseTimer = 0
			gaybird.momx = 0
			gaybird.momy = 0
			gaybird.momz = 0
		end
		gaybird.DisperseTimer = $ + 1

		if gaybird.number == 1 then
			returning(player.STFMod.bird1target, player.STFMod.target1distance, player.STFMod.bird1MissionTime)
		elseif gaybird.number == 2 then
			returning(player.STFMod.bird2target, player.STFMod.target2distance, player.STFMod.bird2MissionTime)
		elseif gaybird.number == 3 then
			returning(player.STFMod.bird3target, player.STFMod.target3distance, player.STFMod.bird3MissionTime)
		elseif gaybird.number == 4 then
			returning(player.STFMod.bird4target, player.STFMod.target4distance, player.STFMod.bird4MissionTime)
		end

		P_SetObjectMomZ(gaybird, (FRACUNIT/2), true)

		if gaybird.z >= gaybird.playerceiling
		or gaybird.DisperseTimer >= TICRATE*5 then
--			DebugPrint("delet this, " .. gaybird.number)
			P_RemoveMobj(gaybird)
		end
	end
	if player.powers[pw_super] and gaybird.TimeToLeave then
--		DebugPrint("player went super early, removing self now: " .. gaybird.number)
		P_RemoveMobj(gaybird)
	end
end, MT_TLBRD)

addHook("MobjThinker", function(CoryInTheHouse)
local player = CoryInTheHouse.tailsdude.player
	if (player.mo.eflags & MFE_VERTICALFLIP) or (player.mo.flags2 & MF2_OBJECTFLIP) then
		CoryInTheHouse.flags2 = $1 | MF2_OBJECTFLIP
	else
		CoryInTheHouse.flags2 = $ & ~MF2_OBJECTFLIP
	end

	if not player.powers[pw_super] then
		P_RemoveMobj(CoryInTheHouse)
	end
end, MT_TLHME)