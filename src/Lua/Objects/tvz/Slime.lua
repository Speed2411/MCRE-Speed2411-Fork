freeslot(
"MT_CYANSLIME",
"S_CYANSLIME",
"S_CYANSLIME_XPLD",
"MT_CYANSLIME_DRIP",
"S_CYANSLIME_DRIP",
"MT_CYANSLIME_DRIP_FAST",
"S_CYANSLIME_DRIP_FAST",
"MT_ORANGESLIME",
"S_ORANGESLIME",
"S_ORANGESLIME_XPLD",
"MT_ORANGESLIME_DRIP",
"S_ORANGESLIME_DRIP",
"MT_ORANGESLIME_DRIP_FAST",
"S_ORANGESLIME_DRIP_FAST",
"MT_BLUESLIME",
"S_BLUESLIME",
"S_BLUESLIME_XPLD",
"MT_BLUESLIME_DRIP",
"S_BLUESLIME_DRIP",
"MT_BLUESLIME_DRIP_FAST",
"S_BLUESLIME_DRIP_FAST",
"MT_CLEARSLIME",
"S_CLEARSLIME",
"S_CLEARSLIME_XPLD",
"MT_CLEARSLIME_DRIP",
"S_CLEARSLIME_DRIP",
"MT_CLEARSLIME_DRIP_FAST",
"S_CLEARSLIME_DRIP_FAST",
"SPR_TVGP",
"MT_SNAILA",
"S_SNAILA_LOOK",
"S_SNAILA_CRAWL1",
"S_SNAILA_CRAWL2",
"S_SNAILA_CRAWL3",
"S_SNAILA_CRAWL4",
"S_SNAILA_CRAWL5",
"S_SNAILA_CRAWL6",
"S_SNAILA_CRAWL7",
"SPR_SNAL",
"MT_OCTOOP",
"S_OCTOOP",
"MT_OCTOOP_TENTACLE_PURPLE",
"S_OCTOOP_TENTACLE_PURPLE",
"MT_OCTOOP_TENTACLE_YELLOW",
"S_OCTOOP_TENTACLE_YELLOW",
"MT_OCTOOP_TENTACLE_END",
"S_OCTOOP_TENTACLE_END",
"MT_OCTOOP_PROJECTILE",
"S_OCTOOP_PROJECTILE",
"SPR_OCTO",
"SPR_TNCL",
"SPR_OCGP",
"MT_MOSQUITO",
"S_MOSQUITO",
"SPR_MOSQ",
"MT_MOSQUITO_BOMBHOLDER",
"S_MOSQUITO_BOMBHOLDER",
"SPR_MOHL",
"MT_CYANSLIME_BOMB",
"S_CYANSLIME_BOMB",
"MT_ORANGESLIME_BOMB",
"S_ORANGESLIME_BOMB",
"MT_BLUESLIME_BOMB",
"S_BLUESLIME_BOMB",
"MT_CLEARSLIME_BOMB",
"S_CLEARSLIME_BOMB",
"SPR_SLSP"
)

mobjinfo[MT_SNAILA] = {
	doomednum = 3101,
    spawnstate = S_SNAILA_LOOK,
    spawnhealth = 1,
    seestate = S_SNAILA_CRAWL1,
    deathstate = S_XPLD_FLICKY,
    deathsound = sfx_pop,
    speed = 8,
    radius = 24*FRACUNIT,
    height = 32*FRACUNIT,
    raisestate = MT_BLUESLIME,
    flags = MF_ENEMY|MF_SPECIAL|MF_SHOOTABLE
}

states[S_SNAILA_LOOK] = {SPR_SNAL, A, 5, A_Look, 0, 0, S_SNAILA_LOOK}
states[S_SNAILA_CRAWL1] = {SPR_SNAL, A, 3, A_Chase, 0, 0, S_SNAILA_CRAWL2}
states[S_SNAILA_CRAWL2] = {SPR_SNAL, B, 3, A_Chase, 0, 0, S_SNAILA_CRAWL3}
states[S_SNAILA_CRAWL3] = {SPR_SNAL, C, 3, A_Chase, 0, 0, S_SNAILA_CRAWL4}
states[S_SNAILA_CRAWL4] = {SPR_SNAL, D, 3, A_Chase, 0, 0, S_SNAILA_CRAWL5}
states[S_SNAILA_CRAWL5] = {SPR_SNAL, E, 3, A_Chase, 0, 0, S_SNAILA_CRAWL6}
states[S_SNAILA_CRAWL6] = {SPR_SNAL, F, 3, A_Chase, 0, 0, S_SNAILA_CRAWL7}
states[S_SNAILA_CRAWL7] = {SPR_SNAL, F, 0, A_DropMine, 0, 0, S_SNAILA_CRAWL1}



mobjinfo[MT_OCTOOP] = {
	doomednum = 3108,
	spawnstate = S_OCTOOP,
	spawnhealth = 1,
	deathstate = S_XPLD_FLICKY,
	deathsound = sfx_pop,
	radius = 24*FRACUNIT,
	height = 72*FRACUNIT,
	flags = MF_ENEMY|MF_SPECIAL|MF_SHOOTABLE|MF_NOGRAVITY
}

states[S_OCTOOP] = {
	sprite = SPR_OCTO,
	frame = A,
	tics = -1,
	nextstate = S_OCTOOP
}

mobjinfo[MT_OCTOOP_TENTACLE_PURPLE] = {
	doomednum = -1,
	spawnstate = S_OCTOOP_TENTACLE_PURPLE,
	spawnhealth = 1,
	deathstate = S_XPLD1,
	radius = 4*FRACUNIT,
	height = 4*FRACUNIT,
	dispoffset = -2,
	flags = MF_NOBLOCKMAP|MF_NOGRAVITY
}

states[S_OCTOOP_TENTACLE_PURPLE] = {
	sprite = SPR_TNCL,
	frame = A,
	tics = -1,
	nextstate = S_OCTOOP_TENTACLE_PURPLE
}

mobjinfo[MT_OCTOOP_TENTACLE_YELLOW] = {
	doomednum = -1,
	spawnstate = S_OCTOOP_TENTACLE_YELLOW,
	spawnhealth = 1,
	deathstate = S_XPLD1,
	radius = 4*FRACUNIT,
	height = 4*FRACUNIT,
	dispoffset = -2,
	flags = MF_NOBLOCKMAP|MF_NOGRAVITY
}

states[S_OCTOOP_TENTACLE_YELLOW] = {
	sprite = SPR_TNCL,
	frame = B,
	tics = -1,
	nextstate = S_OCTOOP_TENTACLE_YELLOW
}

mobjinfo[MT_OCTOOP_TENTACLE_END] = {
	doomednum = -1,
	spawnstate = S_OCTOOP_TENTACLE_END,
	spawnhealth = 1,
	deathstate = S_XPLD1,
	radius = 4*FRACUNIT,
	height = 12*FRACUNIT,
	dispoffset = -2,
	flags = MF_NOBLOCKMAP|MF_NOGRAVITY
}

states[S_OCTOOP_TENTACLE_END] = {
	sprite = SPR_TNCL,
	frame = C,
	tics = -1,
	nextstate = S_OCTOOP_TENTACLE_END
}

mobjinfo[MT_OCTOOP_PROJECTILE] = {
	doomednum = -1,
	spawnstate = S_OCTOOP_PROJECTILE,
	spawnhealth = 1,
	radius = 16*FRACUNIT,
	height = 16*FRACUNIT,
	flags = MF_SPECIAL|MF_MISSILE
}

states[S_OCTOOP_PROJECTILE] = {
	sprite = SPR_CANG,
	frame = A|TR_TRANS20,
	tics = -1,
	nextstate = S_OCTOOP_PROJECTILE
}



mobjinfo[MT_MOSQUITO] = {
	doomednum = 3109,
	spawnstate = S_MOSQUITO,
	spawnhealth = 1,
	deathstate = S_XPLD_FLICKY,
	deathsound = sfx_pop,
	radius = 8*FRACUNIT,
	height = 28*FRACUNIT,
	flags = MF_ENEMY|MF_SPECIAL|MF_SHOOTABLE|MF_NOGRAVITY
}

states[S_MOSQUITO] = {
	sprite = SPR_MOSQ,
	frame = A,
	tics = -1,
	nextstate = S_MOSQUITO
}

mobjinfo[MT_MOSQUITO_BOMBHOLDER] = {
	doomednum = -1,
	spawnstate = S_MOSQUITO_BOMBHOLDER,
	spawnhealth = 1,
	radius = 4*FRACUNIT,
	height = 4*FRACUNIT,
	flags = MF_NOGRAVITY
}

states[S_MOSQUITO_BOMBHOLDER] = {
	sprite = SPR_MOHL,
	frame = A,
	tics = -1,
	nextstate = S_MOSQUITO_BOMBHOLDER
}




mobjinfo[MT_CYANSLIME_BOMB] = {
	doomednum = 5001,
	spawnstate = S_CYANSLIME_BOMB,
	spawnhealth = 1,
	radius = 8*FRACUNIT,
	height = 8*FRACUNIT,
	flags = MF_SPECIAL|MF_NOGRAVITY
}

states[S_CYANSLIME_BOMB] = {
	sprite = SPR_SLSP,
	frame = A,
	tics = -1,
	nextstate = S_CYANSLIME_BOMB
}

mobjinfo[MT_ORANGESLIME_BOMB] = {
	doomednum = 5002,
	spawnstate = S_ORANGESLIME_BOMB,
	spawnhealth = 1,
	radius = 8*FRACUNIT,
	height = 8*FRACUNIT,
	flags = MF_SPECIAL|MF_NOGRAVITY
}

states[S_ORANGESLIME_BOMB] = {
	sprite = SPR_SLSP,
	frame = B,
	tics = -1,
	nextstate = S_ORANGESLIME_BOMB
}

mobjinfo[MT_BLUESLIME_BOMB] = {
	doomednum = 5003,
	spawnstate = S_BLUESLIME_BOMB,
	spawnhealth = 1,
	radius = 8*FRACUNIT,
	height = 8*FRACUNIT,
	flags = MF_SPECIAL|MF_NOGRAVITY
}

states[S_BLUESLIME_BOMB] = {
	sprite = SPR_SLSP,
	frame = C,
	tics = -1,
	nextstate = S_BLUESLIME_BOMB
}

mobjinfo[MT_CLEARSLIME_BOMB] = {
	doomednum = 5004,
	spawnstate = S_CLEARSLIME_BOMB,
	spawnhealth = 1,
	radius = 8*FRACUNIT,
	height = 8*FRACUNIT,
	flags = MF_SPECIAL|MF_NOGRAVITY
}

states[S_CLEARSLIME_BOMB] = {
	sprite = SPR_SLSP,
	frame = D,
	tics = -1,
	nextstate = S_CLEARSLIME_BOMB
}



mobjinfo[MT_CYANSLIME] = {
	doomednum = -1,
    spawnstate = S_CYANSLIME,
    spawnhealth = 1,
    seestate = 0,
    seesound = 0,
    reactiontime = 0,
    attacksound = 0,
    painstate = 0,
    painchance = 0,
    painsound = 0,
    meleestate = 0,
    missilestate = 0,
    deathstate = S_CYANSLIME_XPLD,
    xdeathstate = 0,
    deathsound = sfx_ghit,
    speed = 0,
    radius = 16*FRACUNIT,
    height = 16*FRACUNIT,
    dispoffset = 0,
    mass = 0,
    damage = 0,
    activesound = 0,
    raisestate = 0,
    flags = MF_SPECIAL
}

mobjinfo[MT_CYANSLIME_DRIP] = {
	doomednum = -1,
    spawnstate = S_CYANSLIME_DRIP,
    spawnhealth = 1,
    seestate = 0,
    seesound = 0,
    reactiontime = 0,
    attacksound = 0,
    painstate = 0,
    painchance = 0,
    painsound = 0,
    meleestate = 0,
    missilestate = 0,
    deathstate = 0,
    xdeathstate = 0,
    deathsound = sfx_None,
    speed = 0,
    radius = 8*FRACUNIT,
    height = 8*FRACUNIT,
    dispoffset = 0,
    mass = 0,
    damage = 0,
    activesound = 0,
    raisestate = 0,
    flags = MF_SCENERY|MF_NOCLIPTHING
}

mobjinfo[MT_CYANSLIME_DRIP_FAST] = {
	doomednum = -1,
    spawnstate = S_CYANSLIME_DRIP_FAST,
    spawnhealth = 1,
    seestate = 0,
    seesound = 0,
    reactiontime = 0,
    attacksound = 0,
    painstate = 0,
    painchance = 0,
    painsound = 0,
    meleestate = 0,
    missilestate = 0,
    deathstate = 0,
    xdeathstate = 0,
    deathsound = sfx_None,
    speed = 0,
    radius = 8*FRACUNIT,
    height = 8*FRACUNIT,
    dispoffset = 0,
    mass = 0,
    damage = 0,
    activesound = 0,
    raisestate = 0,
    flags = MF_SCENERY|MF_NOCLIPTHING
}

states[S_CYANSLIME] = {SPR_TVGP, A|FF_FULLBRIGHT|FF_TRANS40, 105, nil, 0, 0, S_NULL}
states[S_CYANSLIME_XPLD] = {SPR_TVGP, A|FF_FULLBRIGHT|FF_TRANS40, 1, nil, 0, 0, S_NULL}
states[S_CYANSLIME_DRIP] = {SPR_TVGP, B|FF_FULLBRIGHT|FF_TRANS60, 6*TICRATE, nil, 0, 0, S_NULL}
states[S_CYANSLIME_DRIP_FAST] = {SPR_TVGP, B|FF_FULLBRIGHT|FF_TRANS60, TICRATE/2, nil, 0, 0, S_NULL}

mobjinfo[MT_ORANGESLIME] = {
	doomednum = -1,
    spawnstate = S_ORANGESLIME,
    spawnhealth = 1,
    seestate = 0,
    seesound = 0,
    reactiontime = 0,
    attacksound = 0,
    painstate = 0,
    painchance = 0,
    painsound = 0,
    meleestate = 0,
    missilestate = 0,
    deathstate = S_ORANGESLIME_XPLD,
    xdeathstate = 0,
    deathsound = sfx_ghit,
    speed = 0,
    radius = 16*FRACUNIT,
    height = 16*FRACUNIT,
    dispoffset = 0,
    mass = 0,
    damage = 0,
    activesound = 0,
    raisestate = 0,
    flags = MF_SPECIAL
}

mobjinfo[MT_ORANGESLIME_DRIP] = {
	doomednum = -1,
    spawnstate = S_ORANGESLIME_DRIP,
    spawnhealth = 1,
    seestate = 0,
    seesound = 0,
    reactiontime = 0,
    attacksound = 0,
    painstate = 0,
    painchance = 0,
    painsound = 0,
    meleestate = 0,
    missilestate = 0,
    deathstate = 0,
    xdeathstate = 0,
    deathsound = sfx_None,
    speed = 0,
    radius = 8*FRACUNIT,
    height = 8*FRACUNIT,
    dispoffset = 0,
    mass = 0,
    damage = 0,
    activesound = 0,
    raisestate = 0,
    flags = MF_SCENERY|MF_NOCLIPTHING
}

mobjinfo[MT_ORANGESLIME_DRIP_FAST] = {
	doomednum = -1,
    spawnstate = S_ORANGESLIME_DRIP_FAST,
    spawnhealth = 1,
    seestate = 0,
    seesound = 0,
    reactiontime = 0,
    attacksound = 0,
    painstate = 0,
    painchance = 0,
    painsound = 0,
    meleestate = 0,
    missilestate = 0,
    deathstate = 0,
    xdeathstate = 0,
    deathsound = sfx_None,
    speed = 0,
    radius = 8*FRACUNIT,
    height = 8*FRACUNIT,
    dispoffset = 0,
    mass = 0,
    damage = 0,
    activesound = 0,
    raisestate = 0,
    flags = MF_SCENERY|MF_NOCLIPTHING
}

states[S_ORANGESLIME] = {SPR_TVGP, C|FF_FULLBRIGHT|FF_TRANS40, 105, nil, 0, 0, S_NULL}
states[S_ORANGESLIME_XPLD] = {SPR_TVGP, C|FF_FULLBRIGHT|FF_TRANS40, 1, nil, 0, 0, S_NULL}
states[S_ORANGESLIME_DRIP] = {SPR_TVGP, D|FF_FULLBRIGHT|FF_TRANS60, 6*TICRATE, nil, 0, 0, S_NULL}
states[S_ORANGESLIME_DRIP_FAST] = {SPR_TVGP, D|FF_FULLBRIGHT|FF_TRANS60, TICRATE/2, nil, 0, 0, S_NULL}

mobjinfo[MT_BLUESLIME] = {
	doomednum = -1,
    spawnstate = S_BLUESLIME,
    spawnhealth = 1,
    seestate = 0,
    seesound = 0,
    reactiontime = 0,
    attacksound = 0,
    painstate = 0,
    painchance = 0,
    painsound = 0,
    meleestate = 0,
    missilestate = 0,
    deathstate = S_BLUESLIME_XPLD,
    xdeathstate = 0,
    deathsound = sfx_ghit,
    speed = 0,
    radius = 16*FRACUNIT,
    height = 16*FRACUNIT,
    dispoffset = 0,
    mass = 0,
    damage = 0,
    activesound = 0,
    raisestate = 0,
    flags = MF_SPECIAL
}

mobjinfo[MT_BLUESLIME_DRIP] = {
	doomednum = -1,
    spawnstate = S_BLUESLIME_DRIP,
    spawnhealth = 1,
    seestate = 0,
    seesound = 0,
    reactiontime = 0,
    attacksound = 0,
    painstate = 0,
    painchance = 0,
    painsound = 0,
    meleestate = 0,
    missilestate = 0,
    deathstate = 0,
    xdeathstate = 0,
    deathsound = sfx_None,
    speed = 0,
    radius = 8*FRACUNIT,
    height = 8*FRACUNIT,
    dispoffset = 0,
    mass = 0,
    damage = 0,
    activesound = 0,
    raisestate = 0,
    flags = MF_SCENERY|MF_NOCLIPTHING
}

mobjinfo[MT_BLUESLIME_DRIP_FAST] = {
	doomednum = -1,
    spawnstate = S_BLUESLIME_DRIP_FAST,
    spawnhealth = 1,
    seestate = 0,
    seesound = 0,
    reactiontime = 0,
    attacksound = 0,
    painstate = 0,
    painchance = 0,
    painsound = 0,
    meleestate = 0,
    missilestate = 0,
    deathstate = 0,
    xdeathstate = 0,
    deathsound = sfx_None,
    speed = 0,
    radius = 8*FRACUNIT,
    height = 8*FRACUNIT,
    dispoffset = 0,
    mass = 0,
    damage = 0,
    activesound = 0,
    raisestate = 0,
    flags = MF_SCENERY|MF_NOCLIPTHING
}

states[S_BLUESLIME] = {SPR_TVGP, E|FF_FULLBRIGHT|FF_TRANS40, 105, nil, 0, 0, S_NULL}
states[S_BLUESLIME_XPLD] = {SPR_TVGP, E|FF_FULLBRIGHT|FF_TRANS40, 1, nil, 0, 0, S_NULL}
states[S_BLUESLIME_DRIP] = {SPR_TVGP, F|FF_FULLBRIGHT|FF_TRANS60, 6*TICRATE, nil, 0, 0, S_NULL}
states[S_BLUESLIME_DRIP_FAST] = {SPR_TVGP, F|FF_FULLBRIGHT|FF_TRANS60, TICRATE/2, nil, 0, 0, S_NULL}

mobjinfo[MT_CLEARSLIME] = {
	doomednum = -1,
    spawnstate = S_CLEARSLIME,
    spawnhealth = 1,
    seestate = 0,
    seesound = 0,
    reactiontime = 0,
    attacksound = 0,
    painstate = 0,
    painchance = 0,
    painsound = 0,
    meleestate = 0,
    missilestate = 0,
    deathstate = S_CLEARSLIME_XPLD,
    xdeathstate = 0,
    deathsound = sfx_ghit,
    speed = 0,
    radius = 16*FRACUNIT,
    height = 16*FRACUNIT,
    dispoffset = 0,
    mass = 0,
    damage = 0,
    activesound = 0,
    raisestate = 0,
    flags = MF_SPECIAL
}

mobjinfo[MT_CLEARSLIME_DRIP] = {
	doomednum = -1,
    spawnstate = S_CLEARSLIME_DRIP,
    spawnhealth = 1,
    seestate = 0,
    seesound = 0,
    reactiontime = 0,
    attacksound = 0,
    painstate = 0,
    painchance = 0,
    painsound = 0,
    meleestate = 0,
    missilestate = 0,
    deathstate = 0,
    xdeathstate = 0,
    deathsound = sfx_None,
    speed = 0,
    radius = 8*FRACUNIT,
    height = 8*FRACUNIT,
    dispoffset = 0,
    mass = 0,
    damage = 0,
    activesound = 0,
    raisestate = 0,
    flags = MF_SCENERY|MF_NOCLIPTHING
}

mobjinfo[MT_CLEARSLIME_DRIP_FAST] = {
	doomednum = -1,
    spawnstate = S_CLEARSLIME_DRIP_FAST,
    spawnhealth = 1,
    seestate = 0,
    seesound = 0,
    reactiontime = 0,
    attacksound = 0,
    painstate = 0,
    painchance = 0,
    painsound = 0,
    meleestate = 0,
    missilestate = 0,
    deathstate = 0,
    xdeathstate = 0,
    deathsound = sfx_None,
    speed = 0,
    radius = 8*FRACUNIT,
    height = 8*FRACUNIT,
    dispoffset = 0,
    mass = 0,
    damage = 0,
    activesound = 0,
    raisestate = 0,
    flags = MF_SCENERY|MF_NOCLIPTHING
}

states[S_CLEARSLIME] = {SPR_TVGP, G|FF_FULLBRIGHT|FF_TRANS40, 105, nil, 0, 0, S_NULL}
states[S_CLEARSLIME_XPLD] = {SPR_TVGP, G|FF_FULLBRIGHT|FF_TRANS40, 1, nil, 0, 0, S_NULL}
states[S_CLEARSLIME_DRIP] = {SPR_TVGP, H|FF_FULLBRIGHT|FF_TRANS60, 6*TICRATE, nil, 0, 0, S_NULL}
states[S_CLEARSLIME_DRIP_FAST] = {SPR_TVGP, H|FF_FULLBRIGHT|FF_TRANS60, TICRATE/2, nil, 0, 0, S_NULL}

addHook("MobjLineCollide", function(mo, line)
	if mo.z < line.frontsector.floorheight
	or mo.z > line.frontsector.ceilingheight then
		print("touching wall")
	end
end, MT_PLAYER)

//fof
//backside

//5000 cyan pool
//6000 orange pool
//7000 blue pool

//5500 cyan slimefall
//6500 orange slimefall
//7500 blue slimefall
//8500 clear slimefall

//slime spill function by Radicalicious
local function GoopParticleSpillage(origin, spilltype, spillpower_horizontal, spillpower_vertical, particlecount)
	for i = 0, particlecount, 1 do // Repeat for every particle needed.
		local particle = P_SpawnMobjFromMobj(origin, 0, 0, 0, spilltype) // Spill some particles!.
		particle.momx = P_RandomRange((spillpower_horizontal - (spillpower_horizontal*2)), spillpower_horizontal) * FRACUNIT // Apply random momentum values.
		particle.momy = P_RandomRange((spillpower_horizontal - (spillpower_horizontal*2)), spillpower_horizontal) * FRACUNIT
		particle.momz = P_RandomRange(0, spillpower_vertical) * FRACUNIT // Use a special vertical momentum value.
	end
end

local function GoopParticleSpillageNoScale(origin, spilltype, spillpower_horizontal, spillpower_vertical, particlecount)
	for i = 0, particlecount, 1 do
		local particle = P_SpawnMobj(origin.x, origin.y, origin.z, spilltype)
		particle.momx = P_RandomRange((spillpower_horizontal - (spillpower_horizontal*2)), spillpower_horizontal) * FRACUNIT
		particle.momy = P_RandomRange((spillpower_horizontal - (spillpower_horizontal*2)), spillpower_horizontal) * FRACUNIT
		particle.momz = P_RandomRange(0, spillpower_vertical) * FRACUNIT
	end
end

local slimetics = 20*TICRATE //6*TICRATE

addHook("PlayerThink", function(p)
	if not p.mo.touchingslimecolor then
		p.mo.touchingslimecolor = "unassigned"
	end

	if not p.mo.coatingslimecolor then
		p.mo.coatingslimecolor = "unassigned"
	end

	if not p.mo.slimetimer then
		p.mo.slimetimer = 0
	end



	//for var1 in thefuckbuddy(a, b)
		//print(var1)
	//end

	//casioloopy()



	//for i=1, #stupidtable
		//print(i.." "..stupidtable[i])
	//end

	//for k,v in list_iter(stupidtable)
		//print(k,v)
	//end

	//for k,v in pairs(stupidkeytable)
		//print(k,v)
	//end

	//for k,v in ipairs(stupidtable)
		//print(k,v)
	//end



	for sector in sectors.iterate do

		if sector.tag == 5000 then
			for i=0, #sector.lines-1, 1 do
				for rover in p.mo.subsector.sector.ffloors() do
					if rover.sector.tag == sector.lines[i].tag
					and not (p.mo.z < (rover.bottomheight + 16*FRACUNIT) or p.mo.z > (rover.topheight + 16*FRACUNIT)) then
						//p.mo.touchingslimecolor = "cyan"
						//p.mo.touchingslimetimer = 2
						GoopParticleSpillage(p.mo, MT_CYANSLIME_DRIP_FAST, 6, 6, 48)
						if p.mo.coatingslimecolor == "orange" then
							GoopParticleSpillage(p.mo, MT_ORANGESLIME_DRIP_FAST, 6, 6, 48)
							p.mo.momz = -$ * 2
						elseif p.mo.coatingslimecolor == "blue" then
							GoopParticleSpillage(p.mo, MT_BLUESLIME_DRIP_FAST, 6, 6, 48)
							p.mo.momz = -$ * (1+(1/8))
						else
							p.mo.momz = -$ * (1+(1/2))
						end
					end
				end
			end
		elseif sector.tag == 6000 then
			for i=0, #sector.lines-1, 1 do
				for rover in p.mo.subsector.sector.ffloors() do
					if rover.sector.tag == sector.lines[i].tag
					and not (p.mo.z < rover.bottomheight or p.mo.z > rover.topheight) then
						p.mo.touchingslimecolor = "orange"
						p.mo.touchingslimetimer = 2
						if (p.mo.momx > 0) or (p.mo.momy > 0) then
							GoopParticleSpillage(p.mo, MT_ORANGESLIME_DRIP_FAST, 6, 6, 12)
						end
						if p.mo.coatingslimecolor == "cyan" then
							//GoopParticleSpillage(p.mo, MT_ORANGESLIME_DRIP_FAST, 6, 6, 48)
							GoopParticleSpillage(p.mo, MT_CYANSLIME_DRIP_FAST, 6, 6, 48)
							p.mo.momz = -$ * 2
						elseif p.mo.coatingslimecolor == "blue" then
							p.normalspeed = (skins[p.mo.skin].normalspeed)
							p.acceleration = (skins[p.mo.skin].acceleration)
							p.thrustfactor = (skins[p.mo.skin].thrustfactor)
							p.accelstart = (skins[p.mo.skin].accelstart)
							p.mindash = (skins[p.mo.skin].mindash)
							p.maxdash = (skins[p.mo.skin].maxdash)
						end
					end
				end
			end
		elseif sector.tag == 7000 then
			for i=0, #sector.lines-1, 1 do
				for rover in p.mo.subsector.sector.ffloors() do
					if rover.sector.tag == sector.lines[i].tag
					and not (p.mo.z < rover.bottomheight or p.mo.z > rover.topheight) then
						p.mo.touchingslimecolor = "blue"
						p.mo.touchingslimetimer = 2
					end
				end
			end
		end

		/*
		if (sector.tag == 5000)
		or (sector.tag == 6000)
		or (sector.tag == 7000)
			for i=0, #sector.lines-1
				for rover in p.mo.subsector.sector.ffloors()
					if allFalseLineTag(sector.lines, p.mo.subsector.sector.tag)
					and allFalseLineTag(sector.lines, rover.sector.tag)
						p.mo.touchingslimecolor = "unassigned"
					end
				end
			end
		end

		if player's current sector/fof tag != tag of the 5000, 6000, 7000 sectors
		*/

		if sector.tag == 5500 then
			for i=0, #sector.lines-1, 1 do
				for rover in p.mo.subsector.sector.ffloors() do
					if rover.sector.tag == sector.lines[i].tag
					and not (p.mo.z < rover.bottomheight or p.mo.z > rover.topheight) then
						p.mo.coatingslimecolor = "cyan"
						p.mo.slimetimer = slimetics
					end
				end
			end
		elseif sector.tag == 6500 then
			for i=0, #sector.lines-1, 1 do
				for rover in p.mo.subsector.sector.ffloors() do
					if rover.sector.tag == sector.lines[i].tag
					and not (p.mo.z < rover.bottomheight or p.mo.z > rover.topheight) then
						p.mo.coatingslimecolor = "orange"
						p.mo.slimetimer = slimetics
					end
				end
			end
		elseif sector.tag == 7500 then
			for i=0, #sector.lines-1, 1 do
				for rover in p.mo.subsector.sector.ffloors() do
					if rover.sector.tag == sector.lines[i].tag
					and not (p.mo.z < rover.bottomheight or p.mo.z > rover.topheight) then
						p.mo.coatingslimecolor = "blue"
						p.mo.slimetimer = slimetics
					end
				end
			end
		elseif sector.tag == 8500 then
			for i=0, #sector.lines-1, 1 do
				for rover in p.mo.subsector.sector.ffloors() do
					if rover.sector.tag == sector.lines[i].tag
					and not (p.mo.z < rover.bottomheight or p.mo.z > rover.topheight) then
						p.mo.slimetimer = 1
					end
				end
			end
		end

	end






	if ((p.mo.slimetimer > 1) and (p.mo.coatingslimecolor == "cyan"))
	or (p.mo.touchingslimecolor == "cyan") then
		p.normalspeed = (skins[p.mo.skin].normalspeed)
		p.actionspd = (skins[p.mo.skin].actionspd)
		p.acceleration = (skins[p.mo.skin].acceleration)
		p.jumpfactor = (skins[p.mo.skin].jumpfactor)
		p.thrustfactor = (skins[p.mo.skin].thrustfactor)
		p.accelstart = (skins[p.mo.skin].accelstart)
		p.mindash = (skins[p.mo.skin].mindash)
		p.maxdash = (skins[p.mo.skin].maxdash)
		//if P_IsObjectOnGround(p.mo)
			//p.mo.momz = FRACUNIT*(p.mo.slimetimer/25)
		//end
	elseif ((p.mo.slimetimer > 1) and (p.mo.coatingslimecolor == "orange"))
	or (p.mo.touchingslimecolor == "orange") then
		//p.normalspeed = (skins[p.mo.skin].normalspeed * 2)
		p.actionspd = (skins[p.mo.skin].actionspd)
		//p.acceleration = (skins[p.mo.skin].acceleration * 2)
		p.jumpfactor = (skins[p.mo.skin].jumpfactor)
		//p.thrustfactor = (skins[p.mo.skin].thrustfactor * 2)
		//p.accelstart = (skins[p.mo.skin].accelstart * 2)
		//p.mindash = (skins[p.mo.skin].mindash * 4)
		//p.maxdash = (skins[p.mo.skin].maxdash * 8)
		P_SpawnGhostMobj(p.mo)
	elseif ((p.mo.slimetimer > 1) and (p.mo.coatingslimecolor == "blue"))
	or (p.mo.touchingslimecolor == "blue") then
		p.normalspeed = (skins[p.mo.skin].normalspeed / 3)
		p.actionspd = (skins[p.mo.skin].actionspd / 3)
		p.acceleration = (skins[p.mo.skin].acceleration / 3)
		p.jumpfactor = 90
		p.thrustfactor = (skins[p.mo.skin].thrustfactor)
		p.accelstart = (skins[p.mo.skin].accelstart)
		p.mindash = (skins[p.mo.skin].mindash)
		p.maxdash = (skins[p.mo.skin].maxdash)
		if p.mo.state == S_PLAY_SPINDASH or MRCE_isHyper(p) then
			p.mo.slimetimer = 1
			GoopParticleSpillage(p.mo, MT_BLUESLIME_DRIP_FAST, 6, 6, 48)
			S_StartSound(p.mo, sfx_ghit, p)
		/*elseif (p.mo.state == S_PLAY_ROLL or p.mo.state == S_PLAY_JUMP)
		and (p.mo.slimetimer > 25)
		//and (P_IsObjectOnGround(p.mo))
			p.mo.slimetimer = $ - 20
			GoopParticleSpillage(p.mo, MT_BLUESLIME_DRIP_FAST, 2, 1, 2)
		elseif (p.mo.state == S_PLAY_ROLL or p.mo.state == S_PLAY_JUMP)
		and (p.mo.slimetimer < 25)
		and (p.mo.slimetimer > 10)
		//and (P_IsObjectOnGround(p.mo))
			p.mo.slimetimer = $ - 6
			GoopParticleSpillage(p.mo, MT_BLUESLIME_DRIP_FAST, 2, 1, 2)*/
		end
	end

	if p.mo.coatingslimecolor == "cyan" then
		p.mo.color = SKINCOLOR_CYAN
		p.mo.colorized = true
		p.tintface = true
		//p.mo.rollangle = $ + (ANG1*(p.mo.slimetimer/20))
		//p.mo.state = S_PLAY_PAIN
		if not (leveltime%6) then
			P_SpawnMobjFromMobj(p.mo,
			(P_RandomRange(-5, 5) * FRACUNIT),
			(P_RandomRange(-5, 5) * FRACUNIT),
			((p.mo.height / 2) + ((P_RandomRange(-3, 3) * FRACUNIT))),
			MT_CYANSLIME_DRIP)
		end
	elseif p.mo.coatingslimecolor == "orange" then
		p.mo.color = SKINCOLOR_ORANGE
		p.mo.colorized = true
		p.tintface = true
		p.mo.rollangle = 0
		if not (leveltime%6) then
			P_SpawnMobjFromMobj(p.mo,
			(P_RandomRange(-5, 5) * FRACUNIT),
			(P_RandomRange(-5, 5) * FRACUNIT),
			((p.mo.height / 2) + ((P_RandomRange(-3, 3) * FRACUNIT))),
			MT_ORANGESLIME_DRIP)
		end
	elseif p.mo.coatingslimecolor == "blue" then
		p.mo.color = SKINCOLOR_DUSK
		p.mo.colorized = true
		p.tintface = true
		p.mo.rollangle = 0
		if not (leveltime%6) then
			P_SpawnMobjFromMobj(p.mo,
			(P_RandomRange(-5, 5) * FRACUNIT),
			(P_RandomRange(-5, 5) * FRACUNIT),
			((p.mo.height / 2) + ((P_RandomRange(-3, 3) * FRACUNIT))),
			MT_BLUESLIME_DRIP)
		end
	end

	if p.mo.slimetimer == 1 then
		p.mo.coatingslimecolor = "unassigned"
		p.mo.color = p.skincolor
		p.mo.colorized = false
		p.tintface = false
		p.normalspeed = skins[p.mo.skin].normalspeed
		p.actionspd = skins[p.mo.skin].actionspd
		p.acceleration = skins[p.mo.skin].acceleration
		p.jumpfactor = skins[p.mo.skin].jumpfactor
		p.thrustfactor = skins[p.mo.skin].thrustfactor
		p.accelstart = skins[p.mo.skin].accelstart
		p.mindash = skins[p.mo.skin].mindash
		p.maxdash = skins[p.mo.skin].maxdash
		p.mo.slimetimer = 0
		if P_IsObjectOnGround(p.mo) then
			p.mo.rollangle = 0
		end
	end

	if p.mo.touchingslimetimer == 1 then
		p.mo.touchingslimecolor = "unassigned"
		p.normalspeed = skins[p.mo.skin].normalspeed
		p.actionspd = skins[p.mo.skin].actionspd
		p.acceleration = skins[p.mo.skin].acceleration
		p.jumpfactor = skins[p.mo.skin].jumpfactor
		p.thrustfactor = skins[p.mo.skin].thrustfactor
		p.accelstart = skins[p.mo.skin].accelstart
		p.mindash = skins[p.mo.skin].mindash
		p.maxdash = skins[p.mo.skin].maxdash
		p.mo.touchingslimetimer = 0
	end

	if p.mo.slimetimer > 1 then
		p.mo.slimetimer = $ - 1
	end

	if p.mo.touchingslimetimer > 1 then
		p.mo.touchingslimetimer = $ - 1
	end

	//print("coating "..p.mo.coatingslimecolor)
	//print("slimetimer "..p.mo.slimetimer)
	//print("touching "..p.mo.touchingslimecolor)
	//print("touchingslimetimer "..p.mo.touchingslimetimer)

end)

addHook("MobjLineCollide", function(mo, line)
	if mo.coatingslimecolor
	and (mo.coatingslimecolor == "cyan")
	and (mo.z < line.frontsector.floorheight or mo.z > line.frontsector.ceilingheight) then
		GoopParticleSpillage(mo, MT_CYANSLIME_DRIP_FAST, 4, 12, 8)
		mo.momx = -$
		mo.momy = -$
	end

	for rover in line.frontsector.ffloors() do
		if not (mo.z < rover.bottomheight or mo.z > rover.topheight) then
			if rover.master.special == 121 then
				if rover.master.frontside.midtexture == R_TextureNumForName("LFALL1") then
					GoopParticleSpillageNoScale(mo, MT_CYANSLIME_DRIP_FAST, 4, 12, 8)
				elseif rover.master.frontside.midtexture == R_TextureNumForName("SFALL1") then
					GoopParticleSpillageNoScale(mo, MT_ORANGESLIME_DRIP_FAST, 4, 12, 8)
				elseif rover.master.frontside.midtexture == R_TextureNumForName("CFALL1") then
					GoopParticleSpillageNoScale(mo, MT_BLUESLIME_DRIP_FAST, 4, 12, 8)
				elseif rover.master.frontside.midtexture == R_TextureNumForName("Q5FALL1") then
					GoopParticleSpillageNoScale(mo, MT_CLEARSLIME_DRIP_FAST, 4, 12, 8)
				end
			end
		end
	end

	for sector in sectors.iterate do
		if sector.tag == 5000 then --5000 is currently used by emerald shrines I'd suggest changing this
			for i=0, #sector.lines-1, 1 do
				for rover in line.frontsector.ffloors() do
					if rover.sector.tag == sector.lines[i].tag
					and not (mo.z < rover.bottomheight or mo.z > rover.topheight) then
						mo.momx = -$
						mo.momy = -$
					end
				end
			end
		end
	end
end, MT_PLAYER)

addHook("PlayerSpawn", function(p)
	p.mo.slimetimer = 1
	p.mo.touchingslimetimer = 1
end)

addHook("TouchSpecial", function(mo, toucher)
	if mo.valid and toucher.valid and toucher.player then
		if mo.state == S_CYANSLIME then
			toucher.coatingslimecolor = "cyan"
			toucher.slimetimer = slimetics
			P_KillMobj(mo, toucher)
		end
	end
end, MT_CYANSLIME)

addHook("TouchSpecial", function(mo, toucher)
	if mo.valid and toucher.valid and toucher.player then
		if mo.state == S_ORANGESLIME then
			toucher.coatingslimecolor = "orange"
			toucher.slimetimer = slimetics
			P_KillMobj(mo, toucher)
		end
	end
end, MT_ORANGESLIME)

addHook("TouchSpecial", function(mo, toucher)
	if mo.valid and toucher.valid and toucher.player then
		if mo.state == S_BLUESLIME then
			toucher.coatingslimecolor = "blue"
			toucher.slimetimer = slimetics
			P_KillMobj(mo, toucher)
		end
	end
end, MT_BLUESLIME)

addHook("TouchSpecial", function(mo, toucher)
	if mo.valid and toucher.valid and toucher.player then
		if mo.state == S_CLEARSLIME then
			toucher.slimetimer = 1
			P_KillMobj(mo, toucher)
		end
	end
end, MT_CLEARSLIME)

addHook("MobjDeath", function(mo)
	GoopParticleSpillage(mo, MT_CYANSLIME_DRIP, 3, 5, 8)
end, MT_CYANSLIME)

addHook("MobjDeath", function(mo)
	GoopParticleSpillage(mo, MT_ORANGESLIME_DRIP, 3, 5, 8)
end, MT_ORANGESLIME)

addHook("MobjDeath", function(mo)
	GoopParticleSpillage(mo, MT_BLUESLIME_DRIP, 3, 5, 8)
end, MT_BLUESLIME)

addHook("MobjDeath", function(mo)
	GoopParticleSpillage(mo, MT_CLEARSLIME_DRIP, 3, 5, 8)
end, MT_CLEARSLIME)

addHook("MobjDeath", function(mo)
	GoopParticleSpillage(mo, MT_BLUESLIME, 2, 6, 8)
end, MT_SNAILA)

addHook("MobjSpawn", function(mo)
	mo.scale = $ * P_RandomRange(2,5)
end, MT_CYANSLIME_DRIP_FAST)

addHook("MobjSpawn", function(mo)
	mo.scale = $ * P_RandomRange(2,5)
end, MT_ORANGESLIME_DRIP_FAST)

addHook("MobjSpawn", function(mo)
	mo.scale = $ * P_RandomRange(2,5)
end, MT_BLUESLIME_DRIP_FAST)

addHook("MobjSpawn", function(mo)
	mo.scale = $ * P_RandomRange(2,5)
end, MT_CLEARSLIME_DRIP_FAST)



addHook("MobjSpawn", function(mo)
	mo.leftholder = P_SpawnMobj(mo.x, mo.y, mo.z, MT_MOSQUITO_BOMBHOLDER)
	mo.rightholder = P_SpawnMobj(mo.x, mo.y, mo.z, MT_MOSQUITO_BOMBHOLDER)
	mo.bomb = P_SpawnMobj(mo.x, mo.y, mo.z, MT_BLUESLIME_BOMB)
end, MT_MOSQUITO)

addHook("MobjThinker", function(mo)
	if mo.valid
	and mo.leftholder.valid
	and mo.rightholder.valid
	and mo.bomb.valid then
		P_MoveOrigin(
			mo.leftholder,
			mo.x+FixedMul(20*FRACUNIT, cos(mo.angle+ANGLE_90)),
			mo.y+FixedMul(20*FRACUNIT, sin(mo.angle+ANGLE_90)),
			mo.z-(5*FRACUNIT)
		)

		P_MoveOrigin(
			mo.rightholder,
			mo.x+FixedMul(20*FRACUNIT, cos(mo.angle+ANGLE_270)),
			mo.y+FixedMul(20*FRACUNIT, sin(mo.angle+ANGLE_270)),
			mo.z-(5*FRACUNIT)
		)

		P_MoveOrigin(
			mo.bomb,
			mo.x,
			mo.y,
			mo.z-(30*FRACUNIT)
		)
	end
end, MT_MOSQUITO)

addHook("MobjDeath", function(mo)
	P_KillMobj(mo.leftholder)
	P_KillMobj(mo.rightholder)
	if mo.bomb.valid then
		mo.bomb.flags = $ &~ MF_NOGRAVITY
	end
end, MT_MOSQUITO)

addHook("MobjThinker", function(mo)
	if mo.health
	and P_IsObjectOnGround(mo) then
		P_KillMobj(mo)
	end
end, MT_BLUESLIME_BOMB)

addHook("MobjDeath", function(mo)
	for i=0,5,1 do
		GoopParticleSpillageNoScale(mo, MT_BLUESLIME, 2*i, 3*i, 4*i)
	end
end, MT_BLUESLIME_BOMB)



//cyan/orange effect

//wall fountain
//slime sphere/explosion
//sphere dispenser

//octopus
//snail
//mosquito

//spear
//slime tree
