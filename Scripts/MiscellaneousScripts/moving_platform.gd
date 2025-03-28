

extends Path2D

@onready var path = $PathFollow2D
@export var direction = 2
@export var rotates = false
@export var pause_timer = 0.7

@export_group("Trigger")
@export var oneShot: bool = false
@export var trigger: bool = false

@export_group("Sprite Control")
@export var sprite: Node
@export var rotate_sprite: bool = false

var is_paused = false

func _ready():
	path.rotates = rotates
	if !trigger:
		sprite.visible = false
		is_paused = true

func _physics_process(_delta: float) -> void:
	if trigger:
		is_paused = false
		sprite.visible = true
		#sprite.z_index = 10 

	if is_paused:
		return

	path.progress += direction
	if path.progress_ratio >= 1 or path.progress_ratio <= 0:
		if oneShot:
			sprite.visible = false
			return
		direction = -direction
		_pause_movement()

func _pause_movement():
	if !is_paused:
		is_paused = true
		await get_tree().create_timer(pause_timer).timeout
		sprite.flip_h = !sprite.flip_h

		is_paused = false
