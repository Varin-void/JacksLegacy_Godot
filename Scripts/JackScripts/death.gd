extends State

func enter():
	owner.anim.play("Death")
	await owner.anim.animation_finished
	await get_tree().create_timer(2.5).timeout
	get_tree().reload_current_scene()
