

	execute @a ~ ~ ~ function setRandomNumber

	execute @s[scores={eob_rand=0..372}] 0 60 0 setblock 0 60 0 grass 0 replace
	execute @s[scores={eob_rand=373..747}] 0 60 0 setblock 0 60 0 podzol 0 replace
	execute @s[scores={eob_rand=748..822}] 0 60 0 setblock 0 60 0 clay 0 replace
	execute @s[scores={eob_rand=823..897}] 0 60 0 setblock 0 60 0 log 0 replace
	execute @s[scores={eob_rand=898..935}] 0 60 0 setblock 0 60 0 brown_mushroom_block 14 replace
	execute @s[scores={eob_rand=936..973}] 0 60 0 setblock 0 60 0 red_mushroom_block 14 replace
	execute @s[scores={eob_rand=974..1024}] ~ ~ ~ function blocks/spawnBlockLvL4