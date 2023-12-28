--[[
    Aerial Garden Hangglider

    This object is composed of 3 components
    - the main object (handles)
    - 2 panels acting as the visual glider portion

    (C) 2022-2023 by K. "ashifolfi" J.
]]

freeslot(
    "MT_HANGGLIDER",
    "S_HANGGLIDER",
    "S_HANGGLIDER_PANEL",

    "SPR_HGPN"
)

mobjinfo[MT_HANGGLIDER] = {
    --$Name HangGlider
    --$Category Aerial Garden Zone
    --$Sprite UNKNA0
    doomednum   = 1339,
    spawnstate  = S_HANGGLIDER,
    seestate    = S_HANGGLIDER,
    spawnhealth = 8,
    flags       = MF_NOGRAVITY
}

states[S_HANGGLIDER]        = {SPR_UNKN, A|FF_PAPERSPRITE, -1, nil, 0, 0, S_NULL}
states[S_HANGGLIDER_PANEL]  = {SPR_HGPN, A, -1, nil, 0, 0, S_NULL}

addHook("MobjSpawn", function(mo)
    mo.panels = {}

    for i=1,2 do
        local panel = P_SpawnMobjFromMobj(mo, 0, 0, 0, MT_THOK)
        panel.angle = mo.angle + ANGLE_90
        panel.tics = -1
        panel.sprite = SPR_HGPN
        panel.frame = i - 1
        panel.flags2 = $ | (MF2_SPLAT|MF2_LINKDRAW)
        panel.renderflags = $ | (RF_FLOORSPRITE|RF_SLOPESPLAT|RF_NOSPLATBILLBOARD|RF_NOSPLATROLLANGLE)
        panel.tracer = mo

        P_CreateFloorSpriteSlope(panel)

        panel.floorspriteslope.o = {x = panel.x, y = panel.y, z = panel.z}
        panel.xydirection = mo.angle
        panel.floorspriteslope.zangle = ANGLE_45

        table.insert(mo.panels, panel)
    end
end, MT_HANGGLIDER)

addHook("MobjThinker", function(mo)

    for _,panel in ipairs(mo.panels) do
        panel.angle = mo.angle + ANGLE_90

        panel.floorspriteslope.o = {x = panel.x, y = panel.y, z = panel.z}
        panel.floorspriteslope.xydirection = mo.angle
    end

end, MT_HANGGLIDER)