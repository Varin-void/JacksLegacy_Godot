extends State
@export var dashspeed: float = 900

var dash_timer

func enter():
	dash_cooldown()
	dash_timer = get_tree().create_timer(0.30)
	dash_timer.timeout.connect(_on_dash_timer_timeout)

	owner.setAbilty("Dashing", true)
	owner.resetSpeed(dashspeed)
	owner.anim.play("DashV2")
	
func update(_delta):

	if Input.is_action_just_pressed("jump"):
		changeState("Jump")

func physicsUpdate(_delta):
	fnDash()

func fnDash():
	owner.velocity.x = (-1 if owner.sprite.flip_h else 1) * owner.speed
	owner.velocity.y = 0

func resetDash():
	if dash_timer:
		dash_timer.timeout.disconnect(_on_dash_timer_timeout)
	owner.setAbilty("Dashing", false)
	owner.resetSpeed(owner.original_speed)

func _on_dash_timer_timeout():
	resetDash()
	if owner.is_on_floor():
		changeState("Idle")
	else:
		changeState("Falling")

func dash_cooldown():
	owner.canDash = false
	await get_tree().create_timer(owner.dashCD).timeout
	owner.canDash = true
