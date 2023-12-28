//here we prevent the player from breaking the mod in an unsupported version and then complain to me that it doesn't work
//yes I very well know it breaks in v2.2.4 stop pinging me
//no I'm not backporting it
local msg = "No Way? No Way!\\SRB2 version 2.2.12 or higher is required\\but was not found. Load halted.\\Please close the game and update\\to the latest version of srb2."
local warpdelay = 0
addHook("ThinkFrame", function()
	if (gamestate == GS_TITLESCREEN or gamemap != 99)
	and warpdelay == 0 then
		COM_BufInsertText(server, "map 99 -force")
		warpdelay = 10
	end
	if warpdelay > 0 then
		warpdelay = $ - 1
	end
	if gamemap == 99 then
		S_ChangeMusic("NOWAY")
		hud.disable("lives")
		hud.disable("score")
		hud.disable("rings")
		hud.disable("time")
		if leveltime == 8 then
			COM_BufInsertText(server, "cechoduration 500")
			COM_BufInsertText(server, "cecho " .. msg)
		end
		if leveltime == 700 then
			COM_BufInsertText(server, "quit")
		end
	end
end)

addHook("PlayerThink", function(player)
	if gamemap == 99 then
		player.momx = 0
		player.momy = 0
		player.momz = 0
		player.mo.flags2 = $|MF2_DONTDRAW
	end
end)