/*
	better hive elemental
	
	Changes the behavior of the hive elemental
	so that it only starts spawning more bees
	once 3 out of the 5 spawned are gone.

    Made by ashifolfi
*/

-- Modified variant of A_ParentTriesToSleep
function A_BeeCheck(actor, var1, var2)

	-- If extravalue1 is greater than 0 assume bees were killed
	if (actor.extravalue1) then
		-- If extravalue2 reads 1 then wait until 3 bees are gone
		-- before respawning them
		if (actor.extravalue2 == 1) then
		-- this assumes that we always use 5 which is a bad bad bad idea.
			if (actor.extravalue1 == 3) then
				actor.extravalue2 = 0
			end
		else
			if (actor.info.seesound) then
					S_StartSound(actor, actor.info.seesound)
			end
			actor.reactiontime = 0
			actor.state = var1
		end
	elseif (!actor.reactiontime) then
		actor.reactiontime = 1
		-- Used to prevent respawning bees right after they die
		actor.extravalue2 = 1
		if (actor.info.activesound) then -- more like INactivesound doy hoy hoy
			S_StartSound(actor, actor.info.activesound)
		end
	end
end

states[S_HIVEELEMENTAL_DORMANT] = {SPR_HIVE, A, 5, A_BeeCheck, S_HIVEELEMENTAL_PREPARE1, 0, S_HIVEELEMENTAL_DORMANT}
