--
-- Frozen screen effect for Midnight Freeze and Silver Cavern
-- by Radicalicious
--

hud.add(function(d, p)
	local TOP_LEFT = d.cachePatch("FROZOVR1")
	local TOP_RIGHT = d.cachePatch("FROZOVR2")
	local BOTTOM_LEFT = d.cachePatch("FROZOVR3")
	local BOTTOM_RIGHT = d.cachePatch("FROZOVR4")
	local TRANSPARENCY = 0

	if (p.mrce and p.mrce.freezeeffect != nil) then
		if p.mrce.freezeeffect >= 8*TICRATE then
			TRANSPARENCY = V_10TRANS
			d.fadeScreen(141, 4)
		elseif p.mrce.freezeeffect >= 7*TICRATE then
			TRANSPARENCY = V_20TRANS
			d.fadeScreen(141, 3)
		elseif p.mrce.freezeeffect >= 6*TICRATE then
			TRANSPARENCY = V_30TRANS
			d.fadeScreen(141, 3)
		elseif p.mrce.freezeeffect >= 5*TICRATE then
			TRANSPARENCY = V_40TRANS
			d.fadeScreen(141, 2)
		elseif p.mrce.freezeeffect >= 4*TICRATE then
			TRANSPARENCY = V_50TRANS
			d.fadeScreen(141, 2)
		elseif p.mrce.freezeeffect >= 3*TICRATE then
			TRANSPARENCY = V_60TRANS
			d.fadeScreen(141, 1)
		elseif p.mrce.freezeeffect >= 2*TICRATE then
			TRANSPARENCY = V_70TRANS
			d.fadeScreen(141, 1)
		elseif p.mrce.freezeeffect >= 1*TICRATE then
			TRANSPARENCY = V_80TRANS
			d.fadeScreen(141, 0)
		elseif p.mrce.freezeeffect > 0 then
			TRANSPARENCY = V_90TRANS
			d.fadeScreen(141, 0)
		else
			d.fadeScreen(141, 0)
			return
		end

		d.draw(0, 0, TOP_LEFT, V_PERPLAYER|V_SNAPTOTOP|V_SNAPTOLEFT|TRANSPARENCY)
		d.draw(320, 0, TOP_RIGHT, V_PERPLAYER|V_SNAPTOTOP|V_SNAPTORIGHT|TRANSPARENCY)
		d.draw(0, 200, BOTTOM_LEFT, V_PERPLAYER|V_SNAPTOBOTTOM|V_SNAPTOLEFT|TRANSPARENCY)
		d.draw(320, 200, BOTTOM_RIGHT, V_PERPLAYER|V_SNAPTOBOTTOM|V_SNAPTORIGHT|TRANSPARENCY)
	end
end, "game")

addHook("PlayerThink", function(p)
	if not p then return end
	if not p.valid then return end
	if not p.mo then return end
	if not p.mo.valid then return end

	if p.mrce.freezeeffect == nil then p.mrce.freezeeffect = 0 end

	if not (p.mrce.freezeeffect == nil) then
		if (not (p.powers[pw_shield] & SH_PROTECTWATER)) then
			if (p.powers[pw_spacetime] > 0)
			and (p.mo.eflags & MFE_UNDERWATER)
			and (P_InSpaceSector(p.mo)) then
				p.mrce.freezeeffect = $ + 1
			else
				p.mrce.freezeeffect = $ - 5
			end
		else
			p.mrce.freezeeffect = $ - 5
		end

		if p.mrce.freezeeffect < 0 then p.mrce.freezeeffect = 0 end
	end
	--print(tostring(p.mrce.freezeeffect))
end)

addHook("PlayerSpawn", function(p)
	if not p then return end
	if not p.valid then return end
	if not p.mo then return end
	if not p.mo.valid then return end

	p.mrce.freezeeffect = 0
end)
