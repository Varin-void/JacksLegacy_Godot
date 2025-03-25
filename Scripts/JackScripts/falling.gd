extends State

var air_attackCount:int=0
func changeToStateRoot():
	changeState("Falling")
	
func enter():
	owner.anim.play("Falling")

func update(_delta):
	if owner.is_on_floor():
		owner.fsm.getState("Attack").air_attack_count = 0
		changeState("Idle")
		if owner.direction:
			changeState("Run")
	else:
		if Input.is_action_just_pressed("move_dash") and owner.canDash:
			changeState("Dash")
		if Input.is_action_just_pressed("attack_swing") :
			changeState("Attack")
