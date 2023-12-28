/*
Mystic Realm CE Shrine Script

(C) 2020-2021 by Ashi

Level Header Variable format:
Lua.shrine = <emeraldcolor>, <emeraldstagemapnumber>
*/

local soffset = 220
local soffsetresettimer = 0
local currentmap = nil
local mysticticker = 0
local shrinedata = nil

-- Text ease variables
local text_pos = {320, 340, 360, 380}

local text_animdur = 1*TICRATE
local text_maxslide = 160
local text_animtime = 0

local animtime_capped = nil
local animate_percentage = nil

addHook("MapLoad", function(p, v)
	if shrine_active == true --Has the shrine been activated, and are we still on the same map?
	and currentmap == gamemap then
		P_LinedefExecute(5000, nil, 5001)
		G_SetCustomExitVars(shrinedata[2])
	else
		shrine_active = false
		text_animtime = 0
		text_maxslide = 160
		text_pos = {320, 340, 360, 380}
	end
	shrinedata = GetNumberList(mapheaderinfo[gamemap].shrine)
end)

local function shrine_pressed(line, mo, d) --This is where we actually activate the shrine.
	if shrine_active == false then --The player hasn't activated the shrine yet. let's do that now.
		currentmap = gamemap --Sets currentmap to the map number
		shrine_active = true
		mysticticker = 0
		S_StartSound(nil, sfx_kc5c)
		G_SetCustomExitVars(shrinedata[2])
	end
	soffsetresettimer = 95 --This makes the shrine marker stay up on screen for a bit longer
end

addHook("LinedefExecute", shrine_pressed, "SHRINE_PRESSED") --When the player steps on the button activate the shrine.

addHook("PlayerThink", function(p) --This is the script that manages the positioning of the marker.
	if not p.bot and p.valid then
		if shrine_active == true and mysticticker < 120 then
			p.shrinemarker = 1 --Using an entirely separate variable to prevent the NewEmblemHUD from appearing
		else
			p.shrinemarker = 0
		end
		if p.shrinemarker or p.changeoffset then
			if soffset > 155 then --our y is greater than 155.
				soffset = $ - 5 --We gotta lower that. bring the marker up.
			end
			if soffset == 155 and soffsetresettimer then --our y is equal to 155
				soffsetresettimer = $ - 1 --let's count down the timer until it auto dismisses itself
			end
		else
			if soffset < 220 then --Our y is less than 220. Usually means the marker is on screen.
				soffset = $ + 10 --Let's increase it. Lowering the marker!
			end
		end
	end
end)

hud.add(function(d, p) --The shrine marker draw code
	if mapheaderinfo[gamemap].shrine == nil then return end
	if bonus_t.display then return end
	if (shrine_active == true) then
		if gamemap == 129 then
			d.drawScaled(165*(FRACUNIT/2+FRACUNIT/3), (soffset*FRACUNIT), (FRACUNIT/2)+FRACUNIT/3, d.cachePatch("MSMRK1"), V_SNAPTOBOTTOM, d.getColormap(TC_DEFAULT, R_GetColorByName("Hyper1")))
		elseif gamemap == 133 then
			d.drawScaled(165*(FRACUNIT/2+FRACUNIT/3), (soffset*FRACUNIT), (FRACUNIT/2)+FRACUNIT/3, d.cachePatch("MSMRK1"), V_SNAPTOBOTTOM, d.getColormap(TC_DEFAULT, R_GetColorByName("Hyper2")))
		else
			d.drawScaled(165*(FRACUNIT/2+FRACUNIT/3), (soffset*FRACUNIT), (FRACUNIT/2)+FRACUNIT/3, d.cachePatch("MSMRK1"), V_SNAPTOBOTTOM, d.getColormap(TC_DEFAULT, shrinedata[1]))
		end
		if mysticticker == 240 then
			return
		else
			if mysticticker == 120 then
				text_maxslide = -380
				text_animtime = 0
				text_pos = {160, 160, 160, 160}
			end
			mysticticker = $ + 1
			text_animtime = text_animtime + 1

			animtime_capped = max(min(text_animtime, text_animdur), 0)
    		animate_percentage = FRACUNIT / text_animdur * animtime_capped

			d.drawString(ease.outquart(animate_percentage, text_pos[1], text_maxslide), 105, mapheaderinfo[gamemap].lvlttl.."'s Mystic Shrine", V_ALLOWLOWERCASE, "center")
			d.drawString(ease.outquart(animate_percentage, text_pos[2], text_maxslide), 115, "has been activated.", V_ALLOWLOWERCASE, "center")
			d.drawString(ease.outquart(animate_percentage, text_pos[3], text_maxslide), 135, "The next level has been changed to", V_ALLOWLOWERCASE, "center")
			d.drawString(ease.outquart(animate_percentage, text_pos[4], text_maxslide), 145, mapheaderinfo[shrinedata[2]].lvlttl, V_ALLOWLOWERCASE, "center")
		end
	else
		d.drawScaled(165*(FRACUNIT/2+FRACUNIT/3), (soffset*FRACUNIT), (FRACUNIT/2)+FRACUNIT/3, d.cachePatch("MSMRK2"), V_SNAPTOBOTTOM, d.getColormap(TC_DEFAULT, SKINCOLOR_GREY))
	end
end, "game")

hud.add(function(d, p)--Shrine marker multiplayer code
	if mapheaderinfo[gamemap].shrine == nil then return end
	if bonus_t.display then return end
	if (multiplayer and netgame) then
		if (shrine_active == true) then
			if gamemap == 129 then
				d.drawScaled(175*(FRACUNIT/2+FRACUNIT/3), (1*FRACUNIT), (FRACUNIT/2), d.cachePatch("MSMRK1"), 0, d.getColormap(TC_DEFAULT, R_GetColorByName("Hyper1")))
			elseif gamemap == 133 then
				d.drawScaled(175*(FRACUNIT/2+FRACUNIT/3), (1*FRACUNIT), (FRACUNIT/2), d.cachePatch("MSMRK1"), 0, d.getColormap(TC_DEFAULT, R_GetColorByName("Hyper2")))
			else
				d.drawScaled(175*(FRACUNIT/2+FRACUNIT/3), (1*FRACUNIT), (FRACUNIT/2), d.cachePatch("MSMRK1"), 0, d.getColormap(TC_DEFAULT, shrinedata[1]))
			end
		else
			d.drawScaled(175*(FRACUNIT/2+FRACUNIT/3), (1*FRACUNIT), (FRACUNIT/2), d.cachePatch("MSMRK2"), 0, d.getColormap(TC_DEFAULT, SKINCOLOR_GREY))
		end
	end
end, "scores")

addHook("NetVars", function(net)
	shrine_active=net($)
	currentmap=net($)
	mysticticker=net($)
end)