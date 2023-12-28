/*
	MRCE Episode Select Deluxe

	Rewritten menu system that offers a significantly more
	polished and refined experience.

	Programmed by ashisharky
*/

--#region variables

local MENUMAP = 99

local EPSIZE = 176

local BGHEIGHT = 200
local HUDTEXTHEIGHT = 30

local INPUT_JUMP = {0,0}
local INPUT_LEFT = {0,0}
local INPUT_RIGHT = {0,0}
-- we need to be able to block these buttons as characters use them for abilities lol
local INPUT_SPIN = {0,0}
local INPUT_CUSTOM1 = {0,0}
local INPUT_CUSTOM2 = {0,0}
local INPUT_CUSTOM3 = {0,0}

-- start with main quest selected
local selection_index = 2
local prev_selection = 2
local menu_background_color
local header_x = 0

local anim_shift = {
	duration = TICRATE/2,
	time = 0,
	time_capped = nil,
	percentage = nil
}

local menu_info = {
	/*[1] = {
		name = "Vanilla",
		description = "Vanilla SRB2 standalone experience with MRCE's QOL features.",
		image = "EPM_LOCKON",
		action = function()
			G_SetCustomExitVars(1,1)
			GlobalBanks_Array[0] = $ & ~(1 << (27))
			mrce_lockOn = false
			G_ExitLevel()
		end
	},*/
	[1] = {
		name = "Lock-On",
		description = "Vanilla SRB2 + The Mystic Realm back-to-back.",
		image = "EPM_LOCKON",
		action = function()
			G_SetCustomExitVars(1,1)
			--GlobalBanks_Array[0] = $|(1 << (27))
			--mrce_lockOn = true
			G_ExitLevel()
		end
	},
	[2] = {
		name = "Main Quest",
		description = "The standalone Mystic Realm experience.",
		image = "EPM_MAINQST",
		action = function()
			G_SetCustomExitVars(101,1)
			G_ExitLevel()
		end
	}
}

--#endregion

-- yw xian - ashi
rawset(_G, "MRCE_addEpisode", function(newentry)
	table.insert(menu_info, newentry)
end)

addHook("MapLoad", function(p)
	-- only enable hub on the menu map
	for player in players.iterate do
		if gamemap == MENUMAP then
			player.mrhubon = true
			player.powers[pw_nocontrol] = 1
		else
			player.mrhubon = false
		end
	end

	if gamemap == MENUMAP then
		INPUT_JUMP[1], INPUT_JUMP[2] = input.gameControlToKeyNum(GC_JUMP)
		INPUT_LEFT[1], INPUT_LEFT[2] = input.gameControlToKeyNum(GC_STRAFELEFT)
		INPUT_RIGHT[1], INPUT_RIGHT[2] = input.gameControlToKeyNum(GC_STRAFERIGHT)
		INPUT_SPIN[1], INPUT_SPIN[2] = input.gameControlToKeyNum(GC_SPIN)
		INPUT_CUSTOM1[1], INPUT_CUSTOM1[2] = input.gameControlToKeyNum(GC_CUSTOM1)
		INPUT_CUSTOM2[1], INPUT_CUSTOM2[2] = input.gameControlToKeyNum(GC_CUSTOM2)
		INPUT_CUSTOM3[1], INPUT_CUSTOM3[2] = input.gameControlToKeyNum(GC_CUSTOM3)


		-- choose a random color for the menu background
		local sky_colors = {
			SKINCOLOR_BLUE,
			SKINCOLOR_PURPLE,
			SKINCOLOR_GREEN,
			SKINCOLOR_RED,
			SKINCOLOR_SKY,
			SKINCOLOR_YELLOW,
			SKINCOLOR_GREY
		}

		-- stolen from xian's random_title_sky script
		local ctime = os.date("*t")
		local st = max((os.time(ctime) % FRACUNIT), 3)
		P_RandomKey(st)

		menu_background_color = sky_colors[P_RandomKey(#sky_colors)+1]
	end
end)

local function Draw_EpisodeOption(v, x, y, name, image)
	local patch = v.cachePatch(image)

	v.drawScaled(x * FU, y * FU, FU/2, patch)
	v.drawString(x + 42, y, name, V_ALLOWLOWERCASE, "thin-center")
end

local current_x = 0
local function Draw_MenuBackground(v)
	local patch = v.cachePatch("EPMBG")
	local colormap = v.getColormap(TC_DEFAULT, menu_background_color)

	if current_x == -256 then
		current_x = 0
	else
		current_x = $ - 1
	end

	local x = 0
	while(x < v.width()) do
		v.draw(x + current_x, 0, patch, V_SNAPTOTOP|V_SNAPTOLEFT, colormap)

		x = $ + 256
	end
end

hud.add(function(v, p)
	if not p.mrhubon then return end

	local cur_inf = menu_info[selection_index]

	anim_shift.time_capped = max(min(anim_shift.time, anim_shift.duration), 0)
    anim_shift.percentage = FU / anim_shift.duration * anim_shift.time_capped

	-- fill screen
	v.drawFill(0, 0, 320, 200,159)
	Draw_MenuBackground(v)

	-- TODO: draw a background of some sort here maybe like a random colored sky

	-- draw header
	if header_x == 224 then
		header_x = 0
	else
		header_x = $ + 1
	end

	v.drawFill(0, 0, v.width(), 10, 106|V_SNAPTOTOP|V_SNAPTOLEFT)
	v.draw(header_x - 224, 10, v.cachePatch("EPMHEADER"), V_SNAPTOTOP|V_SNAPTOLEFT)
	v.draw(header_x, 10, v.cachePatch("EPMHEADER"), V_SNAPTOTOP|V_SNAPTOLEFT)
	v.draw(header_x + 224, 10, v.cachePatch("EPMHEADER"), V_SNAPTOTOP|V_SNAPTOLEFT)
	v.drawLevelTitle(160 - (v.levelTitleWidth("Episode Select") / 2), 5, "Episode Select", V_SNAPTOTOP)

	-- draw the current selection description
	v.drawString(160, 190, cur_inf.description, V_ALLOWLOWERCASE, "thin-center")

	-- draw episode select elements
	local episode_x, x
	for i=1,#menu_info do
		if i < selection_index then
			episode_x = (selection_index - i) * (EPSIZE/2)
			if prev_selection > selection_index then
				x = ease.outcubic(anim_shift.percentage, episode_x + (EPSIZE/2), episode_x)
			else
				x = ease.outcubic(anim_shift.percentage, episode_x - (EPSIZE/2), episode_x)
			end

			Draw_EpisodeOption(v, 118 - x, 70, menu_info[i].name, menu_info[i].image)
		elseif i > selection_index then
			episode_x = (i - selection_index) * (EPSIZE/2)
			if prev_selection > selection_index then
				x = ease.outcubic(anim_shift.percentage, episode_x - (EPSIZE/2), episode_x)
			else
				x = ease.outcubic(anim_shift.percentage, episode_x + (EPSIZE/2), episode_x)
			end

			Draw_EpisodeOption(v, 118 + x, 70, menu_info[i].name, menu_info[i].image)
		else
			local x = (prev_selection > selection_index)
			and ease.outcubic(anim_shift.percentage, 118 - (EPSIZE/2), 118) or ease.outcubic(anim_shift.percentage, 118 + (EPSIZE/2), 118)

			Draw_EpisodeOption(v, x, ease.outcubic(anim_shift.percentage, 70, 50), menu_info[i].name, menu_info[i].image)
		end
	end

	anim_shift.time = $ + 1
end, "game")


-- I am not using player.cmd as it is a horrible practice to directly modify something like that
-- and really shouldn't have been accepted in the first place. a dedicated input library is much
-- better and honestly the way things should have been done in the first place.
local axisheld = 0
addHook("ThinkFrame", function()
	if (gamemap != MENUMAP) then return end

	if (input.joyAxis(JA_STRAFE) > 200) then
		if axisheld == 0 then
			if selection_index < #menu_info then
				prev_selection = selection_index
				selection_index = $ + 1
				anim_shift.time = 0
				S_StartSound(nil, sfx_s3kb7)
			end
		end
		axisheld = 1
	elseif (input.joyAxis(JA_STRAFE) < -200) then
		if axisheld == 0 then
			if selection_index > 0 then
				prev_selection = selection_index
				selection_index = $ - 1
				anim_shift.time = 0
				S_StartSound(nil, sfx_s3kb7)
			end
		end
		axisheld = 1
	else
		axisheld = 0
	end
end)

addHook("KeyDown", function(key)
	if gamemap != MENUMAP then return end

	-- boot player to menu if escape is pressed
	if key.num == 27 then
	-- no netgame check if you're here on a netgame something is wrong
		COM_BufInsertText(consoleplayer, "exitgame")
		return true
	end

	if key.num == INPUT_JUMP[1]
	or key.num == INPUT_JUMP[2] then
		S_StartSound(nil, sfx_menu1)
		menu_info[selection_index].action()
		return true;
	end

	if key.num == INPUT_LEFT[1]
		or key.num == INPUT_LEFT[2] then
		if selection_index > 1 then
			prev_selection = selection_index
			selection_index = $ - 1
			anim_shift.time = 0
			S_StartSound(nil, sfx_s3kb7)
		end
		return true;
	end

	if key.num == INPUT_RIGHT[1]
		or key.num == INPUT_RIGHT[2] then
		if selection_index < #menu_info then
			prev_selection = selection_index
			selection_index = $ + 1
			anim_shift.time = 0
			S_StartSound(nil, sfx_s3kb7)
		end
		return true;
	end

	if key.num == INPUT_SPIN[1]
	or key.num == INPUT_SPIN[2]
	or key.num == INPUT_CUSTOM1[1]
	or key.num == INPUT_CUSTOM1[2]
	or key.num == INPUT_CUSTOM2[1]
	or key.num == INPUT_CUSTOM2[2]
	or key.num == INPUT_CUSTOM3[1]
	or key.num == INPUT_CUSTOM3[2] then
		return true;
	end
end)
