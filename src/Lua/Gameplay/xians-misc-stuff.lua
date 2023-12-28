--=======--
freeslot(
"MT_URING"
)
sfxinfo[freeslot("sfx_marioe")].caption = "Correct Solution"
local debug = 0

--despawn ring maces in ultimate mode

addHook("MobjSpawn", function(mobj)
    if not mobj and mobj.valid then return end

    if not ultimatemode then return end

	mobj.state = S_NULL

end, MT_RING)

addHook("MobjSpawn", function(mobj)
    if not mobj and mobj.valid then return end

    if not ultimatemode then return end

	mo.state = S_NULL

end, MT_COIN)

//credit to katsy for this tiny function pulled from reveries. it's so simple I could've written it myself, but eh.
--Makes elemental shield not render its fire when in water. Because fire can't burn in water. Obviously.

mobjinfo[MT_ELEMENTAL_ORB].spawnstate = S_ELEM1
mobjinfo[MT_ELEMENTAL_ORB].seestate = S_ELEMF1

addHook("MobjThinker", function(shield)
	if (shield.target) and shield.target.valid then
		if (shield.target.type == MT_ELEMENTAL_ORB) then
			if ((shield.target.target.eflags & MFE_UNDERWATER or shield.target.target.eflags & MFE_TOUCHWATER) and not (shield.target.target.eflags & MFE_TOUCHLAVA)) then
				shield.flags2 = $|MF2_DONTDRAW
			elseif (shield.flags2 & MF2_DONTDRAW) then
				shield.flags2 = $ & ~MF2_DONTDRAW
			end
		elseif (shield.target.type == MT_FLAMEAURA_ORB) then
			--print(shield.target.target.player.dashticsleft)
			if shield.target.target.player.dashticsleft and shield.target.target.player.mrce.jump then
				shield.target.flags2 = $|MF2_DONTDRAW
				shield.flags2 = $|MF2_DONTDRAW
			else
				shield.target.flags2 = $ & ~MF2_DONTDRAW
				shield.flags2 = $ & ~MF2_DONTDRAW
			end
		end
	end
end, MT_OVERLAY)

--air bubble thinker
addHook("TouchSpecial", function(mo, toucher)
	if toucher.player
	and MRCE_isHyper(toucher.player) then
		return true -- hyper forms don't need bubbles
	elseif (toucher.player.yusonictable and toucher.player.yusonictable.hypersonic and toucher.player.mo.skin == "adventuresonic") then return true
	else toucher.player.powers[pw_spacetime] = 12 * TICRATE end --midnight freeze's ice water uses space countdown
end, MT_EXTRALARGEBUBBLE)

addHook("MobjSpawn", function(mobj)
	if netgame then
		mobj.fuse = 70
	else
		mobj.fuse = 140
	end
end, MT_CYBRAKDEMON_FLAMEREST)

addHook("MobjFuse", function(mobj)
	P_RemoveMobj(mobj)
end, MT_CYBRAKDEMON_FLAMEREST)

addHook("MobjDeath", function(pmo, imo, smo, dmg)
	if dmg == DMG_FIRE then
		pmo.preburncolor = pmo.color
	end
end, MT_PLAYER)

addHook("PlayerThink", function(p)
	if p.spectator then return end
	local ctime = os.date("*t")
	if p.mo.preburncolor and p.playerstate == PST_DEAD then
		p.mo.colorized = true
		p.mo.color = SKINCOLOR_CARBON
		if not (leveltime % 2) and p.mo.z > p.mo.floorz then
			A_BossScream(p.mo, 0, MT_FIREBALLTRAIL)
		end
	end
	if ctime.month == 4 and ctime.day == 1 then
		p.mo.friction = 3*FRACUNIT/2
		p.mo.spriteyscale = FRACUNIT/2
	end
end)

addHook("PlayerSpawn", function(p)
	if p.spectator then return end
	if p.mo.preburncolor != nil then
		p.mo.color = p.mo.preburncolor
		p.mo.preburncolor = nil
	end
end)

addHook("ThinkFrame", function()
	if gamemap == 99 and CV_FindVar("touch_inputs") != nil then
		G_SetCustomExitVars(101, true)
		G_ExitLevel() --improvised mobile support means no support for episode select
	end
end)