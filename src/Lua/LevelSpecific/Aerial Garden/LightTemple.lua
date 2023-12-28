--Temple of Light in Starlight Palace
addHook("ThinkFrame", function()
	if mapheaderinfo[gamemap].lvlttl != "Starlight Palace" then return end
	if mrce_hyperstones == 7 then
		P_LinedefExecute(12)
	end
end)