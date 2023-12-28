local debug = 0
freeslot(
	"SPR_ANGL",
	"SPR_TFLR",
	"MT_ANGEL",
	"MT_ANGELSPAWNER",
	"S_ANGEL1",
	"S_ANGEL2",
	"S_ANGEL3",
	"S_ANGEL4",
	"A_AngelThink",
	"sfx_grchm",
	"sfx_fwarn",
	"sfx_iwarn",
	"S_ANGEL_INDICATOR"
)

states[S_ANGEL_INDICATOR] = {SPR_TFLR, A|FF_FULLBRIGHT, -1, nil, 3, 2, S_ANGEL_INDICATOR}

addHook("PlayerSpawn", function(p)
	if not p.realmo then return end
	if p.spectator then return end
	p.mo.angel = nil
end)

addHook("MapThingSpawn", function(mo)
	P_SpawnMobjFromMobj(mo, 0, 0, 0, MT_ANGEL)
	for p in players.iterate do
		if p.bot then continue end
		P_SpawnMobjFromMobj(mo, 0, 0, 0, MT_ANGEL)
	end
end, MT_ANGELSPAWNER)

function A_AngelThink(actor, var1, var2)
	if actor.target == nil then
		//Search for airborne players in radius who don't have an angel chasing them yet
		for player in players.iterate do
			if player.spectator then continue end
			if not player.realmo then continue end
			local search_distance = FixedHypot(actor.x - player.mo.x, actor.y - player.mo.y) / FRACUNIT
			local search_height = abs(actor.z - player.mo.z) / FRACUNIT
			if player.playerstate == PST_LIVE and not P_IsObjectOnGround(player.mo) and search_height <= 450 and search_distance <= 3200 and player.mo.angel == nil then
				actor.target = player.mo
				actor.target.angel = actor
				actor.kill_timer = 260

				actor.spawnx = actor.x
				actor.spawny = actor.y
				actor.spawnz = actor.z

				actor.target.angelspawnx = actor.spawnx
				actor.target.angelspawny = actor.spawny
				actor.target.angelspawnz = actor.spawnz

				S_StartSoundAtVolume(actor.target, sfx_grchm, 255, actor.target.player)
				S_FadeMusic(0, 4*MUSICRATE, actor.target.player)
				if actor.target.player.earsave <= 0 then
					S_StartSoundAtVolume(actor.target, sfx_iwarn, 255, actor.target.player)
					actor.target.player.earsave = 105
				end
				S_FadeMusic(0, 4*MUSICRATE, actor.target.player)
			end
		end
	else //Already have a target
		local mo = actor.target.player.mo
		local p = actor.target.player
		if P_IsObjectOnGround(actor.target) then
			//Target reached the ground and is safe
			if p.playerstate == PST_LIVE then
				S_StopFadingMusic(p)
				S_FadeMusic(100, 1*MUSICRATE, p)
				for i = 0, 10 do
					S_StopSoundByID(actor.target, sfx_iwarn)
					S_StopSoundByID(actor.target, sfx_fwarn)
					S_StopSoundByID(actor.target, sfx_grchm)
				end
				mo.angelspawnx = nil
				mo.angelspawny = nil
				mo.angelspawnz = nil
				S_StartSoundAtVolume(actor.target, 445, 200, p)
				p.finalwarning = false
			end
			actor.target.angel = nil
			actor.target = nil
			actor.kill_timer = 260
			P_SetOrigin(actor, actor.spawnx, actor.spawny, actor.spawnz)
			actor.momx = 0
			actor.momy = 0
			actor.momz = 0
			actor.colorized = false
			if mo and mo.landwarn then
				mo.landwarn.flags2 = $|MF2_DONTDRAW
			end

		else //Chase target and countdown
			actor.kill_timer = actor.kill_timer - 1
			if not mo.landwarn or not mo.landwarn.valid then
				mo.landwarn = P_SpawnMobjFromMobj(mo, 0, 0, 0, MT_OVERLAY)
				mo.landwarn.target = mo
				mo.landwarn.flags2 = $|MF2_DONTDRAW
				mo.landwarn.state = S_ANGEL_INDICATOR
			else
				if actor.kill_timer <= 0 then
					mo.landwarn.flags2 = $|MF2_DONTDRAW
				else
					mo.landwarn.flags2 = $ & ~MF2_DONTDRAW
				end
				if actor.kill_timer and mo.landwarn.state ~= S_ANGEL_INDICATOR then
					mo.landwarn.state = S_ANGEL_INDICATOR
				end
			end
			if p.fly1 > 8 and (p.powers[pw_tailsfly] > 0) and actor.kill_timer >= 27 then
				actor.kill_timer = actor.kill_timer - 10
				local bliptimer = leveltime % 4
				if bliptimer < 2 then
					actor.colorized = true
					actor.color = SKINCOLOR_RED
				else
					actor.colorized = false
				end
			end
			if p.legacybandages and actor.kill_timer > 1 then
				actor.kill_timer = 1 --no flying amys, you die now
			elseif p.hypermysticsonic and actor.kill_timer > 1 then
				p.hypermysticsonic = 0
				actor.kill_timer = 1
			elseif actor.target.skin == "hms123311" or actor.target.skin == "fhms123311" --where's your god now?
			and actor.kill_timer > 1 then
				actor.kill_timer = 1
			elseif p.pflags & PF_GODMODE and actor.kill_timer > 1 then
				p.pflags = $ & ~PF_GODMODE
				actor.kill_timer = 1
			elseif p.powers[pw_super] and actor.kill_timer > 180 then
				actor.kill_timer = 180
			elseif mo.momz > 75*FRACUNIT and  actor.kill_timer > 30 then
				actor.kill_timer = 30
			end
			local tx = actor.target.x
			local ty = actor.target.y
			local tz = actor.target.z
			local chase_distance = FixedHypot(actor.x - actor.target.x, actor.y - actor.target.y) / FRACUNIT
			local chase_height = abs(actor.z - actor.target.z) / FRACUNIT
			local chase_amt = 1*FRACUNIT
			local chase_max = 18

			if chase_distance > 60 or chase_height > 60 then
				chase_amt = 4*FRACUNIT
			end
			if chase_distance > 200 or chase_height > 200 then
				chase_amt = 8*FRACUNIT
			end

			if actor.x < tx then
				actor.momx = min(actor.momx + chase_amt, chase_max * FRACUNIT)
			end
			if actor.x > tx then
				actor.momx = min(actor.momx - chase_amt, chase_max * FRACUNIT)
			end
			if actor.y < ty then
				actor.momy = min(actor.momy + chase_amt, chase_max * FRACUNIT)
			end
			if actor.y > ty then
				actor.momy = min(actor.momy - chase_amt, chase_max * FRACUNIT)
			end
			if actor.z < tz then
				actor.momz = min(actor.momz + chase_amt, chase_max * FRACUNIT)
			end
			if actor.z > tz and abs(actor.floorz) > 20*FRACUNIT then
				actor.momz = min(actor.momz - chase_amt, chase_max * FRACUNIT)
			end

			if abs(actor.floorz) < 20*FRACUNIT then
				actor.momz = 15*FRACUNIT
			end

			if debug then
				print(actor.floorz)
			end

			if actor.kill_timer < 26 and not p.finalwarning then
				S_StartSound(actor.target, sfx_fwarn)
				p.finalwarning = true
			end

			if actor.kill_timer <= 0 then //Time's up
				if mo and mo.landwarn then
					mo.landwarn.flags2 = $|MF2_DONTDRAW
				end
				p.finalwarning = false
				P_DamageMobj(mo, actor, actor, 1, DMG_SPACEDROWN)
				S_StartSoundAtVolume(mo, 399, 180, p)
				if p.screenflash == true then
					P_FlashPal(p, PAL_WHITE, 5)
				end
				actor.target.angel = nil
				actor.target = nil
				actor.kill_timer = 260
				P_SetOrigin(actor, actor.spawnx, actor.spawny, actor.spawnz)
				actor.momx = 0
				actor.momy = 0
				actor.momz = 0
				actor.colorized = false
			end
		end
	end
end

local function respawnAngel(player)
	local dumbass = P_SpawnMobj(player.mo.angelspawnx, player.mo.angelspawny, player.mo.angelspawnz, MT_ANGEL)
	dumbass.target = nil
	dumbass.spawnx = dumbass.x
	dumbass.spawny = dumbass.y
	dumbass.spawnz = dumbass.z
	dumbass.kill_timer = 260
	player.mo.angelspawnx = nil
	player.mo.angelspawny = nil
	player.mo.angelspawnz = nil
end

addHook("PlayerThink", function(p)
	p.earsave = $ or 0
	if p.spectator then return end
	if not p.realmo then return end
	if p.earsave > 0 then
		p.earsave = $ - 1
	end

	if p.mo.angel and not p.mo.angel.valid then
		p.mo.angel = nil
		S_StopFadingMusic(p)
		S_FadeMusic(100, 1*MUSICRATE, p)
		if p.mo.landwarn and p.mo.landwarn.valid then
			p.mo.landwarn.flags2 = $|MF2_DONTDRAW
		end
		for i = 0, 10 do
			S_StopSoundByID(p.mo, sfx_iwarn)
			S_StopSoundByID(p.mo, sfx_fwarn)
			S_StopSoundByID(p.mo, sfx_grchm)
		end
		respawnAngel(p)
		S_StartSoundAtVolume(p.mo, 445, 200, p)
	end

	if p.mo.landwarn and p.mo.landwarn.valid
	and p.playerstate != PST_LIVE then
		p.mo.landwarn.flags2 = $|MF2_DONTDRAW
	end
	--print(p.earsave)
end)

addHook("MobjDeath", function(enemy, mo, mobj, pit)
	if pit == DMG_DEATHPIT then
		P_SetOrigin(enemy, enemy.x, enemy.y, (enemy.z + 2*enemy.height)*P_MobjFlip(enemy))
		P_SetObjectMomZ(enemy, 8*FRACUNIT, false)
		enemy.target.angel = nil
		return true
	end
end, MT_ANGEL)

sfxinfo[sfx_grchm] = {
  caption = "Ominous Chiming"
}

mobjinfo[MT_ANGEL] = {
	doomednum = -1,
	spawnstate = S_ANGEL1,
	spawnhealth = 1000,
	flags = MF_NOGRAVITY,
	radius = 16*FRACUNIT,
	height = 16*FRACUNIT
}

mobjinfo[MT_ANGELSPAWNER] = {
	//$Name Primordial Abyss Angel Spawner
	//$Category Mystic Realm Enemies
	//$Sprite ANGLA0
	//$NotAngled
	doomednum = 3108,
	spawnstate = S_INVISIBLE,
	spawnhealth = 1000,
	flags = MF_NOGRAVITY,
	radius = 16*FRACUNIT,
	height = 16*FRACUNIT
}

states[S_ANGEL1] = {
	sprite = SPR_ANGL,
	frame = TR_TRANS30|A,
	tics = 1,
	action = A_AngelThink,
	nextstate = S_ANGEL2
}

states[S_ANGEL2] = {
	sprite = SPR_ANGL,
	frame = TR_TRANS30|A,
	tics = 1,
	action = A_AngelThink,
	nextstate = S_ANGEL3
}

states[S_ANGEL3] = {
	sprite = SPR_ANGL,
	frame = TR_TRANS30|B,
	tics = 1,
	action = A_AngelThink,
	nextstate = S_ANGEL4
}

states[S_ANGEL4] = {
	sprite = SPR_ANGL,
	frame = TR_TRANS30|B,
	tics = 1,
	action = A_AngelThink,
	nextstate = S_ANGEL1
}