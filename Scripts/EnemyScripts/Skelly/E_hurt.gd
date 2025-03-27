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

	if owner.enemyClass == owner.EnemyClass.Golem:
		owner.anim.play("GTakeHit")
		
	else:
		owner.anim.play("TakeHit")

	if not connect_hit:
		connect_hit = true
		hit_timer.timeout.connect(hit_timeout)

func on_animation_finished(anim_name):
	if anim_name == "TakeHit" or anim_name == "GTakeHit":
		
		hit_timer.stop()
		if owner.health <= 0:
			owner.isDead = true
			changeState("Dead")
		else:
			changeState("Patrol")

func hit_timeout():
	owner.speed = owner.orgChaseSpeed
	changeState("Patrol")

func exit():
	owner.RCChkFront.enabled = true
	owner.RCChkGround.enabled = true
	owner.RCChkBack.enabled = true
	owner.isHurt = false  
	connect_hit = false
	hit_timer.timeout.disconnect(hit_timeout)
