//cheat codes. they're mostly here for debug purposes, but they're fun to mess with, so I'll likely be keeping them here.
//currently only 2 cheats are present; hyper cheat, which gives all 7 emeralds and unlocks hyper form,
//and fly cheat, which allows super sonic to fly outside of dwz
//update, glow aura adds blendmode aura to sonic's rebound dash , jump ball, spindash, and roll. Was maybe thinking as a 100% complete reward, until then, it's an easter egg

local function sp()
	if multiplayer then return false end
	if marathonmode then return false end
	if modeattacking then return false end
	if ultimatemode then return false end
	if not gamecomplete then return false end
	return true
end

COM_AddCommand("mrsecret", function(player, arg1, arg2)
	if (gamestate == GS_LEVEL) and player.valid then
		if arg1 and arg1 == "4126" then
			if not netgame then
				if not usedCheats then
					G_SetUsedCheats(false)
				end
				player.mrce.hypercheat = true
			else
				print(player.name .. " is a sussy baka")
				P_DamageMobj(player.mo,nil,nil,1,DMG_INSTAKILL)
			end
		elseif arg1 == "20071101" then
			player.mrce.flycheat = true
		elseif arg1 and arg1 == "radical" then
			if not player.mrce.snowboard then
				player.mrce.snowboard = true
			else
				player.mrce.snowboard = false
			end
		elseif arg1 and arg1 == "697842" then
			if not netgame
			or ((player == server) or IsPlayerAdmin(player)) then
				if mrce_hyperstones > 0 and arg2 and arg2 == "-reset" then
					mrce_hyperstones = 0
					CONS_Printf(player, "\131Elemental Key Shards have been returned to their resting places in the temples")
				elseif mrce_hyperstones == 0 and arg2 and arg2 == "-reset" then
					CONS_Printf(player, "\133You don't have any doofus")
				elseif mrce_hyperstones != 7 then
					if not usedCheats then
						G_SetUsedCheats(false)
					end
					mrce_hyperstones = 7
					CONS_Printf(player, "\131Received all 3 Elemental Key Shards")
				else
					CONS_Printf(player, "\133You already have all 3. Try adding '-reset' if you want to get rid of them")
				end
			end
		elseif arg1 and (arg1 == "0" or arg1 == "off") then
			player.mrce.flycheat = false
			player.mrce.hypercheat = false
			player.mrce.exspark = false
			player.mrce.glowaura = 0
			if player.pet then
				player.mo.pet.blendmode = 0
				player.mo.pet.colorized = false
			end
			if player.followmobj then
				player.followmobj.blendmode = 0
				player.followmobj.colorized = false
			end
			if player.buddies then
				for id,buddy in pairs(player.buddies) do
					if buddy.mo and buddy.mo.valid then
						buddy.mo.blendmode = 0
						buddy.mo.colorized = false
					end
				end
			end
		elseif arg1 == "20100523" then
			if player.mrce.exspark then
				player.mrce.exspark = false
			else
				player.mrce.exspark = true
				if arg2 and R_GetColorByName(arg2) then
					player.mrce.exsparkcolor = R_GetColorByName(arg2)
				else
					player.mrce.exsparkcolor = player.mo.color
				end
			end
		elseif player.mrce.exspark == true and arg1 and (arg1 == "sparkcolor" or arg1 == "66279") and arg2 and R_GetColorByName(arg2) then
			player.mrce.exsparkcolor = R_GetColorByName(arg2)
		elseif arg1 == "1207" or arg1 == "glow" then
			if player.mrce.glowaura > 0 and not arg2 then
				player.mrce.glowaura = 0
				player.mo.colorized = false
				player.mo.blendmode = 0
				if player.pet then
					player.mo.pet.blendmode = 0
					player.mo.pet.colorized = false
				end
				if player.followmobj then
					player.followmobj.blendmode = 0
					player.followmobj.colorized = false
				end
				if player.buddies then
					for id,buddy in pairs(player.buddies) do
						if buddy.mo and buddy.mo.valid then
							buddy.mo.blendmode = 0
							buddy.mo.colorized = false
						end
					end
				end
			else
				if player.spinitem == MT_THOK then
					player.spinitem = 0
				end
				if not arg2
				or arg2 == "1" or arg2 == "add" then
					player.mrce.glowaura = 1
					if player.pet then
						player.mo.pet.blendmode = AST_ADD
						if not (player.mo.pet.color == SKINCOLOR_NONE) then
							player.mo.pet.colorized = true
						end
					end
				elseif arg2 and (arg2 == "2" or arg2 == "subtract") then
					player.mrce.glowaura = 2
					if player.pet then
						player.mo.pet.blendmode = AST_SUBTRACT
						if not (player.mo.pet.color == SKINCOLOR_NONE) then
							player.mo.pet.colorized = true
						end
					end
				end
			end
		elseif arg1 == "juicemeup" then
			if not sp() then
				CONS_Printf(player, "\133Beat the game first")
			elseif arg2 then
				if arg2 == "flame" or arg2 == "fire" then
					player.mrce.spawnshield = SH_FLAMEAURA
					CONS_Printf(player, "Set spawnshield to Flame Shield")
				elseif arg2 == "force" then
					player.mrce.spawnshield = SH_FORCE|1
					CONS_Printf(player, "Set spawnshield to Force Shield")
				elseif arg2 == "bubble" then
					player.mrce.spawnshield = SH_BUBBLEWRAP
					CONS_Printf(player, "Set spawnshield to Bubble Shield")
				elseif arg2 == "wind" or arg2 == "whirlwind" then
					player.mrce.spawnshield = SH_WHIRLWIND
					CONS_Printf(player, "Set spawnshield to Whirlwind Shield")
				elseif arg2 == "lightning" or arg2 == "thunder" then
					player.mrce.spawnshield = SH_THUNDERCOIN
					CONS_Printf(player, "Set spawnshield to Lightning Shield")
				elseif arg2 == "attract" or arg2 == "attraction" or arg2 == "magnet" then
					player.mrce.spawnshield = SH_ATTRACT
					CONS_Printf(player, "Set spawnshield to Attraction Shield")
				elseif arg2 == "elemental" then
					player.mrce.spawnshield = SH_ELEMENTAL
					CONS_Printf(player, "Set spawnshield to Elemental Shield")
				elseif arg2 == "arma" or arg2 == "armageddon" or arg2 == "black" or arg2 == "bomb" then
					player.mrce.spawnshield = SH_ARMAGEDDON
					CONS_Printf(player, "Set spawnshield to Armageddon Shield")
				elseif arg2 == "none" or arg2 == "off" or arg2 == "0" then
					player.mrce.spawnshield = 0
					CONS_Printf(player, "Disabled spawnshields")
				end
			else
				CONS_Printf(player, tostring(player.mrce.spawnshield))
			end
		else
			CONS_Printf(player, "\133invalid input")
		end
	else
		CONS_Printf(player, "\133You must be in a level to use this")
	end
end, 0)
