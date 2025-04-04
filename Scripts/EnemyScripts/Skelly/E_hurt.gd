#extends State
#
#@onready var hit_timer: Timer = $HitTimer
#var connect_hit: bool
#
#func enter():
	#owner.speed = 0
	#owner.velocity.x = 0
	#owner.RCChkFront.enabled = false
	#owner.RCChkGround.enabled = false
	#owner.RCChkBack.enabled = false
	#
#
	#if not owner.anim.is_connected("animation_finished", on_animation_finished):
		#owner.anim.animation_finished.connect(on_animation_finished)
#
	#if owner.enemyClass == owner.EnemyClass.Golem:
		#owner.anim.play("GTakeHit")
		#
	#else:
		#owner.anim.play("TakeHit")
#
	#if not connect_hit:
		#connect_hit = true
		#hit_timer.timeout.connect(hit_timeout)
#
#func on_animation_finished(anim_name):
	#if anim_name == "TakeHit" or anim_name == "GTakeHit":
		#
		#hit_timer.stop()
		#if owner.health <= 0:
			#owner.isDead = true
			#changeState("Dead")
			#return
		#else:
			#changeState("Patrol")
#
#func hit_timeout():
	#owner.speed = owner.orgChaseSpeed
	#changeState("Patrol")
#
#func exit():
	#owner.RCChkFront.enabled = true
	#owner.RCChkGround.enabled = true
	#owner.RCChkBack.enabled = true
	#owner.isHurt = false  
	#connect_hit = false
	#hit_timer.timeout.disconnect(hit_timeout)
#
#extends State
#
#@onready var hit_timer: Timer = $HitTimer
#var connect_hit: bool = false
#
#func enter():
	#owner.speed = 0
	#owner.velocity.x = 0
	#owner.RCChkFront.enabled = false
	#owner.RCChkGround.enabled = false
	#owner.RCChkBack.enabled = false
#
	## Immediately check for death before doing anything else
	#if owner.health <= 0:
		#owner.isDead = true
		#changeState("Dead")
		#return
#
	#if owner.enemyClass == owner.EnemyClass.Golem:
		#owner.anim.play("GTakeHit")
	#else:
		#owner.anim.play("TakeHit")
	#
	#if not owner.anim.is_connected("animation_finished", on_animation_finished):
		#owner.anim.animation_finished.connect(on_animation_finished)
	#
	#if not connect_hit:
		#connect_hit = true
		#if not hit_timer.timeout.is_connected(hit_timeout):
			#hit_timer.timeout.connect(hit_timeout)
#
#func on_animation_finished(anim_name):
	#if anim_name == "TakeHit" or anim_name == "GTakeHit":
		#hit_timer.start()
#
#func hit_timeout():
	#if owner.health<=0:
		#owner.isDead = true
		#changeState("Dead")
	#else:
		#owner.speed = owner.orgChaseSpeed
		#changeState("Patrol")  # Resume normal behavior
#
#func exit():
	#owner.RCChkFront.enabled = true
	#owner.RCChkGround.enabled = true
	#owner.RCChkBack.enabled = true
	#owner.isHurt = false  
	#connect_hit = false
	#
	## Safely disconnect hit_timer to avoid duplicate connections
	#if hit_timer.timeout.is_connected(hit_timeout):
		#hit_timer.timeout.disconnect(hit_timeout)
extends State
@onready var hit_timer = $HitTimer
var connect_hit:bool
@export var hit_sound:AudioStream
@export var hit_particle:GPUParticles2D
func enter():
	if !owner.anim.is_connected("animation_finished",on_animation_finished):
		owner.anim.animation_finished.connect(on_animation_finished)
	
	owner.speed=0
	owner.velocity.x=0
	
	if !connect_hit:
		connect_hit=true
		hit_timer.timeout.connect(hit_timeout)
	
	if owner.enemyClass == owner.EnemyClass.Golem:
		owner.anim.play("GTakeHit")
	else:
		owner.anim.play("TakeHit")

func exit():
	connect_hit = false
	hit_timer.timeout.disconnect(hit_timeout)
	
func on_animation_finished(anim_name):
	if owner.anim.is_connected("animation_finished",on_animation_finished):
		owner.anim.animation_finished.disconnect(on_animation_finished)
	hit_timer.stop()
	hit_timer.start()
	
func hit_timeout():
	if owner.health<=0:
		changeState("Dead")
	else:
		changeState("Idle")
