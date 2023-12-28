------------------------------------------------------------
--                                                        --
-- Radicalicious' auto-decoration script. (v2022.11.04)   --
--                                                        --
-- I encourage you not to use this. I haven't cleaned up  --
-- any of the code for general use yet, really. Since I   --
-- shoved it into MRCE, however, I'm not gonna stop you   --
-- if you decide to use it. Don't come crying to me for   --
-- help, though!                                          --
--                                                        --
-- Credits to amperbee and Golden for helping with the    --
-- table nonsense for getting vertex positions.           --
--                                                        --
------------------------------------------------------------

-- This code here was ripped off from ExAI. I needed a version control system. :(
-- (i'll replace it eventually I promise)
local rad_autodec = {
	-- Mod Settings,
	addon = "mrce", -- Change this to the name of your addon
	-- Info
	version = 0,
	subversion = 1,
	develop = false,
}

if type(rad_autodec_info) == "table" then
	print("autodec script loaded under existing namespace: "..tostring(rad_autodec_info.addon))
	return
end

rawset(_G, "rad_autodec_info", rad_autodec)

local objp_noreloadhack = false

local autodec = {

--
-- decorate(sector, mobjtype, ceiling, grid, spread. rarity)
--
-- sector_t sector: the sector_t to autodec
-- int mobjtype: the mobj constant (MT_*) to spawn
-- bool ceiling: gravflip spawned object?
-- bool scale: scale object randomly?
-- int grid: spacing between objects (the value entered is multiplied by FRACUNIT)
-- int spread: offset from the grid
-- int rarity: chance to not spawn the object (1 in rarity - 1)
--
	decorate = function(sector, mobjtype, ceiling, scale, grid, spread, rarity)
		local sectorVertexes = {}
		local minX = 65535*FRACUNIT
		local minY = 65535*FRACUNIT
		local maxX = -65535*FRACUNIT
		local maxY = -65535*FRACUNIT

		for i = 0,#sector.lines-1, 1 do
			table.insert(sectorVertexes, sector.lines[i].v1)
			table.insert(sectorVertexes, sector.lines[i].v2)
		end

		for i = 1,#sectorVertexes, 1 do
			local vrtx = sectorVertexes[i]
			if minX > vrtx.x then
				minX = vrtx.x
			end
			if minY > vrtx.y then
				minY = vrtx.y
			end
			if maxX < vrtx.x then
				maxX = vrtx.x
			end
			if maxY < vrtx.y then
				maxY = vrtx.y
			end
		end

		local objSpawnX = minX
		local objSpawnY = minY

		while (objSpawnY < maxY) do
			while (objSpawnX < maxX) do
				local deco = P_SpawnMobj(objSpawnX, objSpawnY, 0, MT_RAY) -- We're going to spawn a dummy ray to make sure the object is able to be spawned.

				if scale then
					deco.scale = P_RandomRange(FRACUNIT-(FRACUNIT/3), FRACUNIT+(FRACUNIT/3))
				end

				if (spread > 0) then
					local offsetX = P_RandomRange(-spread, spread)
					local offsetY = P_RandomRange(-spread, spread)
					P_TeleportMove(deco, (deco.x + offsetX*FRACUNIT), (deco.y + offsetY*FRACUNIT), deco.subsector.sector.floorheight)
				end

				P_TeleportMove(deco, deco.x, deco.y, deco.floorz) -- slope hack

				if (ceiling == true) then
					deco.flags2 = $ | MF2_OBJECTFLIP
					deco.eflags = $ | MFE_VERTICALFLIP
					P_TeleportMove(deco, deco.x, deco.y, deco.subsector.sector.ceilingheight-deco.height)
					P_TeleportMove(deco, deco.x, deco.y, deco.ceilingz-deco.height) -- slope hack the second
				end

				if ((deco.subsector.sector != sector) or (P_RandomKey(rarity+1) > 0) or (R_PointInSubsectorOrNil(deco.x, deco.y) == nil)) then
					P_RemoveMobj(deco)
				else
					local deco2 = P_SpawnMobjFromMobj(deco, 0, 0, 0, mobjtype) -- This is the object actually used in game.
					if mobjtype == MT_SPIKE then -- spike-specific setup
						deco2.flags = $ & ~(MF_NOBLOCKMAP|MF_NOGRAVITY|MF_NOCLIPHEIGHT)
						deco2.flags = $ + MF_SOLID
					end
					P_RemoveMobj(deco)
				end

				objSpawnX = $ + grid*FRACUNIT
				--if deco.valid
				--	print(deco + ": x" + tostring(deco.x/FRACUNIT) + "/y" + tostring(deco.y/FRACUNIT) + "/z" + tostring(deco.z/FRACUNIT))
				--end
			end
			objSpawnX = minX
			objSpawnY = $ + grid*FRACUNIT
		end
	end,

	decorate_lists = function(sector)
		if not (mapheaderinfo[gamemap].autodeclist) then return end

		if (mapheaderinfo[gamemap].autodeclist == "2021R2") then
			-- 2021 R2 --

			if sector.floorpic == "CAVEWL7" then
				autodec.decorate(sector, MT_STALAGMITE2, false, true, 320, 32, 4)
				autodec.decorate(sector, MT_STALAGMITE3, false, 512, 16, 4)
			elseif sector.floorpic == "CAVEWLB" then
				autodec.decorate(sector, MT_STALAGMITE4, false, true, 320, 32, 4)
				autodec.decorate(sector, MT_STALAGMITE5, false, true, 512, 16, 4)
			elseif sector.floorpic == "MMBB" then
				autodec.decorate(sector, MT_STALAGMITE4, false, true, 96, 32, 4)
				autodec.decorate(sector, MT_STALAGMITE5, false, true, 192, 16, 4)
			elseif sector.floorpic == "MMBA" then
				autodec.decorate(sector, MT_STALAGMITE2, false, true, 96, 32, 4)
				autodec.decorate(sector, MT_STALAGMITE3, false, true, 192, 16, 4)
			elseif sector.floorpic == "MMB9" then
				autodec.decorate(sector, MT_STALAGMITE0, false, true, 96, 32, 4)
				autodec.decorate(sector, MT_STALAGMITE1, false, true, 192, 16, 4)
			elseif sector.floorpic == "RCZWLL4" then
				autodec.decorate(sector, MT_HHZSTALAGMITE_TALL, false, true, 96, 32, 16)
				autodec.decorate(sector, MT_HHZSTALAGMITE_SHORT, false, true, 192, 16, 16)
			elseif sector.floorpic == "ERZROCK2" then
				autodec.decorate(sector, MT_HHZSTALAGMITE_TALL, false, true, 96, 32, 16)
				autodec.decorate(sector, MT_HHZSTALAGMITE_SHORT, false, true, 192, 16, 16)
			end

			if sector.ceilingpic == "CAVEWL7" then
				autodec.decorate(sector, MT_STALAGMITE2, true, true, 320, 32, 3)
				autodec.decorate(sector, MT_STALAGMITE3, true, true, 512, 16, 3)
			elseif sector.ceilingpic == "CAVEWLB" then
				autodec.decorate(sector, MT_STALAGMITE4, true, true, 320, 32, 3)
				autodec.decorate(sector, MT_STALAGMITE5, true, true, 512, 16, 3)
			elseif sector.ceilingpic == "RVZWALL6" then
				autodec.decorate(sector, MT_STALAGMITE4, true, true, 96, 32, 3)
				autodec.decorate(sector, MT_STALAGMITE5, true, true, 192, 16, 3)
			elseif sector.ceilingpic == "RCZWLL4" then
				autodec.decorate(sector, MT_HHZSTALAGMITE_TALL, true, true, 96, 32, 16)
				autodec.decorate(sector, MT_HHZSTALAGMITE_SHORT, true, true, 192, 16, 16)
			elseif sector.ceilingpic == "ERZROCK2" then
				autodec.decorate(sector, MT_HHZSTALAGMITE_TALL, true, true, 96, 32, 16)
				autodec.decorate(sector, MT_HHZSTALAGMITE_SHORT, true, true, 192, 16, 16)
			end
		elseif (mapheaderinfo[gamemap].autodeclist == "2022R2") then
			-- 2022 R2 --
			if sector.tag == 101 then
				autodec.decorate(sector, MT_SPIKE, false, false, 32, 0, 0)
			end
		end
	end
}

rawset(_G, "autodec", autodec)

addHook("MapLoad", function(mapnum)
	if not (mapheaderinfo[gamemap].autodec) then
		return
	end

	for sector in sectors.iterate do
		autodec.decorate_lists(sector)
	end

	objp_noreloadhack = false
end)

addHook("PlayerSpawn", function(p)
	p.powers[pw_flashing] = 3
	if not objp_noreloadhack then return end
	if not (mapheaderinfo[gamemap].autodec and mapheaderinfo[gamemap].levelflags == LF_NORELOAD) then return end

	for sector in sectors.iterate do
		autodec.decorate_lists(sector)
	end
end)

addHook("MobjDeath", function(pmo, a, b, c)
	objp_noreloadhack = true
end, MT_PLAYER)