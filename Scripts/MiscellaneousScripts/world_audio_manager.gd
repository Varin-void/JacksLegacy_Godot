extends Node

@export var bg_music_player : AudioStreamPlayer
var current_map: String


func _ready():
	current_map = AudioGlobal.current_map

func _process(_delta):
	if current_map != AudioGlobal.current_map:
		current_map = AudioGlobal.current_map
		update_music_for_scene()

func update_music_for_scene():
	var current_map_music = str(current_map+"Music")
	bg_music_player["parameters/switch_to_clip"] = current_map_music
