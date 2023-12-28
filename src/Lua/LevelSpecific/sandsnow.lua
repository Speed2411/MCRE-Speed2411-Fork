freeslot(
	"MT_AEZ_SNOWBIT",
	"S_AEZ_SNOWBIT",
	"SPR_SAFL",
	"sfx_safl1",
	"sfx_safl2",
	"sfx_safl3",
	"sfx_safl4"
)

mobjinfo[MT_AEZ_SNOWBIT] = {
        doomednum = -1,
        spawnstate = S_AEZ_SNOWBIT,
        radius = 8*FRACUNIT,
        height = 8*FRACUNIT,
        flags = MF_NOCLIPTHING
}

states[S_AEZ_SNOWBIT] = {
		sprite = SPR_SAFL,
		frame = A,
		tics = 6*TICRATE,
		nextstate = S_NULL
}

local sandtable = {
	["DCZFLR10"] = "sand",
	["LAKEFLR2"] = "sand",
	["LAKEFLR3"] = "sand",
	["DEM1_5"] = "sand",
	["DPSAND"] = "sand",
	["DPSAND2"] = "sand",
	["QUIK2"] = "sand",
	["QUIK3"] = "sand",
	["QUIK4"] = "sand",
	["QUIK5"] = "sand",
	["QUIK6"] = "sand",
	["QUIK7"] = "sand",
	["QUIKNOAN"] = "sand",
	["D2SANDV"] = "sand",
	["DSSANDV"] = "sand",
	["DUSTY01"] = "sand",
	["SANDWLL"] = "sand",
	["JCZSAND"] = "sand",
	["SPLNCNYN"] = "sand",
	["ACZWALN"] = "sand",
	["XMSFLR02"] = "snow",
	["SNOW01"] = "snow",
	["SNOW02"] = "snow",
	["SNOW03"] = "snow",
	["WHITE01"] = "snow",
	["WHITE02"] = "snow",
	["WHITE03"] = "snow",
	["WHITE04"] = "snow",
	["WHITE05"] = "snow",
	["MFFROSTW"] = "snow",
	["MFFROSTG"] = "snow"
}

addHook("PlayerThink", function(p)
	if not p then return end
	if not p.valid then return end
	local x = p.mrce

	local a = p.mo.subsector.sector.floorpic
	if p.mo.floorrover then
		a = p.mo.floorrover.toppic
	end

	/*for poly in polyobjects.iterate() do
		if poly and poly:mobjInside(p.mo) then
			a = poly.sector.floorpic
		end
	end*/

	--print(tostring(a))

	if P_IsObjectOnGround(p.mo) then
		for k, v in pairs(sandtable) do
			if a != k then continue end
			if (leveltime % 2 == 0 and x.realspeed > 12*FRACUNIT) or (p.panim == PA_ROLL and x.realspeed > 7*FRACUNIT) or (p.mo.state == S_PLAY_SKID) or (p.mo.state == S_PLAY_SPINDASH) then
				for i=1,p.mo.scale/FRACUNIT do
					local revang = p.drawangle + ANGLE_180
					local snow = P_SpawnMobjFromMobj(p.mo, P_RandomRange(-20, 20)*FRACUNIT, P_RandomRange(-20, 20)*FRACUNIT, 2*FRACUNIT, MT_AEZ_SNOWBIT)
					snow.scale = FRACUNIT
					snow.destscale = FRACUNIT
					snow.scalespeed = FRACUNIT
					P_InstaThrust(snow, revang+FixedAngle(P_RandomRange(-45, 45)*FRACUNIT), max(x.realspeed/6, p.dashspeed/8)*max(1, p.mo.scale/FRACUNIT/2))
					snow.momz = P_RandomRange(4, 8)*FRACUNIT*max(1, p.mo.scale/FRACUNIT/2)
					if v == "snow" then
						snow.colorized = true
						snow.color = SKINCOLOR_WHITE
					end
					if (leveltime % 4 == 0) then
						S_StartSound(snow, P_RandomRange(sfx_safl1, sfx_safl4), p)
					end
				end
			end
		end
	end
end)

addHook("MobjThinker", function(mo)
	if P_IsObjectOnGround(mo) then P_RemoveMobj(mo) end
end, MT_AEZ_SNOWBIT)

addHook("MobjSpawn", function(mo)
	mo.frame = P_RandomRange(0, 4)
end, MT_AEZ_SNOWBIT)