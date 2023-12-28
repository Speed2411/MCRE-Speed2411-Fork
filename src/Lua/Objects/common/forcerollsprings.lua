freeslot(
	-- Mobjs
	"MT_BROSPRING", "MT_YROSPRING", "MT_RROSPRING",

	-- Blue spring
	"S_BROSPRING1", "S_BROSPRING2", "S_BROSPRING3",
	"S_BROSPRING4", "S_BROSPRING5", "S_BROSPRING6",
	"S_BROSPRING7", "S_BROSPRING8",

	-- Yellow spring
	"S_YROSPRING1", "S_YROSPRING2", "S_YROSPRING3",
	"S_YROSPRING4", "S_YROSPRING5", "S_YROSPRING6",
	"S_YROSPRING7", "S_YROSPRING8",

	-- Red spring
	"S_RROSPRING1", "S_RROSPRING2", "S_RROSPRING3",
	"S_RROSPRING4", "S_RROSPRING5", "S_RROSPRING6",
	"S_RROSPRING7", "S_RROSPRING8",

	-- Sprites
	"SPR_SBSP", "SPR_SYSP", "SPR_SRSP"
)

addHook("MobjCollide", function(spring, plmo)
    if not (plmo and plmo.valid) then return end
    if not plmo.player then return end
	if spring.z <= plmo.z + plmo.height
	and spring.z + spring.height >= plmo.z then
		plmo.player.pflags = $|PF_SPINNING
		plmo.state = S_PLAY_ROLL
	end
end, MT_BROSPRING)

addHook("MobjCollide", function(spring, plmo)
    if not (plmo and plmo.valid) then return end
    if not plmo.player then return end
	if spring.z <= plmo.z + plmo.height
	and spring.z + spring.height >= plmo.z then
		plmo.player.pflags = $|PF_SPINNING
		plmo.state = S_PLAY_ROLL
	end
end, MT_YROSPRING)

addHook("MobjCollide", function(spring, plmo)
    if not (plmo and plmo.valid) then return end
    if not plmo.player then return end
	if spring.z <= plmo.z + plmo.height
	and spring.z + spring.height >= plmo.z then
		plmo.player.pflags = $|PF_SPINNING
		plmo.state = S_PLAY_ROLL
	end
end, MT_RROSPRING)