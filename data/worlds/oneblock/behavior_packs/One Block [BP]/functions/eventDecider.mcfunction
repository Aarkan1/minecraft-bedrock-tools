
	scoreboard players random @a eob_rand 1 7000
	
	execute @s[scores={eob_rand=6900..7000}] ~ ~ ~ function mobs/spawnMob
	execute @s[scores={eob_rand=1..6837}] ~ ~ ~ function blocks/spawnBlock
	execute @s[scores={eob_rand=6838..6888}] ~ ~ ~ function chests/spawnChest
	execute @s[scores={eob_rand=6889..6896}] ~ ~ ~ function chests/spawnSuperChest
	execute @s[scores={eob_rand=6897..6899}] ~ ~ ~ function chests/spawnRareChest