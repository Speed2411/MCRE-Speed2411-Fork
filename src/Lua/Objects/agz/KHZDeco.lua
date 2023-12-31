//Used slots

freeslot(
	"SPR_KHB1",
	"SPR_KHB4",
	"SPR_KHF1",
	"SPR_KHF2",
	"SPR_KHF3",
	"SPR_KHF4",
	"SPR_KHT1",
	"SPR_KHV1",
	"SPR_KHR1",
	"MT_KHB1A",
	"MT_KHB1B",
	"MT_KHB1C",
	"MT_KHB1D",
	"MT_KHB1E",
	"MT_KHF1A",
	"MT_KHF1B",
	"MT_KHF1C",
	"MT_KHF1D",
	"MT_KHF1E",
	"MT_KHF1F",
	"MT_KHF2A",
	"MT_KHF2B",
	"MT_KHF2C",
	"MT_KHF3A",
	"MT_KHF3B",
	"MT_KHF3C",
	"MT_KHF4A",
	"MT_KHT1A",
	"MT_KHT1B",
	"MT_KHT1C",
	"MT_KHT1D",
	"MT_KHT1E",
	"MT_KHV1",
	"MT_KHR1",
	"S_KHB1A",
	"S_KHB1B",
	"S_KHB1C",
	"S_KHB1D",
	"S_KHB1E",
	"S_KHF1A",
	"S_KHF1B",
	"S_KHF1C",
	"S_KHF1D",
	"S_KHF1E",
	"S_KHF1F",
	"S_KHF2A",
	"S_KHF2B",
	"S_KHF2C",
	"S_KHF3A",
	"S_KHF3B",
	"S_KHF3C",
	"S_KHF4A",
	"S_KHT1A",
	"S_KHT1B",
	"S_KHT1C",
	"S_KHT1D",
	"S_KHT1E",
	"S_KHV1",
	"S_KHR1"
)

// Bush mobjinfo

mobjinfo[MT_KHB1A] = {
//$Category SRB1 KHZ Vegetation
//$Name Bush
//$Sprite KHB1A0
	doomednum = 1351,
	spawnstate = S_KHB1A,
	spawnhealth = 1000,
	reactiontime = 8,
	deathsound = sfx_pop,
	radius = 1048576,
	height = 6291456,
	mass = 100,
	flags = MF_NOCLIP|MF_SCENERY|MF_NOGRAVITY
}

// Bush states

states[S_KHB1A] = {
	sprite = SPR_KHB1,
	frame = A,
	tics = 5,
	nextstate = S_KHB1A
}

// Bush with Red Berries mobjinfo

mobjinfo[MT_KHB1B] = {
//$Category SRB1 KHZ Vegetation
//$Name Bush with Red Berries
//$Sprite KHB1B0
	doomednum = 1352,
	spawnstate = S_KHB1B,
	spawnhealth = 1000,
	reactiontime = 8,
	deathsound = sfx_pop,
	radius = 1048576,
	height = 6291456,
	mass = 100,
	flags = MF_NOCLIP|MF_SCENERY|MF_NOGRAVITY
}

// Bush with Red Berries states

states[S_KHB1B] = {
	sprite = SPR_KHB1,
	frame = B,
	tics = 5,
	nextstate = S_KHB1B
}

// Bush with Blue Berries mobjinfo

mobjinfo[MT_KHB1C] = {
//$Category SRB1 KHZ Vegetation
//$Name Bush with Blue Berries
//$Sprite KHB1C0
	doomednum = 1353,
	spawnstate = S_KHB1C,
	spawnhealth = 1000,
	reactiontime = 8,
	deathsound = sfx_pop,
	radius = 1048576,
	height = 6291456,
	mass = 100,
	flags = MF_NOCLIP|MF_SCENERY|MF_NOGRAVITY
}

// Bush with Blue Berries states

states[S_KHB1C] = {
	sprite = SPR_KHB1,
	frame = C,
	tics = 5,
	nextstate = S_KHB1C
}

// Bush with Black Berries mobjinfo

mobjinfo[MT_KHB1D] = {
//$Category SRB1 KHZ Vegetation
//$Name Bush with Black Berries
//$Sprite KHB1D0
	doomednum = 1354,
	spawnstate = S_KHB1D,
	spawnhealth = 1000,
	reactiontime = 8,
	deathsound = sfx_pop,
	radius = 1048576,
	height = 6291456,
	mass = 100,
	flags = MF_NOCLIP|MF_SCENERY|MF_NOGRAVITY
}

// Bush with Black Berries states

states[S_KHB1D] = {
	sprite = SPR_KHB1,
	frame = D,
	tics = 5,
	nextstate = S_KHB1D
}

// Bush with Snow mobjinfo

mobjinfo[MT_KHB1E] = {
//$Category SRB1 KHZ Vegetation
//$Name Bush with Snow
//$Sprite KHB1E0
	doomednum = 1374,
	spawnstate = S_KHB1E,
	spawnhealth = 1000,
	reactiontime = 8,
	deathsound = sfx_pop,
	radius = 1048576,
	height = 6291456,
	mass = 100,
	flags = MF_NOCLIP|MF_SCENERY|MF_NOGRAVITY
}

// Bush with Snow states

states[S_KHB1E] = {
	sprite = SPR_KHB1,
	frame = E,
	tics = 5,
	nextstate = S_KHB1E
}

// Dandelion White mobjinfo

mobjinfo[MT_KHF1A] = {
//$Category SRB1 KHZ Vegetation
//$Name Dandelion White 
//$Sprite KHF1A0
	doomednum = 1355,
	spawnstate = S_KHF1A,
	spawnhealth = 1000,
	reactiontime = 8,
	deathsound = sfx_pop,
	radius = 1048576,
	height = 6291456,
	mass = 100,
	flags = MF_NOCLIP|MF_SCENERY|MF_NOGRAVITY
}

// Dandelion White states

states[S_KHF1A] = {
	sprite = SPR_KHF1,
	frame = A,
	tics = 5,
	nextstate = S_KHF1A
}

// Dandelion Pink mobjinfo

mobjinfo[MT_KHF1B] = {
//$Category SRB1 KHZ Vegetation
//$Name Dandelion Pink 
//$Sprite KHF1B0
	doomednum = 1356,
	spawnstate = S_KHF1B,
	spawnhealth = 1000,
	reactiontime = 8,
	deathsound = sfx_pop,
	radius = 1048576,
	height = 6291456,
	mass = 100,
	flags = MF_NOCLIP|MF_SCENERY|MF_NOGRAVITY
}

// Dandelion Pink states

states[S_KHF1B] = {
	sprite = SPR_KHF1,
	frame = B,
	tics = 5,
	nextstate = S_KHF1B
}

// Dandelion Red mobjinfo

mobjinfo[MT_KHF1C] = {
//$Category SRB1 KHZ Vegetation
//$Name Dandelion Red 
//$Sprite KHF1C0
	doomednum = 1357,
	spawnstate = S_KHF1C,
	spawnhealth = 1000,
	reactiontime = 8,
	deathsound = sfx_pop,
	radius = 1048576,
	height = 6291456,
	mass = 100,
	flags = MF_NOCLIP|MF_SCENERY|MF_NOGRAVITY
}

// Dandelion Red states

states[S_KHF1C] = {
	sprite = SPR_KHF1,
	frame = C,
	tics = 5,
	nextstate = S_KHF1C
}

// Dandelion Pinkish-Purple  mobjinfo

mobjinfo[MT_KHF1D] = {
//$Category SRB1 KHZ Vegetation
//$Name Dandelion Pinkish-Purple 
//$Sprite KHF1D0
	doomednum = 1358,
	spawnstate = S_KHF1D,
	spawnhealth = 1000,
	reactiontime = 8,
	deathsound = sfx_pop,
	radius = 1048576,
	height = 6291456,
	mass = 100,
	flags = MF_NOCLIP|MF_SCENERY|MF_NOGRAVITY
}

// Dandelion Pinkish-Purple  states

states[S_KHF1D] = {
	sprite = SPR_KHF1,
	frame = D,
	tics = 5,
	nextstate = S_KHF1D
}

// Dandelion Bluish-Purple mobjinfo

mobjinfo[MT_KHF1E] = {
//$Category SRB1 KHZ Vegetation
//$Name Dandelion Bluish-Purple 
//$Sprite KHF1E0
	doomednum = 1359,
	spawnstate = S_KHF1E,
	spawnhealth = 1000,
	reactiontime = 8,
	deathsound = sfx_pop,
	radius = 1048576,
	height = 6291456,
	mass = 100,
	flags = MF_NOCLIP|MF_SCENERY|MF_NOGRAVITY
}

// Dandelion Bluish-Purple states

states[S_KHF1E] = {
	sprite = SPR_KHF1,
	frame = E,
	tics = 5,
	nextstate = S_KHF1E
}

// Dandelion Blue  mobjinfo

mobjinfo[MT_KHF1F] = {
//$Category SRB1 KHZ Vegetation
//$Name Dandelion Blue 
//$Sprite KHF1F0
	doomednum = 1360,
	spawnstate = S_KHF1F,
	spawnhealth = 1000,
	reactiontime = 8,
	deathsound = sfx_pop,
	radius = 1048576,
	height = 6291456,
	mass = 100,
	flags = MF_NOCLIP|MF_SCENERY|MF_NOGRAVITY
}

// Dandelion Blue  states

states[S_KHF1F] = {
	sprite = SPR_KHF1,
	frame = F,
	tics = 5,
	nextstate = S_KHF1F
}

// KHZSF Pink mobjinfo

mobjinfo[MT_KHF2A] = {
//$Category SRB1 KHZ Vegetation
//$Name KHZSF Pink 
//$Sprite KHF2A0
	doomednum = 1361,
	spawnstate = S_KHF2A,
	spawnhealth = 1000,
	reactiontime = 8,
	deathsound = sfx_pop,
	radius = 1048576,
	height = 6291456,
	mass = 100,
	flags = MF_NOCLIP|MF_SCENERY|MF_NOGRAVITY
}

// KHZSF Pink states

states[S_KHF2A] = {
	sprite = SPR_KHF2,
	frame = A,
	tics = 5,
	nextstate = S_KHF2A
}

// KHZSF Red-Pink mobjinfo

mobjinfo[MT_KHF2B] = {
//$Category SRB1 KHZ Vegetation
//$Name KHZSF Red-Pink 
//$Sprite KHF2B0
	doomednum = 1362,
	spawnstate = S_KHF2B,
	spawnhealth = 1000,
	reactiontime = 8,
	deathsound = sfx_pop,
	radius = 1048576,
	height = 6291456,
	mass = 100,
	flags = MF_NOCLIP|MF_SCENERY|MF_NOGRAVITY
}

// KHZSF Red-Pink states

states[S_KHF2B] = {
	sprite = SPR_KHF2,
	frame = B,
	tics = 5,
	nextstate = S_KHF2B
}

// KHZSF Red mobjinfo

mobjinfo[MT_KHF2C] = {
//$Category SRB1 KHZ Vegetation
//$Name KHZSF Red 
//$Sprite KHF2C0
	doomednum = 1363,
	spawnstate = S_KHF2C,
	spawnhealth = 1000,
	reactiontime = 8,
	deathsound = sfx_pop,
	radius = 1048576,
	height = 6291456,
	mass = 100,
	flags = MF_NOCLIP|MF_SCENERY|MF_NOGRAVITY
}

// KHZSF Red states

states[S_KHF2C] = {
	sprite = SPR_KHF2,
	frame = C,
	tics = 5,
	nextstate = S_KHF2C
}

// KHZWF Pink mobjinfo

mobjinfo[MT_KHF3A] = {
//$Category SRB1 KHZ Vegetation
//$Name KHZWF Pink 
//$Sprite KHF3A0
	doomednum = 1364,
	spawnstate = S_KHF3A,
	spawnhealth = 1000,
	reactiontime = 8,
	deathsound = sfx_pop,
	radius = 1048576,
	height = 6291456,
	mass = 100,
	flags = MF_NOCLIP|MF_SCENERY|MF_NOGRAVITY
}

// KHZWF Pink states

states[S_KHF3A] = {
	sprite = SPR_KHF3,
	frame = A,
	tics = 5,
	nextstate = S_KHF3A
}

// KHZWF Red-Pink mobjinfo

mobjinfo[MT_KHF3B] = {
//$Category SRB1 KHZ Vegetation
//$Name KHZWF Red-Pink 
//$Sprite KHF3B0
	doomednum = 1365,
	spawnstate = S_KHF3B,
	spawnhealth = 1000,
	reactiontime = 8,
	deathsound = sfx_pop,
	radius = 1048576,
	height = 6291456,
	mass = 100,
	flags = MF_NOCLIP|MF_SCENERY|MF_NOGRAVITY
}

// KHZWF Red-Pink states

states[S_KHF3B] = {
	sprite = SPR_KHF3,
	frame = B,
	tics = 5,
	nextstate = S_KHF3B
}

// KHZWF Red mobjinfo

mobjinfo[MT_KHF3C] = {
//$Category SRB1 KHZ Vegetation
//$Name KHZWF Red 
//$Sprite KHF3C0
	doomednum = 1366,
	spawnstate = S_KHF3C,
	spawnhealth = 1000,
	reactiontime = 8,
	deathsound = sfx_pop,
	radius = 1048576,
	height = 6291456,
	mass = 100,
	flags = MF_NOCLIP|MF_SCENERY|MF_NOGRAVITY
}

// KHZWF Red states

states[S_KHF3C] = {
	sprite = SPR_KHF3,
	frame = C,
	tics = 5,
	nextstate = S_KHF3C
}

// Cattail mobjinfo

mobjinfo[MT_KHF4A] = {
//$Category SRB1 KHZ Vegetation
//$Name Cattail
//$Sprite KHF4A0
	doomednum = 1367,
	spawnstate = S_KHF4A,
	spawnhealth = 1000,
	reactiontime = 8,
	deathsound = sfx_pop,
	radius = 1048576,
	height = 6291456,
	mass = 100,
	flags = MF_NOCLIP|MF_SCENERY|MF_NOGRAVITY
}

// Cattail states

states[S_KHF4A] = {
	sprite = SPR_KHF4,
	frame = A,
	tics = 5,
	nextstate = S_KHF4A
}

// Tree Oak  mobjinfo

mobjinfo[MT_KHT1A] = {
//$Category SRB1 KHZ Vegetation
//$Name Tree Oak 
//$Sprite KHT1A0
	doomednum = 1368,
	spawnstate = S_KHT1A,
	spawnhealth = 1000,
	reactiontime = 8,
	deathsound = sfx_pop,
	radius = 1048576,
	height = 6291456,
	mass = 100,
	flags = MF_NOCLIP|MF_SCENERY|MF_NOGRAVITY
}

// Tree Oak  states

states[S_KHT1A] = {
	sprite = SPR_KHT1,
	frame = A,
	tics = 5,
	nextstate = S_KHT1A
}

// Tree with Red Apples mobjinfo

mobjinfo[MT_KHT1B] = {
//$Category SRB1 KHZ Vegetation
//$Name Tree with Red Apples
//$Sprite KHT1B0
	doomednum = 1369,
	spawnstate = S_KHT1B,
	spawnhealth = 1000,
	reactiontime = 8,
	deathsound = sfx_pop,
	radius = 1048576,
	height = 6291456,
	mass = 100,
	flags = MF_NOCLIP|MF_SCENERY|MF_NOGRAVITY
}

// Tree with Red Apples states

states[S_KHT1B] = {
	sprite = SPR_KHT1,
	frame = B,
	tics = 5,
	nextstate = S_KHT1B
}

// Tree with Oranges mobjinfo

mobjinfo[MT_KHT1C] = {
//$Category SRB1 KHZ Vegetation
//$Name Tree with Oranges
//$Sprite KHT1C0
	doomednum = 1370,
	spawnstate = S_KHT1C,
	spawnhealth = 1000,
	reactiontime = 8,
	deathsound = sfx_pop,
	radius = 1048576,
	height = 6291456,
	mass = 100,
	flags = MF_NOCLIP|MF_SCENERY|MF_NOGRAVITY
}

// Tree with Oranges states

states[S_KHT1C] = {
	sprite = SPR_KHT1,
	frame = C,
	tics = 5,
	nextstate = S_KHT1C
}

// Tree with Green Apples mobjinfo

mobjinfo[MT_KHT1D] = {
//$Category SRB1 KHZ Vegetation
//$Name Tree with Green Apples
//$Sprite KHT1D0
	doomednum = 1371,
	spawnstate = S_KHT1D,
	spawnhealth = 1000,
	reactiontime = 8,
	deathsound = sfx_pop,
	radius = 1048576,
	height = 6291456,
	mass = 100,
	flags = MF_NOCLIP|MF_SCENERY|MF_NOGRAVITY
}

// Tree with Green Apples states

states[S_KHT1D] = {
	sprite = SPR_KHT1,
	frame = D,
	tics = 5,
	nextstate = S_KHT1D
}

// Tree with Snow mobjinfo

mobjinfo[MT_KHT1E] = {
//$Category SRB1 KHZ Vegetation
//$Name Tree with Snow
//$Sprite KHT1E0
	doomednum = 1372,
	spawnstate = S_KHT1E,
	spawnhealth = 1000,
	reactiontime = 8,
	deathsound = sfx_pop,
	radius = 1048576,
	height = 6291456,
	mass = 100,
	flags = MF_NOCLIP|MF_SCENERY|MF_NOGRAVITY
}

// Tree with Snow states

states[S_KHT1E] = {
	sprite = SPR_KHT1,
	frame = E,
	tics = 5,
	nextstate = S_KHT1E
}

// Water Lylie mobjinfo

mobjinfo[MT_KHV1] = {
//$Category SRB1 KHZ Vegetation
//$Name Water Lylie
//$Sprite KHV1A0
	dommednum = 1373,
	spawnstate = S_KHV1,
	spawnhealth = 1000,
	reactiontime = 8,
	deathsound = sfx_pop,
	radius = 1048576,
	height = 6291456,
	mass = 100,
	flags = MF_NOCLIP|MF_SCENERY|MF_NOGRAVITY
}

// Water Lylie states

states[S_KHV1] = {
	sprite = SPR_KHV1,
	frame = A,
	tics = 5,
	nextstate = S_KHV1
}