freeslot(
"S_BROKENCRAWLA_STND",
"S_BROKENCRAWLA_ATK1",
"S_BROKENCRAWLA_ATK2",
"S_BROKENCRAWLA_ATK3",
"S_BROKENCRAWLA_ATKE",
"MT_BROKENCRAWLA",
"SPR_BCRW"
)

states[S_BROKENCRAWLA_STND] = {
	sprite = SPR_BCRW,
	frame = A,
	tics = 5,
	action = A_Look,
	var1 = 0,
	var2 = 0,
	nextstate = S_BROKENCRAWLA_STND
}

states[S_BROKENCRAWLA_ATK1] = {
	sprite = SPR_BCRW,
	frame = A,
	tics = 30,
	action = None,
	var1 = 0,
	var2 = 0,
	nextstate = S_BROKENCRAWLA_ATK3
}

states[S_BROKENCRAWLA_ATK2] = {
	sprite = SPR_BCRW,
	frame = A,
	tics = 40,
	action = A_DualAction,
	var1 = S_BROKENCRAWLA_ATK3,
	var2 = S_BROKENCRAWLA_ATKE,
	nextstate = S_BROKENCRAWLA_ATK1
}

states[S_BROKENCRAWLA_ATK3] = {
	sprite = SPR_BCRW,
	frame = B,
	tics = 40,
	action = A_MultiShot,
	var1 = MT_SHOCKWAVE*65536+8,
	var2 = -45,
	nextstate = S_BROKENCRAWLA_ATK1
}

states[S_BROKENCRAWLA_ATKE] = {
	sprite = SPR_BCRW,
	frame = A,
	tics = 40,
	action = A_PlaySound,
	var1 = 401,
	var2 = 1,
	nextstate = S_NULL
}

mobjinfo[MT_BROKENCRAWLA] = {
	//$Name DerelictCrawla Commander
	//$Category Mystic Realm Enemies
	//$Sprite BCRWA1
	doomednum = 3100,
	spawnstate = S_BROKENCRAWLA_STND,
	spawnhealth = 1,
	seestate = S_BROKENCRAWLA_ATK1,
	seesound = sfx_None,
	reactiontime = 35,
	attacksound = sfx_None,
	activesound = sfx_None,
	painstate = S_NULL,
	painchance = 200,
	painsound = sfx_None,
	meleestate = S_NULL,
	missilestate = S_NULL,
	deathstate = S_XPLD1,
	xdeathstate = S_NULL,
	deathsound = sfx_pop,
	raisestate = S_NULL,
	speed = 0,
	radius = 24*FRACUNIT,
	height = 32*FRACUNIT,
	dispoffset = 0,
	mass = 100,
	damage = 0,
	flags = MF_ENEMY|MF_SPECIAL|MF_SHOOTABLE
}

addHook("MobjSpawn", function(mo)
	mo.rollangle = P_RandomRange(1,360)*ANG1
    mo.samusHP = 4 --1 samusHP = 1 PowerBeam shot. Missiles and charge shots bypass SamusHP and take regular HP.
    mo.spazresist = true
	mo.plasmaresist = true
	mo.waveweak = true
end, MT_BROKENCRAWLA)
