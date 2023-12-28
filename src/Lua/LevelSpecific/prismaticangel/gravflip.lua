addHook("PlayerThink", function(p)
	if p.spectator then return end
	if not p.realmo then return end
    if (player.mo.eflags & MFE_VERTICALFLIP) and (player.pflags & PF_FLIPCAM) and mapheaderinfo[gamemap].lvlttl == "Prismatic Angel" then
        player.pflags = $ & ~PF_FLIPCAM
    end
end)