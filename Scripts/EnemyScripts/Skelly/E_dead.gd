extends State

func enter():
	owner.anim.play("Death")
	await owner.anim.animation_finished
	owner.visible = false
	owner.reparent($DeadEnemies)
