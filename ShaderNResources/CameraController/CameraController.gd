extends Camera2D
class_name CameraController
@export var player : JackController
@export var attribute : CameraSO
@onready var shake_timer = $Shake_Timer
@onready var tween:Tween
var shake_amount:float=0
var default_offset:Vector2
var pos_x:int
var pos_y:int
var target
#var islock:bool
var isshake:bool

func _ready():
	default_offset=offset
	tween=create_tween()
	zoom=attribute.pov

func _physics_process(delta):
	setZoom(delta)
	if isshake:
		offset = Vector2(randf_range(-1,1)*shake_amount,randf_range(-1,1)*shake_amount)
	
	if attribute.islock:
		LockCamera(delta)
	else:
		followPlayer(delta)

func followPlayer(delta):
	#print(player)
	if player!=null:
		target = player.global_position + Vector2(attribute.offsetX * player.dir, attribute.offsetY)
		target.x=clamp(target.x,attribute.ClampX.x,attribute.ClampX.y)
		target.y=clamp(target.y,attribute.ClampY.x,attribute.ClampY.y)
		global_position = lerp(global_position, target, attribute.smooth * delta).round()

func LockCamera(_delta):
	global_position = lerp(global_position, target, attribute.smooth * _delta)

func setZoom(delta):
	if (zoom - attribute.pov).length()  > 0.01:		
		zoom = lerp(zoom, attribute.pov, 1 * delta)
	
func set_lock_camera(_locktarget:Vector2):	
	target=_locktarget

func shake(duration:float,intensity:float):
	isshake=true
	shake_timer.wait_time=duration
	shake_amount=intensity
	shake_timer.start()
	
func _on_shake_timer_timeout():
	isshake=false
	tween.interpolate_value(self,"offset",1,1,tween.TRANS_LINEAR,tween.EASE_IN)

func update_camera_attribute(cam_so:CameraSO):
	attribute=cam_so
	if cam_so.islock:
		set_lock_camera(cam_so.lock_position)

func get_camera_edges()->Vector2:	
	# Get the camera's viewport
	var viewport_size = get_viewport_rect().size

	# Calculate the left and right edges in global coordinates
	var left_edge = global_position.x - viewport_size.x / 2
	var right_edge = global_position.x + viewport_size.x / 2

	print("Left edge:", left_edge)
	print("Right edge:", right_edge)
	return Vector2(left_edge,right_edge)
