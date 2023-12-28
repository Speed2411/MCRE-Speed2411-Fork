addHook("PlayerThink", function(p)
	if p.spectator then return false end
	if not p.realmo then return false end
	if mapheaderinfo[gamemap].lvlttl != "Primordial Abyss" then return end
	if p.mo.x > -2605*FRACUNIT and p.mo.x < 2871*FRACUNIT
	and p.mo.y > -2630*FRACUNIT and p.mo.y < 2864*FRACUNIT then --first room, green
		P_SetupLevelSky(5004, p)
	elseif p.mo.x > 4546*FRACUNIT and p.mo.x < 9999*FRACUNIT
	and p.mo.y >-2630*FRACUNIT and p.mo.y < 5810*FRACUNIT then --second room, purple
		P_SetupLevelSky(5005, p)
	elseif p.mo.x >-1705*FRACUNIT and p.mo.x < 1845*FRACUNIT
	and p.mo.y > 3901*FRACUNIT and p.mo.y < 10936*FRACUNIT then --third room, blue
		P_SetupLevelSky(9, p)
	elseif p.mo.x > -6088*FRACUNIT and p.mo.x < -2874*FRACUNIT
	and p.mo.y > 3786*FRACUNIT and p.mo.y < 7355*FRACUNIT then --fourth room, cyan
		P_SetupLevelSky(5007, p)
	elseif p.mo.x > -6133*FRACUNIT and p.mo.x < -2874*FRACUNIT
	and p.mo.y > 8510*FRACUNIT and p.mo.y < 13101*FRACUNIT then --fifth room, yellow
		P_SetupLevelSky(5008, p)
	elseif p.mo.x > -1730*FRACUNIT and p.mo.x < 3219*FRACUNIT
	and p.mo.y > 11965*FRACUNIT and p.mo.y < 29351*FRACUNIT then --fourth room, cyan
		P_SetupLevelSky(499, p)
	end
end)

addHook("MapLoad", function(map)
	if mapheaderinfo[gamemap].lvlttl != "Primordial Abyss" then return end
	local ctime = os.date("*t")
	if ctime.month != 4 then return end
	if ctime.day != 1 then return end
	for s in sectors.iterate do
		for rover in s.ffloors() do
			if (rover.sector.floorpic == "RAINBOWC" or rover.sector.floorpic == "DSBLOCK1" or rover.sector.floorpic == "DSBLOCK3") then
				--print("found one")
				if rover.alpha > 5 then
					rover.alpha = 5
					rover.blend = AST_ADD
				end
			end
		end
	end
end)