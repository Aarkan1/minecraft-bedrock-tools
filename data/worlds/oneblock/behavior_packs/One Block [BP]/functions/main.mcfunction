
# if eob_isNewPlayer > 1 then is not a new player and no need to init params
	scoreboard objectives add eob_isNewPlayer dummy
	scoreboard players add @a eob_isNewPlayer 1
	scoreboard players set @a[scores={eob_isNewPlayer=3..}] eob_isNewPlayer 3

	execute @a[scores={eob_isNewPlayer=2}] ~ ~ ~ function init