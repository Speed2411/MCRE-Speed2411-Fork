freeslot("MT_CONTICON", "S_CONTICON1")

local freshset = 0
local setcollect = 0

mobjinfo[MT_CONTICON] = {
//$Title Continue Medal
//$Sprite HUNDA0
//$Category Mystic Realm Special
//$NotAngled
	doomednum = 2218,
	radius = 28*FRACUNIT,
	height = 38*FRACUNIT,
}

addHook("MobjSpawn", function(mo)
	mo.origz = mo.z
	mo.scale = 2*FRACUNIT
	if not (multiplayer or modeattacking or gamecomplete) then
		mo.contindex = freshset + 1
		freshset = $ + 1
	end
end, MT_CONTICON)

addHook("MobjThinker", function(mo)
	if not (mo and mo.valid) then return end

	local dist = INT32_MAX
	local temp
	local closestplayer
	if mo.speentime then
		mo.angle = $ + FixedAngle((60 - mo.fuse) * FRACUNIT)
		mo.z = $ + (2*FRACUNIT*P_MobjFlip(mo))
	else
		mo.angle = $ + FixedAngle(FRACUNIT)
		mo.z = mo.origz + 8 * (abs(sin(FixedAngle(leveltime*4*FRACUNIT))) * P_MobjFlip(mo))
	end
	for p in players.iterate do
		if not p.valid or p.bot or p.spectator then continue end
		if not (p.mo and p.mo.valid) then continue end
		if multiplayer and p.playerstate != PST_LIVE then continue end

		temp = FixedHypot(FixedHypot(p.mo.x - mo.x, p.mo.y - mo.y), p.mo.z - mo.z)

		if temp < dist then
			closestplayer = p
			dist = temp
		end

		if closestplayer == nil or skins[closestplayer.skin].sprites[SPR2_XTRA].numframes == 0 then
			// Closest player not found (no players in game?? may be empty dedicated server!), or does not have correct sprite.
			mo.sprite = SPR_UNKN
			mo.frame = FF_FULLBRIGHT|FF_PAPERSPRITE|B
			return
		end

		if mo.speentime then
			closestplayer = mo.speentime
		end

		mo.skin = closestplayer.mo.skin
		mo.sprite = SPR_PLAY
		mo.sprite2 = SPR2_XTRA
		mo.frame = FF_FULLBRIGHT|FF_PAPERSPRITE|C
		mo.color = closestplayer.skincolor
		mo.colorized = closestplayer.mo.colorized
		mo.blendmode = closestplayer.mo.blendmode
	end
	if mo.fuse and mo.fuse < 36 then
		mo.frame = C|FF_FULLBRIGHT|FF_PAPERSPRITE|TR_TRANS90-((mo.fuse*FRACUNIT)/4)
	end

	if not (multiplayer or modeattacking or gamecomplete) then
		if (setcollect & (1 << (mo.contindex - 1))) and not mo.speentime then
			P_RemoveMobj(mo)
		end
	end
end, MT_CONTICON)

local contcount = 0
local contmap

addHook("TouchSpecial", function(mo, toucher)
	if mo and mo.valid and toucher and toucher.valid and toucher.player and mo.health then
		if mo.speentime then return true end
		local p = toucher.player
		if ((mapheaderinfo[gamemap].lvlttl == "Dimension Warp") or (mapheaderinfo[gamemap].lvlttl == "Primordial Abyss")) or modeattacking then
			P_AddPlayerScore(p, 2500)
			S_StartSound(toucher, sfx_s1c5)
		elseif multiplayer or gamecomplete or p.lives == INFLIVES then
			P_GivePlayerRings(p, 100)
			if p.skipscrap != nil then
				p.skipscrap = $ + 150
			end
			S_StartSound(p.mo, sfx_kc33)
		else
			if ultimatemode then
				if contcount < 4 then
					contcount = $ + 1
					S_StartSound(toucher, sfx_token)
				else
					S_StartSound(nil, sfx_s23f, p)
					contcount = 0
					p.continues = min($ + 1, 99)
				end
			elseif not modeattacking then
				if contcount < 2 then
					contcount = $ + 1
					S_StartSound(toucher, sfx_token)
				else
					contcount = 0
					S_StartSound(nil, sfx_s23f, p)
					p.continues = min($ + 1, 99)
				end
			end
		end
		if not (multiplayer or modeattacking or (p.lives == INFLIVES) or gamecomplete) then
			setcollect = $|(1 << (mo.contindex - 1))
		end
		mo.speentime = p
		mo.fuse = 50
		mo.scalespeed = FRACUNIT / 18
		mo.destscale = $ * 99
		mo.flags = $|MF_NOCLIP|MF_NOCLIPHEIGHT
		P_AddPlayerScore(p, 5000)
		return true
	end
end, MT_CONTICON)

addHook("MapChange", function(map)
	if (multiplayer or modeattacking or gamecomplete) then return end
	if contmap == nil then
		contmap = map
	elseif contmap == map then
		freshset = 0
	else
		freshset = 0
		setcollect = 0
	end
end)