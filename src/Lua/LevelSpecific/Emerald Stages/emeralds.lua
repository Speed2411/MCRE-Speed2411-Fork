//Xian.exe was here
addHook("PlayerThink", function(p)
	if gamemap == 123 and (p.pflags & PF_FINISHED) and ((emeralds & EMERALD1) != 1) then
		emeralds = $ + 1
		if not ((marathonmode & MA_NOCUTSCENES) and p.mrce and p.mrce.hud == 1) then
			S_StartSound(null, sfx_cgot)
		end
	elseif gamemap == 124 and (p.pflags & PF_FINISHED) and ((emeralds & EMERALD2) != 2) then
		emeralds = $ + 2
		if not ((marathonmode & MA_NOCUTSCENES) and p.mrce and p.mrce.hud == 1) then
			S_StartSound(null, sfx_cgot)
		end
	elseif gamemap == 125 and (p.pflags & PF_FINISHED) and ((emeralds & EMERALD3) != 4) then
		emeralds = $ + 4
		if not ((marathonmode & MA_NOCUTSCENES) and p.mrce and p.mrce.hud == 1) then
			S_StartSound(null, sfx_cgot)
		end
	elseif gamemap == 126 and (p.pflags & PF_FINISHED) and ((emeralds & EMERALD4) != 8) then
		emeralds = $ + 8
		if not ((marathonmode & MA_NOCUTSCENES) and p.mrce and p.mrce.hud == 1) then
			S_StartSound(null, sfx_cgot)
		end
	elseif gamemap == 127 and (p.pflags & PF_FINISHED) and ((emeralds & EMERALD5) != 16) then
		emeralds = $ + 16
		if not ((marathonmode & MA_NOCUTSCENES) and p.mrce and p.mrce.hud == 1) then
			S_StartSound(null, sfx_cgot)
		end
	elseif gamemap == 128 and (p.pflags & PF_FINISHED) and ((emeralds & EMERALD6) != 32) then
		emeralds = $ + 32
		if not ((marathonmode & MA_NOCUTSCENES) and p.mrce and p.mrce.hud == 1) then
			S_StartSound(null, sfx_cgot)
		end
	elseif gamemap == 129 and (p.pflags & PF_FINISHED) and ((emeralds & EMERALD7) != 64) then
		emeralds = $ + 64
		if not ((marathonmode & MA_NOCUTSCENES) and p.mrce and p.mrce.hud == 1) then
			S_StartSound(null, sfx_cgot)
		end
	--elseif gamemap == 129 and (p.pflags & PF_FINISHED) and All7Emeralds(emeralds) then
		--S_StartSound(null, sfx_s3k9c)
		--hyperunlocked = true
	end
end)

--goalring support for netgames
addHook("MobjThinker", function(mobj)
    if not mobj and mobj.valid then return end
	--if gamemap < 123 return end //only mudhole karst has a shrine rn, so only it needs this function

	--if gamemap > 129 return end

	if gamemap != 123 then return end

	if GoalRing == nil then
		P_RemoveMobj(mobj)
	end
end, MT_SIGN)

addHook("TouchSpecial", function(mo, toucher)
	if gamemap >= 123 and gamemap <= 135 then return true end --don't want players interacting with the emerald
  end, MT_EMERALD1)

  addHook("TouchSpecial", function(mo, toucher)
	if gamemap >= 123 and gamemap <= 135 then return true end
  end, MT_EMERALD2)

  addHook("TouchSpecial", function(mo, toucher)
	if gamemap >= 123 and gamemap <= 135 then return true end
  end, MT_EMERALD3)

  addHook("TouchSpecial", function(mo, toucher)
	if gamemap >= 123 and gamemap <= 135 then return true end
  end, MT_EMERALD4)

  addHook("TouchSpecial", function(mo, toucher)
	if gamemap >= 123 and gamemap <= 135 then return true end
  end, MT_EMERALD5)

  addHook("TouchSpecial", function(mo, toucher)
	if gamemap >= 123 and gamemap <= 135 then return true end
  end, MT_EMERALD6)

  addHook("TouchSpecial", function(mo, toucher)
	if gamemap >= 123 and gamemap <= 135 then return true end
  end, MT_EMERALD7)
  addHook("MobjThinker", function(mobj)
	  if not (mobj and mobj.valid) then return end
	  if (leveltime%TICRATE == TICRATE/2) or (leveltime%TICRATE == TICRATE) then
		  MRCE_superSpark(mobj, 1, 5, 1, 1*FRACUNIT, false, 55)
	  end
	  if mobj.valid then
		  mobj.blendmode = AST_ADD
	  end
  end, MT_EMERALD1)

  addHook("MobjThinker", function(mobj)
	  if not mobj and mobj.valid then return end
	  if (leveltime%TICRATE == TICRATE/2) or (leveltime%TICRATE == TICRATE) then
		  MRCE_superSpark(mobj, 1, 5, 1, 1*FRACUNIT, false, 62)
	  end
	  if mobj.valid then
		  mobj.blendmode = AST_ADD
	  end
	  if gamemap == 124 then
		  if GoalRing == nil then
			  P_RemoveMobj(mobj)
		  end
	  end
  end, MT_EMERALD2)

  addHook("MobjThinker", function(mobj)
	  if not mobj and mobj.valid then return end
	  if (leveltime%TICRATE == TICRATE/2) or (leveltime%TICRATE == TICRATE) then
		  MRCE_superSpark(mobj, 1, 5, 1, 1*FRACUNIT, false, 43)
	  end
	  if mobj.valid then
		  mobj.blendmode = AST_ADD
	  end
	  if gamemap == 125 then
		  if GoalRing == nil then
			  P_RemoveMobj(mobj)
		  end
	  end
  end, MT_EMERALD3)

  addHook("MobjThinker", function(mobj)
	  if not mobj and mobj.valid then return end
	  if (leveltime%TICRATE == TICRATE/2) or (leveltime%TICRATE == TICRATE) then
		  MRCE_superSpark(mobj, 1, 5, 1, 1*FRACUNIT, false, 23)
	  end
	  if mobj.valid then
		  mobj.blendmode = AST_ADD
	  end
	  if gamemap == 126 then
		  if GoalRing == nil then
			  P_RemoveMobj(mobj)
		  end
	  end
  end, MT_EMERALD4)

  addHook("MobjThinker", function(mobj)
	  if not mobj and mobj.valid then return end
	  if (leveltime%TICRATE == TICRATE/2) or (leveltime%TICRATE == TICRATE) then
		  MRCE_superSpark(mobj, 1, 5, 1, 1*FRACUNIT, false, 50)
	  end
	  if mobj.valid then
		  mobj.blendmode = AST_ADD
	  end
	  if gamemap == 127 then
		  if GoalRing == nil then
			  P_RemoveMobj(mobj)
		  end
	  end
  end, MT_EMERALD5)

  addHook("MobjThinker", function(mobj)
	  if not mobj and mobj.valid then return end
	  if (leveltime%TICRATE == TICRATE/2) or (leveltime%TICRATE == TICRATE) then
		  MRCE_superSpark(mobj, 1, 5, 1, 1*FRACUNIT, false, 36)
	  end
	  if mobj.valid then
		  mobj.blendmode = AST_ADD
	  end
	  if gamemap == 128 then
		  if GoalRing == nil then
			  P_RemoveMobj(mobj)
		  end
	  end
  end, MT_EMERALD6)

  addHook("MobjThinker", function(mobj)
	  if not mobj and mobj.valid then return end
	  if (leveltime%TICRATE == TICRATE/2) or (leveltime%TICRATE == TICRATE) then
		  MRCE_superSpark(mobj, 1, 5, 1, 1*FRACUNIT, false, 3)
	  end
	  if mobj.valid then
		  mobj.blendmode = AST_ADD
	  end
  end, MT_EMERALD7)