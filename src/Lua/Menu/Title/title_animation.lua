-- Title Animation for MRCE
-- (C) 2021-2022 by ashi

-- NOTE: there was a note here about cleaning this up but nah it's fine
-- Variables used in the titlescreen animation

-- variable table.
local anivars = {
    capped = nil,
    perc = nil,
    mslide = {55,30},
    durat = {TICRATE/4,TICRATE/2,TICRATE},
    arrt = {0,0,0},
    txtt = {0,0,0},
    prist = {0,0,0,0}
}

local animtime_capped = nil
local animate_percentage = nil
local animate_maxslide = {55,30}
local animdur = {TICRATE/4,TICRATE/2,TICRATE} -- Animation timers
local arr_animtime = {0,0,0}
local txt_animtime = {0,0,0,0}
local prism_animtime = {0,0,0,0}
local dispstaticlogo = false

-- Reset all variables back to their original values if we reload the titlescreen or credits (Titlemaps FTW)
addHook("MapLoad", function()
    if gamemap == 784
    or gamemap == 98 then
        -- Reset all the animation timers
        arr_animtime = {0,0,0}
        txt_animtime = {0,0,0,0}
        prism_animtime = {0,0,0,0}
        -- Don't display the static logo on the credits.
        -- We've reloaded the map.
        dispstaticlogo = false
    end
end)

-- I couldn't find a better way to actually do this animation.
local function ts_animation(v)
    -- don't display if the debug menu is open
    if debugmenu == true then return end
    if gamestate != GS_TITLESCREEN then if gamemap != 98 then return end end -- don't display if we aren't on the titlescreen or credits.
    if gamemap == 98 and dispstaticlogo == true then return end -- don't display if we are displaying the static logo.
    if gamemap == 98 then v.drawFill(0, 0, 320, 200, 31) end    -- display a black background during the credits.

    -- Prism animation (done first so that it appears behind everything else)
    animtime_capped = max(min(prism_animtime[1], animdur[3]), 0)
    animate_percentage = FU / animdur[3] * animtime_capped
    v.drawScaled(ease.outback(animate_percentage, 355*FU, animate_maxslide[1]*FU), ease.outback(animate_percentage, -355*FU, animate_maxslide[2]*FU), FU/6, v.cachePatch("PRISM1"))

    animtime_capped = max(min(prism_animtime[2], animdur[3]), 0)
    animate_percentage = FU / animdur[3] * animtime_capped
    v.drawScaled(ease.outback(animate_percentage, 355*FU, animate_maxslide[1]*FU), ease.outback(animate_percentage, -355*FU, animate_maxslide[2]*FU), FU/6, v.cachePatch("PRISM2"))

    animtime_capped = max(min(prism_animtime[3], animdur[3]), 0)
    animate_percentage = FU / animdur[3] * animtime_capped
    v.drawScaled(ease.outback(animate_percentage, 355*FU, animate_maxslide[1]*FU), ease.outback(animate_percentage, -355*FU, animate_maxslide[2]*FU), FU/6, v.cachePatch("PRISM3"))

    animtime_capped = max(min(prism_animtime[4], animdur[3]), 0)
    animate_percentage = FU / animdur[3] * animtime_capped
    v.drawScaled(ease.outback(animate_percentage, 355*FU, animate_maxslide[1]*FU), ease.outback(animate_percentage, -355*FU, animate_maxslide[2]*FU), FU/6, v.cachePatch("PRISM4"))

    -- Arrow animation
    animtime_capped = max(min(arr_animtime[1], animdur[1]), 0)
    animate_percentage = FU / animdur[1] * animtime_capped
    v.drawScaled(ease.linear(animate_percentage, -255*FU, animate_maxslide[1]*FU), 30*FU, FU/6, v.cachePatch("ARROW"))

    animtime_capped = max(min(arr_animtime[2], animdur[2]), 0)
    animate_percentage = FU / animdur[2] * animtime_capped
    v.drawScaled(ease.linear(animate_percentage, -255*FU, animate_maxslide[1]*FU), 30*FU, FU/6, v.cachePatch("ARRO2"))

    animtime_capped = max(min(arr_animtime[3], animdur[2]), 0)
    animate_percentage = FU / animdur[2] * animtime_capped
    v.drawScaled(ease.linear(animate_percentage, -255*FU, animate_maxslide[1]*FU), 30*FU, FU/6, v.cachePatch("ARRO3"))

    -- Text animation
    animtime_capped = max(min(txt_animtime[1], animdur[3]), 0)
    animate_percentage = FU / animdur[3] * animtime_capped
    v.drawScaled(ease.outback(animate_percentage, 355*FU, animate_maxslide[1]*FU), 30*FU, FU/6, v.cachePatch("THE"))

    animtime_capped = max(min(txt_animtime[2], animdur[3]), 0)
    animate_percentage = FU / animdur[3] * animtime_capped
    v.drawScaled(ease.outback(animate_percentage, 355*FU, animate_maxslide[1]*FU), 30*FU, FU/6, v.cachePatch("MYSTIC"))

    animtime_capped = max(min(txt_animtime[3], animdur[3]), 0)
    animate_percentage = FU / animdur[3] * animtime_capped
    v.drawScaled(ease.outback(animate_percentage, 355*FU, animate_maxslide[1]*FU), 30*FU, FU/6, v.cachePatch("REALM"))

    animtime_capped = max(min(txt_animtime[4], animdur[3]), 0)
    animate_percentage = FU / animdur[3] * animtime_capped
    v.drawScaled(ease.outback(animate_percentage, 355*FU, animate_maxslide[1]*FU), 30*FU, FU/6, v.cachePatch("JPN"))
end

-- Add the titlescreen animation function into the hud items
hud.add(ts_animation, "game")
hud.add(ts_animation, "title")

-- Tickers are handled here to ensure a smooth 35tps
-- I'm so very sorry about how much of a mess this looks.
addHook("ThinkFrame", function()
    if gamemap == 784
    or gamemap == 98 then
        arr_animtime[1] = $ + 1
        if arr_animtime[1] >= 4 then
            arr_animtime[2] = $ + 1
        end
        if arr_animtime[1] >= 8 then
            arr_animtime[3] = $ + 1
            txt_animtime[1] = $ + 1
            prism_animtime[1] = $ + 1
            if arr_animtime[1] >= 10 then
                txt_animtime[2] = $ + 1
                prism_animtime[2] = $ + 1
            end
            if arr_animtime[1] >= 12 then
                txt_animtime[3] = $ + 1
                prism_animtime[3] = $ + 1
            end
            if arr_animtime[1] >= 14 then
                txt_animtime[4] = $ + 1
                prism_animtime[4] = $ + 1
            end
        end
    end
end)
