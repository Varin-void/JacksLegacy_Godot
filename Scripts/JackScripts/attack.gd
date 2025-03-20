#extends State
#
#var connected = false
#@onready var animator = $"../../AnimationPlayer"
#
#var action_pressed = false
#var att_count:int = 1
#var combo_timer: Timer
#
#func enter():
	#owner.blockflip = true
	#owner.velocity.x = 0
	#animator.play("Attack"+str(att_count))
	#owner.attack_input = false
	#action_pressed = false
	#owner.setAbilty("Attacking", true)
	#owner.anim.speed_scale = 1
	#
	## Initialize combo time
	#if combo_timer == null:
		#combo_timer = Timer.new()
		#combo_timer.wait_time = 1.25
		#combo_timer.one_shot = true
		#combo_timer.timeout.connect(on_combo_timeout)
		#add_child(combo_timer)
	#
	#combo_timer.start()
#
	#if not connected:
		#connected = true
		#owner.anim.animation_finished.connect(on_animation_finish)
#
#func update(_delta: float):
	#if Input.is_action_just_pressed("attack_swing"):
		#action_pressed = true
#
#func exit():
	#owner.setAbilty("Attacking", false)
	#owner.attack_input = true
	#owner.blockflip = false
	#att_count = 1
	#combo_timer.stop()
#
#func on_animation_finish(animName):
	#if animName == "Attack"+str(att_count):
		#if action_pressed and att_count < 3:
			#att_count += 1
			#animator.play("Attack"+str(att_count))
			#action_pressed = false
			#combo_timer.start() # Restart combo timer
		#else:
			#att_count = 1
			#changeState("Idle") # Transition back to Idle
#
#func on_combo_timeout():
	#att_count = 1
	#changeState("Idle")
#
#func comboAtt():
	#if owner.is_on_floor():
		##if on floor play att1 att2 att3 animation
	#else:
		##play " air attack "animation

extends State

var connected = false
@onready var animator = $"../../AnimationPlayer"

var action_pressed = false
var att_count:int = 1
var combo_timer: Timer
var is_air_attack = false

func enter():
	owner.blockflip = true
	owner.velocity.x = 0
	action_pressed = false
	owner.setAbilty("Attacking", true)
	owner.anim.speed_scale = 1
	
	comboAtt()

	if combo_timer == null:
		combo_timer = Timer.new()
		combo_timer.wait_time = 1.25
		combo_timer.one_shot = true
		combo_timer.timeout.connect(on_combo_timeout)
		add_child(combo_timer)
	
	combo_timer.start()

	if not connected:
		connected = true
		owner.anim.animation_finished.connect(on_animation_finish)

func update(_delta: float):
	if Input.is_action_just_pressed("attack_swing"):
		action_pressed = true

func exit():
	owner.setAbilty("Attacking", false)
	owner.setAbilty("Air_Attacking",false)
	owner.attack_input = true
	owner.blockflip = false
	att_count = 1
	combo_timer.stop()

func on_animation_finish(animName):
	if is_air_attack:
		att_count = 1
		changeState("Falling")
	else:
		if animName == "Attack"+str(att_count):
			if action_pressed and att_count < 3:
				att_count += 1
				animator.play("Attack"+str(att_count))
				
				action_pressed = false
				combo_timer.start()
			else:
				att_count = 1
				changeState("Idle")

func on_combo_timeout():
	att_count = 1
	changeState("Idle")

func comboAtt():
	if owner.is_on_floor():
		is_air_attack = false
		animator.play("Attack"+str(att_count))
	else:
		is_air_attack = true
		animator.play("AirAttack")
		owner.setAbilty("Air_Attacking",true)
		owner.velocity.y = 0
