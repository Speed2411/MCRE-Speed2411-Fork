local function axisMovement(mobj)
	if (mobj.tracer) then
		local ax = mobj.tracer
		if (ax.type == MT_AXISTRANSFERLINE) then
			--testing for now
			local ang = R_PointToAngle2(ax.x,ax.y,mobj.x,mobj.y)
			local axdist = R_PointToDist2(ax.x,ax.y,mobj.x,mobj.y)
			
			P_InstaThrust(mobj,ax.angle,mobj.speed)
			if (ang - ax.angle > ANG10) then
				P_TryMove(mobj,
						ax.x + cos(ang - 1) * axdist, 
						ax.x + sin(ang - 1) * axdist)
			elseif (ang - ax.angle < -ANG10) then
				P_TryMove(mobj,
						ax.x + cos(ang + 1) * axdist, 
						ax.x + sin(ang + 1) * axdist)
			end
		elseif (ax.type == MT_AXIS) then
		
			local curspeed = FixedHypot(mobj.momx, mobj.momy)
			local destspeed = mobj.rotatespeed
			
			if (curspeed != destspeed) then
				if not destspeed then
					mobj.momx = 0
					mobj.momy = 0
				elseif not curspeed then
					mobj.momx = 2 * cos(mobj.angle)
					mobj.momy = 2 * sin(mobj.angle)
				else
					mobj.momx = FixedDiv(FixedMul($, destspeed), curspeed)
					mobj.momy = FixedDiv(FixedMul($, destspeed), curspeed)
				end
			end
			
			local angle = R_PointToAngle2(ax.x, ax.y, mobj.x, mobj.y)
			local newmag = R_PointToDist2(0, 0, mobj.momx, mobj.momy)
			local oldmag = R_PointToAngle2(0, 0, mobj.momx, mobj.momy)-angle
			if oldmag > 0 then
				oldmag = ANGLE_90
			else
				oldmag = -ANGLE_90
			end
			P_InstaThrust(mobj, angle+oldmag, newmag)
		
			local rad = ax.radius
			local distfactor = FixedDiv(rad, R_PointToDist2(ax.x,ax.y,mobj.x,mobj.y))
			local ang = R_PointToAngle2(ax.x, ax.y, mobj.x, mobj.y) + ANGLE_90;
			local newx = ax.x + FixedMul(mobj.x - ax.x, distfactor);
			local newy = ax.y + FixedMul(mobj.y - ax.y, distfactor);
			
			P_TryMove(mobj, newx, newy)
		end
	end
end

rawset(_G, "P_AxisMovement", axisMovement)