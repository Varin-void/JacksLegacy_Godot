extends State

func enter():
	owner.anim.play("Idle")
	owner.speed = 0
	owner.velocity.x = 0

func physicsUpdate(_delta):
	if(owner.player) and !owner.isDead:
		owner.rotateToPlayer()
		changeState("Combat")
	else:
		changeState("Patrol")
