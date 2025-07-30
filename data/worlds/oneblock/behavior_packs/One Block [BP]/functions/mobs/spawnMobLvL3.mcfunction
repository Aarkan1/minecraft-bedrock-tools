

	function setRandomNumber

	execute @s[scores={eob_rand=0..102}] 0 61 0 summon cave_spider 0 61 0
	execute @s[scores={eob_rand=103..1024}] ~ ~ ~ function mobs/spawnCommonHostileMob