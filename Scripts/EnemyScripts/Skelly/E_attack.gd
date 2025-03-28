extends State
@onready var attack_timer: Timer = $AttackTimer

func enter():
	if owner.health <= 0:  # Check for death before attacking
		owner.isDead = true
		changeState("Dead")
		return

	if attack_timer.is_stopped():
		owner.velocity.x = 0
		owner.anim.play("Attack")
		
		attack_timer.start() 
		await attack_timer.timeout

		if owner.health <= 0:  # Re-check after attack
			owner.isDead = true
			changeState("Dead")
		else:
			changeState("Idle")


func exit():
	if owner.health <= 0 and !owner.isDead:
		owner.isDead = true
		changeState("Dead")
