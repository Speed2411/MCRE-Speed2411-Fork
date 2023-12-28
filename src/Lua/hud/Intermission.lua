/*
	MRCE Custom Intermission

	STJr (Bonus calc functions)
	AshiFolfi (C -> Lua and much of the rest)
	Xian (everything else)
*/
if MR_continueready == nil then
	rawset(_G, "MR_continueready", false)
end

-- Variables we use during the intermission formatted into a table

rawset(_G, "bonus_t",---@class bonus_t
{
	tpoints = 0, -- time
	rpoints = 0, -- rings
	gpoints = 0, -- guard

	nummaprings = 0,
	perfectbonus = 0,

	prevscore = 0,
	newadd = 0,
	intcomplete = false,

	animticker = 0,
	display = false,
	btick = 0
})

local anim_percent
local anim_capped
local anim_ticker = 0

-- Function used to calculate the total number of rings in a map
---@diagnostic disable-next-line: undefined-doc-param
---@param mobj mobj_t
-- local function Y_CalcTotalRings(mobj)
-- Put inside of a MobjSpawn so that any rings added mid game are accounted for
addHook("MobjSpawn", function() bonus_t.nummaprings = $ + 1 end, MT_RING)
addHook("MobjSpawn", function() bonus_t.nummaprings = $ + 1 end, MT_COIN)
addHook("MobjSpawn", function() bonus_t.nummaprings = $ + 1 end, MT_NIGHTSSTAR)
addHook("MobjSpawn", function() bonus_t.nummaprings = $ + 10 end, MT_NIGHTSSTAR)
addHook("MobjSpawn", function() bonus_t.perfectbonus = -1 end, MT_NIGHTSDRONE)

-- Intermission bonus calc functions

rawset(_G, "Y_SetTimeBonus",
-- Used to calculate the time bonus. C -> Lua Conversion
---@param player player_t
---@param bstruct table
function(player, bstruct)
	local secs, bonus

	-- calculate time bonus
	local secs = player.realtime / TICRATE
	if      (secs <  30) then /*   :30 */ bonus = 50000
	elseif (secs <  60) then /*  1:00 */ bonus = 10000
	elseif (secs <  90) then /*  1:30 */ bonus = 5000
	elseif (secs < 120) then /*  2:00 */ bonus = 4000
	elseif (secs < 180) then /*  3:00 */ bonus = 3000
	elseif (secs < 240) then /*  4:00 */ bonus = 2000
	elseif (secs < 300) then /*  5:00 */ bonus = 1000
	elseif (secs < 360) then /*  6:00 */ bonus = 500
	elseif (secs < 420) then /*  7:00 */ bonus = 400
	elseif (secs < 480) then /*  8:00 */ bonus = 300
	elseif (secs < 540) then /*  9:00 */ bonus = 200
	elseif (secs < 600) then /* 10:00 */ bonus = 100
	else  /* TIME TAKEN: TOO LONG */ bonus = 0 end

	bstruct.tpoints = bonus
end)


rawset(_G, "Y_SetRingBonus",
-- Calculates the ring bonus. C -> Lua Conversion
---@param player player_t
---@param bstruct table
function (player, bstruct)
	bstruct.rpoints = max(0, (player.rings) * 100);
end)

rawset(_G, "Y_SetPerfectBonus",
-- Calculates the perfect bonus and displays it if grabbed
---@param player player_t
---@param bstruct bonus_t
function(player, bstruct)
	-- If the number of rings in a map is 0 there will be no perfect bonus
	if bstruct.nummaprings == 0 then return end
	-- If perfectbonus is set to -1 (map should not have perfect bonus)
	-- Do not run the perfect bonus
	if bstruct.perfectbonus == -1 then return end

	if (player.rings >= bstruct.nummaprings) then
		bstruct.perfectbonus = 50000 -- It's always 50000. No more. No less.
	end
end)

rawset(_G, "Y_SetGuardBonus",
-- Calculates the guard bonus for boss stages
---@param player player_t
---@param bstruct bonus_t
function(player, bstruct)
	local bonus = 0
	-- We don't have access to stagefailed. Shouldn't be that important right?
		if     (player.timeshit == 0) then bonus = 10000
		elseif (player.timeshit == 1) then bonus = 5000
		elseif (player.timeshit == 2) then bonus = 1000
		elseif (player.timeshit == 3) then bonus = 500
		elseif (player.timeshit == 4) then bonus = 100
		else                            bonus = 0
		end

	bstruct.gpoints = bonus;
end)

-- Actual intermission work

-- Here is the full table of what level types determine what bonuses
rawset(_G, "bfunc_t", {
	[-1] = function() -- None
---@diagnostic disable-next-line: redundant-return
		return
	end,
	[0] = function(player) -- Normal
		Y_SetTimeBonus(player, bonus_t)
		Y_SetRingBonus(player, bonus_t)
		Y_SetPerfectBonus(player, bonus_t)
	end,
	[1] = function(player) -- Boss
		Y_SetGuardBonus(player, bonus_t)
		Y_SetRingBonus(player, bonus_t)
	end,
	[2] = function(player) -- ERZ3
		Y_SetGuardBonus(player, bonus_t)
		Y_SetRingBonus(player, bonus_t)
	end,
})

-- Stop the timer and disable player collisions then calculate our bonuses.
---@param player player_t
local function hud_intermission_backend(player)
	-- use the stock intermission if we aren't using the MRCE HUD
	if player.mrce and player.mrce.hud != 1 then return end
	-- Broken stages (linedef based tally skip/custom exit) shouldn't use this
	if IntToExtMapNum(gamemap) == "MAPAL" or IntToExtMapNum(gamemap) == "MAPAV"
	or IntToExtMapNum(gamemap) == "MAPAU" or IntToExtMapNum(gamemap) == "MAPAX"
	or IntToExtMapNum(gamemap) == "MAP25" or IntToExtMapNum(gamemap) == "MAP26"
	or IntToExtMapNum(gamemap) == "MAP27" or IntToExtMapNum(gamemap) == "MAPD0"
	or IntToExtMapNum(gamemap) == "MAPQ0"// or IntToExtMapNum(gamemap) == "MAPD0"
	or IntToExtMapNum(gamemap) == "MAPAM" then return end
	-- NEVER EVER RUN UNDER NETGAMES (see intermission_net.lua for the stripped down netgame variant)
	if multiplayer or netgame or modeattacking or G_IsSpecialStage(gamemap) then return end
	if not (player.exiting) then return end
	-- Perform calculations based on bonustype
	bfunc_t[mapheaderinfo[gamemap].bonustype](player)
	local givescore = 0
	if marathonmode & MA_NOCUTSCENES then
		if shrine_active == true
		and mapheaderinfo[gamemap].shrine != nil then --sometimes shrines seem to randomly not work due to this script overwriting the custom exit for some reason. only solution is to make sure to set it properly here
			local shrinedata = GetNumberList(mapheaderinfo[gamemap].shrine)
			G_SetCustomExitVars(shrinedata[2], 1)
		else
			G_SetCustomExitVars(0, 1)
		end
		givescore = bonus_t.rpoints + bonus_t.tpoints + bonus_t.gpoints
		P_AddPlayerScore(player, givescore)
		givescore = 0
		if MR_continueready and player.continues < 99 then
			player.continues = $ + 1
			MR_continueready = false
		end
		G_ExitLevel()
		return
	end
	-- of course don't run if we aren't exiting
	if (player.exiting > 25) then return end
	if player.exiting > 20 then
		bonus_t.btick = 50
		if S_MusicName != "_CLEAR" then
			S_ChangeMusic("_CLEAR", false, p, 0, 0, MUSICRATE)
		end
	end

	if (bonus_t.intcomplete == false) then
		if marathonmode then
			bonus_t.skiptick = true
		end

		bonus_t.display = true

		-- don't exit the level until we want to
		player.exiting = 5

		bonus_t.newadd = bonus_t.rpoints + bonus_t.tpoints + bonus_t.gpoints

		if bonus_t.btick > 0 then
			bonus_t.btick = $ - 1
			bonus_t.ttick = bonus_t.tpoints
			bonus_t.rtick = bonus_t.rpoints
			bonus_t.gtick = bonus_t.gpoints
		elseif bonus_t.btick == 0 then
			if bonus_t.ttick > 100 then
				bonus_t.ttick = $ - 100
				P_AddPlayerScore(player, 100)
				bonus_t.fakescore = $ + 100
			elseif bonus_t.ttick > 0 then
				bonus_t.ttick = $ - 10
				P_AddPlayerScore(player, 10)
				bonus_t.fakescore = $ + 10
			elseif bonus_t.ttick < 0 then
				bonus_t.ttick = 0
			end
			if bonus_t.rtick > 100 then
				bonus_t.rtick = $ - 100
				P_AddPlayerScore(player, 100)
				bonus_t.fakescore = $ + 100
			elseif bonus_t.rtick > 0 then
				bonus_t.rtick = $ - 10
				P_AddPlayerScore(player, 10)
				bonus_t.fakescore = $ + 10
			elseif bonus_t.rtick < 0 then
				bonus_t.rtick = 0
			end
			if bonus_t.gtick > 100 then
				bonus_t.gtick = $ - 100
				P_AddPlayerScore(player, 100)
				bonus_t.fakescore = $ + 100
			elseif bonus_t.gtick > 0 then
				bonus_t.gtick = $ - 10
				P_AddPlayerScore(player, 10)
				bonus_t.fakescore = $ + 10
			elseif bonus_t.gtick < 0 then
				bonus_t.gtick = 0
			end
			S_StartSound(nil, sfx_menu1, p)
			if bonus_t.skiptick == true then
				P_AddPlayerScore(player, bonus_t.gtick)
				P_AddPlayerScore(player, bonus_t.ttick)
				P_AddPlayerScore(player, bonus_t.rtick)
				bonus_t.fakescore = $ + bonus_t.gtick + bonus_t.ttick + bonus_t.rtick
				bonus_t.gtick = 0; bonus_t.ttick = 0; bonus_t.rtick = 0
			end
			if bonus_t.ttick == 0 and bonus_t.rtick == 0 and bonus_t.gtick == 0 then
				bonus_t.intcomplete = true
				bonus_t.btick = 100
				S_StartSound(nil, sfx_chchng, p)
			end
		end
		anim_ticker = $ + 1
	else
		if bonus_t.btick == 80 and MR_continueready and player.continues < 99 and bonus_t.intcomplete == true then
			player.continues = $ + 1
			S_StartSound(nil, sfx_s23f)
			MR_continueready = false
		end
		if bonus_t.btick > 0 then
			bonus_t.btick = $ - 1
			player.exiting = 5
			return
		end


		if shrine_active == true
		and mapheaderinfo[gamemap].shrine != nil then --sometimes shrines seem to randomly not work due to this script overwriting the custom exit for some reason. only solution is to make sure to set it properly here
			local shrinedata = GetNumberList(mapheaderinfo[gamemap].shrine)
			G_SetCustomExitVars(shrinedata[2], 1)
		else
			G_SetCustomExitVars(0, 1)
		end
		G_ExitLevel()
		-- reset bonuses so we don't accidentally award twice
		bonus_t.tpoints = 0
		bonus_t.rpoints = 0
		bonus_t.gpoints = 0
	end
end
addHook("PlayerThink", hud_intermission_backend)

addHook("PlayerSpawn", function(player)
	bonus_t.display = false
	bonus_t.intcomplete = false
	bonus_t.skiptick = false
	bonus_t.fakescore = 0
	anim_ticker = 0
end)

local function hud_intermission(v, p)
	local string = ""
	if not(bonus_t.display) then return end
	-- NEVER EVER RUN UNDER NETGAMES (see intermission_net.lua for the stripped down netgame variant)
	if multiplayer or netgame then return end

	local string = {
		[1] = skins[p.mo.skin].realname.." got",
		[2] = "Through act",
		[3] = "Through the act"
	}

	anim_capped = max(min(anim_ticker, TICRATE), 0)
	anim_percent = FU / TICRATE * anim_capped

	local x_locs = {}

	x_locs[1] = ease.outcubic(anim_percent, -300, 160-(v.levelTitleWidth(string[1])/2))
	x_locs[2] = ease.outcubic(anim_percent, 300, 160-(v.levelTitleWidth(string[2])/2))

	x_locs[3] = ease.outcubic(anim_percent, -300, hudpos.yb_time.x)
	x_locs[4] = ease.outcubic(anim_percent-2, -300, hudpos.yb_ring.x)
	x_locs[5] = ease.outcubic(anim_percent-4, -300, hudpos.yb_total.x)
	x_locs[6] = ease.outcubic(anim_percent, 300, 160-(v.levelTitleWidth(string[3])/2))

	-- You got through Act X
	local y_off = -25
	for i=1,2 do
		if i == 2 and mapheaderinfo[gamemap].actnum == 0 then
			v.drawLevelTitle(x_locs[6], 60+y_off, string[3])
		else
			v.drawLevelTitle(x_locs[i], 60+y_off, string[i])
		end
		y_off = 0
	end

	if mapheaderinfo[gamemap].actnum != 0 then
		DrawMotdString(v, ease.outcubic(anim_percent, 800*FU, ((160+v.levelTitleWidth(string[2])/2)+2)*FU),
						52*FU, FU, tostring(mapheaderinfo[gamemap].actnum), "TTL0", V_PERPLAYER)
	end

	-- Guard Bonus and Time Bonus are never in effect at the same time
	-- So we don't worry that they use the same spot
	if bonus_t.gpoints > 0 then
		-- Guard
		v.draw(x_locs[3], hudpos.yb_time.y, v.cachePatch("MR_GUARD"), 0, v.getColormap(TC_DEFAULT, p.mo.color))
		DrawMotdString(v, ease.outcubic(anim_percent, 800*FU, (320 - 68)*FU), hudpos.yb_time.y*FU, FRACUNIT, tostring(bonus_t.gtick), "MRCEFNT", V_PERPLAYER, -1)
	else
		-- Time
		v.draw(x_locs[3], hudpos.yb_time.y, v.cachePatch("MR_TIME"), 0, v.getColormap(TC_DEFAULT, p.mo.color))
		DrawMotdString(v, ease.outcubic(anim_percent, 800*FU, (320 - 68)*FU), hudpos.yb_time.y*FU, FRACUNIT, tostring(bonus_t.ttick), "MRCEFNT", V_PERPLAYER, -1)
	end
	-- Rings
	v.draw(x_locs[4], hudpos.yb_ring.y, v.cachePatch("MR_RING"), 0, v.getColormap(TC_DEFAULT, p.mo.color))
	DrawMotdString(v, ease.outcubic(anim_percent, 800*FU, (320 - 68)*FU), hudpos.yb_ring.y*FU, FRACUNIT, tostring(bonus_t.rtick), "MRCEFNT", V_PERPLAYER, -1)
	-- Total
	v.draw(x_locs[5], hudpos.yb_total.y, v.cachePatch("MR_TOTAL"), 0, v.getColormap(TC_DEFAULT, p.mo.color))
	DrawMotdString(v, ease.outcubic(anim_percent, 800*FU, (320 - 68)*FU), hudpos.yb_total.y*FU, FRACUNIT, tostring(bonus_t.fakescore), "MRCEFNT", V_PERPLAYER, -1)
	if p.xian and p.xian.combobest > 0 then
		v.drawString(ease.outcubic(anim_percent, 800, (320 - 80)), hudpos.yb_total.y + 20, "Best Combo: " .. tostring(p.xian.combobest))
	end
	if p.rank then
		local rank = p.rank
		if p.rank == "E" then
			rank = "E"
			v.drawNameTag(x_locs[2] + 220, 100, ""+rank+"", SKINCOLOR_BLACK, SKINCOLOR_BLACK)
		elseif p.rank == "D" then
			rank = "D"
			v.drawNameTag(x_locs[2] + 220, 100, ""+rank+"", SKINCOLOR_WHITE, SKINCOLOR_WHITE)
		elseif p.rank == "C" then
			rank = "C"
			v.drawNameTag(x_locs[2] + 220, 100, ""+rank+"", SKINCOLOR_YELLOW, SKINCOLOR_YELLOW)
		elseif p.rank == "B" then
			rank = "B"
			v.drawNameTag(x_locs[2] + 220, 100, ""+rank+"", SKINCOLOR_GREEN, SKINCOLOR_GREEN)
		elseif p.rank == "A" then
			rank = "A"
			v.drawNameTag(x_locs[2] + 220, 100, ""+rank+"", SKINCOLOR_RED, SKINCOLOR_RED)
		elseif p.rank == "S" then
			rank = "S"
			v.drawNameTag(x_locs[2] + 220, 100, ""+rank+"", SKINCOLOR_BLUE, SKINCOLOR_BLUE)
		end
	end
end
hud.add(hud_intermission, "game")

addHook("KeyDown", function(key)
	if not(bonus_t.display) then return end
	for i=1,2 do
		if key.num == ctrl_inputs.pause[i]
		or key.num == ctrl_inputs.sys[i]
		or key.name == "escape" then
			return true
		end
		if key.num == ctrl_inputs.spn[i]
		and bonus_t.btick == 0 then
			bonus_t.skiptick = true
			return true
		end
	end
end)