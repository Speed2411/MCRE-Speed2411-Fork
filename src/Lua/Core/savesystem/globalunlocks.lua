//
local FILENAME = "client/mrce/global.dat"
local globalData = {}
local recdata = {false, false, false}
rawset(_G, "mrce_lockOn", true)

local CV_MAEPSelect = CV_RegisterVar{
	name = "mr_ma_ep",
	defaultvalue = 3,
	flags = CV_NOTINNET,
	PossibleValue = {MIN = 1, MAX = 8}
}

local marathonstart = 5

local file = io.openlocal(FILENAME, "a")  --create the file if it doesn't exist, but don't alter it. we use append mode for this
file:close()

local file2 = io.openlocal(FILENAME, "r") 	-- file already exsists, load from it

if file2 then

	for l in file2:lines() do
		local secondquest, newgameplus, secondquestplus  = string.match(l, "(.*);(.*);(.*)")

		globalData = {tonumber(secondquest), tonumber(newgameplus), tonumber(secondquestplus)}
	end
end
file2:close()

local function _saveFileFunc()
	-- This function actully opens the file.
	-- If the file failed to open for whatever reason, the assert would catch
	--   it and return back to the pcall that called this function.
	local f = assert(io.openlocal(FILENAME, "w"))
	f:write(globalData[1], ";", globalData[2], ";", globalData[3])
	f:close()
end

local function saveFile()
	-- This function is effectivly a wrapper for the real open file function.
	-- The real open file function opens the file through an assert,
	--   if the file failed to open, it would immediatly stop execution and
	--   return here with a false, causing the if block to be ran and to print
	--   the message.
	if not pcall(_saveFileFunc) then
		CONS_Printf(server, "Failed to save file!")
	end
end

local new1 = {
	name = "Second Quest",
	description = "Shifts up the theme, layout, and enemies of the levels.",
	image = "EPM_NEXTQST",
	action = function()
		G_SetCustomExitVars(101,1)
		mrce_secondquest = true
		G_ExitLevel()
	end
}

local new2 = {
	name = "New Game+",
	action = function(huddata)
		emeralds = 127
		for i = 1, 8, 1 do
			if not (GlobalBanks_Array[0] & (1 << (i - 1))) then
				GlobalBanks_Array[0] = $ | (1 << (i - 1))
			end
		end
		mrce_hyperunlocked = true
		mrce_secondquest = false
		S_StartSound(nil, sfx_cgot)
		G_SetCustomExitVars(101,1)
		G_ExitLevel()
	end,
	image = "EPM_NEXTQST",
	description = "Start a new game with all emeralds acquired",
}

local new3 = {
	name = "New Second Quest+",
	action = function(huddata)
		print("Starting Second Quest+!")
		G_SetCustomExitVars(101,1)
		mrce_secondquest = true
		emeralds = 127
		for i = 1, 8, 1 do
			if not (GlobalBanks_Array[0] & (1 << (i - 1))) then
				GlobalBanks_Array[0] = $ | (1 << (i - 1))
			end
		end
		mrce_hyperunlocked = true
		G_ExitLevel()
	end,
	image = "EPM_NEXTQST",
	description = "Start a Second Quest game with all emeralds acquired",
}

addHook("MapLoad", function(gmap)
	/*if (GlobalBanks_Array[0] & (1 << (27))) then
		mrce_lockOn = true
	else
		mrce_lockOn = false
	end*/
	if gmap > 99 or gmap < 98 then return end

	--print(tostring(globalData[1]) .. " " .. tostring(globalData[2]) .. " " .. tostring(globalData[3]))
	if gmap == 99 and not multiplayer then --episode select, load episode data from file
		/*for i = 1, 3, 1 do
			if globalData[i] then
				MRCE_addEpisode(newi)
			end*/
		if globalData[1] and not recdata[1] then
			MRCE_addEpisode(new1)
			recdata[1] = true
		end
		if globalData[2] and not recdata[2] then
			MRCE_addEpisode(new2)
			recdata[2] = true
		end
		if globalData[3] and not recdata[2] then
			MRCE_addEpisode(new3)
			recdata[3] = true
		end
	elseif gmap == 98 then --credits, save data based on current episode
		if not mrce_secondquest and not globalData[1] then
			globalData[1] = 1
			saveFile()
		end
		if mrce_hyperunlocked and not mrce_secondquest and not globalData[2] then
			globalData[2] = 1
			saveFile()
		elseif mrce_secondquest and mrce_hyperunlocked and not globalData[3] then
			globalData[3] = 1
			saveFile()
		end
	end
end)



local marathonepisodes = {
	[1] = {1, false, false, false},
	[2] = {1, true, false, false},
	[3] = {101, false, false, false},
	[4] = {101, false, true, false},
	[5] = {101, false, false, true},
	[6] = {101, false, true, true},
	[7] = {1, false, false, true},
	[8] = {1, true, false, true}
}

addHook("GameQuit", function()
	mrce_lockOn = true
	marathonstart = 5
end)

local debug = 0


addHook("ThinkFrame", function()
	if gamestate == GS_TITLESCREEN then marathonstart = 5 return end
	if (marathonmode or debug == 1) and marathonstart > 0 and gamestate == GS_LEVEL then
		--print("marathon init ready")
		local exit1 = 101
		for k, v in pairs(marathonepisodes) do
			if k == CV_MAEPSelect.value then
				--print("found marathon table")
				exit1 = v[1]
				--print("attempting to exit to map" .. tostring(v[1]))
				mrce_lockOn = v[2]
				if globalData[1] and v[3] then
					mrce_secondquest = true
				else
					mrce_secondquest = false
				end
				--print("sq " .. tostring(v[3]))
				if v[4] then
					if (globalData[2] and not v[3])
					or globalData[3] then
						emeralds = 127
						for i = 1, 8, 1 do
							if not (GlobalBanks_Array[0] & (1 << (i - 1))) then
								GlobalBanks_Array[0] = $ | (1 << (i - 1))
							end
						end
						mrce_hyperunlocked = true
					end
				end
			end
		end
		--print("go time")
		if gamemap != exit1 then
			marathonstart = $ - 1
			--print("off to see your mother!")
			G_SetCustomExitVars(exit1, 1)
			G_ExitLevel()
		else
			marathonstart = 0
		end
	end
end)

local txn = 0

addHook("LinedefExecute", function(line, mo, sector)
	if txn > 100 then
		if (netgame or not mrce_lockOn) then
			G_SetCustomExitVars(1103, 1)
		else
			G_SetCustomExitVars(101, 1)
		end
		G_ExitLevel()
	else
		txn = $ + 1
	end
end, "LOCKONEXIT")

addHook("NetVars", function(net)
	txn = net($)
end)