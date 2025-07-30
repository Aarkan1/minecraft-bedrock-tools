

	function setRandomNumber

	execute @s[scores={eob_rand=0..252}] 0 61 0 summon camel 0 61 0
	execute @s[scores={eob_rand=253..469}] 0 61 0 summon pig 0 61 0
	execute @s[scores={eob_rand=470..686}] 0 61 0 summon axolotl 0 61 0
	execute @s[scores={eob_rand=687..863}] 0 61 0 summon allay 0 61 0
	execute @s[scores={eob_rand=864..972}] 0 61 0 summon pig 0 61 0
	execute @s[scores={eob_rand=973..1024}] ~ ~ ~ function mobs/spawnCommonHostileMob