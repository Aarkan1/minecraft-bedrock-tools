

	function setRandomNumber

	execute @s[scores={eob_rand=0..11}] 0 61 0 summon cat 0 61 0
	execute @s[scores={eob_rand=12..100}] 0 61 0 summon mooshroom 0 61 0
	execute @s[scores={eob_rand=101..201}] 0 61 0 summon sheep 0 61 0
	execute @s[scores={eob_rand=202..302}] 0 61 0 summon pig 0 61 0
	execute @s[scores={eob_rand=303..403}] 0 61 0 summon chicken 0 61 0
	execute @s[scores={eob_rand=404..504}] 0 61 0 summon cow 0 61 0
	execute @s[scores={eob_rand=505..600}] 0 61 0 summon villager 0 61 0
	execute @s[scores={eob_rand=601..677}] 0 61 0 summon evocation_illager 0 61 0
	execute @s[scores={eob_rand=678..788}] 0 61 0 summon vindicator 0 61 0
	execute @s[scores={eob_rand=789..800}] 0 61 0 summon witch 0 61 0
	execute @s[scores={eob_rand=801..912}] 0 61 0 summon zombie_villager 0 61 0
	execute @s[scores={eob_rand=913..1024}] ~ ~ ~ function mobs/spawnCommonHostileMob