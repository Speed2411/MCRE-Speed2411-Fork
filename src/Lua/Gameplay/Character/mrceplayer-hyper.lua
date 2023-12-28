//Wow this mod's been passed around a lot. Originally based on hyper abilities v4.1.2, then edited for mrce.
//It barely maintains any of the original code, but credit is still due.  v4.1.2 by GameBoyTM101
//Credits for the original scripts from 2.1 go to MotdSpork on the SRB2 Message Board, as well as HitKid61/HitCoder
//Additional credits to Radicalicious for the Multiglide Knuckles and Infinite Flight Tails code.
//Also credit to DirkTheHusky for the custom colors themed after the 7 emeralds
sfxinfo[freeslot("sfx_mrfly")].caption = "Flight"

freeslot(
    "MT_SUPERSPARKLES",
    "SPR_SUSK",
    "S_SUPERSPARK",
    "SKINCOLOR_SUPERSAPPHIRE1",
    "SKINCOLOR_SUPERSAPPHIRE2",
    "SKINCOLOR_SUPERBUBBLEGUM1",
    "SKINCOLOR_SUPERBUBBLEGUM2",
    "SKINCOLOR_SUPERMINT1",
    "SKINCOLOR_SUPERMINT2",
    "SKINCOLOR_SUPERRUBY1",
    "SKINCOLOR_SUPERRUBY2",
    "SKINCOLOR_SUPERWAVE1",
    "SKINCOLOR_SUPERWAVE2",
    "SKINCOLOR_SUPERCOPPER1",
    "SKINCOLOR_SUPERCOPPER2",
    "SKINCOLOR_SUPERAETHER1",
    "SKINCOLOR_SUPERAETHER2",
    "SKINCOLOR_MRCEHYPER1",
    "SKINCOLOR_MRCEHYPER2",
	"SKINCOLOR_MR_COMET",
	"SKINCOLOR_MR_VOID",
	"SKINCOLOR_BLANK"
)

-- this needs to be here
--local luabanks = reserveLuabanks() --save shit to the current savefile, not globally

-- hint. when you see #region you can ctrl+F endregion <regionname> to find the end
-- example: 'endregion hyper skincolor defs' will point to the end of this very large block

--#region hyper skincolor defs

skincolors[SKINCOLOR_SUPERSAPPHIRE1] = {
	name = "Super Sapphire 1",
	ramp = {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 128, 131, 134, 135, 149, 150},
	accessible = false
}

skincolors[SKINCOLOR_SUPERSAPPHIRE2] = {
    name = "Super Sapphire 2",
    ramp = {0, 0, 0, 0, 128, 128, 131, 131, 134, 134, 135, 135, 149, 149, 150, 150},
    accessible = false
}

skincolors[SKINCOLOR_SUPERBUBBLEGUM1] = {
	name = "Super Bubblegum 1",
	ramp = {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 208, 200, 178, 179, 180, 181},
	accessible = false
}

skincolors[SKINCOLOR_SUPERBUBBLEGUM2] = {
    name = "Super Bubblegum 2",
    ramp = {0, 0, 0, 0, 208, 208, 200, 200, 178, 178, 179, 179, 180, 180, 181, 181},
    accessible = false
}

skincolors[SKINCOLOR_SUPERMINT1] = {
	name = "Super Mint 1",
	ramp = {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 88, 89, 98, 99, 100, 101},
	accessible = false
}

skincolors[SKINCOLOR_SUPERMINT2] = {
    name = "Super Mint 2",
    ramp = {0, 0, 0, 0, 88, 88, 89, 89, 98, 98, 99, 99, 100, 100, 101, 101},
    accessible = false
}

skincolors[SKINCOLOR_SUPERRUBY1] = {
	name = "Super Ruby 1",
	ramp = {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 176, 201, 202, 203, 204, 38},
	accessible = false
}

skincolors[SKINCOLOR_SUPERRUBY2] = {
    name = "Super Ruby 2",
    ramp = {0, 0, 0, 0, 176, 176, 201, 201, 202, 202, 203, 203, 204, 204, 38, 38},
    accessible = false
}

skincolors[SKINCOLOR_SUPERWAVE1] = {
	name = "Super Wave 1",
	ramp = {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 120, 121, 141, 135, 136, 137},
	accessible = false
}

skincolors[SKINCOLOR_SUPERWAVE2] = {
    name = "Super Wave 2",
    ramp = {0, 0, 0, 0, 120, 120, 121, 121, 141, 141, 135, 135, 136, 136, 137, 137},
    accessible = false
}

skincolors[SKINCOLOR_SUPERCOPPER1] = {
	name = "Super Copper 1",
	ramp = {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 81, 82, 64, 52, 53, 54},
	accessible = false
}

skincolors[SKINCOLOR_SUPERCOPPER2] = {
    name = "Super Copper 2",
    ramp = {0, 0, 0, 0, 81, 81, 82, 82, 64, 64, 52, 52, 53, 53, 54, 54},
    accessible = false
}

skincolors[SKINCOLOR_SUPERAETHER1] = {
	name = "Super Aether 1",
	ramp = {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 2, 3, 145, 170},
	accessible = false
}

skincolors[SKINCOLOR_SUPERAETHER2] = {
    name = "Super Aether 2",
    ramp = {0, 0, 0, 0, 0, 0, 1, 1, 2, 2, 3, 3, 145, 145, 170, 170},
    accessible = false
}

skincolors[SKINCOLOR_MRCEHYPER1] = {
	name = "Hyper1",
	ramp = {0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0},
	accessible = false
}

skincolors[SKINCOLOR_MRCEHYPER2] = {
	name = "Hyper2",
	ramp = {0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0},
	accessible = false
}

skincolors[SKINCOLOR_MR_COMET] = {
	name = "Comet",
	ramp = {178,162,163,165,166,167,167,157,158,158,159,253,253,30,30,31},
	invcolor = SKINCOLOR_SUNSET,
	invshade = 4,
	chatcolor = V_PURPLEMAP,
	accessible = true
}

skincolors[SKINCOLOR_MR_VOID] = {
	name = "Dark Prism",
	ramp = {177,179,181,182,183,166,166,167,167,168,168,169,253,254,254,30},
	invcolor = SKINCOLOR_SUNSET,
	invshade = 3,
	chatcolor = V_MAGENTAMAP,
	accessible = true
}

skincolors[SKINCOLOR_BLANK] = {
    name = "Blank",
    ramp = {0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0},
    accessible = false
}



local flashColor1 = skincolors[SKINCOLOR_MRCEHYPER1]
local flashColor2 = skincolors[SKINCOLOR_MRCEHYPER2]
local flashDelay = 3 //change this to how many tics it takes to animate
local colorpos1 = 1
local colorpos2 = 1
local colors1 = {
{0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 128, 131, 134, 135, 149, 150},
{0, 0, 0, 0, 128, 128, 131, 131, 134, 134, 135, 135, 149, 149, 150, 150},  --blue
{0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 128, 131, 134, 135, 149, 150},
{0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0},
{0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 208, 200, 178, 179, 180, 181},
{0, 0, 0, 0, 208, 208, 200, 200, 178, 178, 179, 179, 180, 180, 181, 181},  --purple
{0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 208, 200, 178, 179, 180, 181},
{0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0},
{0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 88, 89, 98, 99, 100, 101},
{0, 0, 0, 0, 88, 88, 89, 89, 98, 98, 99, 99, 100, 100, 101, 101},  --green
{0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 88, 89, 98, 99, 100, 101},
{0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0},
{0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 176, 201, 202, 203, 204, 38},
{0, 0, 0, 0, 176, 176, 201, 201, 202, 202, 203, 203, 204, 204, 38, 38},  --red
{0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 176, 201, 202, 203, 204, 38},
{0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0},
{0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 120, 121, 141, 135, 136, 137},
{0, 0, 0, 0, 120, 120, 121, 121, 141, 141, 135, 135, 136, 136, 137, 137},  --cyan
{0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 120, 121, 141, 135, 136, 137},
{0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0},
{0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 81, 82, 64, 52, 53, 54},
{0, 0, 0, 0, 81, 81, 82, 82, 64, 64, 52, 52, 53, 53, 54, 54},  --yellow
{0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 81, 82, 64, 52, 53, 54},
{0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0},
{0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 2, 3, 145, 170},
{0, 0, 0, 0, 0, 0, 1, 1, 2, 2, 3, 3, 145, 145, 170, 170},  --white
{0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 2, 3, 145, 170},
{0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0}}

local colors2 = {
{0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 128, 131, 134, 135, 149, 150},
{0, 0, 0, 0, 128, 128, 131, 131, 134, 134, 135, 135, 149, 149, 150, 150},
{0, 0, 128, 128, 131, 131, 134, 134, 135, 135, 149, 149, 150, 150, 151, 151},
{0, 128, 131, 134, 135, 149, 150, 151, 152, 153, 155, 156, 157, 158, 159, 253},
{128, 131, 134, 135, 149, 150, 151, 152, 153, 155, 156, 157, 158, 159, 253, 254}, --blue
{0, 128, 131, 134, 135, 149, 150, 151, 152, 153, 155, 156, 157, 158, 159, 253},
{0, 0, 128, 128, 131, 131, 134, 134, 135, 135, 149, 149, 150, 150, 151, 151},
{0, 0, 0, 0, 128, 128, 131, 131, 134, 134, 135, 135, 149, 149, 150, 150},
{0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 128, 131, 134, 135, 149, 150},
{0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 208, 200, 178, 179, 180, 181},
{0, 0, 0, 0, 208, 208, 200, 200, 178, 178, 179, 179, 180, 180, 181, 181},
{0, 0, 208, 208, 200, 200, 178, 178, 179, 179, 180, 180, 181, 181, 182, 182},
{0, 208, 200, 178, 179, 180, 181, 182, 163, 163, 164, 164, 165, 165, 166, 167},
{208, 200, 178, 179, 180, 181, 182, 163, 163, 164, 164, 165, 165, 166, 167, 168},  --purple
{0, 208, 200, 178, 179, 180, 181, 182, 163, 163, 164, 164, 165, 165, 166, 167},
{0, 0, 208, 208, 200, 200, 178, 178, 179, 179, 180, 180, 181, 181, 182, 182},
{0, 0, 0, 0, 208, 208, 200, 200, 178, 178, 179, 179, 180, 180, 181, 181},
{0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 208, 200, 178, 179, 180, 181},
{0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 88, 89, 98, 99, 100, 101},
{0, 0, 0, 0, 88, 88, 89, 89, 98, 98, 99, 99, 100, 100, 101, 101},
{0, 0, 88, 88, 89, 89, 98, 98, 99, 99, 100, 100, 101, 101, 102, 102},
{0, 88, 89, 98, 99, 100, 101, 102, 103, 103, 126, 126, 143, 143, 138, 138},
{88, 89, 98, 99, 100, 101, 102, 103, 103, 126, 126, 143, 143, 138, 138, 253},  --green
{0, 88, 89, 98, 99, 100, 101, 102, 103, 103, 126, 126, 143, 143, 138, 138},
{0, 0, 88, 88, 89, 89, 98, 98, 99, 99, 100, 100, 101, 101, 102, 102},
{0, 0, 0, 0, 88, 88, 89, 89, 98, 98, 99, 99, 100, 100, 101, 101},
{0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 88, 89, 98, 99, 100, 101},
{0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 176, 201, 202, 203, 204, 38},
{0, 0, 0, 0, 176, 176, 201, 201, 202, 202, 203, 203, 204, 204, 38, 38},
{0, 0, 176, 176, 201, 201, 202, 202, 203, 203, 204, 204, 38, 38, 39, 39},
{0, 176, 201, 202, 203, 204, 38, 39, 40, 40, 41, 42, 185, 186, 187, 253},
{176, 201, 202, 203, 204, 38, 39, 40, 40, 41, 42, 185, 186, 187, 253, 254},  --red
{0, 176, 201, 202, 203, 204, 38, 39, 40, 40, 41, 42, 185, 186, 187, 253},
{0, 0, 176, 176, 201, 201, 202, 202, 203, 203, 204, 204, 38, 38, 39, 39},
{0, 0, 0, 0, 176, 176, 201, 201, 202, 202, 203, 203, 204, 204, 38, 38},
{0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 176, 201, 202, 203, 204, 38},
{0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 120, 121, 141, 135, 136, 137},
{0, 0, 0, 0, 120, 120, 121, 121, 141, 141, 135, 135, 136, 136, 137, 137},
{0, 0, 120, 120, 121, 121, 141, 141, 135, 135, 136, 136, 137, 137, 137, 137},
{0, 120, 121, 141, 135, 136, 137, 137, 174, 174, 168, 168, 169, 169, 159, 253},
{120, 121, 141, 135, 136, 137, 137, 174, 174, 168, 168, 169, 169, 253, 253, 254},  --cyan
{0, 120, 121, 141, 135, 136, 137, 137, 174, 174, 168, 168, 169, 169, 159, 253},
{0, 0, 120, 120, 121, 121, 141, 141, 135, 135, 136, 136, 137, 137, 137, 137},
{0, 0, 0, 0, 120, 120, 121, 121, 141, 141, 135, 135, 136, 136, 137, 137},
{0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 120, 121, 141, 135, 136, 137},
{0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 81, 82, 64, 52, 53, 54},
{0, 0, 0, 0, 81, 81, 82, 82, 64, 64, 52, 52, 53, 53, 54, 54},
{0, 0, 81, 81, 82, 82, 64, 64, 52, 52, 53, 53, 54, 54, 55, 55},
{0, 81, 82, 64, 52, 53, 54, 55, 56, 57, 58, 59, 60, 61, 42, 43},
{81, 82, 64, 52, 53, 54, 55, 56, 57, 58, 59, 60, 61, 42, 43, 44},  --yellow
{0, 81, 82, 64, 52, 53, 54, 55, 56, 57, 58, 59, 60, 61, 42, 43},
{0, 0, 81, 81, 82, 82, 64, 64, 52, 52, 53, 53, 54, 54, 55, 55},
{0, 0, 0, 0, 81, 81, 82, 82, 64, 64, 52, 52, 53, 53, 54, 54},
{0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 81, 82, 64, 52, 53, 54},
{0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 2, 3, 145, 170},
{0, 0, 0, 0, 0, 0, 1, 1, 2, 2, 3, 3, 145, 145, 170, 170},
{0, 0, 0, 0, 1, 1, 2, 2, 3, 3, 145, 145, 170, 170, 171, 171},
{0, 0, 1, 2, 3, 145, 170, 171, 171, 172, 173, 173, 174, 175, 168, 168},
{0, 1, 2, 3, 145, 170, 171, 171, 172, 173, 173, 174, 175, 168, 168, 169},  --white
{0, 0, 1, 2, 3, 145, 170, 171, 171, 172, 173, 173, 174, 175, 168, 168},
{0, 0, 0, 0, 1, 1, 2, 2, 3, 3, 145, 145, 170, 170, 171, 171},
{0, 0, 0, 0, 0, 0, 1, 1, 2, 2, 3, 3, 145, 145, 170, 170},
{0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 2, 3, 145, 170}}

--#endregion hyper skincolor defs

-- super sparkles
-- FIXME: XIAN. YOU NEED TO COMMENT YOUR CODE
if MRCE_superSpark == nil then
	rawset(_G, "MRCE_superSpark", function(mo, amount, fuse, speed1, speed2, hyper, usecolor)
		local colors = {SKINCOLOR_EMERALD, SKINCOLOR_PURPLE, SKINCOLOR_BLUE, SKINCOLOR_CYAN, SKINCOLOR_ORANGE, SKINCOLOR_RED, SKINCOLOR_GREY}
		if not (mo and mo.valid and amount ~= nil and fuse ~= nil and speed1 ~= nil and speed2 ~= nil and hyper ~= nil) then
			return
		end

		for i = 0, amount, 1 do
			local ha = P_RandomRange(0, 360)*ANG1
			local va = P_RandomRange(0, 360)*ANG1
			local speed = P_RandomRange(speed1/FRACUNIT, speed2/FRACUNIT)*FRACUNIT --how fast should sparkles shoot off their target object. speed1 is the lower range while speed2 is the upper

			local sprk = P_SpawnMobj(mo.x + FixedMul(FixedMul(mo.radius, FixedMul(cos(ha), cos(va))), mo.scale),
									 mo.y + FixedMul(FixedMul(mo.radius, FixedMul(sin(ha), cos(va))), mo.scale),
									 mo.z + FixedMul(FixedMul(mo.radius, sin(va)), mo.scale) + FixedMul(mo.scale, mo.height/2),
									 MT_SUPERSPARKLES)

			sprk.scale = mo.scale
			sprk.fuse = fuse --how long each sparkle should stick around for. Keep in mind shorter fuses can cut the sparkle animation off early
			if hyper == false then --if we don't want hyper form's rainbow sparkles, then
				if usecolor == 0 then --if we didn't set a color manually, try to get the target object's color if possible
					if mo.color then
						sprk.color = mo.color
					else --if the target object doesn't have a color, have a default. At this point though you'd definitely want to manually set a color
						sprk.color = 60
					end
				else --we set a color manually
					sprk.color = usecolor
				end
			else --we set it to use hyper's multicolored sparkles instead
				sprk.color = colors[P_RandomRange(1, #colors)]
			end
			if mo.player and not camera.chase then --if player is in first person view, don't draw sparkles that colud potentially obstruct their view
				sprk.flags2 = $|MF2_DONTDRAW
			end

			sprk.momx = FixedMul(FixedMul(speed, FixedMul(cos(ha), cos(va))), mo.scale)
			sprk.momy = FixedMul(FixedMul(speed, FixedMul(sin(ha), cos(va))), mo.scale)
			sprk.momz = FixedMul(FixedMul(speed, sin(va)), mo.scale)
		end
	end)
end

//break shit with hyper form
addHook ("MobjMoveCollide", function (plr, thing)
	if thing and thing.valid then
		if plr.player ~= nil and MRCE_isHyper(plr.player) then
			if thing.type == MT_TURRET
			or thing.type == MT_EGGROBO1 then
				if (plr.z + plr.height < thing.z)
				or (plr.z > thing.z + thing.height) then
					return false
				else
					P_KillMobj(thing, plr, plr)
					S_StartSound(thing, sfx_bedeen)
					thing.state = S_NULL
					return false
				end
			end
		end
	end
end, MT_PLAYER)

local function HyperA()
	if not (leveltime % flashDelay) then

		if colorpos1 < #colors1 then
			colorpos1 = $ + 1
		else
			colorpos1 = 1
		end
		if colors1 and colorpos1 and colors1[colorpos1] then
			flashColor1.ramp = colors1[colorpos1]
		end

		if colorpos2 <= #colors2 then
			colorpos2 = $ + 1
		else
			colorpos2 = 1
		end
		if colors2 and colorpos2 and colors2[colorpos2] then
			flashColor2.ramp = colors2[colorpos2]
		end
	end
end

addHook("ThinkFrame", HyperA)

//when you have sensitive eyes, this command allows to disable screen flashing
COM_AddCommand("hyperflash", function(player, arg)
	if arg then
		if arg == "1" or arg == "true" or arg == "on" then
			if io and player == consoleplayer then
				local file = io.openlocal("client/mrce/hyperflash.dat", "w+")
				file:write(arg)
				file:close()
			end
			player.screenflash = true
			CONS_Printf(player, "Hyper form screen flashing has been enabled.")
		elseif arg == "0" or arg == "false" or arg == "off" then
			if io and player == consoleplayer then
				local file = io.openlocal("client/mrce/hyperflash.dat", "w+")
				file:write(arg)
				file:close()
			end
			player.screenflash = false
			CONS_Printf(player, "Hyper form screen flashing has been disabled.")
		elseif player.screenflash then
			CONS_Printf(player, "hyperflash [on/off] - Toggles screen flashing caused by hyper forms. Currently on.")
		else
			CONS_Printf(player, "hyperflash [on/off] - Toggles screen flashing caused by hyper forms. Currently off.")
		end
	elseif player.screenflash then
		CONS_Printf(player, "hyperflash [on/off] - Toggles screen flashing caused by hyper forms. Currently on.")
	else
		CONS_Printf(player, "hyperflash [on/off] - Toggles screen flashing caused by hyper forms. Currently off.")
	end
end)

//handle luabanks shenanigans, also gives knux and tails super abilities
addHook("PreThinkFrame", function()
    for p in players.iterate do
        if not (p and p.mo and p.mo.valid) then continue end
		local x = p.mrce
		if x and x.hyperlast and not MRCE_isHyper(p) then
			p.powers[pw_strong] = STR_NONE
			x.hyperlast = false
		end
		if MRCE_isHyper(p) and x and x.canhyper and not x.ultrastar
		and p.playerstate != PST_DEAD then
			if p.scolor == nil or p.scolor == "default" then
				p.mo.color = SKINCOLOR_MRCEHYPER1
			end
		elseif MRCE_isHyper(p) and x and x.ultrastar and not x.canhyper
		and p.playerstate != PST_DEAD then
			if p.scolor == nil or p.scolor == "default" then
				p.mo.color = SKINCOLOR_MRCEHYPER2
			end
		end
        if not p.powers[pw_super] and p.mo.skin == "knuckles" and mrce_hyperunlocked == true then
            p.charflags = $ & ~SF_MULTIABILITY
        end
        if p.powers[pw_super] and p.mo.skin == "knuckles" and mrce_hyperunlocked == true then
            p.charflags = $1 | SF_MULTIABILITY
        end
        if p.powers[pw_super] and p.pflags & PF_THOKKED then
            local ca = p.charability
            if ca == CA_FLY or ca == CA_SWIM then
                p.powers[pw_tailsfly] = 8*TICRATE
            end
        elseif p.powers[pw_super] then
            p.powers[pw_tailsfly] = 0
        end
		if ((gamemap == 130 and (p.pflags & PF_FINISHED)) and All7Emeralds(emeralds) and mrce_hyperunlocked == false) then
			S_StartSound(null, sfx_s3k9c)
			for i = 1, 8, 1 do
				if not (GlobalBanks_Array[0] & (1 << (i - 1))) then
					GlobalBanks_Array[0] = $ | (1 << (i - 1))
				end
			end
			mrce_hyperunlocked = true
		end
		if GlobalBanks_HyperUnlocked() then
			mrce_hyperunlocked = true
			if p.hyper and not p.hyper.isunlocked then
				p.hyper.isunlocked = true
			end
			if p.yusonictable and not p.yusonictable.hyperpower and p.mo.skin == "adventuresonic" and p.mo.health then
				p.yusonictable.hyperpower = true
			end
		else
			mrce_hyperunlocked = false
		end
		if gamemap == 122 and p.pflags & PF_FINISHED then --we're in agz's warp room, and are warping to another zone
			if not (GlobalBanks_Array[0] & (1 << (26))) then
				GlobalBanks_Array[0] = $ | (1 << (26))
			end
			mrce_dowarptime = true --initialize warp memory
		end
		if (GlobalBanks_Array[0] & (1 << (26))) then
			mrce_dowarptime = true --remember warp memory on reloading the save
		else
			mrce_dowarptime = false
		end
		if gamemap == 132 then --we made it to prismatic angel
			GlobalBanks_Array[0] = $ & ~(1 << (26))
			mrce_dowarptime = false --reset the value
		end
		if ((p.pflags & PF_FINISHED) or leveltime == 3) and mrce_secondquest == true then
			GlobalBanks_Array[0] = $ | (1 << (25))
		elseif ((p.pflags & PF_FINISHED) or leveltime == 3)  and mrce_secondquest == false then
			GlobalBanks_Array[0] = $ & ~(1 << (25))
		end
		if (GlobalBanks_Array[0] & (1 << (25))) and mrce_secondquest != true then
			mrce_secondquest = true
		elseif not (GlobalBanks_Array[0] & (1 << (25))) and leveltime == 5 then
			mrce_secondquest = false
		end
		if debug == 1 then
			print("Hyperstones: " .. luabanks[3])
		end
    end
end)

addHook("PostThinkFrame", function()
	for p in players.iterate do
		if not p.realmo then continue end
		if p.spectator then continue end
		local x = p.mrce
		if MRCE_isHyper(p) and x then
			x.hyperlast = true
		else
			x.hyperlast = false
		end
		if p.mrce.speen then
			p.drawangle = p.mrce.speen
			if p.followmobj then
				p.followmobj.drawangle = p.mrce.speen
			end
		end
		if MRCE_isHyper(p) and p.mrce and p.mrce.canhyper and not p.mrce.ultrastar
		and p.playerstate != PST_DEAD then
			if p.scolor == nil or p.scolor == "default" then
				p.mo.color = SKINCOLOR_MRCEHYPER1
			end
			local ghost = P_SpawnGhostMobj(p.mo)
			ghost.fuse = 1
			if p.mrce.glowaura < 2 then
				ghost.blendmode = AST_ADD
			end
			ghost.frame = $|FF_TRANS30
			if p.fakeroll then
				ghost.rollangle = p.fakeroll
			else
				ghost.rollangle = p.mo.rollangle
			end
			ghost.color = p.mo.color
			P_MoveOrigin(ghost, p.mo.x, p.mo.y, p.mo.z)
			ghost.destscale = p.mo.scale * (3 / 2)
		elseif MRCE_isHyper(p) and p.mrce and p.mrce.ultrastar and not p.mrce.canhyper
		and p.playerstate != PST_DEAD then
			if p.scolor == nil or p.scolor == "default" then
				p.mo.color = SKINCOLOR_MRCEHYPER2
			end
		end
	end
end)

--addHook("SpinSpecial", function(player)

--here it is. our really big playerthink hook
addHook("PlayerThink", function(p)
	if p.spectator then return end
	if not p.realmo then return end
	local x = p.mrce
	if MRCE_isHyper(p)
	and p.mrce.canhyper == true
	and p.playerstate != PST_DEAD then
		if not p.mo.hyperflashcolor then
			p.mo.hyperflashcolor = 0
		end
		p.mo.hyperflashcolor = $ + 1
		if p.mo.hyperflashcolor > 59 then
			p.mo.hyperflashcolor = 1
		end
		p.powers[pw_underwater] = 0
		p.powers[pw_spacetime] = 0
		if x.floatpause then
			p.powers[pw_strong] = $|STR_ANIM|STR_ATTACK|STR_WALL|STR_FLOOR|STR_CEILING|STR_SPIKE
		else
			p.powers[pw_strong] = $|STR_ANIM|STR_ATTACK|STR_WALL|STR_CEILING|STR_SPIKE
		end
		if p.scolor == nil or p.scolor == "default" then
			p.mo.color = SKINCOLOR_MRCEHYPER1
		end
	end
	if p.mrce.ultrastar == true
	and MRCE_isHyper(p)
	and p.playerstate != PST_DEAD then
		p.powers[pw_underwater] = 0
		p.powers[pw_spacetime] = 0
		if p.scolor == nil or p.scolor == "default" then
			p.mo.color = SKINCOLOR_MRCEHYPER2
		end
	end
	if x.constext > 0 then x.constext = $ - 1 end
	--print(p.powers[pw_extralife])
	if p.pflags & PF_FINISHED and p.mrce.glowaura then
		p.powers[pw_ignorelatch] = 32768
	end

	if not P_IsObjectOnGround(p.mo) then
		x.oldz = p.mo.momz
	end
	if mrce_hyperunlocked == true and p.yusonictable and p.yusonictable.supersonic and p.mo.skin == "adventuresonic" then
		p.yusonictable.hypersonic = true
	end

	if p.mo and p.charability == 18 then
		p.spinitem = 0
	end

--post AGZ4 return warp handler
	if (gamemap == 103 or gamemap == 106 or gamemap == 109 or gamemap == 112 or gamemap == 115 or gamemap == 118)
	and mrce_dowarptime == true then
		if debug == 1 then
			print("AGZ4 go time")
		end
		G_SetCustomExitVars(122,1)
	end

--in ultimate mode, take away all rings unless in dwz
	if p.rings > 0 and ultimatemode and (mapheaderinfo[gamemap].lvlttl != "Dimension Warp") and (p.mo.skin != "supersonic") then
		p.rings = 0
	end

	x.canhyper = $ or false
	x.hyperimages = $ or false
	x.ultrastar = $ or false
	--super tails?
	if (p.mo.skin == "tails" or p.mo.skin == "amy" or p.mo.skin == "fang") and mrce_hyperunlocked == true then
		p.charflags = $1 | SF_SUPER --yes
	elseif (p.mo.skin == "tails" or p.mo.skin == "amy" or p.mo.skin == "fang") and mrce_hyperunlocked == false then
		p.charflags =  $ & ~SF_SUPER --nah
	end
	if p.powers[pw_super] and p.pflags & PF_THOKKED and p.mo.skin == "tails" then
		p.powers[pw_tailsfly] = 8*TICRATE --super tails infinite fly
	end
	if p.powers[pw_super] and p.mo.skin == "tails" then
		p.actionspd = skins[p.mo.skin].actionspd * 2
	elseif p.mo.skin == "tails" then
		p.actionspd = skins[p.mo.skin].actionspd
	end

	--hyper modern sonic's boost fly doesn't drain additional rings unlike his super
	if MRCE_isHyper(p) then
		if p.superboost == nil then
			p.superboost = false
			p.boosting = false
		end
		if p.mo.skin == "modernsonic" then
			if p.superboost == true then
				if (leveltime % 5 == 0) then
					p.rings = p.rings + 1
				end
			end
			--also nukes because why the fuck not lol
			if (p.boosting == true or p.superboost == true) and (mapheaderinfo[gamemap].lvlttl != "Dimension Warp") then
				if p.modernnuker == true then
					P_NukeEnemies(p.mo, p.mo, 600*FRACUNIT)
					if p.screenflash == true then
						P_FlashPal(p, PAL_WHITE, 7)
					end
					p.modernnuker = false
				end
			else
				p.modernnuker = true
			end
		end
	end

	--basic stat buffs for hyper form
	if MRCE_isHyper(p) then
		p.maxdash = skins[p.mo.skin].maxdash * 3 / 2
		p.jumpfactor = skins[p.mo.skin].jumpfactor * 6 / 5
		--p.supercolor = "Silver"  --doesn't actually work, the variable is read only. Maybe a request for 2.2.11?
		p.actionspd = skins[p.mo.skin].actionspd * 6 / 5
		p.mindash = skins[p.mo.skin].mindash * 5
		p.hyperstats = 1
	elseif not p.slowgooptimer then
		p.maxdash = skins[p.mo.skin].maxdash
		p.jumpfactor = skins[p.mo.skin].jumpfactor
		--p.supercolor = "Gold"
		p.actionspd = skins[p.mo.skin].actionspd
		p.mindash = skins[p.mo.skin].mindash
		p.hyperstats = 0
	end

--reset hyper values if the player changes skin
	if p.skincheck != p.mo.skin then
		x.canhyper = false
		x.ultrastar = false
		x.hyperimages = false
		p.skincheck = p.mo.skin
	end
	if x.exspark != false and p.playerstate != PST_DEAD and not (p.exiting and gamemap == 121 and not netgame) then
		if not MRCE_isHyper(p) then
			MRCE_superSpark(p.mo, 1, 8, 1, 5*FRACUNIT, false, x.exsparkcolor)
		end
	end
--give the player rings if they break a invinc monitor while super. Make lemonade out of lemons.
	if p.powers[pw_super] and p.powers[pw_invulnerability] and p.mo.skin != "supersonic" then
		P_GivePlayerRings(p, 20)
		S_StartSound(null, sfx_itemup)
		p.powers[pw_invulnerability] = 0
	end

	if x.ultrastar == true and p.scoreadd < 4 and MRCE_isHyper(p) then
		p.scoreadd = 4
	elseif P_IsObjectOnGround(p.mo) and p.powers[pw_invulnerability] == 0 then
		p.scoreadd = 0
	end

--spawn the hyper sparkles
	if p and p.valid and p.mo and p.mo.valid
	and p.playerstate != PST_DEAD
	and MRCE_isHyper(p) then
		if p.mo.state == S_PLAY_SUPER_TRANS3 then
			S_StartSound(p.mo,sfx_s3k9f)
		elseif p.mo.state == S_PLAY_SUPER_TRANS5 then
			S_StartSound(p.mo,sfx_bkpoof)
			P_NukeEnemies(p.mo, p.mo, 900*FRACUNIT)
			if p.screenflash then
				P_FlashPal(p, PAL_WHITE, 7)
			end
		elseif not (p.mo.state >= S_PLAY_SUPER_TRANS1 and p.mo.state <= S_PLAY_SUPER_TRANS5) then
			MRCE_superSpark(p.mo, 1, 16, 1, 6*FRACUNIT, true, nil)
		end
	end

--compatibility checks, allowing custom characters to have hyper forms
	if p.mo and (p.mo.skin == "hms123311" or p.mo.skin == "fhms123311") then
		if x.canhyper != nil then
			x.canhyper = true
			x.hyperimages = true
		end
		if mrce_hyperunlocked == true then
			p.pflags = $|PF_GODMODE
		else
			p.pflags = $ & ~PF_GODMODE
		end
	end
	local forwardmove = p.cmd.forwardmove
	--print("FUCK")
	if (p.mo.skin == "mario" or p.mo.skin == "luigi")
	and MRCE_isHyper(p) then
		if p.mariocapeflight != 0 and not P_IsObjectOnGround(p.mo) then
			if forwardmove <= -35 then
				p.mo.momz = -50*P_GetMobjGravity(p.mo)
				if p.startultrafly == true then
					S_StartSound(p.mo, sfx_mrfly)
					p.startultrafly = false
				end
			else p.startultrafly = true
			end
		end
		if p.mariogroundpound and  P_IsObjectOnGround(p.mo) and p.startpoundnuke == true then
			P_NukeEnemies(p.mo, p.mo, 900*FRACUNIT)
			p.startpoundnuke = false
			if p.screenflash == true then
				P_FlashPal(p, PAL_WHITE, 7)
			end
		elseif not P_IsObjectOnGround(p.mo) then
				p.startpoundnuke = true
		end
	end

	if p.mo.skin == "jana" and MRCE_isHyper(p) then
		if p.jana.rockin and p.mo.frame & FF_FRAMEMASK == B then
			P_Earthquake(p.mo, p.mo, 600*FRACUNIT)
		end
	end

	if p.mo .skin == "tails"
	or p.mo.skin == "fang"
	or p.mo.skin == "amy"
	or p.mo.skin == "mcsonic"
	or p.mo.skin == "crystalsonic"
	or p.mo.skin == "altsonic"
	or p.mo.skin == "supersonic" then
		x.hyperimages = false
		x.canhyper = false
		x.ultrastar = false
	end
	if p.mo.skin == "modernsonic"
	or p.mo.skin == "HMS123311"
	or p.mo.skin == "fhms123311"
	or p.mo.skin == "dirk"
	or p.mo.skin == "yoshi"
	or p.mo.skin == "sonic"
	or p.mo.skin == "pointy"
	or p.mo.skin == "shadow"
	or p.mo.skin == "flame"
	or p.mo.skin == "juniosonic"
	or p.mo.skin == "bandages"
	or p.mo.skin == "bean"
	or p.mo.skin == "greeneyesonic"
	or p.mo.skin == "cdsonic"
	or p.mo.skin == "xtreme"
	or p.mo.skin == "extralife"
	or p.mo.skin == "whisper" then
		x.hyperimages = true
		x.canhyper = true
		x.ultrastar = false
	end
	if p.mo.skin == "metalsonic"
	or p.mo.skin == "knuckles" then
		x.hyperimages = true
		x.ultrastar = false
		x.canhyper = false
	end
	if p.mo.skin == "mario"
	or p.mo.skin == "luigi"
	or p.mo.skin == "surge"
	or p.mo.skin == "skip"
	or p.mo.skin == "willow"
	or p.mo.skin == "silver" then
		x.ultrastar = true
		x.hyperimages = false
		x.canhyper = false
	end
	if p.mo.skin == "jana"
	or p.mo.skin == "eggman"
	or p.mo.skin == "gemma"
	or p.mo.skin == "kiryu" then
		x.ultrastar = true
		x.hyperimages = true
		x.canhyper = false
	end
	if p.mo.hyperflashcolor == nil then
		 p.mo.hyperflashcolor = 1
	 end

	if MRCE_isHyper(p) then
		if p.mo.skin == "skip" --SKIP BOOM
		or p.mo.skin == "nasya" then
			p.mysticsuper = true
		end
	else
		if p.mo.skin == "skip"
		or p.mo.skin == "nasya" then
			p.mysticsuper = false
		end
	end
	if not P_IsObjectOnGround(p.mo)
	and p.mo.skin == "skip" and MRCE_isHyper(p) then
		//Hyper float
		if p.cmd.buttons & BT_JUMP
		and p.pflags & PF_JUMPED
		and not (p.pflags & (PF_SPINNING | PF_SHIELDABILITY))
		and not p.climbing and p.secondjump != 255
		and p.mo.momz*P_MobjFlip(p.mo) < 0 then
			if p.mrce.realspeed < 5*p.mo.scale then
				P_SetObjectMomZ(p.mo, -3*FRACUNIT)
			end
			p.pflags = $ &~ PF_STARTJUMP | PF_NOJUMPDAMAGE
		end
	end
	if p.mo.skin == "shadow" and MRCE_isHyper(p) then
		if p.shadow and p.shadow.flags & SHF_SPEARCHARGE then
			p.momz = 0
		end
	end
--blendmode secret
	if x.glowaura == 1 then
		p.mo.blendmode = AST_ADD
		p.mo.colorized = true
	elseif x.glowaura == 2 then
		p.mo.blendmode = AST_SUBTRACT
		p.mo.colorized = true
	end

	if p.followmobj and p.mrce.glowaura then
		p.followmobj.blendmode = p.mo.blendmode
		p.followmobj.colorized = p.mo.colorized
	end

	if p.pet and p.mo.pet and p.mo.pet.valid then
		p.mo.pet.blendmode = p.mo.blendmode
		if not (p.mo.pet.color == SKINCOLOR_NONE) then
			p.mo.pet.colorized = p.mo.colorized
		end
	end

	if p.buddies then
		for id,buddy in pairs(p.buddies) do
			if buddy.mo and buddy.mo.valid then
				buddy.mo.blendmode = p.mo.blendmode
				buddy.mo.colorized = p.mo.colorized
			end
		end
	end
--hyper related cheat code handling
	if x.hypercheat == true then
		if not All7Emeralds(emeralds) and not netgame then
			emeralds = 127
		end
		if p.hyper and not p.hyper.isunlocked then
			p.hyper.isunlocked = true
		end
		if p.yusonictable and p.yusonictable.hyperpower and p.mo.skin == "adventuresonic" then
			p.yusonictable.hyperpower = true
		end
		if modifiedgame == false and not netgame
		and not marathonmode and not modeattacking
		and x.forcehyper == 0 then
			COM_BufInsertText(p, "devmode 1")
			COM_BufInsertText(p, "devmode 0")
		end
	end

	if p.mo.skin == "supersonic" and (p.powers[pw_shield] & SH_FIREFLOWER)
	and p.stomping == true then
		P_SetObjectMomZ(p.mo, -80*FRACUNIT*P_MobjFlip(p.mo) + (p.mo.momz/5))
	end

--hyper after images
	if ((p.mrce.realspeed >= 8*FRACUNIT or p.mo.momz >= 3*FRACUNIT or p.mo.momz <= -3*FRACUNIT) and x.hyperimages == true) --does our character support hyper afterimages?
	and MRCE_isHyper(p)
	and not p.mo.state == ((p.mo.state == S_PLAY_SUPER_TRANS1) or (p.mo.state == S_PLAY_SUPER_TRANS2) or (p.mo.state == S_PLAY_SUPER_TRANS3) or (p.mo.state == S_PLAY_SUPER_TRANS4) or (p.mo.state == S_PLAY_SUPER_TRANS5) or (p.mo.state == S_PLAY_SUPER_TRANS6))
	and p.playerstate != PST_DEAD then
		local ghostpos = 1
		local AfterImageSpawn = P_SpawnGhostMobj(p.mo)
		AfterImageSpawn.colorized = true
		AfterImageSpawn.fuse = 5
		AfterImageSpawn.destscale = $ * (5/4)
		AfterImageSpawn.frame = $|FF_TRANS20
		if p.mrce.glowaura < 2 then
			AfterImageSpawn.blendmode = AST_ADD
		end

		AfterImageSpawn.rollangle = p.mo.rollangle

		if p.mo.hyperflashcolor < 5
		or p.mo.hyperflashcolor == 69 then
			AfterImageSpawn.color = SKINCOLOR_BLANK
		end

		if p.mo.hyperflashcolor > 4
		and p.mo.hyperflashcolor < 7 then
			AfterImageSpawn.color = SKINCOLOR_SUPERSAPPHIRE1
		end

		if p.mo.hyperflashcolor > 6
		and p.mo.hyperflashcolor < 9 then
		AfterImageSpawn.color = SKINCOLOR_SUPERSAPPHIRE2
		end

		if p.mo.hyperflashcolor > 8
		and p.mo.hyperflashcolor < 11 then
			AfterImageSpawn.color = SKINCOLOR_SUPERSAPPHIRE1
		end

		if p.mo.hyperflashcolor > 10
		and p.mo.hyperflashcolor < 13 then
			AfterImageSpawn.color = SKINCOLOR_BLANK
		end

		if p.mo.hyperflashcolor > 12
		and p.mo.hyperflashcolor < 15 then
			AfterImageSpawn.color = SKINCOLOR_SUPERBUBBLEGUM1
		end

		if p.mo.hyperflashcolor > 14
		and p.mo.hyperflashcolor < 17 then
			AfterImageSpawn.color = SKINCOLOR_SUPERBUBBLEGUM2
		end

		if p.mo.hyperflashcolor > 16
		and p.mo.hyperflashcolor < 19 then
			AfterImageSpawn.color = SKINCOLOR_SUPERBUBBLEGUM1
		end

		if p.mo.hyperflashcolor > 18
		and p.mo.hyperflashcolor < 21 then
			AfterImageSpawn.color = SKINCOLOR_BLANK
		end

		if p.mo.hyperflashcolor > 20
		and p.mo.hyperflashcolor < 23 then
			AfterImageSpawn.color = SKINCOLOR_SUPERMINT1
		end

		if p.mo.hyperflashcolor > 22
		and p.mo.hyperflashcolor < 25 then
			AfterImageSpawn.color = SKINCOLOR_SUPERMINT2
		end

		if p.mo.hyperflashcolor > 24
		and p.mo.hyperflashcolor < 27 then
			AfterImageSpawn.color = SKINCOLOR_SUPERMINT1
		end

		if p.mo.hyperflashcolor > 26
		and p.mo.hyperflashcolor < 29 then
			AfterImageSpawn.color = SKINCOLOR_BLANK
		end

		if p.mo.hyperflashcolor > 28
		and p.mo.hyperflashcolor < 31 then
			AfterImageSpawn.color = SKINCOLOR_SUPERRUBY1
		end

		if p.mo.hyperflashcolor > 30
		and p.mo.hyperflashcolor < 33 then
			AfterImageSpawn.color = SKINCOLOR_SUPERRUBY2
		end

		if p.mo.hyperflashcolor > 32
		and p.mo.hyperflashcolor < 35 then
			AfterImageSpawn.color = SKINCOLOR_SUPERRUBY1
		end

		if p.mo.hyperflashcolor > 34
		and p.mo.hyperflashcolor < 37 then
			AfterImageSpawn.color = SKINCOLOR_BLANK
		end

		if p.mo.hyperflashcolor > 36
		and p.mo.hyperflashcolor < 39 then
			AfterImageSpawn.color = SKINCOLOR_SUPERWAVE1
		end

		if p.mo.hyperflashcolor > 38
		and p.mo.hyperflashcolor < 41 then
			AfterImageSpawn.color = SKINCOLOR_SUPERWAVE2
		end

		if p.mo.hyperflashcolor > 40
		and p.mo.hyperflashcolor < 43 then
			AfterImageSpawn.color = SKINCOLOR_SUPERWAVE1
		end

		if p.mo.hyperflashcolor > 42
		and p.mo.hyperflashcolor < 45 then
			AfterImageSpawn.color = SKINCOLOR_BLANK
		end

		if p.mo.hyperflashcolor > 44
		and p.mo.hyperflashcolor < 47 then
			AfterImageSpawn.color = SKINCOLOR_SUPERCOPPER1
		end

		if p.mo.hyperflashcolor > 46
		and p.mo.hyperflashcolor < 49 then
			AfterImageSpawn.color = SKINCOLOR_SUPERCOPPER2
		end

		if p.mo.hyperflashcolor > 48
		and p.mo.hyperflashcolor < 51 then
			AfterImageSpawn.color = SKINCOLOR_SUPERCOPPER1
		end

		if p.mo.hyperflashcolor > 50
		and p.mo.hyperflashcolor < 53 then
			AfterImageSpawn.color = SKINCOLOR_BLANK
		end

		if p.mo.hyperflashcolor > 52
		and p.mo.hyperflashcolor < 55 then
			AfterImageSpawn.color = SKINCOLOR_SUPERAETHER1
		end

		if p.mo.hyperflashcolor > 54
		and p.mo.hyperflashcolor < 57 then
			AfterImageSpawn.color = SKINCOLOR_SUPERAETHER2
		end

		if p.mo.hyperflashcolor > 56
		and p.mo.hyperflashcolor < 59 then
			AfterImageSpawn.color = SKINCOLOR_SUPERAETHER1
		end
		if not camera.chase then
			AfterImageSpawn.flags2 = $|MF2_DONTDRAW
		end
	end
end)

addHook("PlayerCanDamage", function(player, mobj) --hyper forms can pop monitors by just walking into them
	if (MRCE_isHyper(player)) or (player.yusonictable and player.yusonictable.hypersonic and player.mo.skin == "adventuresonic") or (player.hyper and player.hyper.transformed) then
		return true
	end
end)

//Super sparkles


states[S_SUPERSPARK] = {
       sprite = SPR_SUSK,
	   frame = FF_FULLBRIGHT|FF_ANIMATE|A,
	   var1 = 4,
	   var2 = 3
}
mobjinfo[MT_SUPERSPARKLES] = {
         spawnstate = S_SUPERSPARK,
         flags = MF_NOCLIP|MF_SCENERY|MF_NOGRAVITY|MF_NOCLIPHEIGHT,
}

-- eh why not this has no where else to go.
--Triggers an event if you're SA-Sonic.

local function YuHyperMemories(line, so)
	if so and so.valid and so.player and so.player.yusonictable and not so.player.yusonictable.hyperpower and so.skin == "adventuresonic" and so.health then
		S_StartSound(so, sfx_s3k7d)
		S_StartSound(so, sfx_s3kcel)
		so.player.yusonictable.hypermemories = 220
		so.player.yusonictable.superflash = 9*FRACUNIT
		so.player.yusonictable.hyperpower = true
		return false
	end
end
addHook("LinedefExecute", YuHyperMemories, "YUMEMO")
