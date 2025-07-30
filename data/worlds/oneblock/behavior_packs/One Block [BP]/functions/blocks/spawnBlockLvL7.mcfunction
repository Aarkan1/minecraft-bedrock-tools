

execute @a ~ ~ ~ function setRandomNumber

execute @s[scores={eob_rand=0..497}] 0 60 0 setblock 0 60 0 grass 0 replace
execute @s[scores={eob_rand=498..673}] 0 60 0 setblock 0 60 0 log 0 replace
execute @s[scores={eob_rand=674..849}] 0 60 0 setblock 0 60 0 log 3 replace
execute @s[scores={eob_rand=850..925}] 0 60 0 setblock 0 60 0 cocoa 0 replace
execute @s[scores={eob_rand=926..976}] 0 60 0 setblock 0 60 0 melon_block 0 replace
execute @s[scores={eob_rand=977..1024}] ~ ~ ~ function blocks/spawnBlockLvL6