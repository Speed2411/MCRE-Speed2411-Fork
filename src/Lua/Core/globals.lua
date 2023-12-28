-- placed here so it doesn't use it's own file lol
sfxinfo[sfx_kc5c].caption = "Shrine Activated"
rawset(_G, "shrine_active", false)

freeslot("MT_MFZTREE")

--Credit to Motd for this
--Credit to Lach for the OG
-- alignment: -1 = right-aligned, 1 = left-aligned
rawset(_G, "DrawMotdString",
-- Displays a string with a custom font
---@param v drawer
---@param x integer
---@param y integer
---@param scale integer
---@param text string
---@param font string
---@param flags integer
---@param alignment integer
---@param color colormap
function(v, x, y, scale, text, font, flags, alignment, color)
	local right
	local colormap = v.getColormap(0, color)
	local start
	local finish
	alignment = $ or 1
	color = $ or 0
	right = alignment < 0
	text = tostring(text)

	if right then
		start = text:len()
    	finish = 1
	else
		start = 1
		finish = text:len()
	end

	for i = start, finish, alignment do
		local letter = font .. text:sub(i, i)
		if not v.patchExists(letter) then continue end

		local patch = v.cachePatch(letter)

		if right then -- right aligned, change offset before drawing
			x = $ - patch.width*scale
		end

		v.drawScaled(x, y, scale, patch, flags, colormap)

		if not right then -- left aligned, change offset after drawing
			x = $ + patch.width*scale
		end
	end
end)

rawset(_G, "IntToExtMapNum",
-- Borrowed from MapVote.lua
--IntToExtMapNum(n)
--Returns the extended map number as a string
--Returns nil if n is an invalid map number
---@param n number
function(n)
	if n < 0 or n > 1035 then
		return nil
	end
	if n < 10 then
		return "MAP0" + n
	end
	if n < 100 then
		return "MAP" + n
	end
	local x = n-100
	local p = x/36
	local q = x - (36*p)
	local a = string.char(65 + p)
	local b
	if q < 10 then
		b = q
	else
		b = string.char(55 + q)
	end
	return "MAP" + a + b
end)

rawset(_G, "GetNumberList",
--From CobaltBW. Thank you my dude!
--This is used to turn a level header variable into a table
--via detecting a "," as a separator.
---@param str string
function(str)
	local t = {}
	while str do
		local sep = string.find(str,'%,')
		if sep != nil then
			local arg = string.sub(str,0,sep-1)
			local tag = tonumber(arg)
			if tag then
				table.insert(t, tag)
			elseif tag != 0 then
				print('Invalid argument '..arg)
				break
			end
			str = string.sub($,sep+1)
		else
			local tag = tonumber(str)
			if tag then
				table.insert(t, tag)
			end
			break
		end
	end
	return t
end)

-- Misc variables used throughout multiple scripts
rawset(_G, "pi", 22*FRACUNIT/7) -- Used in multiple objects and bosses
rawset(_G, "dispstaticlogo", false) -- Credits

rawset(_G, "debugmenu", false) -- Used to hide titlescreen elements for debug menus

rawset(_G, "ctrl_inputs", {
	-- movement
    up = {}, down = {}, left = {}, right = {},
    -- main
    jmp = {}, spn = {}, cb1 = {}, cb2 = {}, cb3 = {},
    -- sys
    sys = {}, pause = {}, con = {}
})

-- fill out these on map load
addHook("MapLoad", function()
    ctrl_inputs.up[1], ctrl_inputs.up[2] = input.gameControlToKeyNum(GC_FORWARD)
	ctrl_inputs.down[1], ctrl_inputs.down[2] = input.gameControlToKeyNum(GC_BACKWARD)
	ctrl_inputs.left[1], ctrl_inputs.left[2] = input.gameControlToKeyNum(GC_STRAFELEFT)
	ctrl_inputs.right[1], ctrl_inputs.right[2] = input.gameControlToKeyNum(GC_STRAFERIGHT)

	ctrl_inputs.jmp[1], ctrl_inputs.jmp[2] = input.gameControlToKeyNum(GC_JUMP)
	ctrl_inputs.spn[1], ctrl_inputs.spn[2] = input.gameControlToKeyNum(GC_SPIN)
	ctrl_inputs.cb1[1], ctrl_inputs.cb1[2] = input.gameControlToKeyNum(GC_CUSTOM1)
    ctrl_inputs.cb2[1], ctrl_inputs.cb2[2] = input.gameControlToKeyNum(GC_CUSTOM2)
    ctrl_inputs.cb3[1], ctrl_inputs.cb3[2] = input.gameControlToKeyNum(GC_CUSTOM3)

	ctrl_inputs.sys[1], ctrl_inputs.sys[2] = input.gameControlToKeyNum(GC_SYSTEMMENU)
	ctrl_inputs.pause[1], ctrl_inputs.pause[2] = input.gameControlToKeyNum(GC_PAUSE)
    ctrl_inputs.con[1], ctrl_inputs.con[2] = input.gameControlToKeyNum(GC_CONSOLE)


	if (GlobalBanks_Array[0] & (1 << (15))) and not (mrce_hyperstones & (1 << (0))) then mrce_hyperstones = $ + 1 end
	if (GlobalBanks_Array[0] & (1 << (16))) and not (mrce_hyperstones & (1 << (1))) then mrce_hyperstones = $ + 2 end
	if (GlobalBanks_Array[0] & (1 << (17))) and not (mrce_hyperstones & (1 << (2))) then mrce_hyperstones = $ + 4 end
end)

-- position/flag values for the hud elements
rawset(_G, "hudpos", {
	yb_time = {
		x = 152,
		y = 100,
	},
	yb_guard = {
		x = 152,
		y = 100,
	},
	yb_ring = {
		x = 152,
		y = 117,
	},
	yb_total = {
		x = 152,
		y = 151,
	},
	yb_perfect = {
		x = 152,
		y = 151,
	},
	yb_link = {
		x = 141,
		y = 108,
	},
	yb_score = {
		x = 141,
		y = 125,
	},
	yb_downscore = {
		x = 141,
		y = 142,
	},
	yb_continue = {
		x = 141,
		y = 151,
	},
})

--hijacking this for my own global  function stuff instead of it having its own file --Xian

addHook("PreThinkFrame", function()
    for p in players.iterate do
		if not p.realmo then continue end
		if p.spectator then continue end
		if p.mrce == nil then
			local mrce = {
			glowaura = 0,
			flycheat = false,
			hypercheat = false,
			canhyper = false,
			ultrastar = false,
			hyperimages = false,
			hypermode = false,
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
	end
end)

if not (yakuzaBossTexts) then
	rawset(_G, "yakuzaBossTexts", {})
end

rawset(_G, "mrce_hyperunlocked", false) --this is here for mrce to detect if hyper has been unlocked
rawset(_G, "mrce_secondquest", false) --sets whether second quest is currently active
rawset(_G, "mrce_dowarptime", false) --check if the post AGZ4 return warp is active
rawset(_G, "mrce_hyperstones", 0)

addHook("NetVars", function(net)
	mrce_dowarptime = net($)
	mrce_hyperstones = net($)
	mrce_hyperunlocked = net($)
	mrce_secondquest = net($)
end)
