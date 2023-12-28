freeslot(
    "S_LIGHTNING_STONE",
    "S_FIRE_STONE",
    "S_WATER_STONE",
    "SPR_KYST"
)

mobjinfo[MT_LIGHTNING_STONE] = {
//$Title Elemental Shard
//$Sprite KYSTA0
//$Category Mystic Realm Special
//$NotAngled
	doomednum = 3110,
	spawnstate = S_LIGHTNING_STONE,
	radius = 28*FRACUNIT,
	height = 38*FRACUNIT,
	flags = MF_NOGRAVITY|MF_SPECIAL
}

states[S_LIGHTNING_STONE] = {
	sprite = SPR_KYST,
	frame = A,
}

addHook("TouchSpecial", function(mo, toucher)
	if mo and mo.valid then
		if mapheaderinfo[gamemap].lvlttl != "Starlight Palace" then
			if not (GlobalBanks_Array[0] & (1 << (15))) then
				GlobalBanks_Array[0] = $ | (1 << (15))
				mrce_hyperstones = $ | (1 << (0))
				S_StartSound(null, sfx_cdfm63)
			end
		else
			return true
		end
	end
end, MT_LIGHTNING_STONE)

addHook("MobjThinker", function(mo)
	if mo and mo.valid then
		if leveltime > 3 then
			if (GlobalBanks_Array[0] & (1 << (15)))
			and mapheaderinfo[gamemap].lvlttl != "Starlight Palace" then
				P_RemoveMobj(mo)
			elseif mapheaderinfo[gamemap].lvlttl == "Starlight Palace"
			and not (GlobalBanks_Array[0] & (1 << (15))) then
				P_RemoveMobj(mo)
			end
		end
	end
end, MT_LIGHTNING_STONE)

mobjinfo[MT_FIRE_STONE] = {
	doomednum = 3111,
	spawnstate = S_FIRE_STONE,
	radius = 28*FRACUNIT,
	height = 38*FRACUNIT,
	flags = MF_NOGRAVITY|MF_SPECIAL
}

states[S_FIRE_STONE] = {
	sprite = SPR_KYST,
	frame = B,
}

addHook("TouchSpecial", function(mo, toucher)
	if mo and mo.valid then
		if mapheaderinfo[gamemap].lvlttl != "Starlight Palace" then
			if not (GlobalBanks_Array[0] & (1 << (16))) then
				GlobalBanks_Array[0] = $ | (1 << (16))
				mrce_hyperstones = $ | (1 << (1))
				S_StartSound(null, sfx_cdfm63)
			end
		else
			return true
		end
	end
end, MT_FIRE_STONE)

addHook("MobjThinker", function(mo)
	if mo and mo.valid then
		if leveltime > 3 then
			if (GlobalBanks_Array[0] & (1 << (16)))
			and mapheaderinfo[gamemap].lvlttl != "Starlight Palace" then
				P_RemoveMobj(mo)
			elseif mapheaderinfo[gamemap].lvlttl == "Starlight Palace"
			and not (GlobalBanks_Array[0] & (1 << (16))) then
				P_RemoveMobj(mo)
			end
		end
	end
end, MT_FIRE_STONE)

mobjinfo[MT_WATER_STONE] = {
	doomednum = 3112,
	spawnstate = S_WATER_STONE,
	radius = 28*FRACUNIT,
	height = 38*FRACUNIT,
	flags = MF_NOGRAVITY|MF_SPECIAL
}

states[S_WATER_STONE] = {
	sprite = SPR_KYST,
	frame = C,
}

addHook("TouchSpecial", function(mo, toucher)
	if mo and mo.valid then
		if mapheaderinfo[gamemap].lvlttl != "Starlight Palace" then
			if not (GlobalBanks_Array[0] & (1 << (17))) then
				GlobalBanks_Array[0] = $ | (1 << (17))
				mrce_hyperstones = $ | (1 << (2))
				S_StartSound(null, sfx_cdfm63)
			end
		else
			return true
		end
	end
end, MT_WATER_STONE)

addHook("MobjThinker", function(mo)
	if mo and mo.valid then
		if leveltime > 3 then
			if (GlobalBanks_Array[0] & (1 << (17)))
			and mapheaderinfo[gamemap].lvlttl != "Starlight Palace" then
				P_RemoveMobj(mo)
			elseif mapheaderinfo[gamemap].lvlttl == "Starlight Palace"
			and not (GlobalBanks_Array[0] & (1 << (17))) then
				P_RemoveMobj(mo)
			end
		end
	end
end, MT_WATER_STONE)