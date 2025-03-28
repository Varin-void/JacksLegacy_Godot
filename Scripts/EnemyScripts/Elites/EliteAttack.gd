extends State
@onready var attack_timer: Timer = $AttackTimer
var attack_name
#func enter():
	#owner.velocity.x = 0
	#attack_name = fsm.getState("Combat").randomAttack
	#
	#if attack_timer.is_stopped():
		#if !attack_name:
			#attack_name = "Attack3"
		#owner.anim.play(attack_name)
		#await owner.anim.animation_finished
		#
		#attack_timer.start()
		#await attack_timer.timeout
		#changeState("Idle")
func enter():
	if owner.health <= 0:  # Check for death before attacking
		owner.isDead = true
		changeState("Dead")
		return

	if attack_timer.is_stopped():
		owner.velocity.x = 0
		attack_name = fsm.getState("Combat").randomAttack
		
		if !attack_name:
			attack_name = "Attack3"
		owner.anim.play(attack_name)
		await owner.anim.animation_finished
		
		attack_timer.start()
		await attack_timer.timeout

		if owner.health <= 0:
			owner.isDead = true
			changeState("Dead")
		else:
			changeState("Idle")

func exit():
	$"../../prop/AttackBox/CollisionShape2D".call_deferred("set", "disabled", true)
