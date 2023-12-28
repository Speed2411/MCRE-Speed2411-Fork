freeslot(
	"MT_PURPLEDIAG",
	"SPR_PSPR",
	"S_PDIAG1",
	"S_PDIAG2",
	"S_PDIAG3",
	"S_PDIAG4",
	"S_PDIAG5",
	"S_PDIAG6",
	"S_PDIAG7",
	"S_PDIAG8",
	"sfx_psprng"
)

mobjinfo[MT_PURPLEDIAG] = {
--$Name Purple Diagonal Spring
--$Category Custom Springs
--$Sprite PSPRD2
        doomednum = 40,
        spawnstate = S_PDIAG1,
        spawnhealth = 1,
        seestate = S_PDIAG2,
        seesound = sfx_None,
        reactiontime = 8,
        attacksound = sfx_none,
        painstate = S_NULL,
        painchance = 0,
        painsound = sfx_psprng,
        meleestate = S_NULL,
        missilestate = S_NULL,
        deathstate = S_NULL,
        xdeathstate = S_NULL,
        deathsound = sfx_None,
        speed = 1,
        radius = 16*FRACUNIT,
        height = 16*FRACUNIT,
        dispoffset = 0,
        mass = 48*FRACUNIT,
        damage = 48*FRACUNIT,
        activesound = sfx_None,
        flags = MF_SOLID|MF_SPRING,
        raisestate = S_PDIAG2
}

states[S_PDIAG1] = {SPR_PSPR, A, -1, nil, 0, 0, S_NULL}
states[S_PDIAG2] = {SPR_PSPR, B, 1, A_Pain, 0, 0, S_PDIAG3}
states[S_PDIAG3] = {SPR_PSPR, C, 1, nil, 0, 0, S_PDIAG4}
states[S_PDIAG4] = {SPR_PSPR, D, 1, nil, 0, 0, S_PDIAG5}
states[S_PDIAG5] = {SPR_PSPR, E, 1, nil, 0, 0, S_PDIAG6}
states[S_PDIAG6] = {SPR_PSPR, D, 1, nil, 0, 0, S_PDIAG7}
states[S_PDIAG7] = {SPR_PSPR, C, 1, nil, 0, 0, S_PDIAG8}
states[S_PDIAG8] = {SPR_PSPR, B, 1, nil, 0, 0, S_PDIAG1}