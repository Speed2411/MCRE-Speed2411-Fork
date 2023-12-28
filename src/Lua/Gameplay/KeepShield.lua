local shield = 0

local function sp()
	if multiplayer then return false end
	if marathonmode then return false end
	if modeattacking then return false end
	if ultimatemode then return false end
	if not gamecomplete then return false end
	return true
end

addHook("PlayerThink", function(p)
	if not (p and p.mo and p.mo.valid and (gametyperules & GTR_FRIENDLY)) then return end
	if not (p.exiting or (p.mrce and p.mrce.spawnshield)) then return end
	if (p.mrce and p.mrce.spawnshield == 0) then
		p.keepshield = p.powers[pw_shield]
	elseif p.mrce then
		p.keepshield = p.mrce.spawnshield
		if shield != p.mrce.spawnshield then
			shield = p.mrce.spawnshield
		end
	end
end)

addHook("PlayerSpawn", function(p)
	if (p.keepshield == nil and p.mrce and p.mrce.spawnshield == 0) or not (gametyperules & GTR_FRIENDLY) then return end
	if p.mo.skin == "mario" or p.mo.skin == "skip" or p.mo.skin == "luigi" then return end
	if (mapheaderinfo[gamemap].actnum == 1 and (shield == 0)) then return end
	if p.keepshield == nil then p.keepshield = 0 end
	if sp() and shield then
		p.powers[pw_shield] = shield
	else
		p.powers[pw_shield] = p.keepshield
	end
	P_SpawnShieldOrb(p)
	p.keepshield = nil
end)

local monitors = {
	MT_FLAMEAURA_BOX,
	MT_SNEAKERS_BOX,
	MT_RING_BOX,
	MT_ATTRACT_BOX,
	MT_FORCE_BOX,
	MT_ARMAGEDDON_BOX,
	MT_WHIRLWIND_BOX,
	MT_ELEMENTAL_BOX,
	MT_INVULN_BOX,
	MT_1UP_BOX
}

addHook("MapLoad", function(map)
	for k, v in pairs(monitors) do
		mobjinfo[v].height = 52*FRACUNIT
	end
end)