--coded by Sylve, SimplerHud code by SteelT referenced to figure out how to draw the life icons and such in the right places, mainly how to use v.getSprite2Patch (thank you because I was really confused on how to do hud code lol)
// To prevent duplicate freeslots
local function SafeFreeslot(...)
	for _, item in ipairs({...}) do
		if rawget(_G, item) == nil then
			freeslot(item)
		end
	end
end

freeslot(
"SKINCOLOR_COMPLETEBLACKDROPSHADOW"--name is very long and very specific to avoid conflicts
)

SafeFreeslot(
	"SPR2_MRCL",
	"SPR2_MRXL",
	"SKINCOLOR_IRIDESCENCE1",
	"SKINCOLOR_IRIDESCENCE2",
	"SKINCOLOR_IRIDESCENCE3",
	"SKINCOLOR_IRIDESCENCE4",
	"SKINCOLOR_IRIDESCENCE5",
	"SKINCOLOR_IRIDESCENCE6",
	"SKINCOLOR_IRIDESCENCEF" -- icy here. moved the SafeFreeslot down for neatness and added super sonic's hyper colors. this is done so that the colors "exist" but aren't defined, otherwise the game will throw a fit over the colors not existing.
)

skincolors[SKINCOLOR_COMPLETEBLACKDROPSHADOW] = {
	name = "CompleteBlack",
	ramp = {31,31,31,31,31,31,31,31,31,31,31,31,31,31,31,31},
	invcolor = SKINCOLOR_WHITE,
	invshade = 1,
	chatcolor = V_GRAYMAP,
	accessible = false
}

local anim_percent
local anim_capped
local anim_ticker = 0

//icy here, let's test shit
--simple, v is the drawer, num is the desired transparency, do a truth check with function before drawing with it!
local function adjustHUDTrans(v, num)
	local theShift = min(10,(v.localTransFlag()>>V_ALPHASHIFT)+num)
	if theShift >= 10 then
		return false
	end
	return (theShift<<V_ALPHASHIFT)
end

local fadingcolors = {SKINCOLOR_IRIDESCENCEF, SKINCOLOR_IRIDESCENCE1, SKINCOLOR_IRIDESCENCEF, SKINCOLOR_IRIDESCENCE2, SKINCOLOR_IRIDESCENCEF, SKINCOLOR_IRIDESCENCE3, SKINCOLOR_IRIDESCENCEF, SKINCOLOR_IRIDESCENCE4, SKINCOLOR_IRIDESCENCEF, SKINCOLOR_IRIDESCENCE5, SKINCOLOR_IRIDESCENCEF, SKINCOLOR_IRIDESCENCE6}
local fadedcolors = {SKINCOLOR_IRIDESCENCE1, SKINCOLOR_IRIDESCENCEF, SKINCOLOR_IRIDESCENCE2, SKINCOLOR_IRIDESCENCEF, SKINCOLOR_IRIDESCENCE3, SKINCOLOR_IRIDESCENCEF, SKINCOLOR_IRIDESCENCE4, SKINCOLOR_IRIDESCENCEF, SKINCOLOR_IRIDESCENCE5, SKINCOLOR_IRIDESCENCEF, SKINCOLOR_IRIDESCENCE6, SKINCOLOR_IRIDESCENCEF}

local function DrawLivesIcons(v, p, cam)
if p.spectator then return end
if not p.realmo then return end
	if p.shouldhud == false or p.mrce.hud != 1 then
		return
	end
	if p.mrce.hud == 1 and (hud.enabled("lives")) then
		if ultimatemode
		or p.lives == INFLIVES
		or CHUD != nil
		or ((p.mo.skin == "samus") or (p.mo.skin == "basesamus") or (p.mo.skin == "speccy" and p.speccy) or (p.mo.skin == "snolf")) then
			hud.disable("lives")
			return
		end
	end
	local contsprite = v.getSprite2Patch(p.realmo.skin, SPR2_XTRA, false, C)
	local soopsprite = v.getSprite2Patch(p.realmo.skin, SPR2_XTRA, false, C)

	anim_capped = max(min(anim_ticker, TICRATE), 0)
	anim_percent = FU / TICRATE * anim_capped

	if p.exiting <= 50
	and p.exiting > 0 then
		if anim_ticker > 44 then
			anim_ticker = 44
		end
		anim_ticker = $ - 1
	end

	if (p.realmo) and G_PlatformGametype() and (p.mrce.hud == 1) and not (p.hypermysticsonic) and (p.hudstyle == "srb2" or p.hudstyle == nil) and not ((p.mo.skin == "samus") or (p.mo.skin == "basesamus")) and not (p.mo.skin == "duke") and not (srb2p) and not (maptol & TOL_NIGHTS) and not (G_IsSpecialStage(gamemap)) and not modeattacking and gamemap != 99 and not ultimatemode and CHUD == nil and customhud == nil and p.encorelives == nil and not (p.mo.skin == "speccy" and p.speccy) and not (teamkinetic and loadedbots) then
		if P_IsValidSprite2(p.mo, SPR2_MRCL) then
			if p.mo.skin == "supersonic" then
				if (p.powers[pw_shield] & SH_FIREFLOWER) then
					contsprite = v.getSprite2Patch(p.realmo.skin, SPR2_MRCL, false, B)
				else
					contsprite = v.getSprite2Patch(p.realmo.skin, SPR2_MRCL, false, A)
				end
			end
		else
			contsprite = v.getSprite2Patch(p.realmo.skin, SPR2_XTRA, false, C) or v.getSprite2Patch(p.realmo.skin, SPR2_XTRA, false, A) or v.getSprite2Patch(p.realmo.skin, SPR2_STND, false, A, 2)
		end
		if P_IsValidSprite2(p.mo, SPR2_MRXL) then
			soopsprite = v.getSprite2Patch(p.realmo.skin, SPR2_MRXL, false, A)
		 elseif P_IsValidSprite2(p.mo, SPR2_MRCL) then
			if p.mo.skin == "supersonic" then
				if (p.powers[pw_shield] & SH_FIREFLOWER) then
					soopsprite = v.getSprite2Patch(p.realmo.skin, SPR2_MRCL, false, B)
				else
					soopsprite = v.getSprite2Patch(p.realmo.skin, SPR2_MRCL, false, A)
				end
			end
		else
			soopsprite = v.getSprite2Patch(p.realmo.skin, SPR2_XTRA, false, C) or v.getSprite2Patch(p.realmo.skin, SPR2_XTRA, true, A) or v.getSprite2Patch(p.realmo.skin, SPR2_STND, true, A, 2)
		end
		if p.mo.skin == "espio" and p.espio_shiftcolours then
			v.draw(ease.outquart(anim_percent, -300, 16), 176-16,  v.cachePatch("MRLIVEBK"), V_SNAPTOBOTTOM|V_SNAPTOLEFT|V_PERPLAYER|V_HUDTRANS, v.getColormap(p.realmo.skin, p.espio_shiftcolours[startindex]))
		else
			v.draw(ease.outquart(anim_percent, -300, 16), 176-16,  v.cachePatch("MRLIVEBK"), V_SNAPTOBOTTOM|V_SNAPTOLEFT|V_PERPLAYER|V_HUDTRANS, v.getColormap(p.realmo.skin, p.realmo.color))
		end
		if not (p.spectator) then
			if not p.powers[pw_super] then
				v.drawScaled(ease.outquart(anim_percent, -300*FU, (16+18)*FRACUNIT), (176+10)*FRACUNIT, FRACUNIT, contsprite, V_SNAPTOBOTTOM|V_PERPLAYER|V_SNAPTOLEFT|((p.spectator) and V_HUDTRANSHALF or V_HUDTRANS), v.getColormap(TC_BLINK, SKINCOLOR_COMPLETEBLACKDROPSHADOW)) --dropshadow goes first
				v.drawScaled(ease.outquart(anim_percent, -300*FU, (16+17)*FRACUNIT), (176+8)*FRACUNIT, FRACUNIT, contsprite, V_SNAPTOBOTTOM|V_PERPLAYER|V_SNAPTOLEFT|V_HUDTRANS, v.getColormap(p.realmo.skin, p.realmo.color)) --then the actual player sprite
			else
				v.drawScaled(ease.outquart(anim_percent, -300*FU, (16+18)*FRACUNIT), (176+10)*FRACUNIT, FRACUNIT, soopsprite, V_SNAPTOBOTTOM|V_PERPLAYER|V_SNAPTOLEFT|((p.spectator) and V_HUDTRANSHALF or V_HUDTRANS), v.getColormap(TC_BLINK, SKINCOLOR_COMPLETEBLACKDROPSHADOW)) --dropshadow goes first
				v.drawScaled(ease.outquart(anim_percent, -300*FU, (16+17)*FRACUNIT), (176+8)*FRACUNIT, FRACUNIT, soopsprite, V_SNAPTOBOTTOM|V_PERPLAYER|V_SNAPTOLEFT|V_HUDTRANS, v.getColormap(p.realmo.skin, p.realmo.color)) --then the actual player sprite
			end
		else
			v.drawScaled(ease.outquart(anim_percent, -300*FU, (16+17)*FRACUNIT), (176+3)*FRACUNIT, FRACUNIT, contsprite, V_SNAPTOBOTTOM|V_PERPLAYER|V_SNAPTOLEFT|((p.spectator) and V_HUDTRANSHALF), v.getColormap(TC_RAINBOW, p.realmo.color)) --there is no dropshadow when you're spectating; you're a ghost
		end

		--code to make it so super sonic's hyper form still has the smooth fade on the hud.
		if p.mo.skin == "supersonic" and p.hyper
		and p.hyper.transformed and p.mo.hypercolortimer then
		--the color handling shit
			local colorTimer = ((p.mo.hypercolortimer % 132) / 11) + 1

			local flags = V_SNAPTOBOTTOM|V_PERPLAYER|V_SNAPTOLEFT
			local hudTrans = adjustHUDTrans(v, 10 - (p.mo.hypercolortimer % 11))

			if (p.realmo) and G_PlatformGametype() and p.mrce and (p.mrce.hud == 1) --lol
			and not (srb2p) and not (maptol & TOL_NIGHTS) and not (G_IsSpecialStage(gamemap))
			and not modeattacking and gamemap != 99 and not ultimatemode and p.encorelives == nil then --only draw when MRCE would draw it!!
			--also thanks for the formatting, mrce devs

				local contsprite = v.getSprite2Patch(p.realmo.skin, SPR2_MRCL, false, A) --at this point we know super has the goods
				v.draw(16+17, 176+(p.spectator and 3 or 8), contsprite, flags|V_HUDTRANS, v.getColormap(TC_DEFAULT, fadingcolors[colorTimer])) --then the actual player sprite
				if hudTrans or hudTrans == 0 then
					v.draw(16+17, 176+(p.spectator and 3 or 8), contsprite, flags|hudTrans, v.getColormap(TC_DEFAULT, fadedcolors[colorTimer]))
				end
			end
		end

		if (hud.enabled("lives")) and (p.mrce.hud == 1) then
			hud.disable("lives")
		end

		if (G_GametypeUsesLives()) then
			if not (p.lives == INFLIVES) and not (cv_cooplives == "Infinite") then --there is nothing of the sort in gamemodes without lives
				local num = 0
				if (p.fakedisplives) != nil and p.fakedisplives > 94 then
					num = p.fakedisplives
				else
					num = p.lives
				end
				DrawMotdString(v, ease.outquart(anim_percent, -300*FU, (16+68)*FRACUNIT), (176+5)*FRACUNIT, FRACUNIT, tostring(num), "MRCEFNT", V_SNAPTOBOTTOM|V_SNAPTOLEFT|V_PERPLAYER|V_HUDTRANS)
			end
		end
	end
end
hud.add(DrawLivesIcons, "game")

addHook("MapLoad", function()
  anim_ticker = 0
end)

hud.add(function(v,p,ticker,endticker)
	if p.exiting then return end
	if ticker == 1 then
		anim_ticker = 0
	end
	if ticker > 70 then
		anim_ticker = $ + 1
	end
end, "titlecard")
