freeslot(
"SPR_UNCEMB",
"SPR_KEY0L",
"SPR_KEY1S",
"SPR_KEY2S",
"SPR_KEY3S",
"MT_FIRE_STONE",
"MT_WATER_STONE",
"MT_LIGHTNING_STONE"
)
local emblemlist = {}
local numembs = 0
local offset = 400
local offset2 = 360
local offsetresettimer = 0
local offsetresettimer2 = 0
local tabresettimer = 2
local touchedresettimer = 25
local tabMenuOpened = nil
local emblemsupdated = false

addHook("PostThinkFrame", function()
	if multiplayer then return end
	if emblemsupdated then return end
	numembs = 0
	emblemlist = {}
	for mapemblem in mobjs.iterate() do
		if mapemblem.valid and mapemblem.type == MT_EMBLEM then
			numembs = $ + 1
			local emblem = {frame = mapemblem.frame, color = mapemblem.color, origmobj = mapemblem}
			table.insert(emblemlist, emblem)
		end
	end
end)

addHook("PlayerSpawn", function()
	if multiplayer then return end
	emblemsupdated = false
end)

addHook("TouchSpecial", function(emblem, pmo)
	if multiplayer then return end
	pmo.player.changeoffset = 1
	offsetresettimer = touchedresettimer
end, MT_EMBLEM)

addHook("TouchSpecial", function(key, pmo)
	if multiplayer then return end
	pmo.player.changeoffset2 = 1
	offsetresettimer2 = touchedresettimer
end, MT_LIGHTNING_STONE)

addHook("TouchSpecial", function(key, pmo)
	if multiplayer then return end
	pmo.player.changeoffset2 = 1
	offsetresettimer2 = touchedresettimer
end, MT_FIRE_STONE)

addHook("TouchSpecial", function(key, pmo)
	if multiplayer then return end
	pmo.player.changeoffset2 = 1
	offsetresettimer2 = touchedresettimer
end, MT_WATER_STONE)

addHook("ThinkFrame", function()
	if multiplayer then return end
	for p in players.iterate do
		if not p.bot and p.valid then
			if tabMenuOpened == true then
				p.changeoffset = 1
				p.changeoffset2 = 1
				offsetresettimer = 2
				tabMenuOpened = false
			end
			if p.changeoffset then
				if offset > 210 then
					offset = $ - 10
				end
				if offset == 210 and offsetresettimer then
					offsetresettimer = $ - 1
				end
				if not offsetresettimer then
					p.changeoffset = 0
				end
			else
				if offset < 400 then
					offset = $ + 20
				end
			end
			if p.changeoffset2 then
				if offset2 > 280 then
					offset2 = $ - 10
				end
				if offset2 == 280 and offsetresettimer2 then
					offsetresettimer2 = $ - 1
				end
				if not offsetresettimer2 then
					p.changeoffset2 = 0
				end
			else
				if offset2 < 360 then
					offset2 = $ + 20
				end
			end
		end
	end
end)

hud.add(function(d, p)
	if multiplayer then return end
	if bonus_t.display then return end
	if usedCheats then return end
	local loffset = offset
	local soffset = offset2
	local bg = d.cachePatch("EMBBG")
	if numembs > 0 then
		d.drawScaled(loffset*(2*FRACUNIT/3) + (65*FRACUNIT), 17*FRACUNIT, 2*FRACUNIT/3, bg, V_SNAPTORIGHT|V_SNAPTOTOP)
	end
	d.drawScaled(soffset*(2*FRACUNIT/3) + (90*FRACUNIT), 36*FRACUNIT, 2*FRACUNIT/3, bg, V_SNAPTORIGHT|V_SNAPTOTOP)
	local uncollectedkey = d.cachePatch("KEY0L")
	local key1 = d.getSpritePatch("KYST", A)
	local key2 = d.getSpritePatch("KYST", B)
	local key3 = d.getSpritePatch("KYST", C)
	if not (GlobalBanks_Array[0] & (1 << (15))) then
		d.drawScaled((soffset*FRACUNIT + ((uncollectedkey.width / 6)*FRACUNIT) + 6*FRACUNIT), 39*FRACUNIT, FRACUNIT/3, uncollectedkey, V_SNAPTORIGHT|V_SNAPTOTOP, emblemcolor)
	else
		d.drawScaled((soffset*FRACUNIT + ((key1.width / 6)*FRACUNIT) + 6*FRACUNIT), 39*FRACUNIT, FRACUNIT/3, key1, V_SNAPTORIGHT|V_SNAPTOTOP, emblemcolor)
	end
	if not (GlobalBanks_Array[0] & (1 << (16))) then
		d.drawScaled((soffset*FRACUNIT + ((uncollectedkey.width / 6)*FRACUNIT) + 18*FRACUNIT), 39*FRACUNIT, FRACUNIT/3, uncollectedkey, V_SNAPTORIGHT|V_SNAPTOTOP, emblemcolor)
	else
		d.drawScaled((soffset*FRACUNIT + ((key2.width / 6)*FRACUNIT) + 18*FRACUNIT), 39*FRACUNIT, FRACUNIT/3, key2, V_SNAPTORIGHT|V_SNAPTOTOP, emblemcolor)
	end
	if not (GlobalBanks_Array[0] & (1 << (17))) then
		d.drawScaled((soffset*FRACUNIT + ((uncollectedkey.width / 6)*FRACUNIT) + 30*FRACUNIT), 39*FRACUNIT, FRACUNIT/3, uncollectedkey, V_SNAPTORIGHT|V_SNAPTOTOP, emblemcolor)
	else
		d.drawScaled((soffset*FRACUNIT + ((key3.width / 6)*FRACUNIT) + 30*FRACUNIT), 39*FRACUNIT, FRACUNIT/3, key3, V_SNAPTORIGHT|V_SNAPTOTOP, emblemcolor)
	end
	for embnum, emblem in ipairs(emblemlist) do
		local emblempatch = d.getSpritePatch("EMBM", emblem.frame & FF_FRAMEMASK)
		local uncollectedemb = d.cachePatch("UNCEMB")
		local emblemcolor = d.getColormap(TC_DEFAULT, emblem.color)
		d.drawScaled((loffset*(2*FRACUNIT/3) + ((uncollectedemb.width / 6)*(10*FRACUNIT))), 20*FRACUNIT, FRACUNIT/3, uncollectedemb, V_SNAPTORIGHT|V_SNAPTOTOP, emblemcolor)
		if (emblem.frame & FF_TRANSMASK) or ((emblem.origmobj and (emblem.origmobj.flags2 & MF2_DONTDRAW)) or (not emblem.origmobj.valid)) then
			d.drawScaled((loffset*(2*FRACUNIT/3) + ((emblempatch.width / 6)*(10*FRACUNIT))), 20*FRACUNIT, FRACUNIT/3, emblempatch, V_SNAPTORIGHT|V_SNAPTOTOP, emblemcolor)
		end
		loffset = $ + 32
		soffset = $ + 32
	end
end, "game")

hud.add(function(d, p)
	tabMenuOpened = true
	offsetresettimer = tabresettimer
	offsetresettimer2 = tabresettimer
	if netgame then
		local key1 = d.cachePatch("KEY1S")
		local key2 = d.cachePatch("KEY2S")
		local key3 = d.cachePatch("KEY3S")
		if (mrce_hyperstones & (1 << (0))) then
			d.draw(20, 13, key1, V_SNAPTOLEFT|V_SNAPTOTOP)
		end
		if (mrce_hyperstones & (1 << (1))) then
			d.draw(30, 13, key2, V_SNAPTOLEFT|V_SNAPTOTOP)
		end
		if (mrce_hyperstones & (1 << (2))) then
			d.draw(40, 13, key3, V_SNAPTOLEFT|V_SNAPTOTOP)
		end
	end
end, "scores")
