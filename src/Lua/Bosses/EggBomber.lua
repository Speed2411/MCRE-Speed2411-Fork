freeslot("MT_EBOMB")
addHook("ShouldDamage", function(target, inflictor, source, damage, damagetype)
    if inflictor.type == MT_SHOCKWAVE or inflictor.type == MT_FLINGRING or inflictor.type == MT_EBOMB then
        return false
    end
end, MT_EGGEBOMBER)

addHook("MobjSpawn", function(m)
	m.samusHP = 4
	m.plasmaresist = true
	m.waveresist = true
end, MT_EGGEBOMBER)