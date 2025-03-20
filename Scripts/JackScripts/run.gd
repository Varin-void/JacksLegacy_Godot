extends State
const animation:String = "Run"

func changeToStateRoot():
	changeState("Run")

func enter():
	owner.anim.play("Run")

func update(_delta):
	if !owner.direction:
		changeState("Idle")
	
	if owner.is_on_floor():
		if Input.is_action_just_pressed("jump"):
			changeState("Jump")
		if Input.is_action_just_pressed("attack_swing"):
			changeState("Attack")
		if Input.is_action_just_pressed("attack_swing_heavy"):
			changeState("Heavy_Attack")
		if Input.is_action_just_pressed("move_dash") and owner.canDash:
			changeState("Dash")
	else:
		changeState("Falling")

func physicsUpdate(_delta):
	snap_floor_movement()

func snap_floor_movement():
	if owner.is_on_floor() and owner.get_floor_angle()>0.7:
		owner.anim.speed_scale=.7
		owner.apply_floor_snap()
	else:
		owner.anim.speed_scale=1
