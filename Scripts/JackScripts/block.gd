extends State

var connected = false

func enter():
	owner.setAbilty("Blocking", true)
	owner.resetSpeed(0)
	owner.anim.speed_scale = 0.8
	owner.anim.play("Blocking")
	owner.is_blocking = true

func update(_delta):
	if Input.is_action_just_released("block"):
		owner.anim.speed_scale = 1
		owner.anim.play("end_blocking")
		await owner.anim.animation_finished
		changeState("Idle")
	elif Input.is_action_just_pressed("attack_swing"):
		owner.speed = owner.original_speed
		changeState("Attack")

func on_animation_finish(animName):
	print("kkkkkkkkkkk")
	if animName == "Blocking":
		owner.anim.play("end_blocking")
	else:
		owner.speed = owner.original_speed
		changeState("Idle")

func exit():
	owner.anim.speed_scale = 1
	owner.speed = owner.original_speed
	owner.setAbilty("Blocking", false)
	owner.is_blocking = false
	
	#if not connected:
		#connected = true
		#owner.anim.animation_finished.connect(on_animation_finish)
