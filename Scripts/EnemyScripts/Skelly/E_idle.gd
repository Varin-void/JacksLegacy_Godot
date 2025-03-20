extends State

func enter():
	owner.anim.play("Idle")
	owner.speed = 0
	owner.velocity.x = 0

func physicsUpdate(_delta):
	if(owner.player):
		owner.rotateToPlayer()
		if owner.enemyType == owner.EnemyType.Fixed:
			#changeState("Attack")
			print("attack state")
		else:
			#if(owner.RCDown.is_colliding()):
			changeState("Combat")
