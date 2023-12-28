-- Randomize titlemap sky, a small detail that I thought would be neat.

addHook("MapLoad", function(mapnum)
	if (mapnum == 784) then -- MAPT0, remember to change this if we change the titlemap!!
		local titleSkies = { -- in order of emeralds
			9,     -- blue
			5005,  -- purple
			5004,  -- green
			499,   -- red
			5007,  -- light blue
			5008,  -- yellow
			5009   -- gray
		}

		-- Randomness is surprisingly REALLY fucking consistent,
		-- so we're going to steal a value that changes often.
		-- This way we can (kinda) randomize RNG without even
		-- playing the game. How professional of me.
		-- stjr pls fix
		--P_RandomKey(collectgarbage("count"))
		
		--xian here, v2.2.12 adds lua access to system time, so we'll use that to seed rng instead. still, gotta say, that was pretty neat usage of an otherwise useless function (in the case of srb2 at least)
		
		
		local ctime = os.date("*t")
		local st = max((os.time(ctime) % FRACUNIT), 3)
		--print(modifiedgame)
		P_RandomKey(st)

		P_SetupLevelSky(titleSkies[P_RandomKey(#titleSkies)+1], consoleplayer)
	end
end)