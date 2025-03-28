extends State
@onready var timer: Timer = $"../../Timer"

func enter():
	owner.anim.play("Idle")
	owner.speed = 0
	owner.velocity.x = 0
	
	#if !owner.isDead and timer.is_stopped():
		#timer.start(4.0)

func physicsUpdate(_delta):
	if(owner.player) and !owner.isDead:
		owner.rotateToPlayer()
		if owner.enemyType == owner.EnemyType.Fixed:
			pass
		else:
			changeState("Combat")
	else:
			changeState("Patrol")
		

func exit():
	timer.stop()
