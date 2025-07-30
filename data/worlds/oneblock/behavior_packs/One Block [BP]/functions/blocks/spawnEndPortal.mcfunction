


	execute @a ~ ~ ~ tp @a 0 61 0
	
	execute @a ~ ~ ~ fill ~1 ~ ~1 ~1 ~ ~-1 air
	execute @a ~ ~ ~ fill ~-1 ~ ~1 ~-1 ~ ~-1 air
	execute @a ~ ~ ~ fill ~ ~ ~1 ~ ~ ~1 air
	execute @a ~ ~ ~ fill ~ ~ ~-1 ~ ~ ~-1 air

	execute @a ~ ~ ~ fill ~1 ~-1 ~1 ~1 ~-1 ~-1 air
	execute @a ~ ~ ~ fill ~-1 ~-1 ~1 ~-1 ~-1 ~-1 air
	execute @a ~ ~ ~ fill ~ ~-1 ~1 ~ ~-1 ~1 air
	execute @a ~ ~ ~ fill ~ ~-1 ~-1 ~ ~-1 ~-1 air

	execute @a ~ ~ ~ fill ~2 ~-2 ~2 ~-2 ~-2 ~-2 air
	
	execute @a ~ ~ ~ fill ~2 ~-2 ~1 ~2 ~-2 ~-1 end_portal_frame 1 destroy
    execute @a ~ ~ ~ fill ~-2 ~-2 ~1 ~-2 ~-2 ~-1 end_portal_frame 3 destroy
    execute @a ~ ~ ~ fill ~1 ~-2 ~2 ~-1 ~-2 ~2 end_portal_frame 2 destroy
    execute @a ~ ~ ~ fill ~1 ~-2 ~-2 ~-1 ~-2 ~-2 end_portal_frame 0 destroy
    execute @a ~ ~ ~ fill ~-1 ~-3 ~-1 ~1 ~-3 ~1 end_bricks
	

	execute @a ~ ~ ~ title @a title §r 
	execute @a ~ ~ ~ title @a subtitle §5§lThe End Portal has spawned!
	execute @a ~ ~ ~ playsound mob.enderdragon.growl @s ~ ~ ~ 0.3
	execute @a ~ ~ ~ effect @a blindness 5 1 true
	execute @a ~ ~ ~ effect @a slowness 5 10 true

