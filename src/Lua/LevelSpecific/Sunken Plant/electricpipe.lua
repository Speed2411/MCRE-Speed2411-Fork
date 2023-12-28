/*
	Electric pipe gimmick

	(C) 2022 by AshiFolfi
	(C) 2023 by Xian
*/


freeslot("SKINCOLOR_ELECPIPE", "MT_ELECPIPE_MAN", "MT_SPECCY")

skincolors[SKINCOLOR_ELECPIPE] = {
	name = "Electric Pipe Effect",
	ramp = {255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255},
	accessible = false
}

mobjinfo[MT_ELECPIPE_MAN] = {
//$Name Electric Pipe Teleport Start
//$Sprite KYSTA0
//$Category Mystic Realm Special
//$NotAngled
	doomednum = 2219,
	spawnstate = S_INVISIBLE,
	radius = 12*FRACUNIT,
	height = 24*FRACUNIT,
	flags = MF_NOGRAVITY
}
-- Electric pipe effect
---@param line line_t
---@param trigmob mobj_t
---@param sector sector_t
local function sp_elecpipe_start(line , trigmob, sector)
	if not (trigmob and trigmob.valid) then return end

	if trigmob.epipe_ticker == nil then
		trigmob.epipe_ticker = 0
	end
	trigmob.momx = 0
	trigmob.momy = 0
	trigmob.momz = 0

	local tpman
	local xa, ya, za
	for mo in sector.thinglist() do
		if mo.type == MT_ELECPIPE_MAN then
			tpman = mo
			xa, ya, za = mo.x, mo.y, mo.z
		end
	end
	if tpman then
		local dist = R_PointToDist2(trigmob.x, trigmob.y, xa, ya)
		if dist > (1 * FRACUNIT) then
			P_InstaThrust(trigmob, R_PointToAngle2(trigmob.x, trigmob.y, xa, ya), max(dist / 8, 0))
		end
	end

	trigmob.epipecolor = SKINCOLOR_ELECPIPE

	if (trigmob.epipe_ticker >= 35) then
		local x = line.frontside.textureoffset
		local y = line.frontside.rowoffset
		local z = line.frontsector.floorheight
		--print(x .. " " .. y .. " " .. z)
		P_SetOrigin(trigmob, x, y, z+trigmob.height)
	end

	if (trigmob.epipe_ticker >= 15)
	and trigmob.spritexscale > 0
	and trigmob.spriteyscale > 0 then
		-- Change the sprite scale
		-- shrink x scale
		trigmob.spritexscale = max($ - (FRACUNIT/12), 0)

		-- shrink y scale slower than x
		trigmob.spriteyscale = max($ - (FRACUNIT/24), 0)
	end

	-- stop all momentum

	-- Check if it's a player
	if (trigmob.player) then
		-- Transition into spin state
			trigmob.state = S_PLAY_ROLL --keydown is a bad idea here bc we don't want to desync. instead we'll handle it below
			trigmob.player.powers[pw_nocontrol] = 2

		-- increment the ticker
	end
	--print(trigmob.epipe_ticker)
	trigmob.epipe_ticker = $ + 1
end
addHook("LinedefExecute", sp_elecpipe_start, "SP_EPSTART")

-- Electric pipe effect
---@param line nil
---@param mobj mobj_t
---@param sector nil
local function sp_elecpipe_end(line, mobj, sector)
	if not (mobj and mobj.valid) then return end

	if mobj.epipe_ticker == nil then
		mobj.epipe_ticker = 0
	end
	if (mobj.epipe_ticker < 75)
	and (mobj.epipe_ticker != 0) then
		-- Change the sprite scale
		if not(mobj.spritexscale == FRACUNIT) then
			mobj.spritexscale = min($ + (FRACUNIT/12), FRACUNIT)
		end

		if not(mobj.spriteyscale == FRACUNIT) then
			mobj.spriteyscale = min($ + (FRACUNIT/24), FRACUNIT)
		end

		mobj.epipe_ticker = $ + 1
		mobj.momx = 0
		mobj.momy = 0
		mobj.momz = 0
		--print(mobj.epipe_ticker)
	else
		mobj.epipe_ticker = 0
		mobj.epipecolor = nil
		if not (mobj.player and mobj.player.mrce.glowaura) then
			mobj.colorized = false
		end
		if mobj.color then
			mobj.color = mobj.epipe_prevcolor
		end
	end
end
addHook("LinedefExecute", sp_elecpipe_end, "SP_EPEND")

local function sp_elecpipe_colorflash(mo)
	if not (mo and mo.valid) then return end
	if not mo.epipecolor then return end
	if mo.player then
		mo.epipe_prevcolor = mo.player.skincolor
	elseif mo.color then
		mo.epipe_prevcolor = mo.color
	end
	if not (leveltime % 3) then
		mo.colorized = true
		mo.color = mo.epipecolor
	else
		mo.color = mo.epipe_prevcolor
		if not (mo.player and mo.player.mrce.glowaura) then
			mo.colorized = false
		end
	end
end

addHook("MobjThinker", sp_elecpipe_colorflash, MT_GARGOYLE)
addHook("MobjThinker", sp_elecpipe_colorflash, MT_BIGGARGOYLE)
addHook("MobjThinker", sp_elecpipe_colorflash, MT_TNTBARREL)
addHook("MobjThinker", sp_elecpipe_colorflash, MT_PLAYER)
addHook("MobjThinker", sp_elecpipe_colorflash, MT_SPECCY)

addHook("KeyDown", function(key)
	if not (displayplayer and displayplayer.mo and displayplayer.mo.valid) then return end
	if not (displayplayer.mo.epipe_ticker and displayplayer.mo.epipe_ticker > 0) then return end

	for i=1,2 do
		if (key.num == ctrl_inputs.up[i]) or (key.num == ctrl_inputs.down[i])
		or (key.num == ctrl_inputs.left[i]) or (key.num == ctrl_inputs.right[i])
		or (key.num == ctrl_inputs.jmp[i]) or (key.num == ctrl_inputs.spn[i])
		or (key.num == ctrl_inputs.cb1[i]) or (key.num == ctrl_inputs.cb2[i])
		or (key.num == ctrl_inputs.cb3[i]) then
			return true
		end
	end
end)