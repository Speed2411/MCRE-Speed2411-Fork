freeslot(
    "MT_EGGBALLER",
	"MT_EGGBALLER_FIRE",
    "MT_EGGFREEZER",
    "MT_EGGEBOMBER",
    "MT_FBOSS",
    "MT_FBOSS2",
    "MT_XBOSS",
    "MT_EGGANIMUS",
    "MT_EGGANIMUS_EX",
    "MT_SLOWGOOP",
    "MT_GOGGLESCRAWLA_SLOW",
    "MT_GOGGLESCRAWLA_FAST",
    "MT_ULTRABUZZ",
    "MT_BEETLE",
    "MT_DASHERCRAWLA",
    "MT_CRYOCRAWLA",
    "MT_COCONUTS"
)

local bossesInfo = {
	{MT_EGGANIMUS, "Egg Animus", "MASTER OF LIGHT"},
	{MT_EGGANIMUS_EX, "Egg Animus EX", "MASTER OF LIGHT"},
	{MT_EGGBALLER, "Egg FireBaller", "BLAZING N BALLIN"},
	{MT_EGGEBOMBER, "Egg E-Bomber", "EXPLOSIVE SHOCKER"},
	{MT_EGGFREEZER, "Egg Freezer", "FROZEN NIGHTMARE"},
	{MT_FBOSS, "Egg Fighter", "SPARKING DEFENDER"},
	{MT_FBOSS2, "Egg Fighter", "SPARKING DEFENDER"},
	{MT_XBOSS, "Egg Mobile X", "ARMED SUPER WEAPON"}
}
if yakuzaBossTexts then
	for _,val in ipairs(bossesInfo) do
		if not (val[3]) then
			val[3] = ""
		end
		yakuzaBossTexts[val[1]] = {name = val[2], info = val[3]}
	end
end

if speccyStuff == nil then
	rawset(_G, "speccyStuff", {})
	speccyStuff.BossTable = {}
end

speccyStuff.BossTable[MT_EGGANIMUS] = {"Egg Animus", 75, 1000}
speccyStuff.BossTable[MT_EGGANIMUS_EX] = {"Egg Animus EX", 100, 2500}
speccyStuff.BossTable[MT_EGGBALLER] = {"Egg FireBaller", 25, 100}
speccyStuff.BossTable[MT_EGGEBOMBER] = {"Egg E-Bomber", 45, 250}
speccyStuff.BossTable[MT_EGGFREEZER] = {"Egg Freezer", 35, 350}
speccyStuff.BossTable[MT_FBOSS] = {"Egg Fighter", 45, 500}
speccyStuff.BossTable[MT_FBOSS2] = {"Egg Fighter", 55, 750}
speccyStuff.BossTable[MT_XBOSS] = {"Egg Mobile X", 35, 750}

addHook("MobjSpawn", function(m)
	m.samusHP = 4
	m.spazweak = true
end, MT_COCONUTS)

addHook("MobjSpawn", function(m)
	m.samusHP = 8
	m.spazresist = true
	m.iceresist = true
	m.plasmaresist = true
end, MT_ULTRABUZZ)

addHook("MobjSpawn", function(m)
	m.samusHP = 4
	m.waveweak = true
	m.plasmaresist = true
end, MT_GOGGLESCRAWLA_SLOW)

addHook("MobjSpawn", function(m)
	m.samusHP = 4
	m.waveweak = true
	m.plasmaresist = true
end, MT_GOGGLESCRAWLA_FAST)

addHook("MobjSpawn", function(m)
	m.samusHP = 10
	m.waveweak = true
	m.plasmaresist = true
end, MT_BEETLE)

addHook("MobjSpawn", function(m)
	m.samusHP = 8
	m.waveweak = true
	m.plasmaresist = true
end, MT_DASHERCRAWLA)

addHook("MobjSpawn", function(m)
	m.samusHP = 7
	m.iceresist = true
	m.plasmaweak = true
end, MT_CRYOCRAWLA)

local silveradded = false

addHook("ThinkFrame", function()
	if silv_TKextra ~= nil and silveradded == false then
		silv_TKextra = {
			[MT_SLOWGOOP]	=	{
									noaim = true,
									noroll = true,
									grabf = function(mo, pmo)
										mo.fuse = 2*TICRATE
									end,
									},
			[MT_EGGBALLER_FIRE]	=	{
									noaim = true,
									},
							}
		silveradded = true
	end
end)

addHook("PlayerThink", function(p)
	if p.spectator then return end
	if not p.realmo then return end
	if p.playerstate ~= PST_LIVE then return end
	if p.mo and p.mo.valid and p.mo.skin == "supersonic" then
		p.charability = 18
		if not p.mo.shoespower then
			p.actionspd = 50*FRACUNIT
		end
		if gamemap == 98 or gamemap == 99 then
			if not (leveltime%35)
			and not (p.bot)
			and not (p.mo.state >= S_PLAY_SUPER_TRANS1) and (p.mo.state <= S_PLAY_SUPER_TRANS6) then
				P_GivePlayerRings(p, 1)
			end
		end
		if mrce_hyperstones and (mrce_hyperstones & (1 << (1))) --if we have the fire shard
		and not (p.powers[pw_shield] & SH_FIREFLOWER) --if we are't already in fire form
		and not (p.hyper.transformed) --can't transform from a higher form
		and p.rings >= 75 then
			if (leveltime % 12 == 0) then
				local ghost = P_SpawnMobjFromMobj(p.mo,0,0,0,MT_THOK)
				ghost.angle = p.drawangle
				ghost.rollangle = p.mo.rollangle
				ghost.spritexscale = p.mo.spritexscale
				ghost.spriteyscale = p.mo.spriteyscale
				ghost.skin = p.mo.skin
				ghost.frame = p.mo.frame
				ghost.sprite = p.mo.sprite
				ghost.sprite2 = p.mo.sprite2
				ghost.scale = FRACUNIT
				ghost.destscale = FRACUNIT*5
				ghost.scalespeed = $ / 2
				ghost.color = SKINCOLOR_KETCHUP
				ghost.colorized = true
				ghost.blendmode = AST_ADD
				ghost.fuse = 8
			end
			if p.cmd.buttons & BT_CUSTOM2
			and not p.c2down then
				p.powers[pw_shield] = $|SH_FIREFLOWER
				p.rings = $ - 50
				S_StartSound(nil, sfx_cdfm75)
				S_StartSound(nil, sfx_mario3)
				local ghost2 = P_SpawnMobjFromMobj(p.mo,0,0,0,MT_THOK)
				ghost2.angle = p.drawangle
				ghost2.rollangle = p.mo.rollangle
				ghost2.spritexscale = p.mo.spritexscale
				ghost2.spriteyscale = p.mo.spriteyscale
				ghost2.skin = p.mo.skin
				ghost2.frame = p.mo.frame
				ghost2.sprite = p.mo.sprite
				ghost2.sprite2 = p.mo.sprite2
				ghost2.scale = FRACUNIT
				ghost2.destscale = FRACUNIT*60
				ghost2.color = SKINCOLOR_WHITE
				ghost2.colorized = true
				ghost2.blendmode = AST_ADD
				ghost2.fuse = 8
			end
		end
		p.c2down = (p.cmd.buttons & BT_CUSTOM2)
	end
end)