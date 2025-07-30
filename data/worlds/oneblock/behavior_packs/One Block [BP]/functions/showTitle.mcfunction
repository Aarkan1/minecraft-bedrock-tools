
	### TUTORIAL ###
	execute @a[scores={eob_blocks_mined=0}] ~ ~ ~ title @a title §r§f§l 
	execute @a[scores={eob_blocks_mined=0}] ~ ~ ~ titleraw @a subtitle {"rawtext": [{"translate":"eob.text.tutorial_1"}]}

	#execute @a[scores={eob_blocks_mined=0}] ~ ~ ~ title @a title §b§lOne Block Survival
	#execute @a[scores={eob_blocks_mined=0}] ~ ~ ~ title @a subtitle by §2§o§lEmily Wilkins
	execute @a[scores={eob_blocks_mined=1}] ~ ~ ~ say §b§lOne Block Survival §r§fby §2§o§lEmily Wilkins
	execute @a[scores={eob_blocks_mined=1}] ~ ~ ~ tellraw @a {"rawtext": [{"translate":"eob.text.map.description"}]}
	execute @a[scores={eob_blocks_mined=0}] ~ ~ ~ tellraw @a {"rawtext": [{"translate":"eob.text.map.promo"}]}
	execute @a[scores={eob_blocks_mined=500}] ~ ~ ~ playsound random.levelup @s ~ ~ ~

	
	
	### LEVEL 1 ###
	execute @a[scores={eob_blocks_mined=2}] ~ ~ ~ titleraw @a title {"rawtext": [{"translate":"eob.text.level1.title"}]}
	execute @a[scores={eob_blocks_mined=2}] ~ ~ ~ titleraw @a subtitle {"rawtext": [{"translate":"eob.text.level1.subtitle"}]}
	execute @a[scores={eob_blocks_mined=2}] ~ ~ ~ playsound fall.grass @s ~ ~ ~
	execute @a[scores={eob_blocks_mined=2}] ~ ~ ~ playsound use.grass @s ~ ~ ~
	execute @a[scores={eob_blocks_mined=2}] ~ ~ ~ playsound dig.wood @s ~ ~ ~
	
	
	### LEVEL 2 ###
	execute @a[scores={eob_blocks_mined=251}] ~ ~ ~ titleraw @a title {"rawtext": [{"translate":"eob.text.level2.title"}]}
	execute @a[scores={eob_blocks_mined=251}] ~ ~ ~ titleraw @a subtitle {"rawtext": [{"translate":"eob.text.level2.subtitle"}]}
	execute @a[scores={eob_blocks_mined=251}] ~ ~ ~ playsound dig.grass @s ~ ~ ~
	execute @a[scores={eob_blocks_mined=251}] ~ ~ ~ playsound dig.stone @s ~ ~ ~
	execute @a[scores={eob_blocks_mined=251}] ~ ~ ~ playsound dig.stone @s ~ ~ ~
	
	
	### LEVEL 3 ###
	execute @a[scores={eob_blocks_mined=652}] ~ ~ ~ titleraw @a title {"rawtext": [{"translate":"eob.text.level3.title"}]}
	execute @a[scores={eob_blocks_mined=652}] ~ ~ ~ titleraw @a subtitle {"rawtext": [{"translate":"eob.text.level3.subtitle"}]}
	execute @a[scores={eob_blocks_mined=652}] ~ ~ ~ playsound dig.stone @s ~ ~ ~
	execute @a[scores={eob_blocks_mined=652}] ~ ~ ~ summon bat 0 61 0
	execute @a[scores={eob_blocks_mined=652}] ~ ~ ~ summon bat 0 61 0
	execute @a[scores={eob_blocks_mined=652}] ~ ~ ~ summon bat 0 61 0
	#execute @a[scores={eob_blocks_mined=652}] ~ ~ ~ playsound dig.stone @s ~ ~ ~
	#execute @a[scores={eob_blocks_mined=652}] ~ ~ ~ playsound dig.stone @s ~ ~ ~
	#execute @a[scores={eob_blocks_mined=652}] ~ ~ ~ playsound random.break @s ~ ~ ~
	
	
	### LEVEL 4 ###
	execute @a[scores={eob_blocks_mined=1353}] ~ ~ ~ titleraw @a title {"rawtext": [{"translate":"eob.text.level4.title"}]}
	execute @a[scores={eob_blocks_mined=1353}] ~ ~ ~ titleraw @a subtitle {"rawtext": [{"translate":"eob.text.level4.subtitle"}]}
	execute @a[scores={eob_blocks_mined=1353}] ~ ~ ~ playsound step.sand @s ~ ~ ~
	execute @a[scores={eob_blocks_mined=1353}] ~ ~ ~ playsound dig.sand @s ~ ~ ~
	execute @a[scores={eob_blocks_mined=1353}] ~ ~ ~ playsound dig.sand @s ~ ~ ~
	execute @a[scores={eob_blocks_mined=1353}] ~ ~ ~ playsound mob.husk.ambient @s ~ ~ ~
	
	
	### LEVEL 5 ###
	execute @a[scores={eob_blocks_mined=2154}] ~ ~ ~ titleraw @a title {"rawtext": [{"translate":"eob.text.level5.title"}]}
	execute @a[scores={eob_blocks_mined=2154}] ~ ~ ~ titleraw @a subtitle {"rawtext": [{"translate":"eob.text.level5.subtitle"}]}
	execute @a[scores={eob_blocks_mined=2154}] ~ ~ ~ playsound mob.drowned.step @s ~ ~ ~

	
	### LEVEL 6 ###
	execute @a[scores={eob_blocks_mined=2955}] ~ ~ ~ titleraw @a title {"rawtext": [{"translate":"eob.text.level6.title"}]}
	execute @a[scores={eob_blocks_mined=2955}] ~ ~ ~ titleraw @a subtitle {"rawtext": [{"translate":"eob.text.level6.subtitle"}]}
	execute @a[scores={eob_blocks_mined=2955}] ~ ~ ~ playsound liquid.water @s ~ ~ ~
	execute @a[scores={eob_blocks_mined=2955}] ~ ~ ~ playsound cauldron.fillwater @s ~ ~ ~
	execute @a[scores={eob_blocks_mined=2955}] ~ ~ ~ playsound bucket.fill_water @s ~ ~ ~
	
	
	### LEVEL 7 ###
	execute @a[scores={eob_blocks_mined=3756}] ~ ~ ~ titleraw @a title {"rawtext": [{"translate":"eob.text.level7.title"}]}
	execute @a[scores={eob_blocks_mined=3756}] ~ ~ ~ titleraw @a subtitle {"rawtext": [{"translate":"eob.text.level7.subtitle"}]}
	execute @a[scores={eob_blocks_mined=3756}] ~ ~ ~ playsound mob.ocelot.idle @s ~ ~ ~
	execute @a[scores={eob_blocks_mined=3756}] ~ ~ ~ playsound mob.parrot.fly @s ~ ~ ~
	execute @a[scores={eob_blocks_mined=3756}] ~ ~ ~ playsound mob.parrot.fly @s ~ ~ ~
	
	
	### LEVEL 8 ###
	execute @a[scores={eob_blocks_mined=4557}] ~ ~ ~ titleraw @a title {"rawtext": [{"translate":"eob.text.level8.title"}]}
	execute @a[scores={eob_blocks_mined=4557}] ~ ~ ~ titleraw @a subtitle {"rawtext": [{"translate":"eob.text.level8.subtitle"}]}
	execute @a[scores={eob_blocks_mined=4557}] ~ ~ ~ playsound step.snow @s ~ ~ ~
	execute @a[scores={eob_blocks_mined=4557}] ~ ~ ~ playsound mob.polarbear.idle @s ~ ~ ~
	
	
	### LEVEL 9 ###
	execute @a[scores={eob_blocks_mined=5358}] ~ ~ ~ titleraw @a title {"rawtext": [{"translate":"eob.text.level9.title"}]}
	execute @a[scores={eob_blocks_mined=5358}] ~ ~ ~ titleraw @a subtitle {"rawtext": [{"translate":"eob.text.level9.subtitle"}]}
	execute @a[scores={eob_blocks_mined=5358}] ~ ~ ~ playsound mob.ghast.moan @s ~ ~ ~
	execute @a[scores={eob_blocks_mined=5358}] ~ ~ ~ playsound mob.zombiepig.zpig @s ~ ~ ~
	execute @a[scores={eob_blocks_mined=5358}] ~ ~ ~ playsound mob.zombiepig.zpig @s ~ ~ ~
	
	
	### LEVEL 10 ###
	execute @a[scores={eob_blocks_mined=6259}] ~ ~ ~ titleraw @a title {"rawtext": [{"translate":"eob.text.level10.title"}]}
	execute @a[scores={eob_blocks_mined=6259}] ~ ~ ~ titleraw @a subtitle {"rawtext": [{"translate":"eob.text.level10.subtitle"}]}
	execute @a[scores={eob_blocks_mined=6259}] ~ ~ ~ playsound mob.enderdragon.growl @s ~ ~ ~ 0.1