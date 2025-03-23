extends State

@onready var hit_timer: Timer = $HitTimer
var connect_hit: bool

func enter():
	owner.speed = 0
	owner.velocity.x = 0
	owner.RCChkFront.enabled = false
	owner.RCChkGround.enabled = false
	owner.RCChkBack.enabled = false

	if not owner.anim.is_connected("animation_finished", on_animation_finished):
		owner.anim.animation_finished.connect(on_animation_finished)

	owner.anim.play("TakeHit")

	if not connect_hit:
		connect_hit = true
		hit_timer.timeout.connect(hit_timeout)

func on_animation_finished(anim_name):
	if anim_name == "TakeHit":
		hit_timer.stop()
		if owner.health <= 0:
			changeState("Dead")
			#print("nibba is dead")
		else:
			changeState("Idle")

func hit_timeout():
	changeState("Idle")

func exit():
	owner.RCChkFront.enabled = true
	owner.RCChkGround.enabled = true
	owner.RCChkBack.enabled = true
	owner.isHurt = false  
	connect_hit = false
	hit_timer.timeout.disconnect(hit_timeout)
