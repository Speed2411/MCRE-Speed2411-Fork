local amogus = 0
addHook("PreThinkFrame", function(r)
	if (gamestate != GS_LEVEL) then return end
	if (consoleplayer and consoleplayer.mo and consoleplayer.mo.valid) and consoleplayer.mo.health then
		if MRCE_isHyper(consoleplayer) and not consoleplayer.powers[pw_extralife] then
			amogus = S_GetMusicPosition()
		elseif not MRCE_isHyper(consoleplayer) then
			amogus = 0
		end
	end
end)

addHook("MusicChange", function(om, nm)
	if (gamestate != GS_LEVEL) then return end
	if (consoleplayer and consoleplayer.mo and consoleplayer.mo.valid)
	and consoleplayer.mo.health and MRCE_isHyper(consoleplayer)
	and (nm == "_shoes" or nm == "_inv" or nm == "_minv" or nm == mapmusname or nm == "_super") then
		if om == "sshyp" then
			return true
		else
			return "sshyp", 0, true, amogus
		end
	end
	if (consoleplayer and consoleplayer.mo and consoleplayer.mo.valid)
	and consoleplayer.mo.health and consoleplayer.powers[pw_sneakers]
	and mapheaderinfo[gamemap].ltzztext and mapheaderinfo[gamemap].ltzztext == "MYSTIC1"
	and (nm == "_shoes") then
		if om == "mrshoe" then
			return true
		else
			return "mrshoe", 0, true, 0
		end
	end
	if (consoleplayer and consoleplayer.mo and consoleplayer.mo.valid)
	and consoleplayer.mo.health and consoleplayer.powers[pw_invulnerability]
	and mapheaderinfo[gamemap].ltzztext and mapheaderinfo[gamemap].ltzztext == "MYSTIC1"
	and (nm == "_inv") then
		if om == "mrinv" then
			return true
		else
			return "mrinv", 0, true, 0
		end
	end
end)