freeslot("MT_JCZFLOWER", "S_JCZFLOWER", "MT_JCZPINEAPPLE", "S_JCZPINEAPPLE", "MT_JCZBUSH", 
"S_JCZBUSH", "MT_JCZFLOWERBUSH", "S_JCZFLOWERBUSH", "MT_JCZLUSHFLOWER", "S_JCZLUSHFLOWER",
"MT_JCZOAKTREE", "S_JCZOAKTREE", "MT_JCZAPPLETREE", "S_JCZAPPLETREE", "MT_JCZLUSHTREE", "S_JCZLUSHTREE")

mobjinfo[MT_JCZFLOWER] = {
//$Category Jade Coast
//$Name JCZ Flower
//$Sprite 2JCZM0
	doomednum = 2503,
	spawnstate = S_JCZFLOWER,
	spawnhealth = 1000,
	reactiontime = 8,
	deathsound = sfx_pop,
	radius = 32*FRACUNIT,
	height = 64*FRACUNIT,
	mass = 100,
	flags = MF_NOCLIP|MF_SCENERY
}

states[S_JCZFLOWER] = {
	sprite = SPR_2JCZ,
	frame = M|FF_ANIMATE,
	var1 = 3,
	var2 = 3,
}

mobjinfo[MT_JCZPINEAPPLE] = {
//$Category Jade Coast
//$Name JCZ Pineapple
//$Sprite 1JCZM0
	doomednum = 2504,
	spawnstate = S_JCZPINEAPPLE,
	spawnhealth = 1000,
	reactiontime = 8,
	deathsound = sfx_pop,
	radius = 32*FRACUNIT,
	height = 64*FRACUNIT,
	mass = 100,
	flags = MF_NOCLIP|MF_SCENERY
}

states[S_JCZPINEAPPLE] = {
	sprite = SPR_1JCZ,
	frame = M
}

mobjinfo[MT_JCZBUSH] = {
//$Category Jade Coast
//$Name JCZ Bush
//$Sprite 1JCZK0
	doomednum = 2505,
	spawnstate = S_JCZBUSH,
	spawnhealth = 1000,
	reactiontime = 8,
	deathsound = sfx_pop,
	radius = 32*FRACUNIT,
	height = 64*FRACUNIT,
	mass = 100,
	flags = MF_NOCLIP|MF_SCENERY
}

states[S_JCZBUSH] = {
	sprite = SPR_1JCZ,
	frame = K
}

mobjinfo[MT_JCZFLOWERBUSH] = {
//$Category Jade Coast
//$Name JCZ Bulb Bush
//$Sprite 1JCZL0
	doomednum = 2506,
	spawnstate = S_JCZFLOWERBUSH,
	spawnhealth = 1000,
	reactiontime = 8,
	deathsound = sfx_pop,
	radius = 32*FRACUNIT,
	height = 64*FRACUNIT,
	mass = 100,
	flags = MF_NOCLIP|MF_SCENERY
}

states[S_JCZFLOWERBUSH] = {
	sprite = SPR_1JCZ,
	frame = L
}

mobjinfo[MT_JCZLUSHFLOWER] = {
//$Category Jade Coast
//$Name JCZ Lush Cave Flower
//$Sprite 1JCZN0
	doomednum = 2507,
	spawnstate = S_JCZLUSHFLOWER,
	spawnhealth = 1000,
	reactiontime = 8,
	deathsound = sfx_pop,
	radius = 32*FRACUNIT,
	height = 64*FRACUNIT,
	mass = 100,
	flags = MF_NOCLIP|MF_SCENERY|MF_NOGRAVITY
}

states[S_JCZLUSHFLOWER] = {
	sprite = SPR_1JCZ,
	frame = N|FF_PAPERSPRITE|FF_SEMIBRIGHT
}

mobjinfo[MT_JCZOAKTREE] = {
//$Category Jade Coast
//$Name JCZ Oak Tree
//$Sprite 1JCZO0
	doomednum = 2508,
	spawnstate = S_JCZOAKTREE,
	spawnhealth = 1000,
	reactiontime = 8,
	deathsound = sfx_pop,
	radius = 32*FRACUNIT,
	height = 64*FRACUNIT,
	mass = 100,
	flags = MF_NOCLIP|MF_SCENERY
}

states[S_JCZOAKTREE] = {
	sprite = SPR_1JCZ,
	frame = O
}

mobjinfo[MT_JCZAPPLETREE] = {
//$Category Jade Coast
//$Name JCZ Apple Tree
//$Sprite 1JCZP0
	doomednum = 2509,
	spawnstate = MT_JCZAPPLETREE,
	spawnhealth = 1000,
	reactiontime = 8,
	deathsound = sfx_pop,
	radius = 32*FRACUNIT,
	height = 64*FRACUNIT,
	mass = 100,
	flags = MF_NOCLIP|MF_SCENERY
}

states[MT_JCZAPPLETREE] = {
	sprite = SPR_1JCZ,
	frame = P
}

mobjinfo[MT_JCZLUSHTREE] = {
//$Category Jade Coast
//$Name JCZ Lush Tree
//$Sprite 1JCZQ0
	doomednum = 2510,
	spawnstate = S_JCZLUSHTREE,
	spawnhealth = 1000,
	reactiontime = 8,
	deathsound = sfx_pop,
	radius = 32*FRACUNIT,
	height = 64*FRACUNIT,
	mass = 100,
	flags = MF_NOCLIP|MF_SCENERY
}

states[S_JCZLUSHTREE] = {
	sprite = SPR_1JCZ,
	frame = Q
}