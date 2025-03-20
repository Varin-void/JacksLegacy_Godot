extends State
const animation: String = "Idle"

func changeToStateRoot():
	changeState("Idle")

func enter():
	owner.anim.play("Idle")

func update(_delta):
	if owner.direction:
		changeState("Run")
	
	if owner.is_on_floor():
		if Input.is_action_just_pressed("jump"):
			changeState("Jump")
		elif Input.is_action_just_pressed("attack_swing"):
			changeState("Attack")
	
	if Input.is_action_just_pressed("move_dash") and owner.canDash:
		changeState("Dash")
