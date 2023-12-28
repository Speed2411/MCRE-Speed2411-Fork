//torches for the Mystic Temple of Flames
//light all 7 spread amongst the firey catacombs to open the door to the fire stone
freeslot("MT_TEMPLETORCH", "S_TEMPLETORCH1", "S_TEMPLETORCH2")
/*
local function SafeFreeslot(...)
	for _, item in ipairs({...})
		if rawget(_G, item) == nil
			freeslot(item)
		end
	end
end

SafeFreeslot(
"MT_MARIO_FIREBALL")
*/
local flamecounter = 0
local debug = 0

local function onfire(player)
	if player.powers[pw_shield] & SH_FLAMEAURA
	or (player.mo.skin == "supersonic" and (player.powers[pw_shield] & SH_FIREFLOWER))
	or (player.mo.skin == "blaze" and (player.solchar and player.solchar.istransformed))
	or (player.mo.skin == "blaze" and player.blazeboosting)
	or (player.mo.skin == "blaze" and player.mo.blazejumping)
	or IsMario != nil and IsMario(player.mo)
	or (player.mo.skin == "blaze" and player.blazehover) then
		return true
	end
	return false
end

mobjinfo[MT_TEMPLETORCH] = {
	doomednum = 3109,
	spawnstate = S_TEMPLETORCH1,
	radius = 28*FRACUNIT,
	height = 42*FRACUNIT,
	flags = MF_SCENERY|MF_SPECIAL
}

states[S_TEMPLETORCH1] = {
	sprite = SPR_FLMH,
	frame = A,
}

states[S_TEMPLETORCH2] = {
	sprite = SPR_FLMH,
	frame = A,
}

addHook("MapLoad", function(p, v)
	if flamecounter > 0 then
		flamecounter = 0
	end
	local mariobros = false
	for p in players.iterate do
		if IsMario != nil and IsMario(p.mo) and gamemap == 110 and mariobros == false then
			P_SpawnMobj(-4864*FRACUNIT, 17664*FRACUNIT, 832*FRACUNIT, MT_THUNDERCOIN_GOLDBOX)
			mariobros = true
		end
	end
end)

addHook("ThinkFrame", function()
	--print(tostring(flamecounter))
	if flamecounter == 7 then
		P_LinedefExecute(4001, nil)
		flamecounter = 0
		S_StartSound(nil, sfx_zelda)
	end
end)

addHook("TouchSpecial", function(mo, toucher)
	local p = toucher.player
	if mo.state != S_TEMPLETORCH1 then return true end
	if p and p.valid and mo.state == S_TEMPLETORCH1
	and onfire(p) then
		P_SpawnMobj(mo.x, mo.y, mo.z + 80*FRACUNIT, MT_FLAME)
		flamecounter = $ + 1
		mo.state = S_TEMPLETORCH2
		return true
	else
		return true
	end
end, MT_TEMPLETORCH)

addHook("MobjCollide", function(mo, mobj)
	if gamemap != 110 then return end
	if not mobj and (mobj.mrce_IsFire or mobj.flameangle) then return end
	if mo.state == S_TEMPLETORCH2 then return end
	if mo.state == S_TEMPLETORCH1
	and mo.z <= mobj.z + mobj.height
	and mo.z + mo.height >= mobj.z then
		P_SpawnMobj(mo.x, mo.y, mo.z + 80*FRACUNIT, MT_FLAME)
		flamecounter = $ + 1
		mo.state = S_TEMPLETORCH2
	end
end, MT_TEMPLETORCH)
/*
addHook("MobjThinker", function(mobj)
	if gamemap != 110 then return end
	if rawget(_G, "GetMarioOverallsColor")  != nil then --are the mario bros loaded
		if mobj.type == MT_MARIO_FIREBALL then
			mobj.mrce_IsFire = true
		end
	end
	if rawget(_G, "SMSRSpawnGhost")  != nil then --is sms loaded
		if mobj.type == MT_SMSFIREBLAST
		or mobj.type == MT_HMSFIREBLAST then
			mobj.mrce_IsFire = true
		end
	end
end)*/

addHook("NetVars", function(net)
	flamecounter = net($)
end)