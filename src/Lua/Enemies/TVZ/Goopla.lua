freeslot(
    "S_GOOPERCRAWLA_STND",
    "S_GOOPERCRAWLA_RUN1",
    "S_GOOPERCRAWLA_RUN2",
    "S_GOOPERCRAWLA_RUN3",
    "S_GOOPERCRAWLA_RUN4",
    "S_GOOPERCRAWLA_RUN5",
    "S_GOOPERCRAWLA_RUN6",
    "S_GOOPERCRAWLA_RUN7",
    "SPR_GPOS"
)

states[S_GOOPERCRAWLA_STND] = {
    sprite = GPOS,
    frame = A,
    tics = 5,
    nextstate = S_GOOPERCRAWLA_STND,
    Action = A_Look
}

states[S_GOOPERCRAWLA_RUN1] = {
    sprite = GPOS,
    frame = A,
    tics = 3,
    nextstate = S_GOOPERCRAWLA_RUN2,
    Action = A_Chase
}

states[S_GOOPERCRAWLA_RUN2] = {
    sprite = GPOS,
    frame = B,
    tics = 3,
    nextstate = S_GOOPERCRAWLA_RUN3,
    Action = A_Chase
}

states[S_GOOPERCRAWLA_RUN3] = {
    sprite = GPOS,
    frame = C,
    tics = 3,
    nextstate = S_GOOPERCRAWLA_RUN4,
    Action = A_Chase
}

states[S_GOOPERCRAWLA_RUN4] = {
    sprite = GPOS,
    frame = D,
    tics = 3,
    nextstate = S_GOOPERCRAWLA_RUN5,
    Action = A_Chase
}

states[S_GOOPERCRAWLA_RUN5] = {
    sprite = GPOS,
    frame = E,
    tics = 3,
    nextstate = S_GOOPERCRAWLA_RUN6,
    Action = A_Chase
}

states[S_GOOPERCRAWLA_RUN6] = {
    sprite = GPOS,
    frame = F,
    tics = 3,
    nextstate = S_GOOPERCRAWLA_RUN7,
    Action = A_Chase
}
    
states[S_GOOPERCRAWLA_RUN7] = {
    sprite = GPOS,
    frame = F,
    tics = 0,
    nextstate = S_GOOPERCRAWLA_RUN1,
    Action = A_DropMine
}

mobjinfo[MT_GOOPERCRAWLA] = {
    --$Name Gooper Crawla
    --$Sprite GPOSA1
    --$Category Mystic Realm Enemies
    doomednum = 3101,
    spawnstate = S_GOOPERCRAWLA_STND,
    spawnhealth = 1,
    seestate = S_GOOPERCRAWLA_RUN1,
    seesound = sfx_None,
    attacksound = sfx_None,
    painstate = S_NULL,
    painsound = sfx_None,
    meleestate = S_NULL,
    missilestate = S_NULL,
    deathstate = S_XPLD1,
    xdeathstate = S_NULL,
    deathsound = sfx_pop,
    activesound = sfx_None,
    raisestate = MT_SLOWGOOP,
    reactiontime = 35,
    painchance = 200,
    speed = 8,
    radius = 24*FRACUNIT,
    height = 32*FRACUNIT,
    dispoffset = 0,
    mass = 100,
    damage = 0,
    flags = MF_ENEMY|MF_SPECIAL|MF_SHOOTABLE
}