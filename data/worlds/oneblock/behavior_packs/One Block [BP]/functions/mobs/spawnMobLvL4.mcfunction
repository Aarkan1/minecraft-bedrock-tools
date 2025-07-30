

	function setRandomNumber

	execute @s[scores={eob_rand=0..43}] 0 61 0 summon cat 0 61 0
	execute @s[scores={eob_rand=44..257}] 0 61 0 summon llama 0 61 0
	execute @s[scores={eob_rand=258..365}] 0 61 0 summon sniffer 0 61 0
	execute @s[scores={eob_rand=366..473}] 0 61 0 summon donkey 0 61 0
	execute @s[scores={eob_rand=474..689}] 0 61 0 summon villager 0 61 0
	execute @s[scores={eob_rand=690..700}] 0 61 0 summon iron_golem 0 61 0
	execute @s[scores={eob_rand=701..916}] 0 61 0 summon axolotl 0 61 0
	execute @s[scores={eob_rand=917..1024}] ~ ~ ~ function mobs/spawnCommonHostileMob