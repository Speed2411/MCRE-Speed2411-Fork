////////////////////////////////////////////////////////////////////////////////////////////////////////////
//																				                		  //
// Iciclivore enemy. Lua by Radicalicious, freezing mechanic by Lat', sprites for the gas by Spectorious. //
//																				                		  //
////////////////////////////////////////////////////////////////////////////////////////////////////////////



// Freeslots

freeslot("MT_ICICLIVORE")
freeslot("S_ICICLIVORE_LOOK", "S_ICICLIVORE_AWAKEN1", "S_ICICLIVORE_AWAKEN2", "S_ICICLIVORE_AWAKEN3", "S_ICICLIVORE_GAS1", "S_ICICLIVORE_GAS2",
"S_ICICLIVORE_GAS3", "S_ICICLIVORE_GAS4", "S_ICICLIVORE_GAS5", "S_ICICLIVORE_GASREPEAT", "S_ICICLIVORE_CLOSE1", "S_ICICLIVORE_CLOSE2")
freeslot("SPR_ICAN")

// Objects

mobjinfo[MT_ICICLIVORE] = {
		//$Name "Iciclivore"
		//$Category "Mystic Realm - Midnight Freeze Zone"
		doomednum = 2701,
		spawnstate = S_ICICLIVORE_LOOK,
		seestate = S_ICICLIVORE_AWAKEN1,
		deathstate = S_XPLD_FLICKY,
		deathsound = sfx_pop,
		radius = 12*FRACUNIT,
		height = 80*FRACUNIT,
		mass = 100,
		flags = MF_SPECIAL|MF_SHOOTABLE|MF_ENEMY|MF_SPAWNCEILING|MF_NOGRAVITY,
}
	


// States

states[S_ICICLIVORE_LOOK] = {SPR_ICAN, 0, 5, A_Look, 1200*FRACUNIT+1, 1, S_ICICLIVORE_LOOK}
states[S_ICICLIVORE_AWAKEN1] = {SPR_ICAN, 0, 3, A_PlaySound, sfx_s3k76, 1, S_ICICLIVORE_AWAKEN2}
states[S_ICICLIVORE_AWAKEN2] = {SPR_ICAN, 1, 5, nil, 0, 0, S_ICICLIVORE_AWAKEN3}
states[S_ICICLIVORE_AWAKEN3] = {SPR_ICAN, 2, 8, nil, 0, 0, S_ICICLIVORE_GAS1}
states[S_ICICLIVORE_GAS1] = {SPR_ICAN, 2, 15, A_PlaySound, sfx_s3k93, 1, S_ICICLIVORE_GAS2}
states[S_ICICLIVORE_GAS2] = {SPR_ICAN, 1, 4,  nil, 0, 0, S_ICICLIVORE_GAS3}
states[S_ICICLIVORE_GAS3] = {SPR_ICAN, 2, 0,  A_PlaySound, sfx_s3k97, 1, S_ICICLIVORE_GAS4}
states[S_ICICLIVORE_GAS4] = {SPR_ICAN, 2, 5,  A_CanarivoreGas, MT_CANARIVORE_GAS, 0, S_ICICLIVORE_GAS5}
states[S_ICICLIVORE_GAS5] = {SPR_ICAN, 1, 5,  nil, 0, 0, S_ICICLIVORE_GASREPEAT}
states[S_ICICLIVORE_GASREPEAT] = {SPR_ICAN, 2, 0, A_Repeat, 6, S_CANARIVORE_GAS4, S_ICICLIVORE_CLOSE1}
states[S_ICICLIVORE_CLOSE1] = {SPR_ICAN, 1, 8,  nil, 0, 0, S_ICICLIVORE_CLOSE2}
states[S_ICICLIVORE_CLOSE2] = {SPR_ICAN, 0, 90, nil, sfx_s3k5d, 1, S_ICICLIVORE_LOOK}
