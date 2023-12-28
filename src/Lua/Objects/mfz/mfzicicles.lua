freeslot("MT_ICICLE", "sfx_s1dfal")

sfxinfo[sfx_s1dfal] = {
	singular = false,
	caption = "Falling icicle"
}

function A_SpawnIcicle(actor)
	if actor and actor.valid then
		-- Radicalicious 01/05/2023:
		-- Midnight Freeze is a very hardware-intensive map, so let's
		-- use efficient blockmap searching to not spawn any unnecessary
		-- ice objects when players aren't around.
		if not (searchBlockmap("objects", function(amo, pmo)
			if not pmo.valid then return nil end
			if pmo.player then return true else return nil end
		end, actor, actor.x-1024*FRACUNIT, actor.x+1024*FRACUNIT, actor.y-1024*FRACUNIT, actor.y+1024*FRACUNIT)) then
			if leveltime % (2*TICRATE + (AngleFixed(actor.angle)/FRACUNIT)) == 0 then
				local spike = P_SpawnMobj(actor.x, actor.y, actor.z, MT_ICICLE)
				spike.scale = FRACUNIT * 2
				spike.shadowscale = spike.scale
			end
		end
	end
end

addHook("MobjThinker", function(mobj)
	if mobj and mobj.valid then
		if P_IsObjectOnGround(mobj) then
			for i = 0, 8, 1 do
				local fa = (i*(ANGLE_180/4))
				local shatter = P_SpawnMobj(mobj.x, mobj.y, mobj.z+FRACUNIT, MT_ROCKCRUMBLE9)
				shatter.momx = FixedMul(sin(fa),5*FRACUNIT)
				shatter.momy = FixedMul(cos(fa),5*FRACUNIT)
				P_SetObjectMomZ(shatter, 5*FRACUNIT, false)
				shatter.scale = FRACUNIT
				shatter.renderflags = $ | RF_FULLBRIGHT
			end
			S_StartSound(mobj, sfx_shattr)
			P_RemoveMobj(mobj)
		end
	end
end, MT_ICICLE)