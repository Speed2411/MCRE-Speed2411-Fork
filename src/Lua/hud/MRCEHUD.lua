/*
MRCE Lua HUD

(C) 2020-2022 by K. "ashifolfi" J.
*/

local anim_percent
local anim_percent2
local anim_capped
local anim_capped2
local anim_ticker = 0
local anim_ticker2 = 0
local slidein = "no"
local hticker = 0

if not MarioSkins then
	rawset(_G, "MarioSkins", {})
end

local function HudToggle(player, arg)
    if arg and player and player.mrce then
        if arg == "1" or arg == "on" or arg == "default" or arg == "true" or arg == "normal" or arg == "yes" then
			player.mrce.hud = 1
			if player.mrce.constext == 0 then
				CONS_Printf(player, "MRCE Custom hud enabled")
			end
			if io and player == consoleplayer then
				local file = io.openlocal("client/mrce/hud.dat", "w+")
				file:write(arg)
				file:close()
			end
		elseif arg == "off" or arg == "0" or arg == "no" or arg == "false" or arg == "disable" then
			player.mrce.hud = 0
			if player.mrce.constext == 0 then
				CONS_Printf(player, "MRCE Custom hud disabled")
			end
			if io and player == consoleplayer then
				local file = io.openlocal("client/mrce/hud.dat", "w+")
				file:write(arg)
				file:close()
			end
        end
    elseif player.mrce.constext == 0 then
        CONS_Printf(player, "Toggle MRCE lua hud. Note many effects are used by the custom hud, and are lost when disabled, so BEWARE")
    end
end

COM_AddCommand("mr_hud", function(player, arg)
	HudToggle(player, arg)
end)

local function DrawMRCEHUD(v, p, cam, ticker, endticker)
	if p.spectator then return end
	if not p.realmo then return end
	local replaced = {"rings", "time", "score", "lives"}

	if p.shouldhud == false then
		for k,v in ipairs(replaced) do
			hud.disable(v)
		end
		return
	end

	if p.mrce.hud == 0 then
		for k,v in ipairs(replaced) do
			hud.enable(v)
		end
		return
	end

	if p.exiting <= 50
	and p.exiting > 0 then
		if anim_ticker2 > 44 then
			anim_ticker2 = 44
		end
		anim_ticker2 = $ - 1
	end

	anim_capped = max(min(anim_ticker, TICRATE), 0)
	anim_percent = FU / TICRATE * anim_capped

	anim_capped2 = max(min(anim_ticker2, TICRATE), 0)
	anim_percent2 = FU / TICRATE * anim_capped2

	if (p.realmo) and (p.hudstyle == "srb2" or p.hudstyle == nil) and not (p.mo.skin == "speccy" and p.speccy) and not ((p.mo.skin == "samus") or (p.mo.skin == "basesamus")) and not (p.mo.skin == "duke") and not (srb2p) and not (maptol & TOL_NIGHTS) and not (G_IsSpecialStage(gamemap)) and gamemap != 99 and CHUD == nil and customhud == nil
	and p == displayplayer and p.mrce.hud == 1 then
		-- Score
		v.draw(ease.outquart(anim_percent, -300 , 20), 10, v.cachePatch("MRHSCORE"), V_SNAPTOLEFT|V_SNAPTOTOP|V_PERPLAYER|V_HUDTRANS, v.getColormap(p.realmo.skin, p.realmo.color))
		DrawMotdString(v, ease.outquart(anim_percent, -300*FU , 75*FRACUNIT), 10*FRACUNIT, FRACUNIT, tostring(p.score), "MRCEFNT", V_SNAPTOTOP|V_SNAPTOLEFT|V_PERPLAYER|V_HUDTRANS)
		-- Time
		v.draw(ease.outquart(anim_percent, -300 , 20), 26, v.cachePatch("MRHTIME"), V_SNAPTOLEFT|V_SNAPTOTOP|V_PERPLAYER|V_HUDTRANS, v.getColormap(p.realmo.skin, p.realmo.color))
		if G_TicsToMinutes(p.realtime) < 10 and mapheaderinfo[gamemap].lvlttl != "Dimension Warp" then
			DrawMotdString(v, ease.outquart(anim_percent, -300*FU , 75*FRACUNIT), 27*FRACUNIT, FRACUNIT, "0", "MRCEFNT", V_SNAPTOTOP|V_SNAPTOLEFT|V_PERPLAYER|V_HUDTRANS)
			DrawMotdString(v, ease.outquart(anim_percent, -300*FU , 83*FRACUNIT), 27*FRACUNIT, FRACUNIT, G_TicsToMinutes(p.realtime), "MRCEFNT", V_SNAPTOTOP|V_SNAPTOLEFT|V_PERPLAYER|V_HUDTRANS)
		elseif G_TicsToMinutes(p.realtime) >= 10 and mapheaderinfo[gamemap].lvlttl != "Dimension Warp" then
			DrawMotdString(v, ease.outquart(anim_percent, -300*FU , 75*FRACUNIT), 27*FRACUNIT, FRACUNIT, G_TicsToMinutes(p.realtime), "MRCEFNT", V_SNAPTOTOP|V_SNAPTOLEFT|V_PERPLAYER|V_HUDTRANS)
		elseif mapheaderinfo[gamemap].lvlttl == "Dimension Warp" then
			DrawMotdString(v, ease.outquart(anim_percent, -300*FU , 75*FRACUNIT), 27*FRACUNIT, FRACUNIT, tostring(p.warpminutes), "MRCEFNT", V_SNAPTOTOP|V_SNAPTOLEFT|V_PERPLAYER|V_HUDTRANS)
		end
		if G_TicsToSeconds(p.realtime) < 10 and mapheaderinfo[gamemap].lvlttl != "Dimension Warp" then
			DrawMotdString(v, ease.outquart(anim_percent, -300*FU , 99*FRACUNIT), 27*FRACUNIT, FRACUNIT, "0", "MRCEFNT", V_SNAPTOTOP|V_SNAPTOLEFT|V_PERPLAYER|V_HUDTRANS)
			DrawMotdString(v, ease.outquart(anim_percent, -300*FU , 107*FRACUNIT), 27*FRACUNIT, FRACUNIT, G_TicsToSeconds(p.realtime), "MRCEFNT", V_SNAPTOTOP|V_SNAPTOLEFT|V_PERPLAYER|V_HUDTRANS, 1)
		elseif G_TicsToSeconds(p.realtime) >= 10 and mapheaderinfo[gamemap].lvlttl != "Dimension Warp" then
			DrawMotdString(v, ease.outquart(anim_percent, -300*FU , 99*FRACUNIT), 27*FRACUNIT, FRACUNIT, G_TicsToSeconds(p.realtime), "MRCEFNT", V_SNAPTOTOP|V_SNAPTOLEFT|V_PERPLAYER|V_HUDTRANS, 1)
		elseif mapheaderinfo[gamemap].lvlttl == "Dimension Warp" then
			DrawMotdString(v, ease.outquart(anim_percent, -300*FU , 99*FRACUNIT), 27*FRACUNIT, FRACUNIT, tostring(p.warpseconds), "MRCEFNT", V_SNAPTOTOP|V_SNAPTOLEFT|V_PERPLAYER|V_HUDTRANS, 1)
		end
		if G_TicsToCentiseconds(p.realtime) < 10 and mapheaderinfo[gamemap].lvlttl != "Dimension Warp" then
			DrawMotdString(v, ease.outquart(anim_percent, -300*FU , 123*FRACUNIT), 27*FRACUNIT, FRACUNIT, "0", "MRCEFNT", V_SNAPTOTOP|V_SNAPTOLEFT|V_PERPLAYER|V_HUDTRANS)
			DrawMotdString(v, ease.outquart(anim_percent, -300*FU , 131*FRACUNIT), 27*FRACUNIT, FRACUNIT, G_TicsToCentiseconds(p.realtime), "MRCEFNT", V_SNAPTOTOP|V_SNAPTOLEFT|V_PERPLAYER|V_HUDTRANS, 1)
		elseif G_TicsToCentiseconds(p.realtime) >= 10 and mapheaderinfo[gamemap].lvlttl != "Dimension Warp" then
			DrawMotdString(v, ease.outquart(anim_percent, -300*FU , 123*FRACUNIT), 27*FRACUNIT, FRACUNIT, G_TicsToCentiseconds(p.realtime), "MRCEFNT", V_SNAPTOTOP|V_SNAPTOLEFT|V_PERPLAYER|V_HUDTRANS, 1)
		elseif mapheaderinfo[gamemap].lvlttl == "Dimension Warp" then
			DrawMotdString(v, ease.outquart(anim_percent, -300*FU , 123*FRACUNIT), 27*FRACUNIT, FRACUNIT, tostring(p.warpcentiseconds), "MRCEFNT", V_SNAPTOTOP|V_SNAPTOLEFT|V_PERPLAYER|V_HUDTRANS, 1)
		end
		v.draw(ease.outquart(anim_percent, -300 , 91), 27, v.cachePatch("MRCEFNTS"), V_SNAPTOTOP|V_SNAPTOLEFT|V_PERPLAYER|V_HUDTRANS)
		v.draw(ease.outquart(anim_percent, -300 , 115), 27, v.cachePatch("MRCEFNTP"), V_SNAPTOTOP|V_SNAPTOLEFT|V_PERPLAYER|V_HUDTRANS)
		-- Rings
		if not ultimatemode
		or mapheaderinfo[gamemap].lvlttl == "Dimension Warp"
		and not MarioSkins[p.mo.skin] and not mariomode then --normal hud draw for normal characters
		local getrings = p.mo.skin == "xian" and p.xian.rings or p.rings
			v.draw(ease.outquart(anim_percent2, -300 , 20), 42, v.cachePatch("MRHRINGS"), V_SNAPTOLEFT|V_SNAPTOTOP|V_PERPLAYER|V_HUDTRANS, v.getColormap(p.realmo.skin, p.realmo.color))
			DrawMotdString(v, ease.outquart(anim_percent2, -300*FU , 75*FRACUNIT), 42*FRACUNIT, FRACUNIT, tostring(getrings), "MRCEFNT", V_SNAPTOTOP|V_SNAPTOLEFT|V_PERPLAYER|V_HUDTRANS)
		elseif not ultimatemode
		or mapheaderinfo[gamemap].lvlttl == "Dimension Warp" then  --mario time, oh yeah! I'd like to swap the rings graphic out for a coins version where appropriate, just need a graphic for it
			v.draw(ease.outquart(anim_percent2, -300 , 20), 42, v.cachePatch("MRHCOINS"), V_SNAPTOLEFT|V_SNAPTOTOP|V_PERPLAYER|V_HUDTRANS, v.getColormap(p.realmo.skin, p.realmo.color))
			DrawMotdString(v, ease.outquart(anim_percent2, -300*FU , 75*FRACUNIT), 42*FRACUNIT, FRACUNIT, tostring(p.rings), "MRCEFNT", V_SNAPTOTOP|V_SNAPTOLEFT|V_PERPLAYER|V_HUDTRANS)
		end
		if (p.rings == 0 and (leveltime/5%2) and not ultimatemode and p.mo.skin != "xian") or (mapheaderinfo[gamemap].lvlttl == "Dimension Warp" and p.rings <= 10 and (leveltime/5%2)) or (p.mo.skin == "supersonic" and p.rings <= 10 and (leveltime/5%2))
		and (MarioSkins and not MarioSkins[p.mo.skin]) and not mariomode then
			v.draw(ease.outquart(anim_percent2, -300 , 20), 42, v.cachePatch("MRHRRING"), V_SNAPTOLEFT|V_SNAPTOTOP|V_PERPLAYER|V_HUDTRANS, v.getColormap(p.realmo.skin, p.realmo.color))
		elseif (MarioSkins and MarioSkins[p.mo.skin]) and (mapheaderinfo[gamemap].lvlttl == "Dimension Warp" and p.rings <= 10 and (leveltime/5%2))
		or mariomode and not MarioSkins[p.mo.skin] then
			v.draw(ease.outquart(anim_percent2, -300 , 20), 42, v.cachePatch("MRHRCOIN"), V_SNAPTOLEFT|V_SNAPTOTOP|V_PERPLAYER|V_HUDTRANS, v.getColormap(p.realmo.skin, p.realmo.color))
		end
		if p.mrce.hud == 1 then
			hud.disable("rings")
			hud.disable("time")
			hud.disable("score")
		end
	end
end
hud.add(DrawMRCEHUD, "game")

addHook("MapLoad", function()
  anim_ticker = 0
  anim_ticker2 = 0
end)

hud.add(function(v,p,ticker,endticker)
	if p.exiting then return end
	if modeattacking then return end
	if ticker == 1 then
		anim_ticker = 0
		anim_ticker2 = 0
	end
	if ticker > 70 then
		anim_ticker = $ + 1
		anim_ticker2 = $ + 1
	end
end, "titlecard")

addHook("ThinkFrame", function()
	if displayplayer and displayplayer.exiting then return end
	if not modeattacking then return end
	if leveltime == 1 then
		anim_ticker = 0
		anim_ticker2 = 0
	elseif leveltime > 35 and leveltime < 80 then
		anim_ticker = $ + 1
		anim_ticker2 = $ + 1
	end
end)

addHook("PlayerThink", function(p)
	if (mapheaderinfo[gamemap].lvlttl != "Dimension Warp") then return end
	if not (leveltime%35)
	or (leveltime%TICRATE == TICRATE/5) or (leveltime%TICRATE == ((TICRATE/5) * 3)) or (leveltime%TICRATE == ((TICRATE/5) * 2)) or (leveltime%TICRATE == ((TICRATE/5) * 4)) then
		p.warpminutes =  P_RandomRange(10, 99)
		p.warpseconds =  P_RandomRange(10, 99)
		p.warpcentiseconds =  P_RandomRange(10, 99)
	end
end)