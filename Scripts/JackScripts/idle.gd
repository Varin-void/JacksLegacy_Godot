extends State
const animation: String = "Idle"

func changeToStateRoot():
	$"../../PlayerAudio".playing = false
	changeState("Idle")

func enter():
	owner.anim.play("Idle")
	
	$"../../AttackBox/Attack1".disabled = true
	$"../../AttackBox/Attack2".disabled = true
	$"../../AttackBox/Attack3".disabled = true
	$"../../AttackBox/AirAttack".disabled = true

func update(_delta):
	
	if owner.direction:
		changeState("Run")
	
	if owner.is_on_floor():
		if Input.is_action_just_pressed("Ultimate") and GameManager.Ultimate:
			owner.isImmune = true
			changeState("Ultimate")
		if Input.is_action_just_pressed("jump"):
			changeState("Jump")
		elif Input.is_action_just_pressed("attack_swing"):
			changeState("Attack")
			
		elif Input.is_action_just_pressed("block"):
			changeState("Block")
		elif Input.is_action_just_pressed("attack_swing_heavy"):
			owner.heavy_att = true
			changeState("Attack")
	if Input.is_action_just_pressed("move_dash") and owner.canDash:
		changeState("Dash")
