// To prevent duplicate freeslots
local function CheckSlot(item) // this function deliberately errors when a freeslot does not exist
	if _G[item] == nil then // this will error by itself for states and objects
		error() // this forces an error for sprites, which do actually return nil for some reason
	end
end

local function SafeFreeslot(...)
	local item = ...
	if item == nil then
		return
	end
	
	if pcall(CheckSlot, item) then
		print("\131NOTICE:\128 " .. item .. " was not allocated, as it already exists.")
	else
		freeslot(item)
	end
	
	SafeFreeslot(select(2, ...))
end

SafeFreeslot(
	"MT_BIGBUBBLEPATCH",
	"S_BIGBUBBLEPATCH",
	"MT_BIGFLOWBUBBLE",
	"S_BIGFLOWBUBBLE0",
	"S_BIGFLOWBUBBLE1",
	"S_BIGFLOWBUBBLE2",
	"S_BIGFLOWBUBBLE3"
)


function A_BigBubbleSpawner(actor, var1, var2)
	A_BubbleCheck(actor, 0, 0)
	if (actor.tracer) and (actor.tracer.valid) then
		actor.tracer.momz = ($*95)/100
		return
	end
	if (actor.eflags & MFE_UNDERWATER) then
		local bubble = P_SpawnMobj(actor.x, actor.y, actor.z, MT_BIGFLOWBUBBLE)
		bubble.scale = 0
		bubble.destscale = FRACUNIT
		bubble.scalespeed = FRACUNIT/35
		bubble.momz = 2*FRACUNIT
		actor.tracer = bubble
	end



end

mobjinfo[MT_BIGFLOWBUBBLE] = {
spawnstate = S_BIGFLOWBUBBLE0,
deathstate = S_BIGFLOWBUBBLE3,
reactiontime = 16,
speed = 10*FRACUNIT,
radius = 64*FRACUNIT,
height = 64*FRACUNIT,
damage = 3,
spawnhealth = 0,
dispoffset = 0,
flags = MF_NOGRAVITY,
}

states[S_BIGFLOWBUBBLE0] = {
sprite = SPR_BUBS,
frame = J|FF_ANIMATE|FF_GLOBALANIM,
var1 = 2,
var2 = 6,
tics = 35,
nextstate = S_BIGFLOWBUBBLE1
}


states[S_BIGFLOWBUBBLE1] = {
sprite = SPR_BUBS,
frame = J,
action = A_SetObjectFlags,
var1 =  MF_SPECIAL|MF_NOGRAVITY,
tics = 0,
nextstate = S_BIGFLOWBUBBLE2
}

states[S_BIGFLOWBUBBLE2] = {
sprite = SPR_BUBS,
frame = J|FF_ANIMATE|FF_GLOBALANIM,
action = A_BubbleCheck,
var1 = 2,
var2 = 6,
tics = 1,
nextstate = S_BIGFLOWBUBBLE2
}



states[S_BIGFLOWBUBBLE3] = {
sprite = SPR_BUBS,
frame = J,
action = A_CapeChase,
var1 = 26<<16,
tics = 1,
nextstate = S_BIGFLOWBUBBLE3
}

mobjinfo[MT_BIGBUBBLEPATCH] = {
//$Name Flow Bubble
//$Category Generic Items & Hazards
//$Sprite BBLSA0
spawnstate = S_BIGBUBBLEPATCH,
reactiontime = 16,
speed = 10*FRACUNIT,
radius = 32*FRACUNIT,
height = 32*FRACUNIT,
damage = 3,
spawnhealth = 0,
dispoffset = 0,
doomednum = 1515,
flags = MF_NOBLOCKMAP
}


states[S_BIGBUBBLEPATCH] = {
sprite = SPR_BBLS,
frame = A|FF_ANIMATE|FF_GLOBALANIM,
action = A_BigBubbleSpawner,
var1 = 3,
var2 = 6,
tics = 1,
nextstate = S_BIGBUBBLEPATCH
}



addHook("TouchSpecial", function(actor, toucher)
	if (toucher.player) and (toucher.eflags & MFE_UNDERWATER) then
		if (toucher.player.powers[pw_shield] & SH_PROTECTWATER) or MRCE_isHyper(toucher.player) then return true end
		toucher.state = S_PLAY_GASP
		toucher.player.powers[pw_underwater] = underwatertics
		P_RestoreMusic(toucher.player)
		actor.fuse = 10
		//actor.scalespeed = FRACUNIT/20
		actor.destscale = 0
		S_StartSound(toucher, sfx_gasp)
	end

end, MT_BIGFLOWBUBBLE)
