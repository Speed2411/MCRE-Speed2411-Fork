/*
    Rewritten init.lua for MRCE

    this setup is much cleaner and results
    in much less being written
*/

-- Performs a version check. Will only show a warning if subversion check fails.
local debug = 0
if debug > 1 then return end
if VERSION != 202 then -- Just in case 2.3 breaks 2.2 mods or something
	S_ChangeMusic("NOWAY")
    error("\
                               No Way? No Way!\
                 MRCE requires SRB2 version 2.2.12 or higher.\
              You have version 2.3 or a version older than 2.2.0!\
           Grab the latest version of 2.2 from srb2.org to play MRCE!", 0) return
elseif SUBVERSION < 12 or debug then
	dofile("Core/blockgameplay.lua")
    error("No Way? No Way!\nSRB2 version 2.2.12 or higher is required but was not found.\nLoad halted.", 0) return
end

/*
    How does this work?

    The key value [path] determines what path it uses
    when loading files

    the f variable is an array that holds the list of dirs
    example:
                if f = {"dir", "subdir", "subsubdir"}
            the resulting path will be "dir/subdir/subsubdir"
*/

local f={}

local function doDir(path, list, is_subdir)
    if is_subdir then
        table.insert(f, #f+1, path)
    else
        f = {path}
    end
    for _,entry in ipairs(list) do
        -- it's recursive! go in as many folders as you can handle!
        if type(entry) == "table" and entry.path then
            doDir(entry.path, entry, true)
            -- remove our directory from the path when done
            -- our directory should always be the last added. if it isn't something went very wrong
            table.remove(f, #f)
            -- don't run any other code past this check.
            continue
        end

        -- assemble the path
        local fp = ""
        for _,v in ipairs(f) do
            fp =  $..v.."/"
        end

        -- load the file from the full path
        dofile(fp..entry..".lua")
    end
end

local function readFileTable(table)
    for _,entry in ipairs(table) do
        -- is it a file list?
        if type(entry) == "table" then
            assert(entry.path, "ERROR: We can't load files from a dir with no path!")
            -- yea parse it as one
            doDir(entry.path, entry, false)
        -- well then is it a single file?
        elseif type(entry) == "string" then
            -- alrighty then dofile it
            dofile(entry..".lua")
        else -- we don't know what it is. throw a nonfatal error
            print("NONFATAL: filelist entry is not a table or a filename string?\nskipping...")
            continue
        end
    end
end

local filelist = {
    {
        path = "Core",
        "globals",
        -- custom save and unlock system
        {
            path = "savesystem",
			"GlobalBanks",
			"globalunlocks",
            --"debug",
        },
        -- Second quest
        "secondquest",
        -- Seasonal Events
        "time_events",
    },

    -- Contains everything related to the game hud
    {
        path = "HUD",
        "MRCEHUD",
        "ContLives",
        "NewEmblemHUD",
        "emeralds",
        "Intermission",
        "intermission_net",
        "titlecard-credits",
        "itemhud",
        "modernhack",
    },

    -- menu related scripts
    {
        path = "Menu",
        {
            path = "Title",
            "title_animation",
        },
        "episode_select",
        {
            path = "Extras",
            "credits"
        },
    },

    -- gameplay changes
    {
        path = "Gameplay",
        "ExAi",
        "jumpleniency",
        "RecodedMomentum",
        "STF",
        "cheatcodes",
        "charactersupport",
		"music",
        "KeepShield",
        {
            path = "Character",
            -- also loads hyper,superfloat,superattract
            "mrceplayer",
            "ReboundDash"
        },
        "mushroombounce",
        "xians-misc-stuff",
    },

    -- Level specific
    {
        path = "LevelSpecific",
        "DecoScaling",
		--"rad_autodec",
        "sandsnow",

        {
            path = "UtilityMap",
            "dontdraw",
			"random_title_sky",
        },
        {
            path = "Jade Coast",
            "JCZ_Deco",
			"JCZ_SegProps",
			"JCZ_Zipline",
			"MRCE_Hats",
			"UDMF_CustomSpawn",
        },
        {
            path = "midnightfreeze",
            "freezingwater",
            "NorthernLights",
            "snowywind",
            "snowboard",
        },
        {
            path = "Sunken Plant",
            "electricpipe",
        },
        {
            path = "Aerial Garden",
            "ExitStage",
            "portal",
            "LightTemple",
        },
        {
            path = "primordialabyss",
            "skychange",
        },
        {
            path = "dimensionwarp",
            "doomsday",
            "decay",
            "reveriefly",
            "HMScheat",
        },
        {
            path = "Emerald Stages",
            "emeralds",
            "Mystic_Shrines",
        },
    },

    -- Objects
    {
        path = "Objects",
        {
            path = "common",
            "forcerollsprings",
            "NewEmblems",
            "capsule",
            "superdiagspring",
            "hundringbox",
            "hyperstones",
			"flowbubble",
            "corona",
        },
        {
            path = "jcz",
            "CAKE",
            "speccy",
        },
        {
            path = "tvz",
            "slowgoop",
            --"Slime", -- code is wonky
        },
        {
            path = "frz",
            "torchkey",
        },
        {
            path = "mfz",
            "mfzicicles",
            "Cryocrawla",
        },
        {
            path = "agz",
            "vinespike",
            "hangglider",
            "KHZDeco",
            "emeralds",
        },
    },

    -- In Zone Order
    {
        path = "Enemies",
		"CustomSeed",

        {
            path = "TVZ",
            "Goopla",
            --"Octo", -- code is wonky
        },
        {
            path = "MFZ",
            --"iciclivore", -- incomplete, lacks planned custom behavior
        },
        {
            path = "SPZ",
            "DerelictCrawla",
        },
        {
            path = "AGZ",
            -- nerfed hive elementals
            "betterhiveelem",
        },
        {
            path = "PAZ",
            "angel",
        },
    },

    -- In Zone Order
    {
        path = "Bosses",
        "EggDecker",
        {
            path = "EggBaller",
            "Freeslot",
            "Helpers",
            "Boss",
        },
        "EggFreezer",
        "EggBomber",
        {
            path = "EggAnimus",
            "ondeath",
            {
                path = "DWZ",
                "eggmobileX",
            },
        },
    },
}
readFileTable(filelist)
