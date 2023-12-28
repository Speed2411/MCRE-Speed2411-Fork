local pillar1 = false
local pillar2 = false
local pillar3 = false
local pillar4 = false
local pillar5 = false
local pillar6 = false
local pillar7 = false
local portalstart = false
if mr_portalopener == nil then
	rawset(_G, "mr_portalopener", 0)
end
freeslot("sfx_topaz")

for i = 1, 4, 1 do
	freeslot("S_PORTALSCRAP"..i)
end

local function emerald1(line, mo, d)
	if ((emeralds & EMERALD1) == 1) then
		local em1 = P_SpawnMobj(0, -1344*FRACUNIT, 184*FRACUNIT, MT_FAKEEMERALD1)
		em1.state = S_FAKEEMERALD1
		em1.portalpull = true
		mr_portalopener = $ + 1
		pillar1 = true
		S_StartSoundAtVolume(em1, sfx_s3k9c, 150)
	end
end

addHook("LinedefExecute", emerald1, "SEMMY1")

local function emerald2(line, mo, d)
	if ((emeralds & EMERALD2) == 2) then
		local em2 = P_SpawnMobj(1064*FRACUNIT, -816*FRACUNIT, 184*FRACUNIT, MT_FAKEEMERALD1)
		em2.state = S_FAKEEMERALD2
		em2.portalpull = true
		mr_portalopener = $ + 1
		pillar2 = true
		S_StartSoundAtVolume(em2, sfx_s3k9c, 150)
	end
end

addHook("LinedefExecute", emerald2, "SEMMY2")

local function emerald3(line, mo, d)
	if ((emeralds & EMERALD3) == 4) then
		local em3 = P_SpawnMobj(1304*FRACUNIT, 320*FRACUNIT, 184*FRACUNIT, MT_FAKEEMERALD1)
		em3.state = S_FAKEEMERALD3
		em3.portalpull = true
		mr_portalopener = $ + 1
		pillar3 = true
		S_StartSoundAtVolume(em3, sfx_s3k9c, 150)
	end
end

addHook("LinedefExecute", emerald3, "SEMMY3")

local function emerald4(line, mo, d)
	if ((emeralds & EMERALD4) == 8) then
		local em4 = P_SpawnMobj(568*FRACUNIT, 1216*FRACUNIT, 184*FRACUNIT, MT_FAKEEMERALD1)
		em4.state = S_FAKEEMERALD4
		em4.portalpull = true
		mr_portalopener = $ + 1
		pillar4 = true
		S_StartSoundAtVolume(em4, sfx_s3k9c, 150)
	end
end

addHook("LinedefExecute", emerald4, "SEMMY4")

local function emerald5(line, mo, d)
	if ((emeralds & EMERALD5) == 16) then
		local em5 = P_SpawnMobj(-568*FRACUNIT, 1216*FRACUNIT, 184*FRACUNIT, MT_FAKEEMERALD1)
		em5.state = S_FAKEEMERALD5
		em5.portalpull = true
		mr_portalopener = $ + 1
		pillar5 = true
		S_StartSoundAtVolume(em5, sfx_s3k9c, 150)
	end
end

addHook("LinedefExecute", emerald5, "SEMMY5")

local function emerald6(line, mo, d)
	if ((emeralds & EMERALD6) == 32) then
		local em6 = P_SpawnMobj(-1304*FRACUNIT, 320*FRACUNIT, 184*FRACUNIT, MT_FAKEEMERALD1)
		em6.state = S_FAKEEMERALD6
		em6.portalpull = true
		mr_portalopener = $ + 1
		pillar6 = true
		S_StartSoundAtVolume(em6, sfx_s3k9c, 150)
	end
end

addHook("LinedefExecute", emerald6, "SEMMY6")

local function emerald7(line, mo, d)
	if ((emeralds & EMERALD7) == 64) then
		local em7 = P_SpawnMobj(-1064*FRACUNIT, -817*FRACUNIT, 184*FRACUNIT, MT_FAKEEMERALD1)
		em7.state = S_FAKEEMERALD7
		em7.portalpull = true
		mr_portalopener = $ + 1
		pillar7 = true
		S_StartSoundAtVolume(em7, sfx_s3k9c, 150)
	end
end

addHook("LinedefExecute", emerald7, "SEMMY7")

addHook("ThinkFrame", function()
	if gamemap == 97 then
		if marathonmode then
			G_SetCustomExitVars(1101, 1)
		else
			G_SetCustomExitVars(122,1)
		end
		G_ExitLevel()
	end
	for p in players.iterate do
		if pillar1 == true then
			P_LinedefExecute(6001, p.mo, 6000)
			pillar1 = false
		end
		if pillar2 == true then
			P_LinedefExecute(6002, p.mo, 6003)
			pillar2 = false
		end
		if pillar3 == true then
			P_LinedefExecute(6004, p.mo, 6005)
			pillar3 = false
		end
		if pillar4 == true then
			P_LinedefExecute(6006, p.mo, 6007)
			pillar4 = false
		end
		if pillar5 == true then
			P_LinedefExecute(6008, p.mo, 6009)
			pillar5 = false
		end
		if pillar6 == true then
			P_LinedefExecute(6010, p.mo, 6011)
			pillar6 = false
		end
		if pillar7 == true then
			P_LinedefExecute(6012, p.mo, 6013)
			pillar7 = false
		end
		if mr_portalopener == 7 then
			if not All7Emeralds(emeralds) then
				mr_portalopener = 0
				return
			else
				S_StartSound(nil, sfx_s3k54)
				P_FlashPal(p, PAL_WHITE, 7)
				for i = 6014, 6030, 1 do
					P_LinedefExecute(i, p.mo)
				end
				mr_portalopener = 8
			end
		end
	end
end)

addHook("MapLoad", function(map)
	if mr_portalopener != 0 then
		mr_portalopener = 0
		pillar1 = false
		pillar2 = false
		pillar3 = false
		pillar4 = false
		pillar5 = false
		pillar6 = false
		pillar7 = false
	end
	portalstart = false
	if mrce_hyperunlocked == true then
		P_LinedefExecute(4000, nil)
	end
end)

addHook("PlayerThink", function(p)
	if gamemap != 121 then return end
	if (p.pflags & PF_FINISHED or p.exiting) and mr_portalopener == 8 then
		p.mo.flags2 = $|MF2_DONTDRAW
	elseif p.mo.x > 6000*FRACUNIT then
		p.mrce.camroll = $ - 2*ANG1
		p.drawangle = $ + 5*ANG1
	end
	if mr_portalopener >= 7 and p.mo.x < 3250*FRACUNIT then
		P_Thrust(p.mo, (R_PointToAngle2(p.mo.x, p.mo.y, 0, 320*FRACUNIT)), max((cos(R_PointToDist2(p.mo.x, p.mo.y, 0, 320*FRACUNIT)*5)*4), 0))
	end

	if p.pet then
		if gamemap == 121 and p.exiting and All7Emeralds(emeralds) then
			p.mo.pet.flags2 = $|MF2_DONTDRAW --pets support for pet to enter portal as well
		end
	end
end)

addHook("LinedefExecute", function(l, mo)
	local p = mo.player
	mo.rollangle = $ + FixedAngle(l.frontside.textureoffset)
	if portalstart == false then
		local scr1 = P_SpawnMobj((mo.x + (P_RandomRange(-200, 200)*FRACUNIT)), (mo.y + (P_RandomRange(-16000, -12000)*FRACUNIT)), (mo.z + (P_RandomRange(-200, 200)*FRACUNIT)), MT_FAKEEMERALD1)
		scr1.state = S_FAKEEMERALD1
		scr1.portalslide = true
		local scr2 = P_SpawnMobj((mo.x + (P_RandomRange(-200, 200)*FRACUNIT)), (mo.y + (P_RandomRange(-16000, -12000)*FRACUNIT)), (mo.z + (P_RandomRange(-200, 200)*FRACUNIT)), MT_FAKEEMERALD1)
		scr2.state = S_FAKEEMERALD2
		scr2.portalslide = true
		local scr3 = P_SpawnMobj((mo.x + (P_RandomRange(-200, 200)*FRACUNIT)), (mo.y + (P_RandomRange(-16000, -12000)*FRACUNIT)), (mo.z + (P_RandomRange(-200, 200)*FRACUNIT)), MT_FAKEEMERALD1)
		scr3.state = S_FAKEEMERALD3
		scr3.portalslide = true
		local scr4 = P_SpawnMobj((mo.x + (P_RandomRange(-200, 200)*FRACUNIT)), (mo.y + (P_RandomRange(-16000, -12000)*FRACUNIT)), (mo.z + (P_RandomRange(-200, 200)*FRACUNIT)), MT_FAKEEMERALD1)
		scr4.state = S_FAKEEMERALD4
		scr4.portalslide = true
		local scr5 = P_SpawnMobj((mo.x + (P_RandomRange(-200, 200)*FRACUNIT)), (mo.y + (P_RandomRange(-16000, -12000)*FRACUNIT)), (mo.z + (P_RandomRange(-200, 200)*FRACUNIT)), MT_FAKEEMERALD1)
		scr5.state = S_FAKEEMERALD5
		scr5.portalslide = true
		local scr6 = P_SpawnMobj((mo.x + (P_RandomRange(-200, 200)*FRACUNIT)), (mo.y + (P_RandomRange(-16000, -12000)*FRACUNIT)), (mo.z + (P_RandomRange(-200, 200)*FRACUNIT)), MT_FAKEEMERALD1)
		scr6.state = S_FAKEEMERALD6
		scr6.portalslide = true
		local scr7 = P_SpawnMobj((mo.x + (P_RandomRange(-200, 200)*FRACUNIT)), (mo.y + (P_RandomRange(-16000, -12000)*FRACUNIT)), (mo.z + (P_RandomRange(-200, 200)*FRACUNIT)), MT_FAKEEMERALD1)
		scr7.state = S_FAKEEMERALD7
		scr7.portalslide = true
		local scr8 = P_SpawnMobj((mo.x + (P_RandomRange(-200, 200)*FRACUNIT)), (mo.y + (P_RandomRange(-4000, -3250)*FRACUNIT)), (mo.z + (P_RandomRange(-200, 200)*FRACUNIT)), MT_FAKEEMERALD1)
		scr8.state = S_PORTALSCRAP1
		scr8.portalslide = true
		if P_RandomChance(50) then
			local scrspec = P_SpawnMobj((mo.x + (P_RandomRange(-150, 150)*FRACUNIT)), (mo.y + (P_RandomRange(-12000, -15000)*FRACUNIT)), (mo.z + (P_RandomRange(-150, 150)*FRACUNIT)), MT_SPECCY)
			scrspec.flags = MF_NOGRAVITY|MF_NOBLOCKMAP|MF_NOCLIP|MF_SCENERY
			scrspec.state = S_SPECCY
			scrspec.color = SKINCOLOR_CARBON
			scrspec.scale = FRACUNIT/2
			scrspec.portalslide = true
		end
		--local scr8 = P_SpawnMobj((mo.x + (P_RandomRange(-200, 200)*FRACUNIT)), (mo.y + (P_RandomRange(-16000, -12000)*FRACUNIT)), (mo.z + (P_RandomRange(-200, 200)*FRACUNIT)), MT_FAKEEMERALD1)
		--scr8.state = S_FAKEEMERALD8
		--scr8.portalslide = true
		--scr8. flags = MF_NOCLIP|MF_SCENERY|MF_NOGRAVITY|MF_NOCLIPHEIGHT  --uncommenting this won't spawn an 8th emerald, but instead infinite copies of the other emeralds
		portalstart = true																																																																		--for some reason
	end
	if p then
		--P_TeleportCameraMove(camera, 6784*FRACUNIT, camera.y, 16*FRACUNIT)
		p.mrce.speen = $ + FixedAngle(5*FRACUNIT)
		if p.mrce.hud == 1 then
			p.realtime = (P_RandomFixed() * P_RandomFixed())
		end
		p.viewrollangle = p.mrce.camroll
		p.panim = PA_PAIN
		mo.state = S_PLAY_PAIN
		if not netgame then
			for p in players.iterate do
				if not p.bot then continue end
				p.powers[pw_ignorelatch] = 32768
				p.mo.flags = $|MF_NOCLIP|MF_NOCLIPTHING|MF_SCENERY|MF_NOTHINK
				p.mo.flags2 = $|MF2_DONTDRAW
				p.mo.state = S_INVISIBLE
			end
		end
	end
end, "RICKROLL")

addHook("MobjThinker", function(mobj)
    if not (mobj and mobj.valid) then return end
	if gamemap != 121 then return end
	if mr_portalopener != 8 then return end
	mobj.flags = MF_NOCLIP|MF_SCENERY|MF_NOGRAVITY|MF_NOCLIPHEIGHT
	P_Thrust(mobj, (R_PointToAngle2(mobj.x, mobj.y, 0, 320*FRACUNIT)), FRACUNIT)
	if mobj.x > -768*FRACUNIT
	and mobj.y > 256*FRACUNIT
	and mobj.x < 768*FRACUNIT
	and mobj.y < 384*FRACUNIT then
		P_RemoveMobj(mobj)
	end
end, MT_FBOSS2)


local function HandleShieldOrb(mobj)
    if mobj and mobj.valid
	and gamemap == 121
	and mobj.x > 6000*FRACUNIT
	and mobj.y > 12707*FRACUNIT then
		mobj.flags2 = $|MF2_DONTDRAW
	end
end

addHook("MobjThinker", HandleShieldOrb, MT_ELEMENTAL_ORB)
addHook("MobjThinker", HandleShieldOrb, MT_ATTRACT_ORB)
addHook("MobjThinker", HandleShieldOrb, MT_FORCE_ORB)
addHook("MobjThinker", HandleShieldOrb, MT_ARMAGEDDON_ORB)
addHook("MobjThinker", HandleShieldOrb, MT_WHIRLWIND_ORB)
addHook("MobjThinker", HandleShieldOrb, MT_PITY_ORB)
addHook("MobjThinker", HandleShieldOrb, MT_FLAMEAURA_ORB)
addHook("MobjThinker", HandleShieldOrb, MT_BUBBLEWRAP_ORB)
addHook("MobjThinker", HandleShieldOrb, MT_THUNDERCOIN_ORB)


--portal doesn't open in Record Attack, so just end the level once you beat the big bad
addHook("BossThinker", function(mo)
	if not (mo.valid) then return end  --if object was nuked by unexpected outside influence, then prevent console errors
	if mo.health <= 0
	and modeattacking then --if he ded
		for p in players.iterate do
			P_DoPlayerExit(p)
		end
	end
end, MT_FBOSS)

addHook("BossThinker", function(mo)
	if not (mo.valid) then return end  --if object was nuked by unexpected outside influence, then prevent console errors
	if mo.health <= 0
	and modeattacking then --if he ded
		for p in players.iterate do
			P_DoPlayerExit(p) --just end the damn level already nothing else wants to work
		end
	end
end, MT_FBOSS2)

addHook("NetVars", function(net)
	mr_portalopener = net($)
	pillar1 = net($)
	pillar2 = net($)
	pillar3 = net($)
	pillar4 = net($)
	pillar5 = net($)
	pillar6 = net($)
	pillar7 = net($)
	portalstart = net($)
end)
