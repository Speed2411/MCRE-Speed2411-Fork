addHook("PlayerSpawn", function(p)
	if p and p.mo and p.mo.skin == "sms"  and (mapheaderinfo[gamemap].lvlttl == "Dimension Warp") then
	  if not (G_GametypeHasSpectators() or p.mo.battlemodsms) then
		local s = p.mo
		if not p.sms_transformstate and not p.hypermysticsonic and not p.spectator then
			A_TOGOEVENFURTHERBEYOND(s) //Use the build in transform function so SMS settings may apply
			if p.hypermysticsonic then //Success?
				p.xtralife = 9
				p.mo.hmscheatactive = 2
				if (p.rings < 50) then
					p.rings = 46
				end
				if mapheaderinfo[gamemap] and mapheaderinfo[gamemap].startrings then //Silly hack to get around startrings limitation
					for d = 0, 250, 1 do
						P_SpawnMobj(s.x, s.y, s.z, MT_RING)
					end
				end
				p.hypermysticsonic = 50
				s.state = S_PLAY_WALK
			end
		end
	  end
	end
end, MT_PLAYER)

addHook("PlayerThink", function(p) //Sigh. Sigh. Siiiiigh.
	if p.mo and p.mo.hmscheatactive then
		local s = p.mo
		s.hmscheatactive = $-1
		if not p.hypermysticsonic and p.mo.skin == "sms" then
			if not (G_GametypeHasSpectators() or p.mo.battlemodsms) then
				if not p.sms_transformstate and not p.spectator then
					A_TOGOEVENFURTHERBEYOND(s)
					if p.hypermysticsonic then
						p.xtralife = 9
						if (p.rings < 50) then
							p.rings = 46
						end
						if mapheaderinfo[gamemap] and mapheaderinfo[gamemap].startrings then
							for d = 0,250, 1 do
								P_SpawnMobj(s.x, s.y, s.z, MT_RING)
							end
						end
						p.hypermysticsonic = 50
						s.state = S_PLAY_WALK
					end
				end
			end
		end
	end
end)