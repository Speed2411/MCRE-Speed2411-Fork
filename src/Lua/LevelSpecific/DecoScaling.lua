addHook("MapThingSpawn", function(mo, mt)
    if (mo == nil) or (mt == nil) then return end
    
    if (mo.flags & MF_SCENERY) and (mapheaderinfo[gamemap].fakeudmf != nil) then
        local s = mapheaderinfo[gamemap].fakeudmf * mt.extrainfo
        if mt.extrainfo == 0 then
            s = 100
        end
        mo.scale = ($ * s) / 100
        mo.destscale = mo.scale
    end
	if (mo.type == MT_GREENFLAME) and gamemap == 121 then
		mo.scale = ($ * 5)
	end
end)
