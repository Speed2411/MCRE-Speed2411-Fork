states[S_EMBLEM1] = {SPR_EMBM, FF_FULLBRIGHT|FF_PAPERSPRITE|A, -1, nil, 0, 0, S_NULL}
states[S_EMBLEM2] = {SPR_EMBM, FF_FULLBRIGHT|FF_PAPERSPRITE|B, -1, nil, 0, 0, S_NULL}
states[S_EMBLEM3] = {SPR_EMBM, FF_FULLBRIGHT|FF_PAPERSPRITE|C, -1, nil, 0, 0, S_NULL}
states[S_EMBLEM4] = {SPR_EMBM, FF_FULLBRIGHT|FF_PAPERSPRITE|D, -1, nil, 0, 0, S_NULL}
states[S_EMBLEM5] = {SPR_EMBM, FF_FULLBRIGHT|FF_PAPERSPRITE|E, -1, nil, 0, 0, S_NULL}
states[S_EMBLEM6] = {SPR_EMBM, FF_FULLBRIGHT|FF_PAPERSPRITE|F, -1, nil, 0, 0, S_NULL}
states[S_EMBLEM7] = {SPR_EMBM, FF_FULLBRIGHT|FF_PAPERSPRITE|G, -1, nil, 0, 0, S_NULL}
states[S_EMBLEM8] = {SPR_EMBM, FF_FULLBRIGHT|FF_PAPERSPRITE|H, -1, nil, 0, 0, S_NULL}
states[S_EMBLEM9] = {SPR_EMBM, FF_FULLBRIGHT|FF_PAPERSPRITE|I, -1, nil, 0, 0, S_NULL}
states[S_EMBLEM10] = {SPR_EMBM, FF_FULLBRIGHT|FF_PAPERSPRITE|J, -1, nil, 0, 0, S_NULL}
states[S_EMBLEM11] = {SPR_EMBM, FF_FULLBRIGHT|FF_PAPERSPRITE|K, -1, nil, 0, 0, S_NULL}
states[S_EMBLEM12] = {SPR_EMBM, FF_FULLBRIGHT|FF_PAPERSPRITE|L, -1, nil, 0, 0, S_NULL}
states[S_EMBLEM13] = {SPR_EMBM, FF_FULLBRIGHT|FF_PAPERSPRITE|M, -1, nil, 0, 0, S_NULL}
states[S_EMBLEM14] = {SPR_EMBM, FF_FULLBRIGHT|FF_PAPERSPRITE|N, -1, nil, 0, 0, S_NULL}
states[S_EMBLEM15] = {SPR_EMBM, FF_FULLBRIGHT|FF_PAPERSPRITE|O, -1, nil, 0, 0, S_NULL}
states[S_EMBLEM16] = {SPR_EMBM, FF_FULLBRIGHT|FF_PAPERSPRITE|P, -1, nil, 0, 0, S_NULL}
states[S_EMBLEM17] = {SPR_EMBM, FF_FULLBRIGHT|FF_PAPERSPRITE|Q, -1, nil, 0, 0, S_NULL}
states[S_EMBLEM18] = {SPR_EMBM, FF_FULLBRIGHT|FF_PAPERSPRITE|R, -1, nil, 0, 0, S_NULL}
states[S_EMBLEM19] = {SPR_EMBM, FF_FULLBRIGHT|FF_PAPERSPRITE|S, -1, nil, 0, 0, S_NULL}
states[S_EMBLEM20] = {SPR_EMBM, FF_FULLBRIGHT|FF_PAPERSPRITE|T, -1, nil, 0, 0, S_NULL}
states[S_EMBLEM21] = {SPR_EMBM, FF_FULLBRIGHT|FF_PAPERSPRITE|U, -1, nil, 0, 0, S_NULL}
states[S_EMBLEM22] = {SPR_EMBM, FF_FULLBRIGHT|FF_PAPERSPRITE|V, -1, nil, 0, 0, S_NULL}
states[S_EMBLEM23] = {SPR_EMBM, FF_FULLBRIGHT|FF_PAPERSPRITE|W, -1, nil, 0, 0, S_NULL}
states[S_EMBLEM24] = {SPR_EMBM, FF_FULLBRIGHT|FF_PAPERSPRITE|X, -1, nil, 0, 0, S_NULL}
states[S_EMBLEM25] = {SPR_EMBM, FF_FULLBRIGHT|FF_PAPERSPRITE|Y, -1, nil, 0, 0, S_NULL}
states[S_EMBLEM26] = {SPR_EMBM, FF_FULLBRIGHT|FF_PAPERSPRITE|Z, -1, nil, 0, 0, S_NULL}

addHook("MobjSpawn", function(emblem)
	emblem.origz = emblem.z
end, MT_EMBLEM)

addHook("MobjThinker", function(emblem)
	emblem.angle = $ + FixedAngle(FRACUNIT)
	emblem.z = emblem.origz + 8 * abs(sin(FixedAngle(leveltime*4*FRACUNIT)))
	if not (emblem.frame & FF_TRANSMASK) then
		local emblemparticle = P_SpawnMobjFromMobj(emblem, P_RandomRange(-10, 10) * FRACUNIT, P_RandomRange(-10, 10) * FRACUNIT, 20*FRACUNIT, MT_SUPERSPARK) 
		emblemparticle.momx = P_RandomRange(-2, 2) * FRACUNIT
		emblemparticle.momy = P_RandomRange(-2, 2) * FRACUNIT
		emblemparticle.momz =  P_RandomRange(-2, 2) * FRACUNIT
		emblemparticle.colorized = true
		emblemparticle.color = emblem.color
		emblemparticle.fuse = 10
		emblemparticle.scale = emblem.scale *1/6
		emblemparticle.source = emblem
	end
end, MT_EMBLEM)