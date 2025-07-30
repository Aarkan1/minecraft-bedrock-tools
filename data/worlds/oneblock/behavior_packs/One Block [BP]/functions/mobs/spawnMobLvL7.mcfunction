
	function setRandomNumber

	execute @s[scores={eob_rand=0..68}] 0 61 0 summon sheep 0 61 0
	execute @s[scores={eob_rand=69..122}] 0 61 0 summon pig 0 61 0
	execute @s[scores={eob_rand=123..233}] 0 61 0 summon chicken 0 61 0
	execute @s[scores={eob_rand=234..344}] 0 61 0 summon cow 0 61 0
	execute @s[scores={eob_rand=345..455}] 0 61 0 summon parrot 0 61 0
	execute @s[scores={eob_rand=456..566}] 0 61 0 summon ocelot 0 61 0
	execute @s[scores={eob_rand=567..677}] 0 61 0 summon panda 0 61 0
	execute @s[scores={eob_rand=678..778}] 0 61 0 summon villager 0 61 0
	execute @s[scores={eob_rand=779..1024}] ~ ~ ~ function mobs/spawnCommonHostileMob