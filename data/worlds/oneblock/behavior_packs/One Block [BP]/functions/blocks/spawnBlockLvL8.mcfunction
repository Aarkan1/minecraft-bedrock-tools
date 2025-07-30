

execute @a ~ ~ ~ function setRandomNumber

execute @s[scores={eob_rand=0..148}] 0 60 0 setblock 0 60 0 snow 0 replace
execute @s[scores={eob_rand=149..298}] 0 60 0 setblock 0 60 0 ice 0 replace
execute @s[scores={eob_rand=299..598}] 0 60 0 setblock 0 60 0 packed_ice 0 replace
#execute @s[scores={eob_rand=449..598}] 0 60 0 setblock 0 60 0 frosted_ice 0 replace
execute @s[scores={eob_rand=599..748}] 0 60 0 setblock 0 60 0 blue_ice 0 replace
execute @s[scores={eob_rand=749..823}] 0 60 0 setblock 0 60 0 grass 0 replace
execute @s[scores={eob_rand=824..973}] 0 60 0 setblock 0 60 0 log 1 replace
execute @s[scores={eob_rand=974..1024}] ~ ~ ~ function blocks/spawnBlockLvL7