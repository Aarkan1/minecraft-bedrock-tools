

execute @a ~ ~ ~ function setRandomNumber

execute @s[scores={eob_rand=0..606}] 0 60 0 setblock 0 60 0 stone 0 replace
execute @s[scores={eob_rand=607..667}] 0 60 0 setblock 0 60 0 stone 1 replace
execute @s[scores={eob_rand=668..728}] 0 60 0 setblock 0 60 0 stone 3 replace
execute @s[scores={eob_rand=729..789}] 0 60 0 setblock 0 60 0 bamboo_planks 5 replace
execute @s[scores={eob_rand=790..850}] 0 60 0 setblock 0 60 0 gravel 0 replace
execute @s[scores={eob_rand=851..911}] 0 60 0 setblock 0 60 0 bamboo_block 0 replace
execute @s[scores={eob_rand=912..972}] 0 60 0 setblock 0 60 0 iron_ore 0 replace
execute @s[scores={eob_rand=973..1024}] ~ ~ ~ function blocks/spawnBlockLvL1
