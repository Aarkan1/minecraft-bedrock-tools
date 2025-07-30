
	scoreboard players add @a eob_blocks_mined 1
	setblock 0 60 0 barrier
	

	function showTitle


	# special blocks reserved for special chests
	execute @a[scores={eob_blocks_mined=3}] ~ ~ ~ tag @a add special_block
	execute @a[scores={eob_blocks_mined=3}] ~ ~ ~ function chests/spawnChest
	
	execute @a[scores={eob_blocks_mined=250}] ~ ~ ~ tag @a add special_block
	execute @a[scores={eob_blocks_mined=250}] ~ ~ ~ function chests/spawnSpecialChest1
	
	execute @a[scores={eob_blocks_mined=2153}] ~ ~ ~ tag @a add special_block
	execute @a[scores={eob_blocks_mined=2153}] ~ ~ ~ function chests/spawnSpecialChest4
	
	
	execute @a[scores={eob_blocks_mined=7001..}] ~ ~ ~ tag @a add special_block
	execute @a[scores={eob_blocks_mined=7001..}] ~ ~ ~ function blocks/spawnBlock
	execute @a[scores={eob_blocks_mined=7001}] ~ ~ ~ function blocks/spawnEndPortal
	

	# regular blocks
	execute @a[tag=!special_block] ~ ~ ~ function eventDecider
	
	
	tag @a remove special_block