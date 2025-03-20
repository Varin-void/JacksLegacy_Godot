extends State

func enter():
	owner.anim.play("Attack")
	await owner.anim.animation_finished
	print("done")
	changeState("Idle")
