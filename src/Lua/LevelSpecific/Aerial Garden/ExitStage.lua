addHook("PlayerSpawn", function(p)
  p.BCZ2rallied = 0
end)

addHook("LinedefExecute", function(line, mo)
	if not (netgame and mo.player) then return end
	local p = mo.player
	p.BCZ2rallied = 1
	for p2 in players.iterate do
		if p2 ~= p and p2.mo and p2.BCZ2rallied == 0 then
			P_SetOrigin(p2.mo, mo.x, mo.y, mo.z)
			CONS_Printf(p2,p.name.." has reached the end of the level, so you were teleported to them.")
			p2.BCZ2rallied = 1
		end
	end
end,"END_LEVEL")