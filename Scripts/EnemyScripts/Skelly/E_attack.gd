extends State
@onready var attack_timer: Timer = $AttackTimer

func enter():
	if attack_timer.is_stopped():
		owner.anim.play("Attack")
		await owner.anim.animation_finished
		
		attack_timer.start() 
		await attack_timer.timeout
		changeState("Idle")
