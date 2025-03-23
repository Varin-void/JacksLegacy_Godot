extends State

func enter():
	owner.isDead = true
	owner.anim.play("Death")
	await owner.anim.animation_finished
	owner.visible = false
	owner.isInactive = true
	#owner.reparent($DeadEnemies)
