--
--	Mystic Realms Community Editions' OS-Time Events
--	Contributed by Ace Lite,
--

local debug = "none"

local CV_forceSeason = CV_RegisterVar{
	name = "mr_seasons",
	defaultvalue = 0,
	flags = CV_NETVAR,
	PossibleValue = {MIN = -1, MAX = 3}
}

local Temp_Key_TX = {}

-- TO-DO: Add textures (either custom or existing) into presented arrays
-- NOTE: Inserted GFZ assets which are commented are incomplete,
-- mainly due to realization that christmas texture set itself being incomplete

-- WINTER (12-3M)
local WINTER_TEXTURES = {

	-- Green Flower Zone


	// GFZ ROCK
	["GFZROCK"] = "XMAS01",
	["GFZCHEKB"] = "XMAS01A",
	["GFZCHEK1"] = "XMAS01A",
	["GFZCHEK2"] = "XMAS01A",
	["GFZWALL"] = "XMASWALL",
	["GFZWALL2"] = "XMASWALL",
	["GFZVINE1"] = "XMAS03",
	["GFZVINE2"] = "XMAS03",
	["GFZVINE3"] = "XMAS04",
	["GFZROCKB"] = "XMASROCKB",
	["GFZCRACK"] = "XMASCRACK",
	["GFZCRAC1"] = "XMASCRACX",
	["GFZCRAC2"] = "XMASCRACX",
	["GFZINSID"] = "XMAS24",
	["GFZFLR08"] = "XMSFLR04",

	// GFZ GRASS
	["GFZGRASS"] = "SNOWALL",
	["GFZFLR02"] = "XMSFLR02",
	["GFZFLR10"] = "XMSFLR02",
	["GFZFLR21"] = "XMSFLR02",
	["GFZFLR22"] = "XMSFLR02",

	// GFZ MISC
	["GFZBLOCK"] = "XMAS19",
	["GFZFLR09"] = "XMAS19",
	["GFZBRIDG"] = "XMAS23",
	["GFZFLR05"] = "XMSFLR05",
	["GFZFLR06"] = "XMSFLR06",
}
local WINTER_THINGS = {

	-- Green Flower Zone


	[MT_BUSH] = MT_XMASBUSH,
	[MT_BERRYBUSH] = MT_XMASBERRYBUSH,
	[MT_BLUEBERRYBUSH] = MT_XMASBLUEBERRYBUSH,
	[MT_GFZBERRYTREE] = MT_MFZTREE,
	[MT_GFZFLOWER3] = MT_FHZICE1,
	[MT_GFZFLOWER2] = MT_LAMPPOST2,
	[MT_GFZFLOWER1] = MT_XMASPOLE,
	[MT_GFZTREE] = MT_FHZTREE,

}
local WINTER_MUSIC = {

	-- Green Flower Zone

	["GFZ1"] = "CCZ"

}
local WINTER_SKY = {

	-- Green Flower Zone

	[1] = 17


}
local WINTER_SKYBOX = {

	-- Green Flower Zone

	["Greenflower"] = {remove_skybox = true},


}

-- XMAS (24.12)
local XMAS_TEXTURES = WINTER_TEXTURES
local XMAS_THINGS = WINTER_THINGS

-- HALLOWEEN (31.10)
local HALLOWEEN_TEXTURES = {

	-- Green Flower Zone


	// GFZ ROCK
	["GFZROCK"] = "WFZROCK",
	["GFZCHEKB"] = "WFZCHEKB",
	["GFZCHEK1"] = "WFZCHEK1",
	["GFZCHEK2"] = "WFZCHEK2",
	["GFZWALL"] = "WFZWALL",
	["GFZWALL2"] = "WFZWALL2",
	["GFZVINE1"] = "WFZVINE1",
	["GFZVINE2"] = "WFZVINE2",
	["GFZVINE3"] = "WFZVINE3",
	["GFZROCKB"] = "WFZROCKB",
	["GFZCRACK"] = "WFZCRACK",
	["GFZCRAC1"] = "WFZCRAC1",
	["GFZCRAC2"] = "WFZCRAC2",
	["GFZINSID"] = "WFZINSID",
	["GFZFLR01"] = "WFZFLR01",
	["GFZFLR03"] = "WFZFLR03",
	["GFZFLR04"] = "WFZFLR04",
	["GFZFLR07"] = "WFZFLR07",
	["GFZFLR08"] = "WFZFLR08",
	["GFZFLR11"] = "WFZFLR11",
	["GFZFLR12"] = "WFZFLR12",
	["GFZFLR13"] = "WFZFLR13",
	["GFZFLR14"] = "WFZFLR14",
	["GFZFLR15"] = "WFZFLR15",
	["GFZFLR16"] = "WFZFLR16",
	["GFZFLR17"] = "WFZFLR17",
	["GFZFLR18"] = "WFZFLR18",
	["GFZFLR19"] = "WFZFLR19",
	["GFZFLR20"] = "WFZFLR20",

	// GFZ GRASS
	["GFZGRASS"] = "WFZGRASS",
	["GFZFLR02"] = "WFZFLR02",
	["GFZFLR10"] = "WFZFLR10",
	["GFZFLR21"] = "WFZFLR21",
	["GFZFLR22"] = "WFZFLR10",

	// GFZ MISC
	["GFZBLOCK"] = "WFZBLOCK",
	["GFZFLR09"] = "WFZFLR09",
	["GFZBRIDG"] = "WFZBRIDG",
	["GFZBRID2"] = "WFZBRID2",
	["GFZFLR05"] = "WFZFLR05",
	["GFZFLR06"] = "WFZFLR06",
	["GFZFENC2"] = "WFZFENC2",
	["GFZFENCW"] = "WFZFENCW",
	["GFZBLOKS"] = "WFZBLOKS",
	["GFZGRSW"] = "WFZGRSW",
	["GFZROOF"] = "WFZROOF",
	["GFZTILA1"] = "WFZTILA1",
	["GFZTILA2"] = "WFZTILA2",
	["GFZTILB1"] = "WFZTILB1",
	["GFZTILB2"] = "WFZTILB2",
	["GFZTILC1"] = "WFZTILC1",
	["GFZTILC2"] = "WFZTILC2",
	["GFZTILD1"] = "WFZTILD1",
	["GFZTILD2"] = "WFZTILD2",
	["GFZTILE1"] = "WFZTILE1",
	["GFZTILE2"] = "WFZTILE2",
	["GFZTILF1"] = "WFZTILF1",
	["GFZTILF2"] = "WFZTILF2",
	["GFZTILG1"] = "WFZTILG1",
	["GFZTILG2"] = "WFZTILG2",
	["GFZTIL01"] = "WFZTIL01",
	["GFZTIL02"] = "WFZTIL02",
	["GFZTIL03"] = "WFZTIL03",
	["GFZTIL04"] = "WFZTIL04",
	["GFZTIL05"] = "WFZTIL05",
	["GFZTIL06"] = "WFZTIL06",
	["GFZTIL07"] = "WFZTIL07",
	["GFZTIL08"] = "WFZTIL08",
	["GFZTIL09"] = "WFZTIL09",
	["GFZTIL10"] = "WFZTIL10",
	["GFZTIL11"] = "WFZTIL11",
	["GFZWAVE"] = "WFZWAVE",
	["GFZRAIL"] = "WFZRAIL",
	["GFZRAIL2"] = "WFZRAIL2",
	["GFVINESO"] = "WFVINESO",
	["GFVINES"] = "WFVINES",
	["GFZFNCC"] = "WFZFNCC",
	["GFZFNCCG"] = "WFZFNCCG",
	["GFZFNCB"] = "WFZFNCB",
	["GFSM1"] = "WFZSM1",
	["GFSM2"] = "WFZSM2",
	["GFSM3"] = "WFZSM3",
	["GFSM4"] = "WFZSM4",

}
local HALLOWEEN_THINGS = {}
local HALLOWEEN_MUSIC = {}
local HALLOWEEN_SKY = {}
local HALLOWEEN_SKYBOX = {}


-- Description: This function will swap every texture on linedef and sector. It also swaps all mobjs per provided texture, mobj tables.
-- WARNING: Use this function once!!! Preferably at mapload.
local function P_SwapPerDatasets(texture_dataset, mobj_dataset, sky_dataset, skybox_dataset)
	if texture_dataset then
		for sector in sectors.iterate do
			if texture_dataset[sector.floorpic] ~= nil then
				sector.floorpic = texture_dataset[sector.floorpic]
			end
			if texture_dataset[sector.ceilingpic] ~= nil then
				sector.ceilingpic = texture_dataset[sector.ceilingpic]
			end
		end

		--print("sector textures swapped")

		Temp_Key_TX = {}
		for k,v in pairs(texture_dataset) do
			Temp_Key_TX[R_TextureNumForName(k)] = R_TextureNumForName(v)
		end

		for side in sides.iterate do
			if Temp_Key_TX[side.toptexture] then
				side.toptexture = Temp_Key_TX[side.toptexture]
			end

			if Temp_Key_TX[side.midtexture] then
				side.midtexture = Temp_Key_TX[side.midtexture]
			end

			if Temp_Key_TX[side.bottomtexture] then
				side.bottomtexture = Temp_Key_TX[side.bottomtexture]
			end
		end

		--print("wall textures swapped")
	end


	if mobj_dataset then
		for m in mapthings.iterate do
			if m.mobj and m.mobj.valid and mobj_dataset[m.mobj.type] then
				P_SpawnMobjFromMobj(m.mobj, 0, 0, 0, mobj_dataset[m.mobj.type])
				P_RemoveMobj(m.mobj)
			end
		end

		--print("mobjs swapped")
	end

	if sky_dataset and sky_dataset[globallevelskynum] then
		P_SetupLevelSky(sky_dataset[globallevelskynum])
		--print("sky texture swapped")
	end

	if skybox_dataset and skybox_dataset[mapheaderinfo[gamemap].lvlttl] then
		if skybox_dataset[mapheaderinfo[gamemap].lvlttl].mobj and not skybox_dataset[mapheaderinfo[gamemap].lvlttl].remove_skybox then
			P_SetSkyboxMobj(skybox_dataset[mapheaderinfo[gamemap].lvlttl].mobj, skybox_dataset[mapheaderinfo[gamemap].lvlttl].centerpoint or false)
		else
			P_SetSkyboxMobj(nil, nil)
		end
		--print("sky texture swapped")
	end
end

-- Comment: Yes, calculating Easter... WHAT THE !@#^?! -- though this is Orthodox Easter not Catholic Easter...
-- Credit> Thank you someone with nickname Alexandru-Condrin Paranite - https://stackoverflow.com/questions/2192533/function-to-return-date-of-easter-for-the-given-year
local function M_DeterminateEaster(day, mouth, year)
	local a = year % 19
	local b = year / 7
	local c = year % 4
	local d = (19 * a + 16) % 30
	local e = (2 * c + 4 * b + 6 * d) % 7
	local f = d
	local key = f + e + 3
	local easter_mouth, easter_day
	if key > 30 then
		mouth = 5
		day = key-30
	else
		mouth = 4
		day = key
	end

	if easter_mouth == mouth and easter_day == day then
		return true
	else
		return false
	end
end

-- Handler hooked function
addHook("MapLoad", function(map)
	local current_date = os.date('*t')

	--print(mapheaderinfo[gamemap].lvlttl)
	
	if CV_forceSeason.value == -1 then return end

	-- Winter
	if (current_date.month == 12 or current_date.month < 3) or (debug == "winter" or debug == "xmas") or CV_forceSeason.value == 3 then
		-- Christmas check otherwise pure winter
		if (current_date.month == 12 and current_date.day == 24) or debug == "xmas" then
			P_SwapPerDatasets(XMAS_TEXTURES, XMAS_THINGS, WINTER_SKY, WINTER_SKYBOX)
		else
			P_SwapPerDatasets(WINTER_TEXTURES, WINTER_THINGS, WINTER_SKY, WINTER_SKYBOX)
		end
	-- Halloween
	elseif (current_date.month == 10 and current_date.day == 31) or debug == "spook" or CV_forceSeason.value == 2 then
		P_SwapPerDatasets(HALLOWEEN_TEXTURES, HALLOWEEN_THINGS, HALLOWEEN_SKY, HALLOWEEN_SKYBOX)
	-- April Fools
	--elseif current_date.month == 4 and current_date.day == 1 then
		--P_SwapPerDatasets(XMAS_TEXTURES, XMAS_THINGS, HALLOWEEN_SKY)
	-- Orthodox Easter
	--elseif current_date.month > 2 and current_date.month < 5 and M_DeterminateEaster(current_date.day, current_date.mouth, current_date.year) then
		--P_SwapPerDatasets(XMAS_TEXTURES, XMAS_THINGS, HALLOWEEN_SKY)
	end
end)

-- Use for debug, if desired
/*
hud.add(function(v, p, c)
	local timey = os.date('*t')
	v.drawString(320, 40, "CURRENT DATE", V_YELLOWMAP, "right")
	v.drawString(320, 48, string.format("%02d:%02d:%02d", timey.hour, timey.min, timey.sec), 0, "right")
	v.drawString(320, 56, string.format("%02d/%02d/%04d", timey.day, timey.month, timey.year), 0, "right")

	v.drawString(320, 72, "winter: "+(timey.month == 12), V_YELLOWMAP, "right")
	v.drawString(320, 80, "xmas: "+(timey.month == 12 and timey.day == 24), V_YELLOWMAP, "right")
end, "game")
*/

addHook("MusicChange", function(om, nm)
	if (gamestate != GS_LEVEL) then return end
	local current_date = os.date('*t')
	if (current_date.month == 12 or current_date.month < 3) or (debug == "winter" or debug == "xmas") or CV_forceSeason.value == 3 then
		for m, n in pairs(WINTER_MUSIC) do
			if nm == m then
				if om == n then
					return true
				else
					return n, 0, true, 0
				end
			end
		end
	end
	if (current_date.month == 10 and current_date.day > 23) or (debug == "halloween") or CV_forceSeason.value == 2 then
		for m, n in pairs(HALLOWEEN_MUSIC) do
			if nm == m then
				if om == n then
					return true
				else
					return n, 0, true, 0
				end
			end
		end
	end
end)