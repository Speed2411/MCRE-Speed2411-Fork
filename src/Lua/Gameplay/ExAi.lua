addHook("PlayerThink", function(p)
	if not p.realmo then return end
	if not p.bot then return end
	if ((mapheaderinfo[gamemap].lvlttl == "Dimension Warp") or (mapheaderinfo[gamemap].lvlttl == "Primordial Abyss")) then
		P_DamageMobj(p.mo,nil,nil,1,DMG_INSTAKILL)
	end
end)

addHook("BotRespawn", function(p, b)
	if ((mapheaderinfo[gamemap].lvlttl == "Dimension Warp") or (mapheaderinfo[gamemap].lvlttl == "Primordial Abyss")) then
		return false
	end
end)