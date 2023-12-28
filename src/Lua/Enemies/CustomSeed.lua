-- Custom Sonic CD seed
-- by Tatsuru

freeslot("MT_CUSTOMSEED")

mobjinfo[MT_CUSTOMSEED] = {
	//$Name Custom Seed Spawner
	//$Category Mystic Realm Objects
	//$NotAngled
	spawnstate = S_SEED,
	spawnhealth = 1000,
	speed = -2*FRACUNIT,
	radius = 4*FRACUNIT,
	height = 4*FRACUNIT,
	flags = MF_NOBLOCKMAP|MF_SCENERY
}

local seeds = {}

-- Parse the FlowerList parameter
addHook("MapLoad", function(gamemap)
	seeds = {}
	local str = mapheaderinfo[gamemap].flowerlist

	if not str then return end

	-- Get rid of spaces
	str = string.gsub(str, " ", "")

	while #str do
		local c = string.find(str, ",")
		local substr = c and string.sub(str, 1, c - 1) or str

		local _type = _G[substr]

		-- The game already handles invalid MT_ constants so let's handle the ones that aren't object types
		assert(_type and mobjinfo[_type], "FlowerList parameter '" + substr + "' is not a valid object type. Please provide a freeslotted MT_ constant.")

		table.insert(seeds, _type)

		str = c and string.sub(str, c+1) or ""
	end
end)

addHook("MobjSpawn", function(mo)
	P_SetOrigin(mo, mo.x, mo.y, mo.z + 2 * mo.height * P_MobjFlip(mo))
end, MT_CUSTOMSEED)

-- Custom seed thinker!
addHook("MobjThinker", function(mo)
	-- No custom seeds, let's just leave
	if not #seeds then return end

	if P_MobjFlip(mo) * mo.momz < mo.info.speed then
		mo.momz = P_MobjFlip(mo) * mo.info.speed
	end

	if P_CheckDeathPitCollide(mo) then
		P_RemoveMobj(mo)
		return
	end

	if (not (mo.eflags & MFE_VERTICALFLIP) and mo.z <= mo.floorz)
	or (mo.eflags & MFE_VERTICALFLIP and mo.z + mo.height >= mo.ceilingz) then
		-- Pick a random seed from the custom list
		local flowertype = seeds[P_RandomKey(#seeds) + 1]
		local flower = P_SpawnMobjFromMobj(mo, 0, 0, 0, flowertype)

		flower.scale = mo.scale/16
		flower.destscale = mo.scale
		flower.scalespeed = mo.scale/7

		P_RemoveMobj(mo)
		return
	end
end, MT_CUSTOMSEED)

addHook("NetVars", function(net)
	seeds = net($)
end)