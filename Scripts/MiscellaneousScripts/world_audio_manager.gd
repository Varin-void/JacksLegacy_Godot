extends Node

@export var bg_music_player : AudioStreamPlayer
var current_map: String
@onready var ambient_player: AudioStreamPlayer = $AmbientPlayer

func _ready():
	current_map = AudioGlobal.current_map
	ambient_player.playing = false

func _process(_delta):
	if current_map != AudioGlobal.current_map:
		current_map = AudioGlobal.current_map
		update_music_for_scene()

func update_music_for_scene():
	var current_map_music = str(current_map+"Music")
	var current_map_amb = str(current_map+"Ambient")
	
	if current_map == "Map1":
		ambient_player.playing = true
	if current_map == "Map2":
		ambient_player.volume_db = -17.5
	bg_music_player["parameters/switch_to_clip"] = current_map_music
	ambient_player["parameters/switch_to_clip"] = current_map_amb
