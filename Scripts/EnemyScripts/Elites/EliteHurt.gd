extends State

@onready var hit_timer: Timer = $HitTimer
var connect_hit: bool = false

func enter():
	owner.speed = 0
	owner.velocity.x = 0
	owner.RCChkFront.enabled = false
	owner.RCChkGround.enabled = false
	owner.RCChkBack.enabled = false

	if not owner.anim.is_connected("animation_finished", on_animation_finished):
		owner.anim.animation_finished.connect(on_animation_finished)

	if owner.enemyClass == owner.EnemyClass.EliteGolem:
		owner.anim.play("GTakeHit")
	else:
		owner.anim.play("TakeHit")

	if not connect_hit:
		connect_hit = true
		if not hit_timer.timeout.is_connected(hit_timeout):
			hit_timer.timeout.connect(hit_timeout)

func on_animation_finished(anim_name):
	if anim_name == "TakeHit" or anim_name == "GTakeHit":
		if owner.isDead:
			return
		hit_timer.start()

func hit_timeout():
	if owner.isDead:  # If dead, stay in Dead state
		return
	owner.speed = owner.orgChaseSpeed
	changeState("Patrol")  # Resume normal behavior

func exit():
	owner.RCChkFront.enabled = true
	owner.RCChkGround.enabled = true
	owner.RCChkBack.enabled = true
	
	owner.isHurt = false
	connect_hit = false

	if hit_timer.timeout.is_connected(hit_timeout):
		hit_timer.timeout.disconnect(hit_timeout)
	if !owner.player:
		owner.player = get_tree().get_first_node_in_group("Player")
	if owner.material and owner.material is ShaderMaterial:
		owner.material.set_shader_parameter("hit_effect", 0.0)
