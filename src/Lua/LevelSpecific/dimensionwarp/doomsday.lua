freeslot("MT_SUPER_ORB","S_SUPER_ORB","SPR_SORB")

mobjinfo[MT_SUPER_ORB] = {
	doomednum = -1,
	spawnstate = S_SUPER_ORB,
	spawnhealth = 1000,
	reactiontime = 8,
	radius = 32*FRACUNIT,
	height = 64*FRACUNIT,
	mass = 16,
	dispoffset = 1,
	flags = MF_NOBLOCKMAP|MF_NOGRAVITY|MF_NOCLIP|MF_NOCLIPHEIGHT|MF_SCENERY
}

states[S_SUPER_ORB] = {SPR_SORB,A|TR_TRANS50|FF_ANIMATE,-1,nil,7,2,S_SUPER_ORB}

addHook("PlayerCanDamage", function(player, mobj)
	if mapheaderinfo[gamemap].lvlttl == "Dimension Warp" then
		if mobj.flags & MF_MONITOR then
			if MRCE_isHyper(player) then
				return true
			end
		else
			return true
		end
	end
end)

addHook("PlayerSpawn", function(p)
	if not p.realmo then return false end
	if p.spectator then return false end
    p.mrce.cosmichysteria = false
	if mapheaderinfo[gamemap].lvlttl == "Dimension Warp" then
		if modeattacking then
			p.mrce.hypercheat = true
		end
		if p.charflags & SF_SUPER
		and not p.mo.skin == "supersonic" --characters that can be super but have their own transform handlers on spawn
		or p.mo.skin == "adventuresonic" --characters that can be super but use workarounds to avoid transforming on spinpress; i.e., that don't have SF_SUPER
		or p.mo.skin == "skip" then
			if not (p.charflags & SF_SUPER) then
				p.charflags = $ | SF_SUPER
			end
			P_DoSuperTransformation(p, true)
			p.mrce.cosmichysteria = true
		end
		if not (p.charflags & SF_SUPER)
		and not (p.mo.skin == "sms") --nosuper characters that shouldn't get the super shield
		and not (p.mo.skin == "supersonic")
		and not p.bot then  --bots can't enter dwz anyway, but the shield still spawns where they were unless we do this
			p.rings = 50
			local superorb = P_SpawnMobj(p.mo.x, p.mo.y, p.mo.z, MT_SUPER_ORB)
			superorb.target = p.mo
			superorb.scale = p.shieldscale
			p.mrce.cosmichysteria = true
		end
	end
end)

addHook("ThinkFrame", function()
	if mapheaderinfo[gamemap].lvlttl != "Dimension Warp" then return end
    for player in players.iterate do
        if player.mo and player.mo.valid then
            if player.playerstate == PST_LIVE
			and mrce_hyperunlocked then
                player.sshypermusic = true
                if player.mo.skin == "supersonic" then
					S_ChangeMusic("dwz1", true, player)
                    if not player.hyper.transformed
                    and not player.mrce.cosmichysteria then
						player.hyper.capable = true
                        player.hyper.transformed = 1
                        player.mrce.cosmichysteria = true
                        S_StartSound(player.mo,sfx_hypert)
                        P_SetMobjStateNF(player.mo, S_PLAY_SUPER_TRANS1)
                        player.mo.state = S_PLAY_SUPER_TRANS1
                        player.mo.frame = A
                    end
                end
                if (player.mo.skin == "supersonic") and (player.rings <= 0) then
                    P_DamageMobj(player.mo,nil,nil,1,DMG_INSTAKILL)
                    S_StartSound(player.mo,sfx_s3k66)
                    player.mrce.cosmichysteria = false
                end
            end
        end
    end
end)

addHook("PlayerThink", function(p)
	if mapheaderinfo[gamemap].lvlttl == "Dimension Warp"  then
		if p.powers[pw_super] then
			p.mrce.cosmichysteria = true
		end
		if p.mrce.cosmichysteria and not p.bot and p.rings <= 0 then --ran out of rings: KIIIIEEEEEEELLLLLLLL
			P_DamageMobj(p.mo,nil,nil,1,DMG_INSTAKILL)
			p.mrce.cosmichysteria = false
		end
		if not p.powers[pw_super] and p.rings > 0 and not (leveltime%35) and not p.bot and not ((p.mo.skin == "sms" and p.hypermysticsonic) or (p.solchar and p.solchar.istransformed and p.mo.skin == "blaze") or (p.solchar and p.solchar.istransformed and p.mo.skin == "marine") or (p.mo.skin == "supersonic"))
		and leveltime >= 35 then --drain rings for super shield
			P_GivePlayerRings(p, -1)
			p.jumpfactor = skins[p.mo.skin].jumpfactor * 7 / 6
			p.actionspd = skins[p.mo.skin].actionspd * 3 / 2
			p.powers[pw_sneakers] = 2
		end
	end
end)

addHook("MobjThinker", function(orb)
    if orb and orb.valid and orb.health > 0
	and orb.target then
		P_MoveOrigin(orb, orb.target.x, orb.target.y, orb.target.z)
		orb.scale = orb.target.player.shieldscale
		if orb.target.player.playerstate == PST_DEAD then
			P_RemoveMobj(orb)
		end
	end
end, MT_SUPER_ORB)

addHook("MobjDamage", function(target, inflictor, source, damage, damagetype)
	if mapheaderinfo[gamemap].lvlttl != "Dimension Warp" then return end
	if target.player and not (damagetype&DMG_DEATHMASK)
	and not target.player.powers[pw_super] then
		P_DoPlayerPain(target.player, source, inflictor)
		return true
	elseif target.player and not (damagetype&DMG_DEATHMASK)
	and target.player.powers[pw_super]
	and target.skin == "skip" then --make skip NOT drop 5 million scrap  every time he takes damage
		P_DoPlayerPain(target.player, source, inflictor)
		return true
	end
end, MT_PLAYER)
