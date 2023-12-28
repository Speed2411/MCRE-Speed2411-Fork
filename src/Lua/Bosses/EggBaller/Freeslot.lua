freeslot(
"MT_EGGBALLER",
"S_EGGBALLER_IDLE",
"S_EGGBALLER_HURT1",
"S_EGGBALLER_HURT2",
"S_EGGBALLER_PINCH1",
"S_EGGBALLER_PINCH2",
"S_EGGBALLER_PINCH3",
"S_EGGBALLER_FIRE",

"MT_EGGBALLER_SHIELD",
"S_EGGBALLER_SHIELD"
)

mobjinfo[MT_EGGBALLER] = {
	//$Name Egg FireBaller
	//$Category Mystic Realm Bosses
	//$Sprite EGGNA1
	doomednum = 1717,
	spawnstate = S_EGGBALLER_IDLE,
	painstate = S_EGGBALLER_HURT1,
	painsound = sfx_dmpain,
	reactiontime = 5*TICRATE/2,
	deathstate = S_EGGMOBILE2_DIE1,
	deathsound = sfx_s3kb4,
	xdeathstate = S_EGGMOBILE2_FLEE1,
	spawnhealth = 8,
	damage = 3,
	speed = 10*FRACUNIT,
	radius = 36*FRACUNIT,
	height = 88*FRACUNIT,
	flags = MF_SPECIAL|MF_SHOOTABLE|MF_NOGRAVITY|MF_BOSS
}

states[S_EGGBALLER_IDLE] = {
	sprite = SPR_EGGN,
	frame = A,
	tics = 1,
	nextstate = S_EGGBALLER_IDLE
}

states[S_EGGBALLER_HURT1] = {
	sprite = SPR_EGGN,
	frame = D,
	tics = TICRATE,
	nextstate = S_EGGBALLER_HURT2
}

states[S_EGGBALLER_HURT2] = {
	sprite = SPR_EGGN,
	frame = D,
	tics = 2*TICRATE,
	nextstate = S_EGGBALLER_IDLE,
	action = function(actor, var1, var2)
		S_StartSound(actor,sfx_s3k60)
		actor.rotatespeed = actor.info.speed * 3
	end
}

states[S_EGGBALLER_PINCH1] = {
	sprite = SPR_EGGN,
	frame = A,
	tics = TICRATE/2,
	nextstate = S_EGGBALLER_PINCH2,
	action = function(actor, var1, var2)
		S_StartSound(nil, sfx_bnce2)
		actor.shield = P_SpawnMobj(actor.x, actor.y, actor.z + actor.height/2, MT_EGGBALLER_SHIELD)
		actor.shield.scale = 3*FRACUNIT
		actor.shield.target = actor
		A_FaceTracer(actor)
	end
}

states[S_EGGBALLER_PINCH2] = {
	sprite = SPR_EGGN,
	frame = D,
	tics = 4*TICRATE,
	nextstate = S_EGGBALLER_PINCH3
}

states[S_EGGBALLER_PINCH3] = {
	sprite = SPR_EGGN,
	frame = D,
	tics = 3 * TICRATE,
	nextstate = S_EGGBALLER_IDLE,
	action = function(actor, var1, var2)
		actor.momx = $ / 4
		actor.momy = $ / 4
		P_RemoveMobj(actor.shield)
	end
}

mobjinfo[MT_EGGBALLER_FIRE] = {
	doomednum = -1,
	spawnstate = S_EGGBALLER_FIRE,
	painstate = S_EGGBALLER_FIRE,
	painchance = MT_FLAMEPARTICLE,
	seesound = sfx_s3kc2s,
	reactiontime = 2*TICRATE,
	deathstate = S_XPLD1,
	spawnhealth = 1000,
	speed = 15*FRACUNIT,
	radius = 28*FRACUNIT,
	height = 68*FRACUNIT,
	flags = MF_PAIN|MF_BOUNCE|MF_FIRE
}

states[S_EGGBALLER_FIRE] = {
	sprite = SPR_BFBR,
	frame = A|FF_FULLBRIGHT|FF_ANIMATE,
	tics = 13*TICRATE/4,
	nextstate = S_DEATHSTATE,
	var1 = 15,
	var2 = 1
}

mobjinfo[MT_EGGBALLER_SHIELD] = {
	doomednum = -1,
	spawnstate = S_EGGBALLER_SHIELD,
	painstate = S_EGGBALLER_SHIELD,
	painchance = MT_FLAMEPARTICLE,
	seesound = sfx_s3kc2s,
	reactiontime = 2*TICRATE,
	deathstate = S_XPLD1,
	spawnhealth = 1000,
	speed = 16*FRACUNIT,
	radius = 34*FRACUNIT,
	height = 68*FRACUNIT,
	flags = MF_PAIN|MF_NOGRAVITY|MF_RUNSPAWNFUNC|MF_FIRE
}

states[S_EGGBALLER_SHIELD] = {
	sprite = SPR_BFBR,
	frame = A|FF_FULLBRIGHT|FF_ANIMATE|FF_TRANS40,
	tics = -1,
	nextstate = S_DEATHSTATE,
	var1 = 15,
	var2 = 1
}