--thanks Spectrum for this lua, you're amazing

freeslot("MT_ICEBEAM", "MT_ICEBEAMSHARD", "MT_ICEBEAMPARTICLE", "S_ICEBEAMPARTICLE", "MT_ICESCATTER", "MT_ICESCATTERSHARD", "MT_ICEBOMB")


local function IceTouchesSomething(special, toucher)
    if special and special.valid and toucher and toucher.valid and toucher.player and toucher.player.frozen ~= 1 then
        toucher.player.frozen = 1
        if gamemap == 115 then
            toucher.player.frozentimer = 210
        else
            toucher.player.frozentimer = 140
        end
        toucher.player.oldcolor = toucher.color
    end
end

addHook("TouchSpecial", IceTouchesSomething, MT_ICEBEAM)
addHook("TouchSpecial", IceTouchesSomething, MT_ICEBEAMSHARD)
addHook("TouchSpecial", IceTouchesSomething, MT_ICESCATTERSHARD)
addHook("TouchSpecial", IceTouchesSomething, MT_ICESCATTER)

addHook("PlayerThink", function(p)
	p.frozen = $ or 0
	p.frozentimer = $ or 0
	p.oldcolor = $ or 0
	if p.frozen == 1 and p.frozentimer > 0 then
		p.mo.colorized = true
		p.mo.color = SKINCOLOR_ICY
		p.frozentimer = $-1
		p.pflags = $1|PF_FULLSTASIS
		P_SpawnMobjFromMobj(p.mo, (P_RandomRange(-5, 5) * FRACUNIT), (P_RandomRange(-5, 5) * FRACUNIT), ((p.mo.height / 2) + ((P_RandomRange(-3, 3) * FRACUNIT))), MT_ICEBEAMPARTICLE)
		if P_IsObjectOnGround(p.mo) and p.speed == 0 then
			p.mo.flags = $1|MF_NOTHINK
		end
		for mobj in mobjs.iterate() do
			if mobj.type == MT_TAILSOVERLAY and mobj.tracer == p.mo then
				mobj.flags = $1|MF_NOTHINK
			end
		end
	elseif p.oldcolor then
		p.mo.colorized = false
		p.mo.color = p.oldcolor
		p.oldcolor = 0
		p.frozen = 0
		p.pflags = $1 & ~PF_FULLSTASIS
		p.mo.flags = $1 & ~MF_NOTHINK
		for mobj in mobjs.iterate() do
			if mobj.type == MT_TAILSOVERLAY and mobj.tracer == p.mo then
				mobj.flags = $1 & ~MF_NOTHINK
			end
		end
	end
end)

addHook("MobjDeath", function(mo)
	if mo.player and mo.player.oldcolor then
		local p = mo.player
		p.frozen = 0
		p.frozentimer = 0
		mo.color = p.oldcolor
		p.pflags = $1 & ~PF_FULLSTASIS
		mo.flags = $1 & ~MF_NOTHINK
	end
end,MT_PLAYER)

addHook("ShouldDamage", function(mo, i, so)
	if (so and (so.type == MT_ICEBOMB)) then
	return false --No damage from icebombs, ever.
	elseif mo.player and mo.player.oldcolor then
		local p = mo.player
		p.frozen = 0
		p.frozentimer = 0
		mo.color = p.oldcolor
		p.pflags = $1 & ~PF_FULLSTASIS
		mo.flags = $1 & ~MF_NOTHINK
	end
end,MT_PLAYER)

addHook("MobjCollide", function(mo, inflictor)
    if mo.player and mo.player.oldcolor and inflictor.type == not MT_ICEBEAM and MT_ICEBEAMPARTICLE then
        local p = mo.player
        p.frozen = 0
        p.frozentimer = 0
        mo.color = p.oldcolor
        p.pflags = $1 & ~PF_FULLSTASIS
        mo.flags = $1 & ~MF_NOTHINK
    end
end,MT_PLAYER)

--Put in by Golden Shine. Ignore these ice bombs entirely. Also put in a shoulddamage check up there.

local function iceignore(s, m)
	if m and m.player then
		return false --Ignore Ice Bombs all the time.
	end
end
addHook("MobjCollide", iceignore, MT_ICEBOMB)
addHook("MobjMoveCollide", iceignore, MT_ICEBOMB)

local function pinchsmoke(bossmo, MT_EGGFREEZER)
	if bossmo.health <= 3 then
		bossmo.ghs = P_SpawnMobj(bossmo.x+P_RandomRange(-20, 20)*FRACUNIT, bossmo.y+P_RandomRange(-20, 20)*FRACUNIT, bossmo.z+P_RandomRange(-10, 40)*FRACUNIT, MT_THOK)
		bossmo.ghs.sprite = SPR_SMOK
		bossmo.ghs.frame = A|(TR_TRANS10+(P_RandomRange(2,7)*FRACUNIT))
		bossmo.ghs.scale = bossmo.scale*P_RandomRange(1,2)
		bossmo.ghs.momz = P_RandomRange(0, 9)*FRACUNIT
		bossmo.ghs = P_SpawnMobj(bossmo.x+P_RandomRange(-20, 20)*FRACUNIT, bossmo.y+P_RandomRange(-20, 20)*FRACUNIT, bossmo.z+P_RandomRange(-10, 40)*FRACUNIT, MT_THOK)
		bossmo.ghs.sprite = SPR_SMOK
		bossmo.ghs.frame = A|(TR_TRANS10+(P_RandomRange(2,7)*FRACUNIT))
		bossmo.ghs.scale = bossmo.scale*P_RandomRange(1,2)
		bossmo.ghs.momz = P_RandomRange(0, 9)*FRACUNIT
	end
end

addHook("BossThinker", pinchsmoke, MT_EGGFREEZER)

addHook("MobjSpawn", function(m)
	m.iceresist = true
	m.plasmaweak = true
end, MT_EGGFREEZER)