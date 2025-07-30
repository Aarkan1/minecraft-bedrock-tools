
	function setRandomNumber

	execute @s[scores={eob_rand=0..14}] 0 61 0 summon iron_golem 0 61 0
	execute @s[scores={eob_rand=15..89}] 0 61 0 summon fox 0 61 0
	execute @s[scores={eob_rand=90..164}] 0 61 0 summon polar_bear 0 61 0
	execute @s[scores={eob_rand=165..239}] 0 61 0 summon wolf 0 61 0
	execute @s[scores={eob_rand=240..312}] 0 61 0 summon sheep 0 61 0
	execute @s[scores={eob_rand=313..387}] 0 61 0 summon pig 0 61 0
	execute @s[scores={eob_rand=388..462}] 0 61 0 summon chicken 0 61 0
	execute @s[scores={eob_rand=463..537}] 0 61 0 summon cow 0 61 0
	execute @s[scores={eob_rand=538..612}] 0 61 0 summon rabbit 0 61 0
	execute @s[scores={eob_rand=613..750}] 0 61 0 summon villager 0 61 0
	execute @s[scores={eob_rand=751..1024}] ~ ~ ~ function mobs/spawnCommonHostileMob