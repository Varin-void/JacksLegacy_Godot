extends CharacterBody2D
class_name JackController

@onready var anim: AnimationPlayer = $AnimationPlayer
@onready var sprite: Sprite2D = $JackSprite
@onready var fsm = $FSM
@onready var body: CollisionShape2D = $CollisionShape2D

var gravity: float = ProjectSettings.get_setting("physics/2d/default_gravity")
var direction: float = 0
var dir: int = 0
var blockflip: bool = false
var original_gravity: float
var platVel: Vector2
var original_speed: float
var canDash: bool = true
var dashCD: float = 0.75
var is_dead: bool = false
var attack_input: bool = false
var camera:CameraController
var is_hurt: bool = false

var camera_pos:Vector2
var viewport_size:Vector2
var clampMin:Vector2
var clampMax:Vector2
var cam_pov:Vector2

var ability: Dictionary = {
	"Dashing": false,
	"Attacking": false,
	"Air_Attacking": false,
	"Falling": false,
	"Air_Combo": false
}

@export var stats : _PlayerStats
@export var speed: float = 300

@export_group("SoundFX")
@export var AttackSfx : AudioStreamMP3
@export var DashSfx : AudioStreamMP3
@export var playerAudio : AudioStreamPlayer2D

func _ready():
	floor_snap_length = 10
	camera = get_tree().get_nodes_in_group("Camera")[0] as CameraController
	calJumpForce(5*16, .25)
	original_gravity = gravity
	original_speed = speed

	add_to_group("Player")

	if !is_on_floor():
		fsm.changeState("Falling")
	else:
		fsm.changeState("Idle")

	if GameManager.isLoad:
		GameManager.Character = self
		await get_tree().process_frame
		GameManager._load_game()
	else:
		GameManager.setPlayerStat(stats.max_hp, stats._str, stats.agi, stats.vit, stats.def)

func _process(_delta):
	$Label.text = str(fsm.currentState)
	if !chkAbility("Dashing"):
		direction = Input.get_axis("move_left", "move_right")
	flip()
	if is_on_floor() and dir == 0:
		velocity.x = move_toward(velocity.x, 0, speed)
	global_position = round(global_position)

	fsm.update(_delta)

func _physics_process(_delta):
	fsm.physicsUpdate(_delta)
	movement(_delta)
	move_and_slide()
	platVel = get_platform_velocity()

func movement(_delta):
	
	if (!chkAbility("Air_Attacking")) and velocity.y < 22000:
		velocity.y += gravity * _delta

	if !chkAbility("Dashing") and !chkAbility("Air_Combo") :
		velocity.x = direction * speed

	if chkAbility("Air_Combo") or chkAbility("Attacking"):
		velocity.x = 0

	if chkAbility("Falling"):
		velocity.y += gravity * _delta 

func flip():
	if blockflip: return
	if direction < 0:
		sprite.flip_h = true
		dir = -1
	elif direction > 0:
		sprite.flip_h = false
		dir = 1
	$AttackBox.scale.x = -1 if sprite.flip_h else 1


func resetSpeed(newspeed:float):
	speed = newspeed
	velocity.x = direction * speed

func calJumpForce(_jumpheight:float,_peaktime:float)->float:
	gravity = (2 * _jumpheight) / pow(_peaktime,2)
	return -1 * gravity * _peaktime

func calJumpDistance(_jumpdistance:float,_peaktime:float)->float:
	return _jumpdistance/(_peaktime * 1.8)

func setAbilty(_ability:String,val:bool)->void:
	ability[_ability] = val

func chkAbility(_ability: String) -> bool:
	return ability.get(_ability, false)

func _take_damage(amount):
	if is_dead:
		return
	
	is_hurt = true
	GameManager.HP -= amount
	fsm.changeState("Hurt")
	#if(GameManager.HP <= 0):
		#_die()

#func _die():
	#print("Player Died")

func fn_ClampPosition():
	camera_pos = get_parent().camera.global_position
	viewport_size = get_parent().camera.get_viewport().get_visible_rect().size
	cam_pov=get_parent().camera.attribute.pov
	clampMin.x=camera_pos.x - viewport_size.x / (cam_pov.x+cam_pov.x)
	clampMax.x=camera_pos.x + viewport_size.x / (cam_pov.x+cam_pov.x)
	clampMin.y = -INF  # Let it move freely
	clampMax.y = INF   # Let it move freely
	
	clampMin.x += body.shape.radius
	clampMax.x -= body.shape.radius
	clampMin.y += (body.shape.height / 2) + body.shape.radius
	clampMax.y -= (body.shape.height / 2) + body.shape.radius

	global_position=Vector2(clamp(global_position.x, clampMin.x, clampMax.x),clamp(global_position.y, clampMin.y, clampMax.y)).round()

func audio_random_pitch():
	playerAudio.pitch_scale = randf_range(0.9, 1.1)

func set_audio_volume(amount:float):
	playerAudio.volume_db = amount
