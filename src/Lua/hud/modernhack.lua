--[[
	Hacky hud thing because modern sonic is annoying

	whenever you have modern sonic loaded no matter what
	if you're not playing as him he will forcefully enable
	the vanilla hud.

	super annoying.

	our solution? shove the vanilla hud far off screen while
	the mrce hud is active lmao.

	it was super annoying to write and is super hacky but it does
	the job and that's all that matters!
]]


local original_info = {
	[HUD_LIVES] 		= {x = 16 , y = 176},

	[HUD_SCORE] 		= {x = 16 , y = 10 },
	[HUD_SCORENUM]		= {x = 120, y = 10 },

	[HUD_TIME] 			= {x = 16 , y = 26 },
	[HUD_MINUTES] 		= {x = 72 , y = 26 },
	[HUD_TIMECOLON] 	= {x = 72 , y = 26 },
	[HUD_SECONDS] 		= {x = 96 , y = 26 },
	[HUD_TIMETICCOLON] 	= {x = 96 , y = 26 },
	[HUD_TICS] 			= {x = 120, y = 26 },

	[HUD_RINGS] 		= {x = 16 , y = 42 },
	[HUD_RINGSNUM] 		= {x = 96 , y = 42 },
	[HUD_RINGSNUMTICS]  = {x = 120, y = 42 },
}

local function badmodern(v, p)
	-- if a modern specific state is detected (modern is loaded)
	if rawget(_G, "S_PLAY_MODERNGRIND") != nil then
		-- if the mrce hud is active
		-- and you are playing as modern with the srb2 hud
		-- or you aren't modern at all
		if p.mrce != nil and p.mrce.hud == 1 
		and ((p.mo.skin == "modernsonic" and p.hudstyle == "srb2") 
			or (p.mo.skin != "modernsonic")) then
			-- put it somewhere else!

			for key,_ in pairs(original_info) do
				hudinfo[key].x = -900
				hudinfo[key].y = -900
			end
		else
			for key,_ in pairs(original_info) do
				hudinfo[key].x = original_info[key].x
				hudinfo[key].y = original_info[key].y
			end
		end
	end
end
hud.add(badmodern)