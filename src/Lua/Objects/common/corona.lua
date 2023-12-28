local debug = false
local function debugPrint(string)
	if debug then
		print(string)
	end
end

freeslot("MT_CORONA", "MT_CORONALAMP")

-- Fake mobj that uses mapthing properties to create a real corona,
-- set its properties based on the mapthing, then self-destructs
mobjinfo[MT_CORONA] = {
	--$Category Mystic Realm Objects
	--$Name Corona (Customizable)
	--$Sprite OILFA0
	--$AngleText Angle/Tag
	doomednum = 972,
	radius = 16*FRACUNIT,
	height = 16*FRACUNIT,
	spawnstate = S_NULL,
	flags = MF_NOTHINK
}

mobjinfo[MT_CORONALAMP] = {
	doomednum = 973,
	spawnstate = S_OILLAMP,
	spawnhealth = 1,
	seestate = S_NULL,
	seesound = sfx_None,
	reactiontime = 0,
	attacksound = sfx_None,
	painstate = S_NULL,
	painchance = 0,
	painsound = sfx_None,
	meleestate = S_NULL,
	missilestate = S_NULL,
	deathstate = S_NULL,
	xdeathstate = S_NULL,
	deathsound = sfx_None,
	speed = 0,
	radius = 22*FRACUNIT,
	height = 64*FRACUNIT,
	dispoffset = 0,
	mass = 0,
	damage = 0,
	activesound = sfx_s3k4b,
	flags = MF_SCENERY|MF_NOBLOCKMAP|MF_NOGRAVITY|MF_SPAWNCEILING,
	raisestate = S_NULL
}

local function P_MakeCoronaMobj(target, x, y, z, scale, strength, skincolor)
	local motype = MT_PARTICLE
	if type(target) == "userdata" and target.valid then
		motype = MT_OVERLAY
	end
	local corona = P_SpawnMobj(x, y, z, motype)
	corona.scale = scale
	corona.sprite = SPR_OILF
	corona.frame = (FF_FULLBRIGHT|strength)
	if skincolor > 0 then
		corona.colorized = true
		corona.color = skincolor
	else
		corona.renderflags = $1|RF_NOCOLORMAPS
	end
	corona.tics = -1
	if motype == MT_OVERLAY then
		corona.target = target
	end
	return corona
end
-- This has gotten too complex to be generalized imo
--rawset(_G, "P_MakeCoronaMobj", P_MakeCoronaMobj)

-- this could be better organized, i'll do it
-- after my head stops hurting
local function HandleCoronaMThing(mo, mt, isoverlay)
	local skincolor = 0
	local strength = FF_TRANS90
	local scale = FRACUNIT
	local modifier = (mt.options & MTF_OBJECTSPECIAL)
	and (mt.options & MTF_AMBUSH)

	if mt.extrainfo > 0 then
		strength = $ - FF_TRANS10*min(mt.extrainfo, 8)
		debugPrint("stronk multiplier: "..min(mt.extrainfo, 8))
	end
	if (mt.options & MTF_EXTRA) then
		if modifier then
			-- this stupid-ass thing is a truncate function
			-- srb2 drops all decimals, so we can use this to
			-- drop an arbitrary number of digits, then subtract
			-- the original value by the result * digits dropped
			-- in this case, we take the bottom two digits
			-- to use them as skincolors

			local bottom = mt.angle-((mt.angle/100)*100)
			debugPrint("bottom: ".. bottom)

			skincolor = bottom
		else
			skincolor = mt.angle
		end
		debugPrint("skincolor: "..mt.angle)
	end
	if modifier then
		debugPrint("custom scale")
		if (mt.options & MTF_EXTRA) then
			-- return of decimal horseshit
			local top = mt.angle/100
			debugPrint("top: ".. top)

			scale = ((FRACUNIT*100)*(top*2))/10000
		else
			scale = ((FRACUNIT*100)*(mt.angle*2))/10000
		end
	else
		if (mt.options & MTF_OBJECTSPECIAL) then
			debugPrint(".5 scale")
			scale = FRACUNIT/2
		elseif (mt.options & MTF_AMBUSH) then
			debugPrint("2.0 scale")
			scale = FRACUNIT*2
		end
	end
	debugPrint("scale: "..scale.."FU")

	debugPrint("spawning at "..FixedInt(mo.x)..", "..FixedInt(mo.y)..", "..FixedInt(mo.z))
	local target = nil
	if isoverlay then
		target = mo
	end
	P_MakeCoronaMobj(target, mo.x, mo.y, mo.z, scale, strength, skincolor)
end


addHook("MapThingSpawn", function(mo, mt)
	HandleCoronaMThing(mo, mt, false)
end, MT_CORONA)
addHook("MapThingSpawn", function(mo, mt)
	HandleCoronaMThing(mo, mt, true)
end, MT_CORONALAMP)

-- Debug

/*
rawset(_G, "cv_corona_size", CV_RegisterVar({
	name = "corona_size",
	defaultvalue = "1.0",
	PossibleValue = {MIN = 0, MAX = INT32_MAX},
	flags = CV_FLOAT
}))

rawset(_G, "cv_corona_strength", CV_RegisterVar({
	name = "corona_strength",
	defaultvalue = "FF_TRANS90"
}))

rawset(_G, "cv_corona_skincolor", CV_RegisterVar({
	name = "corona_skincolor",
	defaultvalue = 0,
	PossibleValue = {MIN = 0, MAX = INT32_MAX}
}))

rawset(_G, "cv_corona_offset", CV_RegisterVar({
	name = "corona_offset",
	defaultvalue = "32.0",
	PossibleValue = CV_Unsigned,
	flags = CV_FLOAT
}))

rawset(_G, "cv_corona_target_player", CV_RegisterVar({
	name = "corona_target_player",
	defaultvalue = "0",
	PossibleValue = CV_OnOff
}))


COM_AddCommand("corona-make", function(p, arg)
	local target = nil
	if cv_corona_target_player.value then
		target = p.realmo
	end
	P_MakeCoronaMobj(target, p.realmo.x, p.realmo.y, p.realmo.z+cv_corona_offset.value, cv_corona_size.value, _G[cv_corona_strength.string], cv_corona_skincolor.value)
end, COM_LOCAL)
*/
