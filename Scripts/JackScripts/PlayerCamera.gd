extends Camera2D

@export var player: JackController

@export_group("Camera Smoothing")
@export var smoothing_enable: bool = true
@export_range(1, 10) var smoothing_distance: int = 8
@export var camera_controller : Resource
func _physics_process(delta):
	if player == null:
		return
	
	var camera_position: Vector2 = player.global_position
	
	if smoothing_enable:
		var weight: float = (11 - smoothing_distance) / 100.0
		camera_position = lerp(global_position, camera_position, weight).round()
	
	global_position = camera_position.floor()
