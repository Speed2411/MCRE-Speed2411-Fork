--[[
Goggles Crawla - "Goggola"

SOC by Zippy_Zolton

Lua conversion done by Ryuko
--]]

freeslot(
	"SPR_GOGA",
	"MT_GOGGLESCRAWLA_SLOW",
	"MT_GOGGLESCRAWLA_FAST",
	"S_JOSS_STND",
	"S_JOSS_WALK1",
	"S_JOSS_WALK2",
	"S_JOSS_WALK3",
	"S_JOSS_WALK4",
	"S_JOSS_WALK5",
	"S_JOSS_WALK6",
	"S_JOSS_CHARGE1",
	"S_JOSS_CHARGE2",
	"S_JOSS_RUN1",
	"S_JOSS_RUN2",
	"S_JOSS_RUN3",
	"S_JOSS_RUN4",
	"S_JOSS_RUN5",
	"S_JOSS_RUN6",
	"S_JOSS_STOP"
)

-- "Goggles Crawla, may have colored variants later"

mobjinfo[MT_GOGGLESCRAWLA_SLOW] = {
	--$Name Goggles Crawla (Slow)
	--$Sprite GOGAA1
	--$Category Mystic Realm Enemies
	doomednum = 2303,
	spawnstate = S_JOSS_STND,
	spawnhealth = 1,
	seestate = S_JOSS_WALK1,
	reactiontime = 35,
	attacksound = sfx_s3kb6,
	painstate = S_NULL,
	painchance = 5*TICRATE,
	meleestate = S_JOSS_STOP,
	missilestate = S_JOSS_CHARGE1,
	deathstate = S_XPLD_FLICKY,
	xdeathstate = S_JOSS_STOP,
	deathsound = sfx_pop,
	speed = 1,
	radius = 24*FRACUNIT,
	height = 32*FRACUNIT,
	mass = 100,
	damage = 0,
	activesound = sfx_s3k5a,
	raisestate = S_NULL,
	flags = MF_ENEMY|MF_SPECIAL|MF_SHOOTABLE
}

mobjinfo[MT_GOGGLESCRAWLA_FAST] = {
	--$Name Goggles Crawla (Fast)
	--$Sprite GOGAA1
	--$Category Mystic Realm Enemies
	doomednum = 2302,
	spawnstate = S_JOSS_STND,
	spawnhealth = 1,
	seestate = S_JOSS_WALK1,
	seesound = sfx_none,
	reactiontime = 35,
	attacksound = sfx_s3kb6,
	painstate = S_NULL,
	painchance = 5*TICRATE,
	painsound = sfx_none,
	meleestate = S_JOSS_STOP,
	missilestate = S_JOSS_CHARGE1,
	deathstate = S_XPLD_FLICKY,
	xdeathstate = S_JOSS_STOP,
	deathsound = sfx_pop,
	speed = 2,
	radius = 24*FRACUNIT,
	height = 32*FRACUNIT,
	mass = 100,
	damage = 0,
	activesound = sfx_s3k5a,
	flags = MF_ENEMY|MF_SPECIAL|MF_SHOOTABLE,
	raisestate = S_NULL
}

states[S_JOSS_STND] = {
	sprite = GOGA,
	frame = A,
	tics = 5,
	nextstate = S_JOSS_STND,
	Action = A_Look,
	Var1 = 0,
	Var2 = 0
}

states[S_JOSS_WALK1] = {
	sprite = GOGA,
	frame = A,
	tics = 3,
	nextstate = S_JOSS_WALK2,
	Action = A_SharpChase,
	Var1 = 0,
	Var2 = 0
}

states[S_JOSS_WALK2] = {
	sprite = GOGA,
	frame = B,
	tics = 3,
	nextstate = S_JOSS_WALK3,
	Action = A_SharpChase,
	Var1 = 0,
	Var2 = 0
}

states[S_JOSS_WALK3] = {
	sprite = GOGA,
	frame = C,
	tics = 3,
	nextstate = S_JOSS_WALK4,
	Action = A_SharpChase,
	Var1 = 0,
	Var2 = 0
}

states[S_JOSS_WALK4] = {
	sprite = GOGA,
	frame = D,
	tics = 3,
	nextstate = S_JOSS_WALK1,
	Action = A_SharpChase,
	Var1 = 0,
	Var2 = 0
}

-- "Charging state because A_SharpSpin sucks ass"

states[S_JOSS_CHARGE1] = {
	sprite = GOGA,
	frame = A,
	tics = 1,
	nextstate = S_JOSS_CHARGE1,
	Action = A_FaceStabRev,
	Var1 = 35,
	Var2 = S_JOSS_CHARGE2
}

states[S_JOSS_CHARGE2] = {
	sprite = GOGA,
	frame = A,
	tics = 0,
	nextstate = S_JOSS_RUN1,
	Action = A_PlayAttackSound,
	Var1 = 0,
	Var2 = 0
}

states[S_JOSS_RUN1] = {
	sprite = GOGA,
	frame = A,
	tics = 1,
	nextstate = S_JOSS_RUN2,
	Action = A_SharpSpin,
	Var1 = 0,
	Var2 = 0
}

states[S_JOSS_RUN2] = {
	sprite = GOGA,
	frame = B,
	tics = 1,
	nextstate = S_JOSS_RUN3,
	Action = A_SharpSpin,
	Var1 = 0,
	Var2 = 0
}

states[S_JOSS_RUN3] = {
	sprite = GOGA,
	frame = C,
	tics = 1,
	nextstate = S_JOSS_RUN4,
	Action = A_SharpSpin,
	Var1 = 0,
	Var2 = 0
}

states[S_JOSS_RUN4] = {
	sprite = GOGA,
	frame = D,
	tics = 1,
	nextstate = S_JOSS_RUN1,
	Action = A_SharpSpin,
	Var1 = 0,
	Var2 = 0
}
-- "Stop state for the same fucking reason"

states[S_JOSS_STOP] = {
	sprite = GOGA,
	frame = A,
	tics = 1,
	nextstate = S_JOSS_STND,
	Action = none,
	Var1 = 0,
	Var2 = 0
}
