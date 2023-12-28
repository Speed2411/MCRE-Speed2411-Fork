--thanks spec for this lua, youre amazing

freeslot("MT_ICEBEAM", "MT_ICEBEAMSHARD", "MT_ICEBEAMPARTICLE", "S_ICEBEAMPARTICLE")

local debug = 0

local function onfire(player)
	if player.spectator then return false end
	if not player.realmo then return false end
	if (player.powers[pw_shield] & SH_FLAMEAURA)
	or (player.mo.skin == "supersonic" and (player.powers[pw_shield] & SH_FIREFLOWER))
	or (player.mo.skin == "blaze" and (player.solchar and player.solchar.istransformed))
	or (player.mo.skin == "blaze" and player.blazeboosting)
	or (player.mo.skin == "blaze" and player.mo.blazejumping)
	or (player.mo.skin == "blaze" and player.blazehover)
	or MRCE_isHyper(player) then
		return true
	end
	return false
end

local function IceTouchesSomething(special, toucher)
	if special and special.valid and toucher and toucher.valid and toucher.player and toucher.player.frozen ~= 1 and not toucher.player.powers[pw_flashing] and not onfire(toucher.player) then
		toucher.player.oldcolor = toucher.color
		if toucher.player.mo.state != nil then
			toucher.player.frozenstate = toucher.player.mo.state
		else
			toucher.player.frozenstate = 13
		end
		toucher.player.frozenframe = toucher.player.mo.frame
		toucher.player.frozenanim = toucher.player.panim
		toucher.player.frozen = 1
		toucher.player.frozentimer = 140
	end
end

addHook("TouchSpecial", IceTouchesSomething, MT_ICEBEAM)
addHook("TouchSpecial", IceTouchesSomething, MT_ICEBEAMSHARD)

addHook("PlayerThink", function(p)
	if not p.realmo then return end
	if p.spectator then return end
	--print(tostring(onfire(p)))
	p.frozen = $ or 0
	p.frozentimer = $ or 0
	p.oldcolor = $ or 0
	if onfire(p) then
		p.frozentimer = 0
		p.frozen = 0
		return
	end
	if debug == 1 then
		--print("frozentimer: " .. p.frozentimer)
		--print("jump: " .. p.mrce.jump)
		if (p.pflags & PF_FULLSTASIS) then
			print("stasis")
		end
	end
	if p.frozentimer == 140 then
		S_StartSound(p.mo, sfx_s3k80)
	end
	if p.frozentimer == 1 then
		S_StartSound(p.mo, sfx_shattr)
	end
	if p.frozen == 1 and p.frozentimer > 0 then
		p.mo.colorized = true
		p.mo.color = SKINCOLOR_ICY
		if p.frozenstate != nil then
			p.mo.state = p.frozenstate
		else
			p.frozenstate = p.mo.state
		end
		if p.frozenframe != nil then
			p.mo.frame = p.frozenframe
		else
			p.frozenframe = p.mo.frame
		end
		if p.frozenanim != nil then
			p.panim = p.frozenanim
		else
			p.frozenanim = p.panim
		end
		if p.powers[pw_flashing] then
			p.frozentimer = 0
			p.frozen = 0
			return
		end
		p.frozentimer = $-1
		p.pflags = $1|PF_FULLSTASIS
		if p.mrce and p.mrce.jump == 1 and p.frozentimer > 20 then
			p.frozentimer = $-15
			S_StartSound(p.mo, sfx_s3k80)
		end
		if not (leveltime % 50) then
			P_SpawnMobjFromMobj(p.mo, (P_RandomRange(-5, 5) * FRACUNIT), (P_RandomRange(-5, 5) * FRACUNIT), ((p.mo.height / 2) + ((P_RandomRange(-3, 3) * FRACUNIT))), MT_ICEBEAMPARTICLE)
		end
		if P_IsObjectOnGround(p.mo) and p.speed == 0 then
			p.mo.flags = $1|MF_NOTHINK
		end
		if p.followmobj and p.followmobj.type == MT_TAILSOVERLAY then
			p.followmobj.flags = $1|MF_NOTHINK
		end
	elseif p.frozen == 1 then
		p.mo.colorized = false
		p.mo.color = p.oldcolor
		p.oldcolor = 0
		p.pflags = $1 & ~PF_FULLSTASIS
		p.mo.flags = $1 & ~MF_NOTHINK
		p.frozenstate = nil
		p.frozenframe = nil
		p.frozenanim = nil
		if p.followmobj and p.followmobj.type == MT_TAILSOVERLAY then
			p.followmobj.flags = $1 & ~MF_NOTHINK
		end
		p.mo.state = S_PLAY_FALL
		p.frozen = 0
		p.frozentimer = 0
		p.powers[pw_flashing] = 40
	end
end)

addHook("PostThinkFrame", function()
    for player in players.iterate do
		if player.frozen == 1 and player.frozentimer > 0 then
			if player.frozenstate != nil then
				player.mo.state = player.frozenstate
			end
			if player.frozenframe != nil then
				player.mo.frame = player.frozenframe
			end
			if player.frozenanim != nil then
				player.panim = player.frozenanim
			end
		end
	end
end)

addHook("MobjDeath", function(mo)
	if mo.player and mo.player.oldcolor then
		local p = mo.player
		p.frozen = 0
		p.frozentimer = 0
		mo.color = p.oldcolor
		if p.mrce and not p.mrce.glowaura then
			p.mo.blendmode = 0
		end
		p.pflags = $1 & ~PF_FULLSTASIS
		--mo.flags = $1 & ~MF_NOTHINK
	end
end,MT_PLAYER)

-- Radicalicious 01/05/2023:
-- Like what is done for icicles, we're going to make sure Cryocrawlas can't
-- fire anything when the player isn't in reasonable firing distance. This
-- could be done by changing the SOC to use A_Look with distance checks like
-- how Coconuts does it, but I'm lazy and don't feel like touching that ancient
-- SOC we might replace eventually anyways.
addHook("MobjThinker", function(mo)
	if (searchBlockmap("objects", function(amo, pmo)
		if not pmo.valid then return nil end
		if pmo.player then return true else return nil end
	end, mo, mo.x-1024*FRACUNIT, mo.x+1024*FRACUNIT, mo.y-1024*FRACUNIT, mo.y+1024*FRACUNIT)) then
		if mo.state >= S_CRYOCRAWLA_RUN7 then mo.state = S_CRYOCRAWLA_RUN1 end
	end
end, MT_CRYOCRAWLA)