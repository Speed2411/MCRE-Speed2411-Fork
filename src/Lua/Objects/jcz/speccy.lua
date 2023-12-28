local function SafeFreeslot(...)
	for _, item in ipairs({...}) do
		if rawget(_G, item) == nil then
			freeslot(item)
		end
	end
end

SafeFreeslot(
"SKINCOLOR_SPECCY"
)

skincolors[SKINCOLOR_SPECCY] = {
	name = "Speccy",
	ramp = {22,22,23,23,24,24,25,25,26,26,27,27,27,28,28,29},
	invcolor = SKINCOLOR_WHITE,
	invshade = 2,
	chatcolor = V_GREYMAP,
	accessible = true
}

addHook("MobjSpawn", function(speccy)
	speccy.scale = (FRACUNIT*13) / 20
	speccy.color = SKINCOLOR_SPECCY
	if gamemap != 101 then
		speccy.flags = MF_SLIDEME|MF_SOLID|MF_PUSHABLE
	end
end, MT_SPECCY)