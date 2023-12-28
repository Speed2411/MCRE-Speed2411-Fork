-- see the bottom of this file for the dofile lines for the rest of the player code

local flashconfig
local hudconfig

addHook("PlayerSpawn", function(p)
	if not p.realmo then return false end
	if p.spectator then return false end
	if p.mo.signglow == nil then
		p.mo.signglow = false
	end
	--p.screenflash = $ or true
	if p.mrce == nil then
		local mrce = {
		glowaura = 0,
		flycheat = false,
		hypercheat = false,
		canhyper = false,
		ultrastar = false,
		hyperimages = false,
		hypermode = 0,
		customskin = 0,
		dontwantphysics = false,
		physics = true,
		skipmystic = false,
		nasyamystic = false,
		exspark = false,
		ishyper = false,
		jump = 0,
		spin = 0,
		c1 = 0,
		exsparkcolor = R_GetColorByName("Galaxy"),
		camroll = 0,
		cosmichysteria = false,
		speen = 0,
		freezeeffect = 0,
		hud = 1,
		constext = 0,
		forcehyper = 0,
		oldz = 0,
		snowboard = false,
		spinkick = 0,
		realspeed = 0,
		secmus = 0,
		glide = 0,
		floatpause = 0,
		spawnshield = 0,
		hyperlast = false
		}
		if p.mo then
			p.mrce = mrce
		end
	end
	p.mrce.speen = 0
	p.mrce.constext = 8
	--p.pflags = $ & ~PF_GODMODE
	if io and p == consoleplayer and flashconfig == nil then
		local file = io.openlocal("client/mrce/hyperflash.dat")
		if file then
			local string = file:read("*a")
			if string == "1" or string == "true" or string == "on" then
				COM_BufInsertText(p, "hyperflash on")
			elseif string == "0" or string == "false" or string == "off" or string == nil then
				COM_BufInsertText(p, "hyperflash off")
			end
			file:close()
		else
			COM_BufInsertText(p, "hyperflash on")
		end
		flashconfig = consoleplayer
	end

	if io and p == consoleplayer and hudconfig == nil then
		local file = io.openlocal("client/mrce/hud.dat")
		if file then
			local string = file:read("*a")
			if string == "1" or string == "on" or string == "default" or string == "normal" or string == "yes" or string == nil then
				COM_BufInsertText(p, "mr_hud 1")
			elseif string == "0" or string == "disable" or string == "off" or string == "no" then
				COM_BufInsertText(p, "mr_hud 0")
			end
			file:close()
		else
			COM_BufInsertText(p, "mr_hud 1")
		end
		hudconfig = consoleplayer
	end
--reset hyper values
	p.mrce.canhyper = false
	p.mrce.ultrastar = false
	p.mrce.hyperimages = false
	p.skincheck = p.mo.skin

	if p.mo and p.mo.valid and p.mo.skin == "supersonic" then
		if ((gamemap == 132)  or (gamemap == 133)) then
			P_GivePlayerRings(p, 50)
		elseif mapheaderinfo[gamemap].lvlttl == "Primordial Abyss" then
			if p.lives < 99 then
				P_GivePlayerRings(p, 100)
				p.lives = $ - 1
			else
				P_GivePlayerRings(p, 100)
			end
		end
	end
end)

rawset(_G, "MRCE_isHyper", function(p)
	if not p.powers[pw_super] then return false end
	local x = p.mrce
	if x and mrce_hyperunlocked then
		if x.canhyper
		or x.ultrastar then
			return true
		end
	elseif x and x.hypercheat
	and (x.canhyper or x.ultrastar) then
		return true
	else
		return false
	end
end)



addHook("PlayerThink", function(p)
	if not p.realmo then return end
	if p.spectator then return end
	local x = p.mrce
	x.realspeed = FixedDiv(FixedHypot(p.rmomx,p.rmomy),p.mo.scale)

	x.jump = (p.cmd.buttons & BT_JUMP) and $+1 or 0
	x.spin = (p.cmd.buttons & BT_SPIN) and $+1 or 0
	x.c1 = (p.cmd.buttons & BT_CUSTOM1) and $+1 or 0
	if x.secmus > 0 then
		x.secmus = $ - 1
	end

	if x.secmus == 1 then
		if S_FadeOutStopMusic(500, p) then
			P_RestoreMusic(p)
		end
	end

	--print(x.secmus)

	--fall animations. bc fuck airwalk, all my homies hate airwalk

	--
	if not (p.mo.skin == "msonic")
	and not (p.moskin == "modernsonic")
	and not (p.mo.skin == "adventuresonic")
	and not (p.mo.skin == "nasya")
	and not p.wallCling then
		if (p.mo.state == S_PLAY_FALL)
		and ((p.mo.momz*P_MobjFlip(p.mo)) > 2*FRACUNIT)
		and not (p.sms_sontransform)
		and not (p.mo.eflags & MFE_GOOWATER)
		and not (p.powers[pw_carry])
		and not (p.pflags & PF_SHIELDABILITY) then
			p.mo.state = S_PLAY_SPRING
		end

		if ((p.mo.state == S_PLAY_STND) or (p.mo.state == S_PLAY_WAIT) or (p.mo.state == S_PLAY_WALK) or (p.mo.state == S_PLAY_RUN) or (p.mo.state == S_PLAY_DASH) or (p.mo.state == S_PLAY_FLOAT_RUN and not x.glide) or (p.mo.state == S_PLAY_FLOAT and not x.glide))
		and not P_IsObjectOnGround(p.mo)
		and not (p.mo.standingslope)
		and not (p.powers[pw_carry])
		and not (p.secondjump)
		and not x.snowboard
		and not p.eggsuperflying
		and p.playerstate == PST_LIVE then
			if ((p.mo.momz*P_MobjFlip(p.mo)) > 1*FRACUNIT)
			and not (p.mo.eflags & MFE_GOOWATER) then
				p.mo.state = S_PLAY_SPRING
			elseif ((p.mo.momz*P_MobjFlip(p.mo)) < -1*FRACUNIT) then
				p.mo.state = S_PLAY_FALL
			end
		end
	end

	if p.mo.state == S_PLAY_FALL
	and gamemap == 110
	and p.mo.x > -10368*FRACUNIT
	and p.mo.x < -5312*FRACUNIT
	and p.mo.y > 16576*FRACUNIT
	and p.mo.y < 17344*FRACUNIT then
		p.mo.state = S_PLAY_PAIN
	end
end)

-- and now just to clean up the init file we'll load any other non skin specific player code here.
dofile("Gameplay/Character/superfloat.lua")
dofile("Gameplay/Character/mrceplayer-hyper.lua")
--dofile("Gameplay/Character/superattract.lua")
