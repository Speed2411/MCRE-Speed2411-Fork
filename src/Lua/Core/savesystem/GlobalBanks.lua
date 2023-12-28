//Global Banks, a mod that globalizes the luabanks save file array, making it completely accesible at all times. By Xian
//normally, luabanks is limited to only being usable just once by a single file, any other files that try to use it after in the same session will simply error
//Global Banks intends to bypass this limitation by assigning the luabanks array to a global table,
//thereby allowing any number of mods to access custom information stored directly to the ssg save file, and access it as many times as necessary, with no limitations
//Once released, the mod page will be marked as non-reusable, but only due to the necessity of keeping slot reservations organized
//The mod would also need to be loaded alongside any other mod that uses its functions
//As such, I give permission to do so, adding this mod to your mod, under the condition that the actual contents of this file remain unmodified
print("initializing GlobalBanks tables")
if GlobalBanks_Array != nil then
	print("GlobalBanks has already been initialized, aborting")
	return
end

rawset(_G, "GlobalBanks_Array", reserveLuabanks())

--everything past this point isn't required for the mod to function, but is necessary for organizing the limited table slots as efficiently as possible

rawset(_G, "GlobalBanks_HyperUnlocked", function() --table entry 0 is where special collectibles like emeralds are kept. here we can read if we have the correct combination to allow a theoretical hyper form
	local table = GlobalBanks_Array[0]
	if (table & (1 << (7))) then --bit position 7, the black emerald
		return true
	end
	for i = 1, 7, 1 do --bit positions 0 - 6, the super emeralds
		if not (table & (1 << (i - 1))) then
			return false
		end
	end
	return true
end)

rawset(_G, "GlobalBanks_AllTimeStones", function() --here we can read if we have the correct combination for hypothetical time stones, like with srb2mvd
	local table = GlobalBanks_Array[0]
	for i = 9, 15, 1 do --bit positions 8 - 14, the time stones
		if not (table & (1 << (i - 1))) then
			return false
		end
	end
	return true
end)

addHook("MobjThinker", function(s) --this hook was borrowed from SA-Sonic with permission from Golden Shine
	if s.target and s.target.valid and s.target.player --You have passed the vibe check, observe and steal nothing.
	and s.target.player.exiting and (s.target.player.powers[pw_carry] == CR_NIGHTSMODE) then
		if (s.sprite == SPR_CEMG) and (s.frame == H or s.frame >= H|FF_FULLBRIGHT)
		or (gamemap == 57 and mapheaderinfo[gamemap].lvlttl == "Black Hole") then --You're welcome, Goal Ring mod.
			GlobalBanks_Array[0] = $ | (1 << (7))
		end
	end
end, MT_GOTEMERALD)

print("GlobalBanks initialization successful")

/*
you can read and write a given bit flag with (GlobalBanks_Array[x] & (1 << (y))), where x is the array slot and y is the bit flag contained within the array slot.
there are 16 array slots zero indexed (0-15) and each can contain up to 32 bit flags (also zero indexed, 0-31)
as such, with perfect optimization and organization, a save file can hold up to 512 bits of custom information
my job is to ascertain the proper organization of the array, and as such will be organizing GLOBAL RESERVATIONS
Listed below you will find the currently reserved slots and flags, and how to read/write them
Please contact Xian#1101 if you wish to reserve flags so that I may record them properly, and possibly advise the best flags to use if necessary
*/

--some advice: feel free to read the value of a flag as much as you need, however try to only write to it when necessary, and only after first reading it's current value to see if it even needs to be updated

--if x is to be considered the slot number, and y to be considered the flag number, then you can read/write the values as such:

--if not (GlobalBanks_Array[x] & (1 << (y))) then --read the value
--	GlobalBanks_Array[x] = $ | (1 << (y)) --write the value to on
--else
--	GlobalBanks_Array[x] = $ & ~(1 << (y)) --write the value to off
--end

---slot [0]
--primarily used for custom emeralds, but also used by mrce since I get first dibs on reservations for my own mod :yeeboi:

--flag 0
--Super Emerald 1

--flag 1
--Super Emerald 2

--flag 2
--Super Emerald 3

--flag 3
--Super Emerald 4

--flag 4
--Super Emerald 5

--flag 5
--Super Emerald 6

--flag 6
--Super Emerald 7

--flag 7
--Black Emerald/Wireframe emerald

--flag 8
--Time Stone 1

--flag 9
--Time Stone 2

--flag 10
--Time Stone 3

--flag 11
--Time Stone 4

--flag 12
--Time Stone 5

--flag 13
--Time Stone 6

--flag 14
--Time Stone 7

--flag 15
--Elemental Key Shard 1 (Lightning Shard) - MRCE

--flag 16
--Elemental Key Shard 2 (Fire Shard) - MRCE

--flag 17
--Elemental Key Shard 3 (Water Shard) - MRCE

--flag 18
--Elemental Key Shard 4 (Wind Shard) - MRCE --unused

--flag 19
--Elemental Key Shard 5 (Ice Shard) - MRCE --unused

--flag 20
--Jade Prism 1 - MRCE --unused

--flag 21
--Jade Prism 2 - MRCE --unused

--flag 22
--Jade Prism 3 - MRCE --unused

--flag 23
--Jade Prism 4 - MRCE --unused

--flag 24
--Prism of Light - MRCE --unused

--flag 25
--Second Quest / New Game+ / Encore Mode --currently only used by MRCE's Second Quest but is available for use by any other similar mods that add an EX Campaign of some sort

--flag 26
--AGZ Warp Memory - Exclusive effect for MRCE's AGZ4

--flags 27 - 31
--available, but may be used later, try using a flag entry from a different slot

----slots 1-15 are completely open rn