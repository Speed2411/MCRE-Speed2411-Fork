/*
    titlecard credits for music and level

    (C) 2022 by K. "ashifolfi" J.
*/

local text_slideout = false
local text_animdur = 1*TICRATE
local text_animtime = 0

local animtime_capped = nil
local animate_percentage = nil

addHook("MapLoad", function()
	text_slideout = false
	text_animtime = 0
end)

local function hud_tcard_credits(v, p, ticker, endticker)
	if (animate_percentage == 65520 and ticker == endticker) then return end

	if (ticker == endticker - 1) then
    	text_animtime = 0
    	text_slideout = true
    end

	animtime_capped = max(min(text_animtime, text_animdur), 0)
    animate_percentage = FU / text_animdur * animtime_capped

    local X = text_slideout and ease.inquint(animate_percentage, 310, 640) or ease.outquint(animate_percentage, 640, 310)
    local Y = marathonmode and 175 or 185
    local snap_flags = V_SNAPTOBOTTOM|V_SNAPTORIGHT

	-- Level design credits
	v.draw(X - 8, Y, v.cachePatch("TCCFN022"), snap_flags, v.getStringColormap(131))
	if mapheaderinfo[gamemap].lcredits == nil then
		v.drawString(X - 10, Y, "Unavailable", snap_flags|V_ALLOWLOWERCASE, "thin-right")
	else
		v.drawString(X - 10, Y, mapheaderinfo[gamemap].lcredits:match('(%w.*[^"])'), snap_flags|V_ALLOWLOWERCASE, "thin-right")
	end

	Y = $ - 15

	--Music credits
	v.drawString(X, Y, "\25", snap_flags|V_GREENMAP, "right")
	if mapheaderinfo[gamemap].mcredits == nil then
		v.drawString(X - 10, Y, "Unavailable", snap_flags|V_ALLOWLOWERCASE, "thin-right")
	else
		v.drawString(X - 10, Y, mapheaderinfo[gamemap].mcredits:match('(%w.*[^"])'), snap_flags|V_ALLOWLOWERCASE, "thin-right")
	end

	if not modeattacking then
		text_animtime = $ + 1
	end
end
hud.add(hud_tcard_credits, "titlecard")

addHook("ThinkFrame", function()
	if leveltime > 300 then return end
	if not modeattacking then return end
	if leveltime == 1 then
		text_animtime = 0
		text_slideout = false
	elseif leveltime > 5 and leveltime < 50 then
		text_animtime = $ + 1
	elseif leveltime > 90 then
		text_slideout = true
		text_animtime = $ + 1
	end
end)