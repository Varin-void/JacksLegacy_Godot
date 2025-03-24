extends State

func enter():
	owner.anim.play("Death")
	await owner.anim.animation_finished
	if owner.is_dead:
		owner._die()
