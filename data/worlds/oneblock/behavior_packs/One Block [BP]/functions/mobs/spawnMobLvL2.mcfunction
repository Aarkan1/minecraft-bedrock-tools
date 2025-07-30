

	function setRandomNumber

	execute @s[scores={eob_rand=0..252}] 0 61 0 summon zombie 0 61 0
	execute @s[scores={eob_rand=253..469}] 0 61 0 summon panda 0 61 0
	execute @s[scores={eob_rand=470..686}] 0 61 0 summon glow_squid 0 61 0
	execute @s[scores={eob_rand=687..863}] 0 61 0 summon frog 0 61 0
	execute @s[scores={eob_rand=864..972}] 0 61 0 summon sniffer 0 61 0
	execute @s[scores={eob_rand=973..1024}] ~ ~ ~ function mobs/spawnCommonHostileMob