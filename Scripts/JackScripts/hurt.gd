extends State

@onready var hit_timer: Timer = $HurtTimer
var connect_hit: bool

func enter():
	owner.speed = 0
	owner.velocity.x = 0
	$"../../AttackBox/Attack1".set_deferred("disabled", true)
	$"../../AttackBox/Attack2".set_deferred("disabled", true)
	$"../../AttackBox/Attack3".set_deferred("disabled", true)
	$"../../AttackBox/AirAttack".set_deferred("disabled", true)

	GameManager.frame_freeze(0.2,0.2)
	
	if not owner.anim.is_connected("animation_finished", on_animation_finished):
		owner.anim.animation_finished.connect(on_animation_finished)
	owner.ui.health_bar.value = GameManager.HP

	owner.anim.play("Hurt")

	if not connect_hit:
		connect_hit = true
		hit_timer.timeout.connect(hit_timeout)

func on_animation_finished(anim_name):
	if anim_name == "Hurt":
		hit_timer.stop()
		if GameManager.HP <= 0:
			owner.is_dead = true
			changeState("Death")
		else:
			changeState("Idle")

func hit_timeout():
	changeState("Idle")

func exit():
	owner.is_hurt = false  
	connect_hit = false
	owner.speed = owner.original_speed
	
	hit_timer.timeout.disconnect(hit_timeout)
