extends Node2D
class_name StageControl

@onready var current_map = "Map1"
@onready var completed_condition = false
@onready var info_timer: Timer = $CanvasLayer/Instruction/infoTimer
@onready var instruction: Control = $CanvasLayer/Instruction
@onready var bg_1: ParallaxBackground = $BG_Map1
@onready var bg_2: ParallaxBackground = $bg2/BG_Map2
@onready var _bg_2: Node2D = $bg2

var audio_control = preload("uid://cyjix7ve8f03c")

@onready var jack: JackController = $Jack
@onready var health_bar: ProgressBar = $CanvasLayer/PlayerUi/HealthBar
@onready var camera: CameraController = $Camera2D
@onready var coin_pools: Node2D = $CoinsPooling
@onready var coin_marker: Marker2D = $CoinMarker

var maps = {}
var spawn_points = {}
var camera_triggers = {}

func _ready():
	GameManager.add_fade_to_scene("/root/GameScenes/CanvasLayer")
	info_timer.start()
	info_timer.timeout.connect(_on_info_timer_timeout)

	# Store Maps & Triggers
	for i in range(1, 3):
		var map = get_node_or_null("Map" + str(i))
		var spawn = get_node_or_null("Map" + str(i) + "/Map" + str(i) + "Spawn")
		var cam_trig = get_node_or_null("Map" + str(i) + "/Map" + str(i) + "Triggers/lvl" + str(i) + "CamTrig")

		if map and spawn and cam_trig:
			maps["Map" + str(i)] = map
			spawn_points["Map" + str(i)] = spawn
			camera_triggers["Map" + str(i)] = cam_trig

	# 🛠️ Automatically Pool 10 Coins (Instead of Manually Placing Them)
	GameManager.coinSpread.clear()
	var coin_spread_scene = preload("uid://wcaylsvafv00")
	
	for i in range(10):  # Pool 10 coins
		var coin_instance = coin_spread_scene.instantiate()
		coin_instance.global_position = coin_marker.global_position
		coin_pools.add_child(coin_instance)
		GameManager.coinSpread.append(coin_instance)
		
	GameManager.coinSpreadMax = GameManager.coinSpread.size()
	
	# Set Initial Player and Camera Positions
	if "Map1" in maps and !GameManager.isLoad:
		jack.global_position = spawn_points["Map1"].global_position
		camera.global_position = spawn_points["Map1"].global_position + Vector2(200, 20)
		camera.update_camera_attribute(camera_triggers["Map1"].cam_so)
		$Camera2D/RainParticle.visible = false
		bg_1.visible = true

	# Load Game If Necessary
	if GameManager.isLoad:
		GameManager.StageController = self
		await get_tree().process_frame
		GameManager._load_game()
		camera.update_camera_attribute(camera_triggers[current_map].cam_so)
	else:
		GameManager.StageController = self

func _process(_delta):
	AudioGlobal.current_map = current_map
	update_health_bar()
	%CoinValue.text = str(int(GameManager.VCoins))
	checkForCompletion()
	# Simplified PlayerUi visibility logic
	$CanvasLayer/PlayerUi.visible = not ($CanvasLayer/PauseMenus.visible or $CanvasLayer/StatsControl.visible)

func _on_body_entered(body):
	if body.is_in_group("Player") and completed_condition:
		print(maps)
		completed_condition = false
		await transition_to_next_map()
		$Camera2D/RainParticle.visible = true
		bg_2.scroll_base_offset = Vector2(2750,2700)

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
	else:
		_inTheWork()

func _on_info_timer_timeout():
	instruction.visible = false

func checkForCompletion():
	if $Map1/Map1Enemy.get_child_count() == 0 and current_map == "Map1":
		completed_condition = true
	elif $Map2/Map2Enemy.get_child_count() == 0 and current_map == "Map2":
		completed_condition = true
	else:
		return

var dialog = ConfirmationDialog.new()

func _inTheWork():
	get_tree().paused = true
	dialog.dialog_text = "🚧 Contrustion in Progress. New Game? 🚧"
	
	get_tree().root.add_child(dialog)
	dialog.process_mode = Node.PROCESS_MODE_ALWAYS
	
	dialog.ok_button_text = "Ok"
	dialog.cancel_button_text = "Cancel"
	
	dialog.connect("confirmed", Callable(self, "_start_new_game"))
	dialog.connect("canceled", Callable(self, "_back_to_menu"))
	
	dialog.popup_centered()

func _start_new_game():
	GameManager.transition_scene("uid://cjae7tcahph3m")
	get_tree().paused = false
	dialog.queue_free()

func _back_to_menu():
	GameManager.transition_scene("uid://cbyayktnmu7h5")
	get_tree().paused = false
	dialog.queue_free()

func update_health_bar():
	var max_hp = GameManager.max_hp
	
	health_bar.max_value = max_hp
	health_bar.value = GameManager.HP

#func coin_setup():
	#var coin_children = coins.get_children()
	#var marker_children = coin_pos.get_children()
	#
	#if coin_children.size() != 10 or marker_children.size() != 10:
		#print("Error: Coins and Markers do not have exactly 10 children!")
		#return
	#
	#for i in range(10):
		#coin_children[i].global_position = marker_children[i].global_position
