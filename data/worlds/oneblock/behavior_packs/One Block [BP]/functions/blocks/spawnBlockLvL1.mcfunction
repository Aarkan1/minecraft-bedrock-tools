

execute @a ~ ~ ~ function setRandomNumber

execute @s[scores={eob_rand=1..820}] 0 60 0 setblock 0 60 0 grass 0 replace
execute @s[scores={eob_rand=821..910}] 0 60 0 setblock 0 60 0 log 0 replace
execute @s[scores={eob_rand=911..1000}] 0 60 0 setblock 0 60 0 log2 0 replace
execute @s[scores={eob_rand=1001..1024}] 0 60 0 setblock 0 60 0 cherry_planks 0 replace