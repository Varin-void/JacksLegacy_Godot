extends State

var connected = false
@onready var animator = $"../../AnimationPlayer"

var action_pressed = false
var att_count:int = 1
var combo_timer: Timer
var is_air_attack = false
var air_attack_count = 0
const MAX_AIR_ATTACKS = 3
var att_name : String = "Attack1"

func enter():
	owner.blockflip = true
	owner.velocity.x = 0
	action_pressed = false
	owner.setAbilty("Attacking", true)
	owner.anim.speed_scale = 1
	
	if !owner.heavy_att:
		comboAtt()
		
		if combo_timer == null:
			combo_timer = Timer.new()
			combo_timer.wait_time = 1.25
			combo_timer.one_shot = true
			combo_timer.timeout.connect(on_combo_timeout)
			add_child(combo_timer)
		
		combo_timer.start()
	else:
		is_air_attack = false
		air_attack_count = 0
		animator.play("Attack3")
		await animator.animation_finished
		changeState("Idle")

	if not connected:
		connected = true
		owner.anim.animation_finished.connect(on_animation_finish)

func update(_delta: float):
	if Input.is_action_just_pressed("attack_swing"):
		action_pressed = true
	
func exit():
	if !owner.heavy_att:
		owner.setAbilty("Attacking", false)
		owner.setAbilty("Air_Attacking",false)
		owner.attack_input = true
		owner.blockflip = false
		att_count = 1
		combo_timer.stop()
		$"../../AttackBox/AirAttack".disabled = true
	else:
		owner.speed = owner.original_speed
		owner.blockflip = false
		owner.setAbilty("Attacking", false)
		owner.heavy_att = false
#func exit():
	#if !owner.heavy_att:
		#owner.setAbilty("Attacking", false)
		#owner.setAbilty("Air_Attacking",false)
		#owner.attack_input = true
		#owner.blockflip = false
		#att_count = 1
		#if combo_timer != null:
			#combo_timer.stop()
		#$"../../AttackBox/AirAttack".disabled = true
	#else:
		#owner.speed = owner.original_speed
		#owner.blockflip = false
		#owner.setAbilty("Attacking", false)
		#owner.heavy_att = false

func on_combo_timeout():
	att_count = 1
	changeState("Idle")

func comboAtt():
	if owner.is_on_floor():
		is_air_attack = false
		animator.play("Attack" + str(att_count))
		att_name = "Attack" + str(att_count)
	else:
		is_air_attack = true
		air_attack_count += 1
		
		if air_attack_count > MAX_AIR_ATTACKS:
			changeState("Falling")
			is_air_attack = false
			return
		
		animator.play("AirAttack")
		owner.setAbilty("Air_Attacking", true)
		att_name = "AirAttack"
		owner.velocity.y = 0

func on_animation_finish(animName):
	if is_air_attack:
		att_count = 1
		changeState("Falling")
	else:
		if animName == "Attack"+str(att_count):
			if action_pressed and att_count < 2:
				att_count += 1
				att_name = "Attack"+str(att_count)  
				animator.play(att_name)
				
				action_pressed = false
				combo_timer.start()
			else:
				att_count = 1
				changeState("Idle")

func _on_attack_box_body_entered(body: Node2D) -> void:
	if body.is_in_group("Enemy"):
		body.take_dmg(att_name,owner.global_position)
