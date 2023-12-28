freeslot(
	"MT_FAKEEMERALD1"
)

addHook("MobjThinker", function(mobj)
    if not (mobj and mobj.valid) then return end
	if not (leveltime%35) then
		if mobj.state == S_FAKEEMERALD1 then
			MRCE_superSpark(mobj, 1, 9, 1, 21845, false, 55)
		elseif mobj.state == S_FAKEEMERALD2 then
			MRCE_superSpark(mobj, 1, 9, 1, 21845, false, R_GetColorByName("Dark Prism"))
		elseif mobj.state == S_FAKEEMERALD3 then
			MRCE_superSpark(mobj, 1, 9, 1, 21845, false, 43)
		elseif mobj.state == S_FAKEEMERALD4 then
			MRCE_superSpark(mobj, 1, 9, 1, 21845, false, 23)
		elseif mobj.state == S_FAKEEMERALD5 then
			MRCE_superSpark(mobj, 1, 9, 1, 21845, false, 50)
		elseif mobj.state == S_FAKEEMERALD6 then
			MRCE_superSpark(mobj, 1, 9, 1, 21845, false, 36)
		elseif mobj.state == S_FAKEEMERALD7 then
			MRCE_superSpark(mobj, 1, 9, 1, 21845, false, 2)
		end
	end
	if mobj.state >= S_FAKEEMERALD1 and mobj.state <= S_FAKEEMERALD8 then
		mobj.blendmode = AST_ADD
	end
	if ((emeralds & EMERALD1) != 1 and mobj.state == S_FAKEEMERALD1
	or (emeralds & EMERALD2) != 2 and mobj.state == S_FAKEEMERALD2
	or (emeralds & EMERALD3) != 4 and mobj.state == S_FAKEEMERALD3
	or (emeralds & EMERALD4) != 8 and mobj.state == S_FAKEEMERALD4
	or (emeralds & EMERALD5) != 16 and mobj.state == S_FAKEEMERALD5
	or (emeralds & EMERALD6) != 32 and mobj.state == S_FAKEEMERALD6
	or (emeralds & EMERALD7) != 64 and mobj.state == S_FAKEEMERALD7)
	and mobj.valid then
		P_RemoveMobj(mobj)
	end
	if gamemap == 121 then
		if mobj.portalslide and mr_portalopener and mr_portalopener >= 7 then
			mobj.flags = MF_NOCLIP|MF_SCENERY|MF_NOGRAVITY|MF_NOCLIPHEIGHT
			if mobj.state == S_PORTALSCRAP1 then
				P_InstaThrust(mobj, ANGLE_90, 70*FRACUNIT)
				mobj.rollangle = $ + ANG2
				mobj.angle = ANGLE_90
			else
				P_InstaThrust(mobj, ANGLE_90, 80*FRACUNIT)
				mobj.rollangle = $ + ANG10
			end
			if mobj.y > 12709*FRACUNIT and mobj.valid then
				P_KillMobj(mobj)
			end
		end
		if mobj.valid and mobj.portalpull and mr_portalopener >= 7 then
			mobj.flags = MF_NOCLIP|MF_SCENERY|MF_NOGRAVITY|MF_NOCLIPHEIGHT
			P_Thrust(mobj, (R_PointToAngle2(mobj.x, mobj.y, 0, 320*FRACUNIT)), FRACUNIT)
			if mobj.x > -768*FRACUNIT
			and mobj.y > 256*FRACUNIT
			and mobj.x < 768*FRACUNIT
			and mobj.y < 384*FRACUNIT then
				P_RemoveMobj(mobj)
			end
		end
	end
end, MT_FAKEEMERALD1)

addHook("MobjThinker", function(mobj)
    if not (mobj and mobj.valid) then return end
	if gamemap == 121 then
		if mobj.portalslide and mr_portalopener and mr_portalopener >= 7 then
			mobj.flags = MF_NOCLIP|MF_SCENERY|MF_NOGRAVITY|MF_NOCLIPHEIGHT
			P_InstaThrust(mobj, ANGLE_90, 80*FRACUNIT)
			mobj.rollangle = $ + ANG10
			if mobj.y > 12709*FRACUNIT and mobj.valid then
				P_KillMobj(mobj)
			end
		end
	end
end, MT_SPECCY)

addHook("MapLoad", function(p, v)
	if gamemap != 130 then return end
	if (emeralds & EMERALD1) == 1 then
		local em1 = P_SpawnMobj(8466*FRACUNIT, -469*FRACUNIT, 48*FRACUNIT, MT_FAKEEMERALD1)
		em1.state = S_FAKEEMERALD1
	end
	if (emeralds & EMERALD2) == 2 then
		local em2 = P_SpawnMobj(8818*FRACUNIT, -469*FRACUNIT, 48*FRACUNIT, MT_FAKEEMERALD1)
		em2.state = S_FAKEEMERALD2
	end
	if (emeralds & EMERALD3) == 4 then
		local em3 = P_SpawnMobj(8562*FRACUNIT, -437*FRACUNIT, 72*FRACUNIT, MT_FAKEEMERALD1)
		em3.state = S_FAKEEMERALD3
	end
	if (emeralds & EMERALD4) == 8 then
		local em4 = P_SpawnMobj(8722*FRACUNIT, -437*FRACUNIT, 72*FRACUNIT, MT_FAKEEMERALD1)
		em4.state = S_FAKEEMERALD4
	end
	if (emeralds & EMERALD5) == 16 then
		local em5 = P_SpawnMobj(8498*FRACUNIT, -405*FRACUNIT, 88*FRACUNIT, MT_FAKEEMERALD1)
		em5.state = S_FAKEEMERALD5
	end
	if (emeralds & EMERALD6) == 32 then
		local em6 = P_SpawnMobj(8786*FRACUNIT, -405*FRACUNIT, 88*FRACUNIT, MT_FAKEEMERALD1)
		em6.state = S_FAKEEMERALD6
	end
	if (emeralds & EMERALD7) == 64 then
		local em7 = P_SpawnMobj(8642*FRACUNIT, -421*FRACUNIT, 104*FRACUNIT, MT_FAKEEMERALD1)
		em7.state = S_FAKEEMERALD7
	end
end)