

	function setRandomNumber

	execute @s[scores={eob_rand=0..46}] 0 60 0 replaceitem block 0 60 0 slot.container 0 bone 3 0
	execute @s[scores={eob_rand=47..90}] 0 60 0 replaceitem block 0 60 0 slot.container 2 spider_eye 2 0
	execute @s[scores={eob_rand=91..137}] 0 60 0 replaceitem block 0 60 0 slot.container 4 emerald 3 0
	execute @s[scores={eob_rand=138..184}] 0 60 0 replaceitem block 0 60 0 slot.container 6 sand 10 0
	execute @s[scores={eob_rand=185..285}] 0 60 0 replaceitem block 0 60 0 slot.container 5 sand 10 0
	execute @s[scores={eob_rand=286..363}] 0 60 0 replaceitem block 0 60 0 slot.container 20 sand 10 0
	execute @s[scores={eob_rand=364..464}] 0 60 0 replaceitem block 0 60 0 slot.container 8 bucket 1 8
	execute @s[scores={eob_rand=465..511}] 0 60 0 replaceitem block 0 60 0 slot.container 13 deadbush 2 0

	execute @s[scores={eob_rand=512..1024}] 0 60 0 function chests/putItemInChest3