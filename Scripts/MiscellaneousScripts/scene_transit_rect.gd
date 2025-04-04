extends ColorRect

# Path to the next scene to transition to
@export_file("*.tscn") var next_scene_path: String

# Reference to the _AnimationPlayer_ node
@onready var _anim_player := $AnimationPlayer

func _ready() -> void:
	# Plays the animation backward to fade in
	_anim_player.play_backwards("Fade")

func transition_to(_next_scene := next_scene_path) -> void:
	# Plays the Fade animation and wait until it finishes
	_anim_player.play("Fade")
	await _anim_player.animation_finished
	get_tree().change_scene(_next_scene)
