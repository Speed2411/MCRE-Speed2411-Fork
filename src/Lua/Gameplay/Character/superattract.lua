//Ring Attraction function based upon P_Attract from source.
local function SuperAttract(source, dest)
	local dist = 0
	local ndist = 0
	local speedmul = 0
	local tx = dest.x
	local ty = dest.y
	local tz = dest.z + (dest.height/2)
	local xydist = P_AproxDistance(tx - source.x, ty - source.y)
	if dest and dest.health and dest.valid and dest.type == MT_PLAYER then
		source.angle = R_PointToAngle2(source.x, source.y, tx, ty)
		dist = P_AproxDistance(xydist, tz - source.z)
		if (dist < 1) then
			dist = 1
		end
		speedmul = P_AproxDistance(dest.momx, dest.momy) + FixedMul(source.info.speed, source.scale)
		source.momx = FixedMul(FixedDiv(tx - source.x, dist), speedmul)
		source.momy = FixedMul(FixedDiv(ty - source.y, dist), speedmul)
		source.momz = FixedMul(FixedDiv(tz - source.z, dist), speedmul)
		ndist = P_AproxDistance(P_AproxDistance(tx - (source.x + source.momx), ty - (source.y+source.momy)), tz - (source.z+source.momz))
		if (ndist > dist) then
			source.momx = 0
			source.momy = 0
			source.momz = 0
			P_MoveOrigin(source, tx, ty, tz)
		end
	end
end

addHook("MobjThinker", function(ring)
    if ring and ring.valid and ring.health > 0 then
        local soup
        for p in players.iterate do
            if p and p.valid and ((MRCE_isHyper(p)) or (mapheaderinfo[gamemap].lvlttl == "Dimension Warp"))  and R_PointToDist2(p.mo.x, p.mo.y, ring.x, ring.y) <= (RING_DIST/5) and abs(ring.z - p.mo.z) < (RING_DIST/5) then
                soup = p.mo
            end
        end
        if soup then
            local momRing = P_SpawnMobjFromMobj(ring, 0,0,0, MT_FLINGRING)
            momRing.followmo = soup
            P_RemoveMobj(ring)
        end
    end
end, MT_RING)

addHook("MobjThinker", function(ring)
    if ring and ring.valid and ring.health > 0 and ring.followmo and ring.followmo.valid then
        if R_PointToDist2(ring.followmo.x, ring.followmo.y, ring.x, ring.y) <= RING_DIST/2 and abs(ring.z - ring.followmo.z) < RING_DIST/2 then
			SuperAttract(ring, ring.followmo)
        else
            ring.fuse = 5*TICRATE
        end
        if ring.fuse == 2 then
            P_SpawnMobjFromMobj(ring, 0,0,0, MT_RING)
            P_RemoveMobj(ring)
        end
    end
end, MT_FLINGRING)
