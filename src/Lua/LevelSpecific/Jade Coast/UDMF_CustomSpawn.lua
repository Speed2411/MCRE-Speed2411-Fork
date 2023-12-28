freeslot("MT_UDMFCUSTOMSPAWN")

mobjinfo[MT_UDMFCUSTOMSPAWN] = {
	//$Name Custom Spawn
	//$Arg0 SpawnID
	//$Arg1 Invidiual Spawn Point?
	//$Arg1Type 11
	//$Arg2 Ban Netplay?	
	doomednum = 2496,
	spawnstate = S_INVISIBLE,
	spawnhealth = 1,
	speed = 1,
	radius = 24*FRACUNIT,
	height = 32*FRACUNIT,
	mass = 100,
	flags = MF_SCENERY
}

local reset_spawns = false
local last_map = 0
local spawns_points = {}

addHook("MapThingSpawn", function(a, tm)
	if reset_spawns == true then 
		spawns_points = {}
		reset_spawns = false
	end

	local skin_name = tm.stringargs[0]
	local spawn_num = max(min(tm.args[0], 32), 0)
	local spawn_single = tm.args[1]
	local bool_multipl = tm.args[2]	
	
	if bool_multipl > 0 and netgame then
		return
	end
	
	if not spawns_points[skin_name] then
		spawns_points[skin_name] = {}		
	end
	
	local spawns_check = spawns_points[skin_name]
	if spawn_single < 1 and #spawns_check == 0 then
		for i = 0, 32 do
			spawns_points[skin_name][i] = a
		end
	end	
	
	spawns_points[skin_name][spawn_num] = a
end, MT_UDMFCUSTOMSPAWN)

addHook("PlayerSpawn", function(p)
	if p.mo and p.mo.valid and p.starpostnum == 0 then
		local a = p.mo
		local skin_spawnpoint = spawns_points[a.skin]
		if spawns_points[a.skin] then
			local spawnpoint = skin_spawnpoint[#p % 32]
		
			--print(a.skin)
			if spawnpoint and spawnpoint.valid then
				P_SetOrigin(a, spawnpoint.x, spawnpoint.y, spawnpoint.z)
				a.angle = spawnpoint.angle
				a.scale = spawnpoint.scale
				a.spawnpoint_neworigin = spawnpoint 
			end
		end
	end
end)