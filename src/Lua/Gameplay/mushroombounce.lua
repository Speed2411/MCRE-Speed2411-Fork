local function mushBounce(l,m,s)
	if not m.player then return end
	if not m.player.mrce then return end
	local boost = 1
	if (l.flags & ML_EFFECT2) and l.backside and l.backside.textureoffset then --cap max bounce height. does nothing with effect 1
		--print("textureoffset " .. l.backside.textureoffset)
		boost = max(m.player.mrce.oldz, (-1 * (l.backside.textureoffset)))
	else
		boost = m.player.mrce.oldz
	end
	--print("boost1 " .. boost)
	if (l.flags & ML_EFFECT1) then --should vert mom be added. If enabled effect 2 will do nothing
		P_SetObjectMomZ(m, (FixedHypot(l.dx, l.dy) / 5))
	else
		P_SetObjectMomZ(m, (FixedHypot(l.dx, l.dy) / 25) + (abs(boost) / (7/4)) + FRACUNIT)
	end
	if l.backside and l.backside.text then
		local soundtext = "sfx_" .. string.lower(l.backside.text)
		S_StartSound(m, _G[soundtext])
	else
		S_StartSound(m, sfx_s3k87)
	end
	if not (l.flags & ML_EFFECT3) then --should player be able to act out of a bounce
		m.player.pflags = $ | PF_JUMPED
		if (skins[m.skin].flags & SF_NOJUMPSPIN) then
			m.state = S_PLAY_SPRING
		else
			m.state = S_PLAY_JUMP
		end
	else
		m.state = S_PLAY_SPRING
	end
end

addHook("LinedefExecute", mushBounce, "MUSHBNC")

local function stairs(l,m,s)
	if not m.player then return end
	S_ChangeMusic("SCSTRS", true, m.player, 0, 0, 500, 800)
end

addHook("LinedefExecute", stairs, "INFSTAIR")

local function stairs(l,m,s)
	if not m.player then return end
	m.player.mrce.secmus = 10
end

addHook("LinedefExecute", stairs, "SECMUSIC")