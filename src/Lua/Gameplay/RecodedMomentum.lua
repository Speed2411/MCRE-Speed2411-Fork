--custom momentum made with a lot less hacks then CBWMom, heavily referenced from ChrispyChars.
--Originally was gonna launch this in v2.0, but that's taking forever so i'm putting it in this minor update.
--ported from xmom v1.3 with assistance from frostiikin to suit the needs of MRCE
addHook("PreThinkFrame", function(p)
	for p in players.iterate do
		if p.spectator then return end
		if not p.realmo then return end
		if p.mrce and p.mrce.customskin > 0 then --Set player.mrce.customskin to 2 every frame on your character's end to qualify as a custom skin!
			p.mrce.customskin = $-1
			p.mrce.physics = false
			return
		end
		if p.mrce and p.mrce.physics == false then
			return
		end
		if (p.noxmomchar or p.xmomtoggledoff) then
			return
		end
		local x = p.mrce
		if p.xmlastz == nil then
			p.xmlastspeed = x.realspeed
			p.xmlastz = p.mo.z
			p.xmlastx = p.mo.x
			p.xmlasty = p.mo.y
			p.xmlastmomx = p.mo.momx
			p.xmomlastmomy = p.mo.momy
			p.xmlaststate = p.mo.state
			p.xmexhaust = 35
		end
		if p.fakenormalspeed == nil then
			p.fakenormalspeed = skins[p.mo.skin].normalspeed
		end
		local watermul = (p.mo.eflags & MFE_UNDERWATER) and 2 or 1
		if (p.mo and p.mo.valid and p.mo.health) then
			if p.xmlastskin and p.xmlastskin != p.mo.skin then
				p.hasnomomentum = false
			end
			p.xmlastskin = p.mo.skin
		end
		local speedcap = (skins[p.mo.skin].normalspeed * 3) - (skins[p.mo.skin].normalspeed / 2)
		local speed = FixedDiv(FixedHypot(p.mo.momx - p.cmomx, p.mo.momy - p.cmomy), p.mo.scale)
		local SPEED_INCREASE_LEEWAY = 0*FRACUNIT // the amount of speed above normalspeed needed to update normalspeed
		local SPEED_DECREASE_LEEWAY = 15*FRACUNIT // the amount of speed below normalspeed needed to update normalspeed
			if not p.hasnomomentum then
				local speen = (p.pflags & PF_SPINNING) and 4 or 0
				if x.snowboard then speen = max(0, $ - 2) end
				local shine = MRCE_isHyper(p) and 1 or 0
				--print(p.xmexhaust)
				if p.xmlastz*P_MobjFlip(p.mo) > p.mo.z*P_MobjFlip(p.mo) and P_IsObjectOnGround(p.mo) and not (p.mo.eflags & MFE_JUSTHITFLOOR) then
					p.normalspeed = $ + (p.mo.z*P_MobjFlip(p.mo)-p.xmlastz*P_MobjFlip(p.mo))/(21 - (shine + speen))*-1
					p.xmexhaust = min($ + 2, 35)
				elseif p.xmlastz*P_MobjFlip(p.mo) < p.mo.z*P_MobjFlip(p.mo) and P_IsObjectOnGround(p.mo) and not (p.mo.eflags & MFE_JUSTHITFLOOR) then
					if p.xmexhaust <= 0 then
						local lose = (p.mo.z*P_MobjFlip(p.mo)+p.xmlastz*P_MobjFlip(p.mo))/(5000 - ((speen*32) - (shine*64)))*-1
						p.normalspeed = max($ + lose, skins[p.mo.skin].normalspeed)
						p.xmexhaust = max($ - 1, -35)
					--print(tostring(lose/FRACUNIT))
					else
						p.xmexhaust = max($ - 1, -35)
					end
				elseif MRCE_isHyper(p) then
					p.xmexhaust = min($ + 3, 35)
					if P_IsObjectOnGround(p.mo) then
						if p.powers[pw_sneakers] then
							p.normalspeed = $ + FRACUNIT/2
						else
							p.normalspeed = $ + FRACUNIT/8
						end
					end
				else
					p.xmexhaust = min($ + 1, 35)
				end
				local restorefakenormalspeed = p.fakenormalspeed
				if p.dashmode > 3*TICRATE then
					p.fakenormalspeed = p.normalspeed
				end
				if not p.powers[pw_super] and not p.powers[pw_sneakers] then
					if (speed*watermul > p.normalspeed + SPEED_INCREASE_LEEWAY
					or speed*watermul < p.normalspeed - SPEED_DECREASE_LEEWAY) then
						p.normalspeed = max(speed*watermul, p.fakenormalspeed)
					end
				elseif not MRCE_isHyper(p) then
					if (speed*3/5*watermul > p.normalspeed + SPEED_INCREASE_LEEWAY
					or speed*3/5*watermul < p.normalspeed - SPEED_DECREASE_LEEWAY) then
						p.normalspeed = max((speed*3/5)*watermul, p.fakenormalspeed)
					end
				else
					if speed < p.normalspeed - SPEED_DECREASE_LEEWAY then
					--or speed > p.normalspeed + SPEED_INCREASE_LEEWAY then
						p.normalspeed = max(speed*watermul, p.fakenormalspeed)
					end
				end
				p.fakenormalspeed = restorefakenormalspeed
				if not (MRCE_isHyper(p) or p.powers[pw_sneakers]) then
					if p.normalspeed > speedcap*watermul then --max speed cap
						p.normalspeed = $ - p.normalspeed/50
						if x.snowboard and p.normalspeed > 100*FRACUNIT then
							p.normalspeed = min($, 100*FRACUNIT)
							print(p.normalspeed)
						end
					end
				end
			end
			local momangle = R_PointToAngle2(0,0,p.rmomx,p.rmomy) //Used for angling new momentum in ability cases
			local pmom = FixedDiv(FixedHypot(p.rmomx,p.rmomy),p.mo.scale) //Current speed, scaled for normalspeed calculations


			//
			// Dummied out for MRCE.
			// ~Radicalicious (4/21/22)
			//
			/*
			//Knuckles momentum renewal
			if p.charability == CA_GLIDEANDCLIMB then
				//Create glide history
				if p.glidelast == nil then
					p.glidelast = 0
				end
				local gliding = p.pflags&PF_GLIDING
				local thokked = p.pflags&PF_THOKKED
				local exitglide = (p.glidelast == 1 and not(gliding) and thokked)
				local landglide = (p.glidelast == 2 and not(gliding|thokked))
				//Restore glide momentum after deactivation
				if exitglide or landglide then
					p.mo.momx = p.xmlastmomx
					p.mo.momy = p.xmlastmomy
				end
				//Update glide history
				if gliding then
					p.glidelast = 1 //Gliding
				elseif exitglide then
					p.glidelast = 2 //Falling from glide
				elseif not(gliding|thokked) then
					p.glidelast = 0 //Not in glide state
				end
			end

			//////
			//Fang momentum renewal
			if p.charability == CA_BOUNCE then
				//Create bounce history
				if p.bouncelast == nil then
					p.bouncelast = false
				end
				if p.pflags&PF_BOUNCING and not(p.bouncelast) //Activate bounce
					or (not(p.pflags&PF_BOUNCING) and p.pflags&PF_THOKKED and p.bouncelast) //Deactivate bounce
					//Undo the momentum cut from bounce activation/deactivation
					p.mo.momx = p.xmlastmomx
					p.mo.momy = p.xmlastmomy
					p.mo.momz = $*2
				end
				//Update bounce history
				p.bouncelast = (p.pflags&PF_BOUNCING > 0)
			end
			*/
		p.xmlastspeed = p.speed
		p.xmlastz = p.mo.z
		p.xmlastx = p.mo.x
		p.xmlasty = p.mo.y
		p.xmlastmomx = p.mo.momx
		p.xmlastmomy = p.mo.momy
		p.xmlaststate = p.mo.state
	end
end)

local function P_SpawnCoolSkidDust(player, radius, sound, state)
    local particle = P_SpawnMobjFromMobj(player.mo, 0, 0, 0, MT_SPINDUST)
    local xn = P_RandomChance(FRACUNIT/2)
    local yn = P_RandomChance(FRACUNIT/2)
    if xn then xn = -1 else xn = 1 end
    if yn then yn = -1 else yn = 1 end

    local x = particle.x + (xn * (FixedMul(radius,P_RandomFixed()) << FRACBITS))
    local y = particle.y + (yn * (FixedMul(radius,P_RandomFixed()) << FRACBITS))
    local z = particle.z --+ (P_RandomRange(0, FRACUNIT-1))
    P_MoveOrigin(particle, x, y, z)
    particle.tics = 10
    particle.scale = (2*player.mo.scale)/3
    particle.momx = player.mo.momx/4
    particle.momy = player.mo.momy/4
    P_SetScale(particle, particle.destscale)
    P_SetObjectMomZ(particle, FRACUNIT, false)
    if player.powers[pw_super] then
        P_SetObjectMomZ(particle, FRACUNIT*3, false)
    end

    if sound then
        S_StartSound(player.mo, sfx_s3k7e)
    end
    return particle -- the one thing the original version of this didn't do, smh smh
end

addHook("PlayerThink", function(p)
	local x = p.mrce
	if p.spectator then return end
--detect if physics are enabled
	if IsCustomSkin(p) then
		x.physics = false
	else
		x.physics = true
	end
--disable custom physics for a few known characters
	if p.mo and ((p.mo.skin == "sms") or (p.mo.skin == "ass") or (p.mo.skin == "juniosonic") or (p.mo.skin == "iclyn") or (p.mo.skin =="kiryu") or (p.mo.skin == "adventuresonic")) then
		x.customskin = 2
		x.physics = false
	elseif x.dontwantphysics == false then
		x.physics = true
	end
	--if p.speed == go fast, allow the player to run on water. aka, momentum based water running
	if (x.realspeed >= 60*FRACUNIT) and not (skins[p.mo.skin].flags & SF_RUNONWATER)  and not IsCustomSkin(p)
	and not ((p.mo.skin == "mario" or p.mo.skin == "luigi") and p.powers[pw_shield] == SH_MINI) then --mini mario gets to always run on water
		p.charflags = $1|SF_RUNONWATER
		if p.mo.eflags & (MFE_TOUCHWATER|MFE_UNDERWATER) and P_IsObjectOnGround(p.mo) then
			local sploop = P_SpawnCoolSkidDust(p, 16, false, nil)
			sploop.destscale = p.mo.scale/6+p.mo.scale/5
			sploop.scalespeed = FRACUNIT/19
			sploop.state = S_SPLISH1
		end
	elseif not IsCustomSkin(p) then
		if not (skins[p.mo.skin].flags & SF_RUNONWATER)
		and not ((p.mo.skin == "mario" or p.mo.skin == "luigi") and p.powers[pw_shield] == SH_MINI)
		and x.realspeed <= 60*FRACUNIT then
			p.charflags = $1 & ~(SF_RUNONWATER)
		end
	end
end)
