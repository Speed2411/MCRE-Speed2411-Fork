//Credits to MotdSpork for this script is based off of his Modern Sonic HUD
//Last edited by Marcos - 20/10/2021 19:35 (UTC+2)

local cv = CV_RegisterVar({name = "powerupdisplay_size", defaultvalue = "small", flags = 0, PossibleValue = {small=0, medium=1, big=2}, func = 0}) --my first console variable
local cv1 = CV_FindVar("powerupdisplay")
local cv2 = CV_FindVar("chasecam")
local fpok

//move away the vanilla ones, since they can't be completely erased  --note vanilla value is 176

local function MRCEItemHUD(v, player)
	if cv1.value == 0 then
		return
	end
	if player.spectator then return end
	if not player.realmo then return end
	if player.mrce and player.mrce.hud == 0 then
		hudinfo[HUD_POWERUPS].y = 176
		return
	end
	hudinfo[HUD_POWERUPS].y = 250
	if cv1.value == 2
	or cv1.value == 1 and cv2.value == 0 then
        if not (player.powers[pw_carry] == CR_NIGHTSMODE) then --there's no NiGHTS in MRCE anyways --there is now --there isn't --lock on moment b like. also netgames exist dummy
			local p_box 		 = v.cachePatch("BOX")
			local p_triangle 	 = v.cachePatch("TRIANGLE")
			local p_emerald	 	 = v.cachePatch("EMERLD")
			local p_fire	 	 = v.cachePatch("FIRE")
			local p_sneakers	 = v.cachePatch("SNEAK")
			local p_invinc		 = v.cachePatch("INVINC")
			local p_invins		 = v.cachePatch("INVINS")
			local p_grav		 = v.cachePatch("GRAV")
			local p_pity	 	 = v.cachePatch("PITY")
			local p_whirl		 = v.cachePatch("WHIRL")
			local p_arm			 = v.cachePatch("ARM")
			local p_pink		 = v.cachePatch("HEART")
			local p_element	 	 = v.cachePatch("ELEMENT")
			local p_attract	 	 = v.cachePatch("MAGNET")
			local p_force1		 = v.cachePatch("FORCE1")
			local p_force2		 = v.cachePatch("FORCE2")
			local p_flame		 = v.cachePatch("FLAME")
			local p_bubble		 = v.cachePatch("BUBBLE")
			local p_thunder	 	 = v.cachePatch("THUNDER")
			local p_starman	 	 = v.cachePatch("STARMAN")
			local p_starmans	 = v.cachePatch("STARMANS")
			local p_spity		 = v.cachePatch("SPITY") --small versions start here
			local p_swhirl		 = v.cachePatch("SWHIRL")
			local p_sarm		 = v.cachePatch("SARM")
			local p_spink		 = v.cachePatch("SPINK")
			local p_selement	 = v.cachePatch("SELEMENT")
			local p_sattract	 = v.cachePatch("SMAGNET")
			local p_sthunder	 = v.cachePatch("STHUNDER")
			local p_sbubble		 = v.cachePatch("SBUBBLE")
			local p_sflame		 = v.cachePatch("SFLAME")
			local p_sforce1		 = v.cachePatch("SFORCE1")
			local p_sforce2		 = v.cachePatch("SFORCE2")

			local posx --stands for position x
			local posy --stands for position y
			local numposx --position for v.drawNum is handled differently
			local numposy
			local gravposx --don't ask
			local gravposy

			local whatcolor = player.mo.color --for cool rainbow and super colors

			local size

			if cv.value == 0 then
				size = FRACUNIT/2
				posx = 307*FRACUNIT --Jump wanted it a liiiitle bit more to the right so instead of a fixed good looking 305 have a fucking 307
				posy = 185*FRACUNIT
				numposx = 280
				numposy = 180
				gravposx = 310
				gravposy = 160
			elseif cv.value == 1 then
				size = 3*FRACUNIT/4
				posx = 302*FRACUNIT
				posy = 182*FRACUNIT
				numposx = 280
				numposy = 180
				gravposx = 310
				gravposy = 160
			elseif cv.value == 2 then
				size = FRACUNIT
				posx = 297*FRACUNIT
				posy = 179*FRACUNIT
				numposx = 280
				numposy = 180
				gravposx = 310
				gravposy = 160
			else
				size = FRACUNIT/2
				posx = 307*FRACUNIT
				posy = 185*FRACUNIT
				numposx = 280
				numposy = 180
				gravposx = 310
				gravposy = 160
			end

			//Always draw the box, the box is what we need
			v.drawScaled(posx, posy, size, p_box, V_SNAPTOBOTTOM|V_SNAPTORIGHT|V_PERPLAYER|V_HUDTRANS); --snapto flags don't even fucking work so globox moment --(20/20/2021) they did
								   --^scale for everything (0,5 of the original scale because "too big")

			//Super now is overriden by shields as you can't go Super if you have a shield
			if (player.powers[pw_super] and not (player.mo.state >= S_PLAY_SUPER_TRANS1 and player.mo.state <= S_PLAY_SUPER_TRANS6)) then
				v.drawScaled(posx, posy, size, p_triangle, V_SNAPTOBOTTOM|V_SNAPTORIGHT|V_PERPLAYER|V_HUDTRANS, v.getColormap("-1", whatcolor));
				v.drawScaled(posx, posy, size, p_emerald, V_SNAPTOBOTTOM|V_SNAPTORIGHT|V_PERPLAYER|V_HUDTRANS);
			elseif All7Emeralds(emeralds)
			and player.rings >= 50
			and player.powers[pw_shield] & SH_NOSTACK == SH_NONE then
				v.drawScaled(posx, posy, size, p_triangle, V_SNAPTOBOTTOM|V_SNAPTORIGHT|V_PERPLAYER|V_HUDTRANS, v.getColormap("-1", SKINCOLOR_SUPERSILVER1));
				v.drawScaled(posx, posy, size, p_emerald, V_SNAPTOBOTTOM|V_SNAPTORIGHT|V_PERPLAYER|V_HUDTRANS);
			//If both Invincibility and Super Sneakers
			elseif player.powers[pw_invulnerability] and player.powers[pw_sneakers] then
				v.drawPaddedNum(numposx, numposy - 10, (player.powers[pw_sneakers] / TICRATE), 2, V_SNAPTOBOTTOM|V_SNAPTORIGHT|V_PERPLAYER|V_HUDTRANS|V_REDMAP);
				v.drawPaddedNum(numposx, numposy, (player.powers[pw_invulnerability] / TICRATE), 2, V_SNAPTOBOTTOM|V_SNAPTORIGHT|V_PERPLAYER|V_HUDTRANS);
				//Triangle shit
				if mariomode == true then --Xian said it was being axed but fuck it special effects
					v.drawScaled(posx, posy, size, p_triangle, V_SNAPTOBOTTOM|V_SNAPTORIGHT|V_PERPLAYER|V_HUDTRANS, v.getColormap("-1", whatcolor)); --RRRRRRRAAAAAAAAAAIIIIIIIIIIINNNNNNNNNBBBBBBBBBBBBOOOOOOOOOOOOOOWWWWWWWWWWWSSSSSSSSSSS
				else
					v.drawScaled(posx, posy, size, p_triangle, V_SNAPTOBOTTOM|V_SNAPTORIGHT|V_PERPLAYER|V_HUDTRANS, v.getColormap("-1", SKINCOLOR_PURPLE));
				end
				//Super Sneakers
				if player.powers[pw_sneakers] < 3*TICRATE then
					if (leveltime % 2) then --flicker effect because without it "it does less of a service than vanilla"
					else	--^ courtesy of kays they explained this to me
						v.drawScaled(posx, posy, size, p_sneakers, V_SNAPTOBOTTOM|V_SNAPTORIGHT|V_PERPLAYER|V_HUDTRANS);
					end
				else
					v.drawScaled(posx, posy, size, p_sneakers, V_SNAPTOBOTTOM|V_SNAPTORIGHT|V_PERPLAYER|V_HUDTRANS);
				end
				//Invincibility
				if player.powers[pw_invulnerability] < 3*TICRATE then
					if (leveltime % 2) then
					else
						if mariomode == true then
							v.drawScaled(posx, posy, size, p_starmans, V_SNAPTOBOTTOM|V_SNAPTORIGHT|V_PERPLAYER|V_HUDTRANS, v.getColormap("-1", whatcolor));
						else
							v.drawScaled(posx, posy, size, p_invins, V_SNAPTOBOTTOM|V_SNAPTORIGHT|V_PERPLAYER|V_HUDTRANS);
						end
					end
				else
					if mariomode == true then
						v.drawScaled(posx, posy, size, p_starmans, V_SNAPTOBOTTOM|V_SNAPTORIGHT|V_PERPLAYER|V_HUDTRANS, v.getColormap("-1", whatcolor));
					else
						v.drawScaled(posx, posy, size, p_invins, V_SNAPTOBOTTOM|V_SNAPTORIGHT|V_PERPLAYER|V_HUDTRANS);
					end
				end
				//Shields
				if player.powers[pw_shield] & SH_NOSTACK == SH_PITY then
					v.drawScaled(posx, posy, size, p_spity, V_SNAPTOBOTTOM|V_SNAPTORIGHT|V_PERPLAYER|V_HUDTRANS);
				elseif player.powers[pw_shield] & SH_NOSTACK == SH_WHIRLWIND then
					v.drawScaled(posx, posy, size, p_swhirl, V_SNAPTOBOTTOM|V_SNAPTORIGHT|V_PERPLAYER|V_HUDTRANS);
				elseif player.powers[pw_shield] & SH_NOSTACK == SH_ARMAGEDDON then
					v.drawScaled(posx, posy, size, p_sarm, V_SNAPTOBOTTOM|V_SNAPTORIGHT|V_PERPLAYER|V_HUDTRANS);
				elseif player.powers[pw_shield] & SH_NOSTACK == SH_PINK then
					v.drawScaled(posx, posy, size, p_spink, V_SNAPTOBOTTOM|V_SNAPTORIGHT|V_PERPLAYER|V_HUDTRANS);
				elseif player.powers[pw_shield] & SH_NOSTACK == SH_ELEMENTAL then
					v.drawScaled(posx, posy, size, p_selement, V_SNAPTOBOTTOM|V_SNAPTORIGHT|V_PERPLAYER|V_HUDTRANS);
				elseif player.powers[pw_shield] & SH_NOSTACK == SH_ATTRACT then
					v.drawScaled(posx, posy, size, p_sattract, V_SNAPTOBOTTOM|V_SNAPTORIGHT|V_PERPLAYER|V_HUDTRANS);
				elseif player.powers[pw_shield] & SH_NOSTACK == SH_TUNDERCOIN or player.powers[pw_shield] & SH_NOSTACK == SH_WHIRLWIND|SH_PROTECTELECTRIC then
					v.drawScaled(posx, posy, size, p_sthunder, V_SNAPTOBOTTOM|V_SNAPTORIGHT|V_PERPLAYER|V_HUDTRANS);
				elseif player.powers[pw_shield] & SH_NOSTACK == SH_BUBBLEWRAP then
					v.drawScaled(posx, posy, size, p_sbubble, V_SNAPTOBOTTOM|V_SNAPTORIGHT|V_PERPLAYER|V_HUDTRANS);
				elseif player.powers[pw_shield] & SH_NOSTACK == SH_FLAMEAURA then
					v.drawScaled(posx, posy, size, p_sflame, V_SNAPTOBOTTOM|V_SNAPTORIGHT|V_PERPLAYER|V_HUDTRANS);
				elseif player.powers[pw_shield] & SH_FORCE then
					if player.powers[pw_shield] & SH_FORCEHP then
						v.drawScaled(posx, posy, size, p_sforce1, V_SNAPTOBOTTOM|V_SNAPTORIGHT|V_PERPLAYER|V_HUDTRANS);
					else
						v.drawScaled(posx, posy, size, p_sforce2, V_SNAPTOBOTTOM|V_SNAPTORIGHT|V_PERPLAYER|V_HUDTRANS);
					end
				end
			//Super Sneakers
			elseif player.powers[pw_sneakers] then
				if player.powers[pw_sneakers] < 3*TICRATE then
					if (leveltime % 2) then
					else
						v.drawScaled(posx, posy, size, p_sneakers, V_SNAPTOBOTTOM|V_SNAPTORIGHT|V_PERPLAYER|V_HUDTRANS);
					end
				else
					v.drawScaled(posx, posy, size, p_sneakers, V_SNAPTOBOTTOM|V_SNAPTORIGHT|V_PERPLAYER|V_HUDTRANS);
				end
				//1st person thing for PV
				if player.powers[pw_shield] & SH_NOSTACK == SH_PITY then
					v.drawScaled(posx, posy, size, p_spity, V_SNAPTOBOTTOM|V_SNAPTORIGHT|V_PERPLAYER|V_HUDTRANS);
					v.drawScaled(posx, posy, size, p_triangle, V_SNAPTOBOTTOM|V_SNAPTORIGHT|V_PERPLAYER|V_HUDTRANS, v.getColormap("-1", SKINCOLOR_MOSS));
				elseif player.powers[pw_shield] & SH_NOSTACK == SH_WHIRLWIND then
					v.drawScaled(posx, posy, size, p_swhirl, V_SNAPTOBOTTOM|V_SNAPTORIGHT|V_PERPLAYER|V_HUDTRANS);
					v.drawScaled(posx, posy, size, p_triangle, V_SNAPTOBOTTOM|V_SNAPTORIGHT|V_PERPLAYER|V_HUDTRANS, v.getColormap("-1", SKINCOLOR_WHITE));
				elseif player.powers[pw_shield] & SH_NOSTACK == SH_ARMAGEDDON then
					v.drawScaled(posx, posy, size, p_sarm, V_SNAPTOBOTTOM|V_SNAPTORIGHT|V_PERPLAYER|V_HUDTRANS);
					v.drawScaled(posx, posy, size, p_triangle, V_SNAPTOBOTTOM|V_SNAPTORIGHT|V_PERPLAYER|V_HUDTRANS, v.getColormap("-1", SKINCOLOR_CRIMSON));
				elseif player.powers[pw_shield] & SH_NOSTACK == SH_PINK then
					v.drawScaled(posx, posy, size, p_spink, V_SNAPTOBOTTOM|V_SNAPTORIGHT|V_PERPLAYER|V_HUDTRANS);
					v.drawScaled(posx, posy, size, p_triangle, V_SNAPTOBOTTOM|V_SNAPTORIGHT|V_PERPLAYER|V_HUDTRANS, v.getColormap("-1", SKINCOLOR_ROSY));
				elseif player.powers[pw_shield] & SH_NOSTACK == SH_ELEMENTAL then
					v.drawScaled(posx, posy, size, p_selement, V_SNAPTOBOTTOM|V_SNAPTORIGHT|V_PERPLAYER|V_HUDTRANS);
					v.drawScaled(posx, posy, size, p_triangle, V_SNAPTOBOTTOM|V_SNAPTORIGHT|V_PERPLAYER|V_HUDTRANS, v.getColormap("-1", SKINCOLOR_APRICOT));
				elseif player.powers[pw_shield] & SH_NOSTACK == SH_ATTRACT then
					v.drawScaled(posx, posy, size, p_sattract, V_SNAPTOBOTTOM|V_SNAPTORIGHT|V_PERPLAYER|V_HUDTRANS);
					v.drawScaled(posx, posy, size, p_triangle, V_SNAPTOBOTTOM|V_SNAPTORIGHT|V_PERPLAYER|V_HUDTRANS, v.getColormap("-1", SKINCOLOR_SUPERGOLD3));
				elseif player.powers[pw_shield] & SH_NOSTACK == SH_TUNDERCOIN or player.powers[pw_shield] & SH_NOSTACK == SH_WHIRLWIND|SH_PROTECTELECTRIC then
					v.drawScaled(posx, posy, size, p_sthunder, V_SNAPTOBOTTOM|V_SNAPTORIGHT|V_PERPLAYER|V_HUDTRANS);
					v.drawScaled(posx, posy, size, p_triangle, V_SNAPTOBOTTOM|V_SNAPTORIGHT|V_PERPLAYER|V_HUDTRANS, v.getColormap("-1", SKINCOLOR_BONE));
				elseif player.powers[pw_shield] & SH_NOSTACK == SH_BUBBLEWRAP then
					v.drawScaled(posx, posy, size, p_sbubble, V_SNAPTOBOTTOM|V_SNAPTORIGHT|V_PERPLAYER|V_HUDTRANS);
					v.drawScaled(posx, posy, size, p_triangle, V_SNAPTOBOTTOM|V_SNAPTORIGHT|V_PERPLAYER|V_HUDTRANS, v.getColormap("-1", SKINCOLOR_SKY));
				elseif player.powers[pw_shield] & SH_NOSTACK == SH_FLAMEAURA then
					v.drawScaled(posx, posy, size, p_sflame, V_SNAPTOBOTTOM|V_SNAPTORIGHT|V_PERPLAYER|V_HUDTRANS);
					v.drawScaled(posx, posy, size, p_triangle, V_SNAPTOBOTTOM|V_SNAPTORIGHT|V_PERPLAYER|V_HUDTRANS, v.getColormap("-1", SKINCOLOR_RUST));
				elseif player.powers[pw_shield] & SH_FORCE then
					if player.powers[pw_shield] & SH_FORCEHP then --Zolton said to check it inside sh_force which I guess is more optimized
						v.drawScaled(posx, posy, size, p_triangle, V_SNAPTOBOTTOM|V_SNAPTORIGHT|V_PERPLAYER|V_HUDTRANS, v.getColormap("-1", SKINCOLOR_NEON));
						v.drawScaled(posx, posy, size, p_sforce1, V_SNAPTOBOTTOM|V_SNAPTORIGHT|V_PERPLAYER|V_HUDTRANS);
					else
						v.drawScaled(posx, posy, size, p_triangle, V_SNAPTOBOTTOM|V_SNAPTORIGHT|V_PERPLAYER|V_HUDTRANS, v.getColormap("-1", SKINCOLOR_MAGENTA));
						v.drawScaled(posx, posy, size, p_sforce2, V_SNAPTOBOTTOM|V_SNAPTORIGHT|V_PERPLAYER|V_HUDTRANS);
					end
				else
					v.drawScaled(posx, posy, size, p_triangle, V_SNAPTOBOTTOM|V_SNAPTORIGHT|V_PERPLAYER|V_HUDTRANS, v.getColormap("-1", SKINCOLOR_RED));
				end
			//Invincibility
			elseif player.powers[pw_invulnerability] then
				v.drawPaddedNum(numposx, numposy, (player.powers[pw_invulnerability] / TICRATE), 2, V_SNAPTOBOTTOM|V_SNAPTORIGHT|V_PERPLAYER|V_HUDTRANS);
				if mariomode == true then
					v.drawScaled(posx, posy, size, p_triangle, V_SNAPTOBOTTOM|V_SNAPTORIGHT|V_PERPLAYER|V_HUDTRANS, v.getColormap("-1", whatcolor));
				else
					v.drawScaled(posx, posy, size, p_triangle, V_SNAPTOBOTTOM|V_SNAPTORIGHT|V_PERPLAYER|V_HUDTRANS, v.getColormap("-1", SKINCOLOR_SUPERSILVER1));
				end
				if player.powers[pw_invulnerability] < 3*TICRATE then
					if (leveltime % 2) then
					else
						if mariomode == true then
							v.drawScaled(posx, posy, size, p_starman, V_SNAPTOBOTTOM|V_SNAPTORIGHT|V_PERPLAYER|V_HUDTRANS);
						else
							v.drawScaled(posx, posy, size, p_invinc, V_SNAPTOBOTTOM|V_SNAPTORIGHT|V_PERPLAYER|V_HUDTRANS);
						end
					end
				else
					if mariomode == true then
						v.drawScaled(posx, posy, size, p_starman, V_SNAPTOBOTTOM|V_SNAPTORIGHT|V_PERPLAYER|V_HUDTRANS);
					else
						v.drawScaled(posx, posy, size, p_invinc, V_SNAPTOBOTTOM|V_SNAPTORIGHT|V_PERPLAYER|V_HUDTRANS);
					end
				end
				if player.powers[pw_shield] & SH_NOSTACK == SH_PITY then
					v.drawScaled(posx, posy, size, p_spity, V_SNAPTOBOTTOM|V_SNAPTORIGHT|V_PERPLAYER|V_HUDTRANS);
				elseif player.powers[pw_shield] & SH_NOSTACK == SH_WHIRLWIND then
					v.drawScaled(posx, posy, size, p_swhirl, V_SNAPTOBOTTOM|V_SNAPTORIGHT|V_PERPLAYER|V_HUDTRANS);
				elseif player.powers[pw_shield] & SH_NOSTACK == SH_ARMAGEDDON then
					v.drawScaled(posx, posy, size, p_sarm, V_SNAPTOBOTTOM|V_SNAPTORIGHT|V_PERPLAYER|V_HUDTRANS);
				elseif player.powers[pw_shield] & SH_NOSTACK == SH_PINK then
					v.drawScaled(posx, posy, size, p_spink, V_SNAPTOBOTTOM|V_SNAPTORIGHT|V_PERPLAYER|V_HUDTRANS);
				elseif player.powers[pw_shield] & SH_NOSTACK == SH_ELEMENTAL then
					v.drawScaled(posx, posy, size, p_selement, V_SNAPTOBOTTOM|V_SNAPTORIGHT|V_PERPLAYER|V_HUDTRANS);
				elseif player.powers[pw_shield] & SH_NOSTACK == SH_ATTRACT then
					v.drawScaled(posx, posy, size, p_sattract, V_SNAPTOBOTTOM|V_SNAPTORIGHT|V_PERPLAYER|V_HUDTRANS);
				elseif player.powers[pw_shield] & SH_NOSTACK == SH_TUNDERCOIN or player.powers[pw_shield] & SH_NOSTACK == SH_WHIRLWIND|SH_PROTECTELECTRIC then
					v.drawScaled(posx, posy, size, p_sthunder, V_SNAPTOBOTTOM|V_SNAPTORIGHT|V_PERPLAYER|V_HUDTRANS);
				elseif player.powers[pw_shield] & SH_NOSTACK == SH_BUBBLEWRAP then
					v.drawScaled(posx, posy, size, p_sbubble, V_SNAPTOBOTTOM|V_SNAPTORIGHT|V_PERPLAYER|V_HUDTRANS);
				elseif player.powers[pw_shield] & SH_NOSTACK == SH_FLAMEAURA then
					v.drawScaled(posx, posy, size, p_sflame, V_SNAPTOBOTTOM|V_SNAPTORIGHT|V_PERPLAYER|V_HUDTRANS);
				elseif player.powers[pw_shield] & SH_FORCE then
					if player.powers[pw_shield] & SH_FORCEHP then
						v.drawScaled(posx, posy, size, p_sforce1, V_SNAPTOBOTTOM|V_SNAPTORIGHT|V_PERPLAYER|V_HUDTRANS);
					else
						v.drawScaled(posx, posy, size, p_sforce2, V_SNAPTOBOTTOM|V_SNAPTORIGHT|V_PERPLAYER|V_HUDTRANS);
					end
				end
			//Pity Shield
			elseif player.powers[pw_shield] & SH_NOSTACK == SH_PITY then
				v.drawScaled(posx, posy, size, p_triangle, V_SNAPTOBOTTOM|V_SNAPTORIGHT|V_PERPLAYER|V_HUDTRANS, v.getColormap("-1", SKINCOLOR_MOSS));
				v.drawScaled(posx, posy, size, p_pity, V_SNAPTOBOTTOM|V_SNAPTORIGHT|V_PERPLAYER|V_HUDTRANS);
			//Whirlwind Shield
			elseif player.powers[pw_shield] & SH_NOSTACK == SH_WHIRLWIND then
				v.drawScaled(posx, posy, size, p_triangle, V_SNAPTOBOTTOM|V_SNAPTORIGHT|V_PERPLAYER|V_HUDTRANS, v.getColormap("-1", SKINCOLOR_WHITE));
				v.drawScaled(posx, posy, size, p_whirl, V_SNAPTOBOTTOM|V_SNAPTORIGHT|V_PERPLAYER|V_HUDTRANS);
			//Armageddon Shield
			elseif player.powers[pw_shield] & SH_NOSTACK == SH_ARMAGEDDON then
				v.drawScaled(posx, posy, size, p_triangle, V_SNAPTOBOTTOM|V_SNAPTORIGHT|V_PERPLAYER|V_HUDTRANS, v.getColormap("-1", SKINCOLOR_CRIMSON));
				v.drawScaled(posx, posy, size, p_arm, V_SNAPTOBOTTOM|V_SNAPTORIGHT|V_PERPLAYER|V_HUDTRANS);
			//Amy Pity Shield
			elseif player.powers[pw_shield] & SH_NOSTACK == SH_PINK then
				v.drawScaled(posx, posy, size, p_triangle, V_SNAPTOBOTTOM|V_SNAPTORIGHT|V_PERPLAYER|V_HUDTRANS, v.getColormap("-1", SKINCOLOR_ROSY));
				v.drawScaled(posx, posy, size, p_pink, V_SNAPTOBOTTOM|V_SNAPTORIGHT|V_PERPLAYER|V_HUDTRANS);
			//Elemental Shield
			elseif player.powers[pw_shield] & SH_NOSTACK == SH_ELEMENTAL then
				v.drawScaled(posx, posy, size, p_triangle, V_SNAPTOBOTTOM|V_SNAPTORIGHT|V_PERPLAYER|V_HUDTRANS, v.getColormap("-1", SKINCOLOR_APRICOT));
				v.drawScaled(posx, posy, size, p_element, V_SNAPTOBOTTOM|V_SNAPTORIGHT|V_PERPLAYER|V_HUDTRANS);
			//Attraction Shield
			elseif player.powers[pw_shield] & SH_NOSTACK == SH_ATTRACT then
				v.drawScaled(posx, posy, size, p_triangle, V_SNAPTOBOTTOM|V_SNAPTORIGHT|V_PERPLAYER|V_HUDTRANS, v.getColormap("-1", SKINCOLOR_SUPERGOLD3));
				v.drawScaled(posx, posy, size, p_attract, V_SNAPTOBOTTOM|V_SNAPTORIGHT|V_PERPLAYER|V_HUDTRANS);
			//Electric Shield
			elseif player.powers[pw_shield] & SH_NOSTACK == SH_TUNDERCOIN or player.powers[pw_shield] & SH_NOSTACK == SH_WHIRLWIND|SH_PROTECTELECTRIC then --thundercoin alone doesn't work because lua
				v.drawScaled(posx, posy, size, p_triangle, V_SNAPTOBOTTOM|V_SNAPTORIGHT|V_PERPLAYER|V_HUDTRANS, v.getColormap("-1", SKINCOLOR_BONE));
				v.drawScaled(posx, posy, size, p_thunder, V_SNAPTOBOTTOM|V_SNAPTORIGHT|V_PERPLAYER|V_HUDTRANS);
			//Bubble Shield
			elseif player.powers[pw_shield] & SH_NOSTACK == SH_BUBBLEWRAP then
				v.drawScaled(posx, posy, size, p_triangle, V_SNAPTOBOTTOM|V_SNAPTORIGHT|V_PERPLAYER|V_HUDTRANS, v.getColormap("-1", SKINCOLOR_SKY));
				v.drawScaled(posx, posy, size, p_bubble, V_SNAPTOBOTTOM|V_SNAPTORIGHT|V_PERPLAYER|V_HUDTRANS);
			//Flame Shield
			elseif player.powers[pw_shield] & SH_NOSTACK == SH_FLAMEAURA then
				v.drawScaled(posx, posy, size, p_triangle, V_SNAPTOBOTTOM|V_SNAPTORIGHT|V_PERPLAYER|V_HUDTRANS, v.getColormap("-1", SKINCOLOR_RUST));
				v.drawScaled(posx, posy, size, p_flame, V_SNAPTOBOTTOM|V_SNAPTORIGHT|V_PERPLAYER|V_HUDTRANS);
			//Force Shield
			elseif player.powers[pw_shield] & SH_FORCE then
				if player.powers[pw_shield] & SH_FORCEHP then --Zolton said to check it inside sh_force which I guess is more optimized
					v.drawScaled(posx, posy, size, p_triangle, V_SNAPTOBOTTOM|V_SNAPTORIGHT|V_PERPLAYER|V_HUDTRANS, v.getColormap("-1", SKINCOLOR_NEON));
					v.drawScaled(posx, posy, size, p_force1, V_SNAPTOBOTTOM|V_SNAPTORIGHT|V_PERPLAYER|V_HUDTRANS);
				else
					v.drawScaled(posx, posy, size, p_triangle, V_SNAPTOBOTTOM|V_SNAPTORIGHT|V_PERPLAYER|V_HUDTRANS, v.getColormap("-1", SKINCOLOR_MAGENTA));
					v.drawScaled(posx, posy, size, p_force2, V_SNAPTOBOTTOM|V_SNAPTORIGHT|V_PERPLAYER|V_HUDTRANS);
				end
			end
			//Fire Flower overlay (As it can be used with anything)
			if player.powers[pw_shield] & SH_FIREFLOWER then
				v.drawScaled(posx, posy, size, p_fire, V_SNAPTOBOTTOM|V_SNAPTORIGHT|V_PERPLAYER|V_HUDTRANS);
			end
			//Gravity won't override everythinganymore
			if player.powers[pw_gravityboots] then
				v.drawPaddedNum(gravposx, gravposy, (player.powers[pw_gravityboots] / TICRATE), 2, V_SNAPTOBOTTOM|V_SNAPTORIGHT|V_PERPLAYER|V_HUDTRANS|V_SKYMAP);
				v.drawPaddedNum(posx, posy, (player.powers[pw_gravityboots] / TICRATE), 2, V_SNAPTOBOTTOM|V_SNAPTORIGHT|V_PERPLAYER|V_HUDTRANS);
				v.drawScaled(posx, posy, size, p_grav, V_SNAPTOBOTTOM|V_SNAPTORIGHT|V_PERPLAYER|V_HUDTRANS);
			end
			//draw speed shoes counter separately so it still renders when super
			if player.powers[pw_sneakers] then
				v.drawPaddedNum(numposx, numposy - 10, (player.powers[pw_sneakers] / TICRATE), 2, V_SNAPTOBOTTOM|V_SNAPTORIGHT|V_PERPLAYER|V_HUDTRANS|V_REDMAP);
			end
		end
	end
end

hud.add(MRCEItemHUD, "game")