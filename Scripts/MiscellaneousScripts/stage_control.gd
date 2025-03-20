extends Node2D
class_name StageControl

@onready var current_map = "Map1"
@onready var completed_condition = true

var audio_control = preload("uid://cyjix7ve8f03c")

@onready var jack: JackController = $Jack
@onready var camera: CameraController = $Camera2D

var maps = {}
var spawn_points = {}
var camera_triggers = {}

func _ready():
	GameManager.add_fade_to_scene("/root/TestScene/CanvasLayer")
	
	for i in range(1, 3):
		var map = get_node_or_null("Map" + str(i))
		var spawn = get_node_or_null("Map" + str(i) + "/Map" + str(i) + "Spawn")
		var cam_trig = get_node_or_null("Map" + str(i) + "/Map" + str(i) + "Triggers/lvl" + str(i) + "CamTrig")

		if map and spawn and cam_trig:
			maps["Map" + str(i)] = map
			spawn_points["Map" + str(i)] = spawn
			camera_triggers["Map" + str(i)] = cam_trig

	print("Final maps dictionary:", maps)

	if "Map1" in maps:
		jack.global_position = spawn_points["Map1"].global_position
		camera.global_position = spawn_points["Map1"].global_position + Vector2(200, 20)
		camera.update_camera_attribute(camera_triggers["Map1"].cam_so)
	
	if GameManager.isLoad:
		GameManager.StageController = self
		await get_tree().process_frame
		GameManager._load_game()
		camera.update_camera_attribute(camera_triggers[current_map].cam_so)
	else:
		GameManager.StageController = self

func _process(_delta):
	AudioGlobal.current_map = current_map

func _on_body_entered(body):
	if body.is_in_group("Player") and completed_condition:
		print(maps)
		await transition_to_next_map()

func transition_to_next_map():
	var next_map_index = int(current_map.replace("Map", "")) + 1
	var next_map_name = "Map" + str(next_map_index)
	
	if next_map_name in maps:
		await GameManager.transition_map()
		
		jack.global_position = spawn_points[next_map_name].global_position
		camera.global_position = spawn_points[next_map_name].global_position + Vector2(200, 10)
		camera.update_camera_attribute(camera_triggers[next_map_name].cam_so)
		current_map = next_map_name
		
		await GameManager.fade_out(GameManager.fade_panel.get_node("ColorRect"),1)
		GameManager.fade_panel.visible = true

	
