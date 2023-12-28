--
--	Mystic Realms Community Editions' Northen Lights
--	Contributed by Ace Lite, Changes made by Nami and Xian
--

-- note: it no longer is similar in anyway to C-code of CEZ Flags,
-- 		 it is possible there are more comments that are outdated to code.

-- Set custom number of segments...
-- In case of changing dimensions of sprites, refer to changing mobj radius as well.
local SEGMENTS = 39

-- Freeslots
local stop = 0

if stop then return end

freeslot("MT_AURORABOREALIS", "MT_AURORASEG", "S_AURORASEG", "SPR_11AB")

-- Cvars (Please organize things, don't make me do it)

local CV_auroraDeletus = CV_RegisterVar{
	name = "mr_mfz1boost",
	defaultvalue = 0,
	flags = CV_NETVAR,
	PossibleValue = CV_OnOff
}

-- Mobjinfo

// controller of Aurora mobjinfo
// mapthing num - doomednum (921)

mobjinfo[MT_AURORABOREALIS] = {
	//$Name "Aurora Borealis Skybox Deco"
	//$Sprite 11ABA0
	//$Category "Mystic Realm - Midnight Freeze Zone"
	doomednum = 921,
	spawnstate = S_INVISIBLE,
	spawnhealth = 1000,
	reactiontime = 8,
	deathsound = sfx_pop,
	radius = 48*FRACUNIT,
	height = 128*FRACUNIT,
	mass = 100,
	flags = MF_NOCLIP|MF_NOCLIPTHING|MF_NOBLOCKMAP|MF_SCENERY|MF_NOGRAVITY|MF_NOCLIPHEIGHT
}

// invidiual segment mobjinfo
mobjinfo[MT_AURORASEG] = {
	spawnstate = S_AURORASEG,
	spawnhealth = 1000,
	reactiontime = 8,
	deathsound = sfx_pop,
	radius = 48*FRACUNIT,
	height = 128*FRACUNIT,
	mass = 100,
	flags = MF_NOCLIP|MF_NOCLIPTHING|MF_NOBLOCKMAP|MF_NOGRAVITY|MF_NOCLIPHEIGHT|MF_NOTHINK
}

-- States

// 40% less sugar in your borealis.
states[S_AURORASEG] = {
	sprite = SPR_11AB,
	frame = A|FF_PAPERSPRITE|FF_ADD|FF_TRANS40|FF_SEMIBRIGHT|FF_ANIMATE,
	var1 = 13,
	var2 = 3,
}

-- Functions

// Spawn function; makes 39 segments of Aurora;
local function auroraSpawn(a)
	if CV_auroraDeletus.value then return end

	-- container of all segments.
	a.segs = {}

	-- set up
	local scaley = 0
	local angx = 0
	local angy = 0

	-- Why was check there? I moved at very frist line of block.

	-- pre-calculation -- you don't want to make loading screens *longer* by calculating same thing.
	local SegCalStart = SEGMENTS/3
	local SegCalEnd = (SEGMENTS*2)/3

	local thrFRAC = FRACUNIT/SegCalStart
	local sixFRAC = FRACUNIT/16

	-- you can change amount of segments but don't forget to change scaling as well at the end.
	for i = 0,SEGMENTS do
		local seg = P_SpawnMobjFromMobj(a, 0,0,0, MT_AURORASEG)
		seg.tracer = (i > 0 and a.segs[i-1] or a)

		// edit the scale for specific skybox purposes.
		seg.scale = a.scale

		// segmenter
		seg.cusval = angy
		seg.extravalue1 = sin(angy)
		seg.extravalue2 = FixedAngle(22*seg.extravalue1)+angx
		seg.angle = a.angle+seg.extravalue2
		angx = $+ANG2
		angy = $+ANG15

		// Segments on each end are scaled to be smaller. Yes, I could do it more simplier but
		// ease functions are simply giving me ease
		if i % 2 then
			seg.spriteyscale = FRACUNIT+FRACUNIT/4
		end

		if i < SegCalStart then
			seg.spriteyscale = ease.outquint(i*thrFRAC, sixFRAC, FRACUNIT)
		end

		if i > SegCalEnd then
			seg.spriteyscale = ease.inquint((i-SegCalEnd)*thrFRAC, FRACUNIT, sixFRAC)
		end

		// insert into custom table in mobj userdata.
		table.insert(a.segs, seg)
	end
end

local function P_CalcEdgeCoordinates(a)
	local x = a.x + FixedMul(a.radius, cos(a.angle))
	local y = a.y + FixedMul(a.radius, sin(a.angle))
	return x, y
end

local function P_ConnectEdges(a, t)
	local radius = t.radius
	local x, y = P_CalcEdgeCoordinates(a)
	P_SetOrigin(t, x+FixedMul(radius, cos(t.angle)), y+FixedMul(radius, sin(t.angle)), a.z)
end

local AuroraColors = {
	SKINCOLOR_AQUA,
	SKINCOLOR_TEAL,
	SKINCOLOR_SKY,
	SKINCOLOR_SAPPHIRE,
	SKINCOLOR_RED,
	SKINCOLOR_FLAME,
	SKINCOLOR_PURPLE,
	SKINCOLOR_EMERALD,
	SKINCOLOR_APPLE,
}

// Offing constant calculation -- for crying out loud!
local movemv = FRACUNIT/700
local angmax = ANG1*16
local angmin = -angmax
local angcal = ANG2/6

// Thinker function; moves 97 segments of Aurora;
local function auroraThinker(a)
	local segs = a.segs
	local leveltimedif = abs((leveltime % 1500)-699)*movemv
	local easedif = ease.inoutsine(leveltimedif, angmin, angmax)
	local leveltimex = leveltime*angcal

	// Connect Edges
	for id,seg in ipairs(segs) do
		seg.extravalue1 = sin(seg.cusval+leveltimex)
		seg.angle = seg.extravalue2+FixedMul(easedif, seg.extravalue1)
		P_ConnectEdges(seg.tracer, seg)
	end

	// Switch the frame
	// If I were making it for my own project I would use MapThingSpawn hook to spawn segments in
	// Too bad I have to do this crime against humanity.
	if a.extravalue1 ~= 0 then return end
	a.extravalue1 = 1

	// just decrease in checking if Aurora was spawned by different means.
	if not a.spawnpoint then return end

	local framenum = AuroraColors[min(max(a.spawnpoint.extrainfo or a.spawnpoint.args[0], 0), #AuroraColors-1)+1]

	for id,seg in ipairs(segs) do
		seg.color = framenum
	end
end

-- Hooks

addHook("MobjSpawn", auroraSpawn, MT_AURORABOREALIS)
addHook("MobjThinker", auroraThinker, MT_AURORABOREALIS)

--
-- Do I have to comment everything?
--

