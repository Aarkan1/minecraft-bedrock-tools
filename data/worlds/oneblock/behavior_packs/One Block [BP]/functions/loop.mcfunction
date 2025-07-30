
	### Main loop function, executes every tick
	

	# Initialization for new players
	execute @a ~ ~ ~ function main

	
	# On block mined
	execute @a ~ ~ ~ detect 0 60 0 air 0 function onBlockMined

	
	# TP falling items on top of the block
	execute @e[type=item,x=0,y=60,z=0,r=2] ~ ~ ~ teleport 0 61 0