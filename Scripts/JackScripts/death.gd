extends State

func enter():
	owner.anim.play("Death")
	await owner.anim.animation_finished
	owner.velocity = Vector2.ZERO
	owner.gravity = owner.original_gravity
	await get_tree().create_timer(1.75).timeout
	if owner.is_dead:
		owner._die()
