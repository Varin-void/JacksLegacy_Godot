extends State

func enter():
	owner.anim.play("Death")
	await owner.anim.animation_finished
	await get_tree().create_timer(1.5).timeout
	if owner.is_dead:
		owner._die()
