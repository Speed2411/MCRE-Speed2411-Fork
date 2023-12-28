/* Credits Framework
(C) 2021-2022 by Ashi
(C) 2021 by Tatsuru

Huge help from Tatsuru for making the text framework not trash
Rest was done by me

//////// Parameter info ////////
header = <string>: The string should be the name of the header patch (default is nul)
secstick = <true/false>: Should the section stick around before scrolling up? (default is false)
sticktime = <integer>: How long should it stick around? (default is 50)
////////////////////////////////
Reminder: Credits are usually listed in alphebetical order.
*/

local CV_Netwarp = CV_RegisterVar{
	name = "mr_cwarp",
	defaultvalue = 1,
	flags = CV_NETVAR,
	PossibleValue = {MIN = 1, MAX = 1035}
}

local dispstaticlogo = false
local y = 200 -- You shouldn't need to edit this.
local x = 0

local openticker = 0
local sizing = FRACUNIT/6
local endstick = 175

local p1, p2 = 0, 0
local sys1, sys2 = 0, 0
local j1, j2 = 0, 0
local c1, c2 = 0, 0
local c3, c4 = 0, 0
local c5, c6 = 0, 0
local s1, s2 = 0, 0
local tf1, tf2 = 0, 0
local spinhold = false

local creditstable = {
	{
		header = "GMDHEADER";
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
	},
	{
		header = "MCHEADER";
		"",
		"",
		"",
		'"Ashi"',
		'Bartu "Zipper" Ince',
		'"D00D64"', -- Continue lives script (HOW DID I FORGET YOU I'M SORRY)
		'"Felicia.iso"', --I hope you realize that once your name's out on the internet, you can't pull it back. I can remove it from current versions but can never remove it from old versions
		'"Frostiikin"',
		'"Tatsuru"',
		'"Krabs"',
		'Lachlan "Lach" Wright', --DrawCustomString
		'"MotdSpork"', --DrawCustomString
		'"nami"',
		'"Radicalicious"',
		'Sam "Prime 2.0" Peters',
		'"SMS Alfredo"',
		'"Spectrum"',
		'"Xian"',
		'Zolton "Zippy_Zolton" Auburn',
	},
	/*{
		header = "PAHEADER";
		"",
		'"amperbee/Rapidgame7"',
		'"Tatsuru"',
		'"Flame"',
		'"Golden"',
	},*/ --removing this table until  I can make a header for it. Can't do that if I don't even know what "PAHEADER" even stands for
	{
		header = "GDHEADER";
		"",
		"",
		"",
		'"Ashi"',
		'"Akira"',
		'"connie"',
		'"DaJumpJump"',
		'"DirktheHusky"',
		'"InferNOr"',
		'"Motdspork"',
		'"RalphJeremy65"',
		'"sphere"',
		'"STFU"',
		'"Twins\39R\39Epic"',
		'"Xian"',
	},
	{
		header = "MMHEADER";
		"",
		"",
		"",
		'"Ashi"',
		'"cookiefonster"',
		'Jarel "Arrow" Jones',
		'Malcolm "RedXVI" Brown',
		'"Marcos"', --MKZ/VulkanForge/DWZ
		'Shane "clairebun" Ellis',
		'"Sheepbun"',
	},
	{
		header = "SWHEADER";
		"",
		"",
		"",
		'"Ashi"',
		'"Jewbert"',
		'Zolton "Zippy_Zolton" Auburn',
		'"Xian"',
		"",
	},
	{
		header = "LDHEADER";
		"",
		"",
		"",
		"All Original Level Design",
		'Ben "Mystic" Geyer', -- All OG level designs
		"",
		"Remastered Levels",
		"",
		"\139Jade Coast Zone",
		'\131Act 1',
		'"Ashi"', -- AGZ1/2,JCZ1/2/3,VFZ1,GSZ
		'"AceLite"',
		'"DirktheHusky"', -- JCZ,TVZ1
		'"Othius"', --JCZ1/2,GSZ
		"",
		'\131Act 2',
		'"Ashi"', -- AGZ1/2,JCZ1/2/3,VFZ1,GSZ
		'"AceLite"',
		'"DirktheHusky"', -- JCZ,TVZ1
		'"Nami"',
		'"Neon"',
		'"Othius"', --JCZ1/2,GSZ
		'"Seaballer"',
		'"Xian"',
		"",
		'\131Act 3',
		'"Ashi"', -- AGZ1/2,JCZ1/2/3,VFZ1,GSZ
		'"Xian"', --arena work
		'"AceLite"',
		'"Ordomandalore"', --One single flower inside JCZ3
		"",
		'\131Mudhole Karst Zone',
		'"Marcos"', -- MKZ
		'"Radicalicious"', -- MKZ,GSZ,FRZ1,LWZ,VFZ3
		"",
		"",
		"\139Tempest Valley Zone",
		'\131Act 1',
		'"Ashi"', -- Fixed up the merger
		'"DirktheHusky"', -- JCZ,TVZ1
		'"Hajime"', -- FRZ1/2/3
		'"Inferno"', -- TVZ1
		'"Nami"',
		'"Othius"', --JCZ1/2,GSZ
		'"Radicalicious"', -- New TVZ/RKZ goop
		'"Xian"',
		"",
		'\131Act 2',
		'Nobody yet :(',
		"",
		'\131Act 3',
		'"Ashi"', -- made the boss easier :troll:
		'"Radicalicious"',
		"",
		'\131Rainstorm Keep Zone',
		'"Ashi"',
		'"Radicalicious"',
		'"SilverVortex"',
		"",
		"",
		"\139Verdant Forest Zone",
		'\131Act 1',
		'"Ashi"',
		'"Othius"', --JCZ1/2,GSZ
		"",
		'\131Act 2',
		'"Radicalicious"',
		"",
		'\131Act 3',
		'"Radicalicious"', -- MKZ,GSZ,FRZ1,LWZ,VFZ3
		"",
		'\131Labyrinth Woods Zone',
		'"Radicalicious"', -- MKZ,GSZ,FRZ1,LWZ,VFZ3
		"",
		"",
		'\139Flame Rift Zone',
		'\131Act 1',
		'Felicia.iso', -- SPZ1/3,FRZ1,MFZ3
		'"Hajime"', -- FRZ1/2/3
		'"Othius"', --JCZ1/2,GSZ
		'"Radicalicious"', -- MKZ,GSZ,FRZ1,LWZ,VFZ3
		'"Xian"', -- AGZ,FRZ1,PAZ2,DWZ (Placeholder)
		'"STF"',
		'',
		'\131Act 2',
		'"Xian"', -- AGZ,FRZ1,PAZ2,DWZ (Placeholder)
		'"STF"',
		'',
		'\131Act 3',
		'Bartu "Zipper" Ince',  --wrote the egg fireballer in v6
		'"Hajime"', -- built the arena
		'',
		'\131Vulkan Forge Zone',
		'"Kanna"',
		'',
		'',
		'\139Midnight Freeze',
		'\131Act 1',
		'Inferno',
		'Diego',
		'',
		'\131Act 2',
		'Diego',
		'"Xian"',
		'',
		'\131Act 3',
		'"Ashi"',
		'Diego',
		'Felicia.iso', -- SPZ1/3,FRZ1,MFZ3
		'',
		'\131Silver Cavern Zone',
		'Nobody yet :(',
		'',
		'',
		'\139Sunken Plant Zone',
		'\131Act 1',
		'Felicia.iso', -- SPZ1/3,FRZ1,MFZ3
		'"InferNOr"', -- SPZ1
		'"Xian"',
		'',
		'\131Act 2',
		'"Xian"', --did the shrine
		'',
		'\131Act 3',
		'Felicia.iso', --built the arena and coded the boss
		'"Ketchupik"', -- made the helicopter turn on
		'"Xian"',
		'',
		'\131Nitric Citadel Zone',
		'"Xian"',
		'',
		'',
		'\139Aerial Garden Zone',
		'\131Act 1',
		'"Ashi"', -- literally everything
		'',
		'\131Act 2',
		'"Ashi"',
		'"Spectrum"', -- Fixes for AGZ2
		'"Xian"', -- did the shrine and the skybox borrowed and edited from act 1
		'',
		'\131Act 3',
		'"Xian"', --built the arena and portal , and all the lua scripts to make the emerald placing and portal opening function
		'"Marcos"',  --started the portal sequence
		'"Neon"',  --made portal sequence a tunnel
		'"Ashi"', --did the skybox for agz1, which I "borrowed" and edited for use here
		'',
		'\131Act 4',
		'"Xian"',
		'',
		'\131Starlight Temple Zone',
		'"Xian"', -- AGZ,FRZ1,PAZ2,DWZ (Placeholder)
		'',
		'',
		'\139Prismatic Angel Zone',
		'\131Act 1',
		'"Xian"',
		'',
		'\131Act 2',
		'"Xian"', -- AGZ,FRZ1,PAZ2,DWZ (Placeholder)
		'',
		'',
		'\131Spatial Void Zone',
		'"Xian"', -- AGZ,FRZ1,PAZ2,DWZ (Placeholder)
		'"STF"',
		'',
		'',
		'\131Mystic Realm Zone',
		'"Xian"',
		'',
		'\131Dimension Warp Zone',
		--'"Ashi"', -- waiting for a solid decided on concept before beginning
		'"Xian"', -- (did the placeholder)
		'',
		'',
		'\139Bonus Levels',
		'\131Golden Sands Zone',
		'"Ashi"', -- AGZ1/2,JCZ1/2/3,VFZ1,GSZ
		'"Othius"', --JCZ1/2,GSZ
		'"Radicalicious"', -- MKZ,GSZ,FRZ1,LWZ,VFZ3
		'',
		'\131Primordial Abyss Zone',
		'"Othius"', --JCZ1/2,GSZ
		'"So2ro"', -- Primordial Abyss (anger)
		'"Xian"',
		'',
		'\139Auxillary Maps',
		'\131Titlemap',
		'"PersistentVoid"',
		"",
		'\131Credits Map',
		'"Ashi"',  --IT'S LITERALLY A SQUARE
		'',  --LIKE ACTUALLY WHY IS THIS HERE
			-- ok so like. the idea was that I was going to have like
			-- parts of the zones show up during the credits but like
			-- I have completely forgotten how I was going to do that
			-- anyways this is really funny so I suggest we keep it here
			-- as a joke. - ashi
	},
	{
		header = "PTHEADER";
		"",
		"",
		"",
		'"Appleblurt"',
		'"DaJumpJump"',
		'"Frostiikin"',
		'"Inazuma"',
		'"Logan8r"',
		'"PencilVoid"',
		'"RalphJeremy65"',
		'"Slow"',
		'"Starlight"',
		'"Sylve"',
		'"Tatsuru"',
		'"Xian"',
		'The SRB2 Community',
	},
	{
		header = "CHIEFJACK";
		"",
		"",
		"",
		'"PencilVoid"',
		"",
		"",
	},
	{
		header = "STHEADER";
		"",
		"",
		"",
		'Porting to 2.0 by Ezer.Arch, Kaysakado,',
		'	MascaraSnake and Prime 2.0',
		"", -- Blank lines are used to add spaces between each special thank
		'SSNTails - for coding',
		'	all sorts of stuff into SRB2 for this',
		"",
		'Sonic Team Junior - For creating SRB2.',
		"	This wouldn't exist without it",
		"",
		'Kwiin / Othius - For making v6 reusable and',
		'	Allowing this project to happen',
		"",
	},
	{
		header = "THANKPLAY",
		secstick = true;
	},
}

local function DrawCredits(v)
	if not(gamemap == 98) then return end -- Change 99 to any sutable map you use
	if dispstaticlogo == true then
		v.drawFill(0, 0, 320, 200, 31)
	end
	if y >= -12275000
	and dispstaticlogo == true then
		v.drawScaled(55*FRACUNIT, x+(30*FU), FRACUNIT/6, v.cachePatch("SLOGO"))
	end
    -- if not(sceneblock == credits) then return end -- Don't run this unless we are supposed to
	local yspace = 0
	for i, section in ipairs(creditstable) do -- for each section in the credits
		local headerpatch = v.cachePatch(section.header)
		v.drawScaled(0, (280*FRACUNIT)+(y+(yspace)), FRACUNIT/2, headerpatch) -- or however you need to format it
		yspace = $ + (headerpatch.height*FRACUNIT/8) -- arbitrary amount of space you want to move from the header

		for j, name in ipairs(section) do
			v.drawString(160*FRACUNIT, (300*FRACUNIT)+(y+yspace), name, V_ALLOWLOWERCASE, "fixed-center") -- same thing here
			yspace = $ + 11*FRACUNIT -- arbitrary amount of space between each name
		end
		yspace = $ + 42*FRACUNIT-- arbitrary amount of space before next header
	end
end

addHook("ThinkFrame", function()
	if gamemap != 98 then return end -- Change this along with the gamemap line in DrawCredits
	if openticker <= 300 then --how long the logo should stay rendered. after 300 ticks it disappears, which is just after it slides offscreen
		sizing = $ - 1
		openticker = $ + 1
	end
	if openticker >= 115 then --start moving the text early so it transitions with the logo smoothly
			-- hey quick question me where the FUCK did this number come from
		if spinhold and y >= -262563016 then -- Increase the speed when the player holds down spin --since the entire table is rendered all at once,
			y = $ - FRACUNIT*4																-- checking which part is currently onscreen doesn't really work. So instead we check how long the text
		elseif y >= -262563016 then 															-- has been scrolling for, and pause it when the "Thanks for playing" graphic is centered on screen.
			y = $ - FRACUNIT																--be sure to change this value if any additional names are added, else the credits may end early
		end
	end
	if openticker > 115 and openticker < 400 and spinhold then--since the logo starts scrolling separately from the text, it has its own value. runs at the same speed though
		dispstaticlogo = true
		x = $ - FRACUNIT*4
	elseif openticker > 115 and openticker < 400 then
		dispstaticlogo = true
		x = $ - FRACUNIT
	end
	if y <= -262563016 then  --change this too if adding more names, as this ticks a short timer before exitlevel once the value stops due to the above function
		endstick = $ - 1
		if endstick == 0 then
			if netgame then
				G_SetCustomExitVars((CV_Netwarp.value),1)
			else
				G_SetCustomExitVars(1101,1)
			end
			G_ExitLevel()
		end
	end
	--print(tostring(y))--enable this when adding more names to more easily tell what number to change theabove 3 values to
end)

addHook("PlayerThink", function(p)
	if p.spectator then return end
	if not p.realmo then return end
	if gamemap != 98 then return end
	p.momz = 1*FRACUNIT
	p.momx = 0
	p.momy = 0 --put the player against the ceiling and don't let them move. prevents spindash noise when holding spin to speed up
	p.mo.state = S_PLAY_STUN --should prevent all air abilities including modded characters, assuming the character is well designed
	if not multiplayer
	and p.cmd.buttons & BT_SPIN then
		spinhold = true --allow speeding up credits in singleplayer. only singleplayer though bc it causes game freezes in netgames
	else
		spinhold = false
	end
end)
hud.add(DrawCredits)

addHook("MapLoad", function()
	if gamemap == 98 then -- Change this along with the gamemap line in DrawCredits
		y = 200
		x = 0
		dispstaticlogo = false
		endstick = 175
		openticker = 0
		sys1, sys2 = input.gameControlToKeyNum(GC_SYSTEMMENU)
		p1, p2 = input.gameControlToKeyNum(GC_PAUSE)
		j1, j2 = input.gameControlToKeyNum(GC_JUMP)
		c1, c2 = input.gameControlToKeyNum(GC_CUSTOM1)
		c3, c4 = input.gameControlToKeyNum(GC_CUSTOM2)
		c5, c6 = input.gameControlToKeyNum(GC_CUSTOM3)
		s1, s2 = input.gameControlToKeyNum(GC_SCORES)
		tf1, tf2 = input.gameControlToKeyNum(GC_TOSSFLAG)
	end
end)

-- Prevent the player from opening the pause menu
-- NOTE: You can still open the console and warp out
--
-- TODO: Add functionality to skip credits if viewed before
--		(Thank you xian for reminding me this exists in vanilla)
addHook("KeyDown", function(key)
	if gamemap == 98 then
		if key.num == sys1
		or key.num == sys2 then
			return true
		end
		if key.num == p1 and not netgame
		or key.num == p2 and not netgame then
			print("You cannot pause right now!")
			return true
		end
		if key.num == j1
		or key.num == j2
		or key.num == c1
		or key.num == c2
		or key.num == s1
		or key.num == s2
		or key.num == tf1
		or key.num == tf2
		or key.num == c3
		or key.num == c4
		or key.num == c5
		or key.num == c6 then
			return true
		end
		if key.num == 32 then
			return true
		end
		if key.num == 27 and not netgame then
			-- CURSE YOU ESCAPE FOR BEING DIFFERENT
			return true
		end
	end
end)

addHook("NetVars", function(net)
	spinhold = net($)
	y = net($)
	dispstaticlogo = net($)
	x = net($)
	openticker = net($)
	endstick = net($)
end)