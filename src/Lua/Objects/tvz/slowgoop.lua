//State and object definitions

freeslot("spr_tvgp", "S_SLOWGOOP", "S_SLOWGOOP_XPLD", "MT_SLOWGOOP_PARTICLE", "S_SLOWGOOP_PARTICLE")

freeslot("MT_GOOPERCRAWLA", "MT_OLDCRAWLA", "spr_rcrw") // Freeslotting so I can reference it without breaking anything, since the rest of the enemy is defined in SOC.
local debug = 0

mobjinfo[MT_SLOWGOOP] = {
        doomednum = 2410,
        spawnstate = S_SLOWGOOP,
        spawnhealth = 1,
        seestate = S_NULL,
        seesound = sfx_None,
        reactiontime = 0,
        attacksound = sfx_None,
        painstate = S_NULL,
        painchance = 1,
        painsound = sfx_None,
        meleestate = S_NULL,
        missilestate = S_NULL,
        deathstate = S_SLOWGOOP_XPLD,
        xdeathstate = S_NULL,
        deathsound = sfx_ghit,
        speed = 1,
        radius = 16*FRACUNIT,
        height = 16*FRACUNIT,
        dispoffset = 0,
        mass = 100,
        damage = 0,
        activesound = sfx_None,
        flags = MF_SPECIAL,
        raisestate = MT_NULL
}

mobjinfo[MT_SLOWGOOP_PARTICLE] = {
        doomednum = -1,
        spawnstate = S_SLOWGOOP_PARTICLE,
        spawnhealth = 1,
        seestate = S_NULL,
        seesound = sfx_None,
        reactiontime = 0,
        attacksound = sfx_None,
        painstate = S_NULL,
        painchance = 1,
        painsound = sfx_None,
        meleestate = S_NULL,
        missilestate = S_NULL,
        deathstate = S_NULL,
        xdeathstate = S_NULL,
        deathsound = sfx_None,
        speed = 1,
        radius = 8*FRACUNIT,
        height = 8*FRACUNIT,
        dispoffset = 0,
        mass = 100,
        damage = 0,
        activesound = sfx_None,
        flags = MF_NOCLIPTHING,
        raisestate = MT_NULL
}

states[S_SLOWGOOP_PARTICLE] = {
		sprite = SPR_TVGP,
		frame = FF_FULLBRIGHT|FF_TRANS60|B,
		tics = 6*TICRATE,
		nextstate = S_NULL
}

states[S_SLOWGOOP] = {
        sprite = SPR_TVGP,
        frame = FF_FULLBRIGHT|FF_TRANS40|A,
        tics = 105,
        nextstate = S_NULL
}

states[S_SLOWGOOP_XPLD] = {
        sprite = SPR_TVGP,
        frame = FF_FULLBRIGHT|FF_TRANS40|A,
        tics = 1,
        nextstate = S_NULL
}



/* Mystic Realm Slow Goop, by Radicalicious */

// GoopParticleSpillage(origin, spilltype, spillpower_horizontal, spillpower_vertical, particlecount)
//
// Arguments:
//
// mobj_t origin (origin spawnpoint for the particle spillage)
// MT_ spilltype (MT_X constant for what object to spill)
// int spillpower_horizontal (how far to propel the gel horizontally)
// int spillpower_vertical (how high to propel the gel vertically)
// int particlecount (how many particles to spawn)

local function GoopParticleSpillage(origin, spilltype, spillpower_horizontal, spillpower_vertical, particlecount)
	for i = 0, particlecount, 1 do // Repeat for every particle needed.
		local particle = P_SpawnMobjFromMobj(origin, 0, 0, 0, spilltype) // Spill some particles!.
		particle.momx = P_RandomRange((spillpower_horizontal - (spillpower_horizontal*2)), spillpower_horizontal) * FRACUNIT // Apply random momentum values.
		particle.momy = P_RandomRange((spillpower_horizontal - (spillpower_horizontal*2)), spillpower_horizontal) * FRACUNIT
		particle.momz = P_RandomRange(0, spillpower_vertical) * FRACUNIT // Use a special vertical momentum value.
	end
end

addHook("TouchSpecial", function(goopmobj, pmo)
	if goopmobj.valid and pmo.valid and pmo.player then // Are the goop and player objects valid?
		if goopmobj.state == S_SLOWGOOP then // Is the goop laying on the ground?
			pmo.player.slowgooptimer = 6*TICRATE // Reset the player slow timer.
			P_KillMobj(goopmobj, pmo) // Remove the goop object.
		end
	end
end, MT_SLOWGOOP) // Run for TVZ goop objects only.

addHook("PlayerThink", function(p)
	if p.spectator then return end
	if not p.realmo then return end
	p.slowgooptimer = $ or 0
	if p.slowgooptimer > 1 then // Is the player coated with slow goop?
		if p.mo.state == S_PLAY_SPINDASH
		or p.mrce and (p.mrce.canhyper == true or p.mrce.ultrastar == true) and mrce_hyperunlocked and p.powers[pw_super]
		or p.yusonictable and p.yusonictable.hypersonic and p.mo.skin == "adventuresonic" then// Is the player spindashing?
			p.slowgooptimer = 1 // Remove the slowness.
			GoopParticleSpillage(p.mo, MT_SLOWGOOP_PARTICLE, 6, 6, 48) // Burst into particles.
			S_StartSound(p.mo, sfx_ghit, p) // Play the goop sound effect.
		elseif (p.mo.state == S_PLAY_ROLL or p.mo.state == S_PLAY_JUMP or p.mariospinjump) and (p.slowgooptimer > 20) then // Is the player rolling and the slow goop timer is above 20 tics?
			p.slowgooptimer = $ - 16 // Reduce the timer at a faster rate.
			if debug == 1 then
				print(p.slowgooptimer)
				print("Extra Fast Drain")
			end
			GoopParticleSpillage(p.mo, MT_SLOWGOOP_PARTICLE, 2, 1, 2) // Make particles appear when you roll.
		elseif (p.mo.state == S_PLAY_ROLL or p.mo.state == S_PLAY_JUMP or p.mariospinjump) and (p.slowgooptimer < 18) and (p.slowgooptimer > 10) then // Is the player rolling and the slow goop timer is above 10 tics?
			p.slowgooptimer = $ - 6 // Reduce the timer at a faster rate.
			if debug == 1 then
				print(p.slowgooptimer)
				print("Fast Drain")
			end
			GoopParticleSpillage(p.mo, MT_SLOWGOOP_PARTICLE, 2, 1, 2) // Make particles appear when you roll.
		end
	end

	if p.slowgooptimer then // Is the player slimed?
		p.mo.color = SKINCOLOR_PURPLE // Set the player's color to purple.
		p.mo.colorized = true // Tint the player instead of having their skincolor changed.
		p.tintface = true // Tint the player's life icon. Only has an effect in v2.2.9 and up.
		p.normalspeed = (skins[p.mo.skin].normalspeed / 3) // Halve their normalspeed.
		p.actionspd = (skins[p.mo.skin].actionspd / 3) // Halve their action speed (Tails flying, Sonic thokking, etc.).
		p.acceleration = (skins[p.mo.skin].acceleration / 3) // Halve their acceleration.
		p.jumpfactor = 90 --halve their jump height

		if p.slowgooptimer == 1 then // Is the slow goop about to expire?
			p.mo.color = p.skincolor // Restore player's color.
			p.mo.colorized = false // Remove tinting.
			p.tintface = false // Remove HUD face tinting.
			p.normalspeed = skins[p.mo.skin].normalspeed   //
			p.actionspd = skins[p.mo.skin].actionspd       // Restore stats.
			p.acceleration = skins[p.mo.skin].acceleration //
			p.jumpfactor = skins[p.mo.skin].jumpfactor
			p.slowgooptimer = 0 // Goodbye, slow goop.
		else
			if not (leveltime % 6) then // Slime dripping effect.
				P_SpawnMobjFromMobj(p.mo, (P_RandomRange(-5, 5) * FRACUNIT), (P_RandomRange(-5, 5) * FRACUNIT), ((p.mo.height / 2) + ((P_RandomRange(-3, 3) * FRACUNIT))), MT_SLOWGOOP_PARTICLE)
			end
			p.slowgooptimer = $ - 1 // Decrement the goop timer.
		end
	end
end)

freeslot("SKINCOLOR_SLOWGOOPHONEY")
skincolors[SKINCOLOR_SLOWGOOPHONEY] = { -- honey's "fur" is the darker side of the overlay's colorspace. why.
	name = "slowgoophoney",
	ramp = skincolors[SKINCOLOR_PURPLE].ramp,
	invcolor = SKINCOLOR_WHITE,
	invshade = 0,
	accessible = false
}
-- lazyness, but effective... probably
skincolors[SKINCOLOR_SLOWGOOPHONEY].ramp[10] = skincolors[SKINCOLOR_SLOWGOOPHONEY].ramp[0]
skincolors[SKINCOLOR_SLOWGOOPHONEY].ramp[11] = skincolors[SKINCOLOR_SLOWGOOPHONEY].ramp[1]
skincolors[SKINCOLOR_SLOWGOOPHONEY].ramp[12] = skincolors[SKINCOLOR_SLOWGOOPHONEY].ramp[2]
skincolors[SKINCOLOR_SLOWGOOPHONEY].ramp[13] = skincolors[SKINCOLOR_SLOWGOOPHONEY].ramp[3]
skincolors[SKINCOLOR_SLOWGOOPHONEY].ramp[14] = skincolors[SKINCOLOR_SLOWGOOPHONEY].ramp[4]
skincolors[SKINCOLOR_SLOWGOOPHONEY].ramp[15] = skincolors[SKINCOLOR_SLOWGOOPHONEY].ramp[5]

addHook("PostThinkFrame", function()
	for p in players.iterate() do
		if p.superobj and p.slowgooptimer > 1 then
			p.superobj.color = SKINCOLOR_PURPLE
			if p.mo.skin == "honey" then -- in case another character uses secondcolor using the same script as honey's
				p.superobj.color = SKINCOLOR_SLOWGOOPHONEY
			end
		end
	end
end)


addHook("PlayerSpawn", function(p)
	p.slowgooptimer = 1 // Reset the goop upon death.
end)

addHook("MobjDeath", function(slowgoop) /* Spill particles when Slow Goop is removed. */
	GoopParticleSpillage(slowgoop, MT_SLOWGOOP_PARTICLE, 3, 5, 8) // Spill some goop.
end, MT_SLOWGOOP)

addHook("MobjDeath", function(crawla)
	GoopParticleSpillage(crawla, MT_SLOWGOOP, 2, 6, 8)
end, MT_GOOPERCRAWLA)