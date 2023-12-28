freeslot(
	"MT_JCZCAKE",
	"S_CAKE1",
	"S_CAKE2",
	"S_CAKE3",
	"S_CAKE4",
	"SPR_CAKE",
	"sfx_cake"
)

mobjinfo[MT_JCZCAKE] = {
//$Name JCZ Cake
//$Category Mystic Realm Special
//$Sprite CAKEA0
doomednum = 2333,
spawnstate = S_CAKE1,
spawnhealth = 1000,
radius = 20*FRACUNIT,
height = 24*FRACUNIT,
speed = 8,
flags = MF_SOLID|MF_PUSHABLE
}

states[S_CAKE1].sprite = SPR_CAKE
states[S_CAKE1].frame = A
states[S_CAKE1].tics = -1
states[S_CAKE1].nextstate = S_NULL

states[S_CAKE2].sprite = SPR_CAKE
states[S_CAKE2].frame = A
states[S_CAKE2].tics = -1
states[S_CAKE2].nextstate = S_NULL

states[S_CAKE3].sprite = SPR_CAKE
states[S_CAKE3].frame = A|FF_ANIMATE
states[S_CAKE3].var1 = 6
states[S_CAKE3].var2 = 1
states[S_CAKE3].tics = 7
states[S_CAKE3].nextstate = S_CAKE4

states[S_CAKE4].sprite = SPR_CAKE
states[S_CAKE4].frame = G
states[S_CAKE4].tics = -1
states[S_CAKE4].nextstate = S_NULL

addHook("MobjThinker", function(mo)
	mo.shadowscale = 5*FRACUNIT/4
	
	if (mo.state == S_CAKE2)
	and P_IsObjectOnGround(mo) == true then
		mo.state = S_CAKE3
		S_StartSound(mo, sfx_cake)
		mo.height = 17*FRACUNIT
	end
	if P_IsObjectOnGround(mo) == false
	and not (mo.state == S_CAKE3) and not (mo.state == S_CAKE4) then
		mo.state = S_CAKE2
	end
end, MT_JCZCAKE)