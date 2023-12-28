--Convenient function to see if we're a custom character, and also doubles as a global Lua toggle.
--Put this check in at the start of every player-affecting Lua script.
--This'll drastically increase compatibility with custom characters and physics, and allow "vanilla" gameplay if desired.

--Simple toggle to turn off Mystic Realm physics at player discretion.

local guessilldoitmyself = {
	"adventuresonic",
	"inazuma",
	"aether"
}

COM_AddCommand("nomrphysics", function(p)
	if (gamestate == GS_LEVEL) and p.valid and p.mrce then
		if p.mrce.dontwantphysics == false then
			p.mrce.dontwantphysics = true
			p.mrce.physics = false
			CONS_Printf(p, "\x83" .. "You've opted out of Mystic Realm's custom Lua behaviour")
		else
			p.mrce.dontwantphysics = false
			p.mrce.physics = true
			CONS_Printf(p, "\x83" .. "You've opted back into Mystic Realm's custom Lua behaviour")
		end
	end
end)

rawset(_G, "IsCustomSkin", function(player)
	if player.mrce and player.mrce.customskin or player.mrce.dontwantphysics then --Either the custom character or the player has opted out of custom stuff!
		player.mrce.physics = false
		return true
	elseif player.mrce then
		player.mrce.physics = true
		return false
	end
	for k, v in pairs(guessilldoitmyself) do
		if player.mo.skin == v then
			return true
		end
	end
end)

--Use it like this at the beginning of each script and we now no longer screw up custom characters, physics mods, etc.
 /*
	if IsCustomSkin(player)
		return
	end
	*/

local function honeycheck(p) -- this makes the if statement for "should we let them jump" into a function for ease of edit
	--local canceljump = false
	if p.honey then
		if p.mo.state == S_PLAY_HONEYBACKFLIP or p.mo.state == S_PLAY_HONEYMELEE1 or p.mo.state == S_PLAY_HONEYMELEE2 then
			return true
		end
	end

	return false
end

local function PreThinkJump(player)
	P_DoJump(player, true);

	-- Prevent using abilities immediately, by removing jump inputs.
	player.cmd.buttons = $1 & ~BT_JUMP;
	player.pflags = $1 | (PF_JUMPDOWN|PF_JUMPSTASIS);
end

local function RestoreAbility(player)
	player.secondjump = 0;
	player.pflags = $1 & ~PF_THOKKED;
end

local function RemoveAbility(player)
	player.secondjump = UINT8_MAX;
	player.pflags = $1 | PF_THOKKED;
end

local function RecoveryThink(player, mo, pressedJump, latency)
	mo.coyoteTime = 0; -- Reset coyote time
	mo.recoveryWait = $1 + 1; -- Increment recovery wait time.

	-- The recovery jump from SA2, where you can jump out of your pain state.
	if (pressedJump == true) then
		local painThrust = 69*FRACUNIT/10;
		local baseGravity = max(1, abs(P_GetMobjGravity(mo)));
		local painTime = FixedFloor(FixedDiv(painThrust, baseGravity)) >> FRACBITS;

		local baseRecoveryWait = (painTime * 2); -- Double the length of your pain state, - your latency.

		if (mo.recoveryWait > baseRecoveryWait - latency) then
			PreThinkJump(player);

			--[[
			RemoveAbility(player);

			-- Reset momentum so you can move a bit.
			player.mo.momx = 0;
			player.mo.momy = 0;
			--]]

			RestoreAbility(player);
		end
	end
end

local function CoyoteThink(player, mo, pressedJump, latency)
	-- "Coyote time" is how much time you have after leaving the ground where you can jump off.
	-- Many modern platformers do this, especially 3D.
	-- Prevents lots of "the jump didn't jump".
	local baseCoyoteTime = TICRATE/4; -- 0.25 seconds, + your latency.

	-- Check if you're in a state where you would normally be allowed to jump.
	local canJump = false;
	if ((P_IsObjectOnGround(mo) == true) or (P_InQuicksand(mo) == true))
	and (player.powers[pw_carry] == CR_NONE) then
		canJump = true;
	end

	if (player.pflags & PF_JUMPED) or (player.powers[pw_justsprung]) or honeycheck(player) then
		-- We jumped. We should not have coyote time.
		mo.coyoteTime = 0;
	elseif (canJump == true) then
		-- Set the coyote time while in a state where you can jump.
		mo.coyoteTime = baseCoyoteTime + latency;
	else
		if (pressedJump == true) and (mo.coyoteTime > 0) then
			-- Pressed jump in a state where you can't jump,
			-- but you have coyote time. So we'll give you a jump anyway!
			PreThinkJump(player);
			RestoreAbility(player);
			mo.coyoteTime = 0;
		end

		if (mo.coyoteTime > 0) then
			-- Reduce coyote timer while in a state where you can't jump.
			mo.coyoteTime = $1 - 1;
		end
	end
end

local function JumpLeniencyThink(player)
	if player.mo.skin == "adventuresonic" or player.mrce and player.mrce.physics == false then
		return
	end
	if not (player.mo and player.mo.valid) then
		return;
	end
	local mo = player.mo;

	if (player.playerstate != PST_LIVE) then
		return;
	end

	local latency = player.cmd.latency;

	-- Init variables
	if (mo.coyoteTime == nil) then
		mo.coyoteTime = 0;
	end

	if (mo.recoveryWait == nil) then
		mo.recoveryWait = 0;
	end

	if (player.exiting)
	or (player.pflags & PF_JUMPSTASIS)
	or ((player.powers[pw_nocontrol] > 0) and not (player.powers[pw_nocontrol] & (1<<15))) then
		-- Can't control anyway.
		return;
	end

	local pressedJump = false;
	if (player.cmd.buttons & BT_JUMP) and not (player.pflags & PF_JUMPDOWN) then
		pressedJump = true;
	end

	if (P_PlayerInPain(player) == true) then
		RecoveryThink(player, mo, pressedJump, latency);
		return;
	else
		-- Reset recovery wait time outside of pain state.
		mo.recoveryWait = 0;
	end

	CoyoteThink(player, mo, pressedJump, latency);
end

addHook("PreThinkFrame", function()
	if (mapheaderinfo[gamemap].jumpleniency) then
		-- Don't run more than once on maps that have their own (SUGOI)
		return;
	end

	for player in players.iterate do
		JumpLeniencyThink(player);
	end
end);
