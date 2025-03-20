extends State
const animation:String = "Jump"
var isjump : bool = false
var jumpforce : float = -330
var jumpcount : int = 0

var pixelSize :float = 16
var jumpHeight :float = 8 * pixelSize
var jumpDistance :float = 15 * pixelSize
var jumpPeakTime :float = .3

func enter():
	jumpForceCal()
	
func physicsUpdate(_delta):
	if !isjump:
		fnJump()
		
	if !owner.is_on_floor():
		if Input.is_action_just_pressed("jump") and (jumpcount<2):
			fnJump()
		if Input.is_action_just_pressed("move_dash") and owner.canDash:
			changeState("Dash")
		if Input.is_action_just_pressed("attack_swing"):
			changeState("Attack")
	elif owner.is_on_floor():
		if owner.direction:
			changeState("Run")
		else:
			changeState("Idle")
			
	if !owner.is_on_floor() and jumpcount == 2:
		await owner.anim.animation_finished
		changeState("Falling")

func exit():
	isjump=false
	jumpcount=0
	owner.speed = owner.original_speed

func fnJump():
	owner.anim.play("Jump")
	owner.velocity.y = 0
	isjump=true
	jumpcount+=1
	owner.velocity.y = jumpforce
	owner.velocity.x = owner.platVel.x
	owner.move_and_slide()

func jumpForceCal():
	jumpforce=owner.calJumpForce(jumpHeight,jumpPeakTime)
	owner.original_gravity=owner.gravity
	owner.speed=owner.calJumpDistance(jumpDistance,jumpPeakTime)
