/*
    Stripped down implementation of Intermission.lua
    for netgames.

    Netgames won't work with our standard intermission.lua script
    so we need an entirely different purely visual variant just
    for netgame use.

    Just letting the game handle the intermission is best practice 
    for netgames due to unpredictability in the netcode.

    (C) 2022 by K. "ashifolfi" J.
*/

local anim_percent
local anim_capped
local anim_ticker = 0

local function hud_inter_draw(v, x_locs, string)
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
						52*FU, FU, tostring(mapheaderinfo[gamemap].actnum), "TTL0")
	end

	-- Guard Bonus and Time Bonus are never in effect at the same time
	-- So we don't worry that they use the same spot
	if bonus_t.gpoints > 0 then
		-- Guard
		v.draw(x_locs[3], hudpos.yb_time.y, v.cachePatch("YB_GUARD"), 0)
		DrawMotdString(v, ease.outcubic(anim_percent, 800*FU, (320 - 68)*FU), hudpos.yb_time.y*FU, FRACUNIT, tostring(bonus_t.gtick), "MRCEFNT", 0, -1)
	else
		-- Time
		v.draw(x_locs[3], hudpos.yb_time.y, v.cachePatch("YB_TIME"), 0)
		DrawMotdString(v, ease.outcubic(anim_percent, 800*FU, (320 - 68)*FU), hudpos.yb_time.y*FU, FRACUNIT, tostring(bonus_t.ttick), "MRCEFNT", 0, -1)
	end
	-- Rings
	v.draw(x_locs[4], hudpos.yb_ring.y, v.cachePatch("YB_RING"), 0)
	DrawMotdString(v, ease.outcubic(anim_percent, 800*FU, (320 - 68)*FU), hudpos.yb_ring.y*FU, FRACUNIT, tostring(bonus_t.rtick), "MRCEFNT", 0, -1)
	-- Total
	v.draw(x_locs[5], hudpos.yb_total.y, v.cachePatch("YB_TOTAL"), 0)
	DrawMotdString(v, ease.outcubic(anim_percent, 800*FU, (320 - 68)*FU), hudpos.yb_total.y*FU, FRACUNIT, tostring(bonus_t.fakescore), "MRCEFNT", 0, -1)
end

local function hud_intermission(v)
	-- don't run outside of a netgame dummy
	if not(multiplayer or netgame or modeattacking or (gamemap == 123 and not All7Emeralds(emeralds))) then return end
	-- Don't display if we shouldn't
	if not(bonus_t.display) then return end

	local string = ""

	local string = {
		[1] = /*skins[p.mo.skin].realname*/"SKINNAME".." got",
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

    hud_inter_draw(v, x_locs, string)

    -- It doesn't matter if we handle anim_ticker directly in the hud. it shouldn't affect anything
	anim_ticker = $ + 1
end
hud.add(hud_intermission, "intermission")

local function net_intermission_helper(player)
	if not(multiplayer or netgame) then return end
	if /*not(player.mrce.hud)*/ true then hud.enable("intermissiontally"); return end

	if player.exiting then 
		bonus_t.display = true
		-- Used to get player color
		bonus_t.player = player
		bfunc_t[mapheaderinfo[gamemap].bonustype](player)
		hud.disable("intermissiontally")
	end
end
addHook("PlayerThink", net_intermission_helper)
