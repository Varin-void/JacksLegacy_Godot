extends Node

#region Variable
var loading_scene = preload("uid://dc1tescjuv6j8")
var fade_control = preload("uid://dp4kp15ct53tw")
var main_screen = preload("uid://cbyayktnmu7h5")
var game_scene = preload("uid://cjae7tcahph3m")
var Character : JackController
var StageController : StageControl
var pause_ui = preload("uid://clnw6lm0wf2im")

var tween_fade
var nextScene : String
var fade_panel : Control

const XP_DATABASE = "res://Data/Database.json"
const MAX_LEVEl = 4

var xp_table_data = {}

var path : String
var dir:String
var json:String
const filename = "jack_save.dat"
const folder:String = "JackSaveFiles"

var isLoad = false

var att = [
	{
		"name": "Attack1",
		"dmg": get_stat_damage(),
		"knockback": 20,
	},
	{
		"name": "Attack2",
		"dmg": get_stat_damage()+5,
		"knockback":25,
	},
	{
		"name": "Attack3",
		"dmg": get_stat_damage()+5,
		"knockback": 5,
	},
	{
		"name": "AirAttack",
		"dmg": get_stat_damage()+2,
		"knockback": 10,
	}
]

var coinSpread = []
var coinSpreadInd = 0
var coinSpreadMax = 3

#endregion

func _ready():
	dir = "user://" + folder
	path = dir + "/" + filename
	self.process_mode = Node.PROCESS_MODE_ALWAYS
	xp_table_data = get_xp_data()
	total_xp = 0
	print("Initializing GameManager")
	print("coinSpread: ", coinSpread)

func update_attacks():
	att = [
		{
			"name": "Attack1",
			"dmg": get_stat_damage(),
			"knockback": 20,
		},
		{
			"name": "Attack2",
			"dmg": get_stat_damage() + 5,
			"knockback": 25,
		},
		{
			"name": "Attack3",
			"dmg": get_stat_damage() + 5,
			"knockback": 5,
		},
		{
			"name": "AirAttack",
			"dmg": get_stat_damage() + 2,
			"knockback": 10,
		}
	]

# Function to get an attack by name
func get_attack_by_name(_name: String) -> Dictionary:
	for attack in att:
		if attack.name == _name:
			return attack
	return {}

func get_xp_data() -> Dictionary:
	var file = FileAccess.open(XP_DATABASE,FileAccess.READ)
	var data = JSON.parse_string(file.get_as_text())
	return data

func get_max_xp_at(level):
	return xp_table_data[str(level)]["need"]

func add_coin(value:int):
	VCoins += value

func getCoinSpread() -> int:
	if coinSpread.is_empty():
		print("Error: coinSpread is empty!")
		return -1
	
	coinSpreadInd += 1
	if coinSpreadInd >= coinSpread.size():
		coinSpreadInd = 0
	return coinSpreadInd

#region Pause n Stat Controller
var is_paused: bool = false
var pause_menu: Control = null
var stat_menu: Control = null
var shop_menu: Control = null

func register_stat_menu(menu: Control):
	stat_menu = menu

func register_pause_menu(menu: Control):
	pause_menu = menu
	pause_menu.visible = false

func toggle_pause():
	if not pause_menu:
		return  

	if stat_menu and stat_menu.visible:
		toggle_stat()

	is_paused = !is_paused
	get_tree().paused = is_paused

	if is_paused:
		pause_menu.pause()  # Calls animation inside Pause Menu
	else:
		pause_menu.resume()  # Calls animation to close

func toggle_stat():
	if not is_paused:
		return  
	if pause_menu and pause_menu.visible:
		toggle_pause()
	stat_menu.visible = !stat_menu.visible

func toggle_shop():
	if not is_paused:
		return  
	if pause_menu and pause_menu.visible:
		toggle_pause()
	shop_menu.visible = !shop_menu.visible
#endregion

#region Fade and Scene Transition
func fade_in(_fade_panel:ColorRect,fade_duration:float,_nextscene:String,_hexcode:String="292929"):
	_fade_panel.color =Color("#"+_hexcode)
	tween_fade = get_tree().create_tween()
	tween_fade.set_pause_mode(Tween.TWEEN_PAUSE_PROCESS)
	tween_fade.tween_property(fade_panel, "modulate:a", 1.0, fade_duration)
	tween_fade.finished.connect(_on_tween_fade_in_finished)
	nextScene=_nextscene

func fast_fade(_fade_panel:ColorRect,_alpha:float):
	var modulate_color = fade_panel.modulate
	modulate_color.a = _alpha
	_fade_panel.modulate = modulate_color
	
func fade_out(_fade_panel:ColorRect,fade_duration:float):
	tween_fade = get_tree().create_tween()
	tween_fade.set_pause_mode(Tween.TWEEN_PAUSE_PROCESS)
	tween_fade.tween_property(_fade_panel, "modulate:a", 0.0, fade_duration)
	tween_fade.finished.connect(_on_tween_fade_out_finished)

func _on_tween_fade_in_finished():
	tween_fade.finished.disconnect(_on_tween_fade_in_finished)
	if nextScene != "":
		remove_fade_panel_root()
		fast_fade(fade_panel.get_node("ColorRect"),0)
		get_tree().paused=false
		get_tree().change_scene_to_packed(GameManager.loading_scene)
	GameManager.is_paused = false
	get_tree().paused = false

func _on_tween_fade_out_finished():
	if tween_fade.is_connected("finished",_on_tween_fade_out_finished):
		tween_fade.finished.disconnect(_on_tween_fade_out_finished)
	fade_panel.visible=false

func remove_fade_panel_root():
	if fade_panel.get_parent() != get_tree().root:
		fade_panel.get_parent().remove_child(fade_panel)

func re_parent_global_object(parent_node:Node):
	if (fade_panel.get_parent()):
		fade_panel.get_parent().remove_child(fade_panel)
	get_tree().root.call_deferred("add_child",fade_panel)
	fade_panel.call_deferred("reparent",parent_node)

func add_fade_to_scene(_path:String):
	get_node(_path).call_deferred("add_child", GameManager.fade_panel)
	GameManager.fast_fade(GameManager.fade_panel.get_node("ColorRect"),1)
	GameManager.fade_panel.visible = true
	GameManager.fade_panel.global_position = Vector2(0,0)
	GameManager.fade_out(GameManager.fade_panel.get_node("ColorRect"),0.55)

func transition_scene(scene_uid:String):
	GameManager.fade_panel.visible = true
	GameManager.fade_panel.global_position = Vector2(0,0)
	GameManager.fade_in(GameManager.fade_panel.get_node("ColorRect"),1,scene_uid)

func transition_map():
	GameManager.fade_panel.visible = true
	GameManager.fade_panel.global_position = Vector2(0,0)
	GameManager.fast_fade(GameManager.fade_panel.get_node("ColorRect"),1)
#endregion

#region PlayerStats
var lvl: int = 1:
	set(value):
		lvl = value
		Strength += 4
		Agility += 2
		Vitality += 1
		Defense += 5
		
		setPlayerStatCalc()
		update_attacks()

var total_xp = 0

var current_xp = 0:
	set(value):
		current_xp = value
		var max_xp = GameManager.get_max_xp_at(lvl)
		
		if current_xp >= max_xp and lvl < GameManager.MAX_LEVEl:
			lvl += 1
			current_xp -= max_xp
		elif lvl == GameManager.MAX_LEVEl:
			current_xp = 0
		
		var total = min((GameManager.xp_table_data[str(lvl)]["total"] + current_xp),GameManager.xp_table_data[str(GameManager.MAX_LEVEl)]["total"])
		total_xp = total

var max_hp: int:
	set(value):
		max_hp = value
		HP = min(HP, max_hp)

var HP:int:
	set(value):
		HP = value

var Strength:int:
	set(value):
		Strength = value

var Vitality:int:
	set(value):
		Vitality = value

var Agility:int:
	set(value):
		Agility = value

var Defense:int:
	set(value):
		Defense = value

var VCoins = 50 :
	set(value):
		VCoins = value

func setPlayerStat(_hp:int, _str:int, _agi:int, _vit:int, _def:int):
	lvl = 1
	total_xp = 0
	current_xp = 0

	# Set base stats from save data
	HP = _hp
	Strength = _str
	Agility = _agi
	Vitality = _vit
	Defense = _def

	# Recalculate extra stats
	Character = get_tree().get_nodes_in_group("Player")[0] as JackController
	
	setPlayerStatCalc()

func get_extra_hp() -> int:
	return 10 * (Vitality / 4)

func get_extra_speed(speed:float) -> float:
	return speed + (Agility * 2)

func get_stat_damage() -> int:
	return Strength * 2 + 5

func setPlayerStatCalc():
	max_hp = 100 + get_extra_hp() + (lvl * 20)
	HP = max_hp
	update_attacks()
#endregion

#region Save Game

func to_dict() -> Dictionary:
	return {
		"Name": "Jack",
		"lvl": lvl,
		"total_xp": total_xp,
		"current_xp": current_xp, 
		"HP": HP,
		"max_hp": max_hp,
		"Strength": Strength,
		"Agility": Agility,
		"Vitality": Vitality,
		"Defense": Defense,
		"VCoins": VCoins,
		"global_position": Character.global_position,
		"current_map": StageController.current_map,
		"camera_position": StageController.camera.global_position,
		"background_offset" : StageController.bg_2.scroll_base_offset,
	}

func load_from_dict(data: Dictionary):
	#print("🔄 Loading Data from Save:", data)

	if "lvl" in data:
		lvl = data["lvl"]
	if "total_xp" in data:
		total_xp = data["total_xp"]
	if "current_xp" in data:
		current_xp = data["current_xp"]
	if "HP" in data:
		HP = data["HP"]
	if "max_hp" in data:
		max_hp = data["max_hp"]
	if "Strength" in data:
		Strength = data["Strength"]
	if "Agility" in data:
		Agility = data["Agility"]
	if "Vitality" in data:
		Vitality = data["Vitality"]
	if "Defense" in data:
		Defense = data["Defense"]
	if "VCoins" in data:
		VCoins = data["VCoins"]
	
	# Restore player position
	if "global_position" in data and Character:
		var pos_str = data["global_position"]
		if pos_str is String:
			var pos_values = pos_str.trim_prefix("(").trim_suffix(")").split(", ")
			if pos_values.size() == 2:
				Character.global_position = Vector2((pos_values[0].to_float())+100, pos_values[1].to_float())
		else:
			Character.global_position = data["global_position"]

	# Restore map
	if "current_map" in data:
		StageController.current_map = data["current_map"]

	# Restore camera position
	if "camera_position" in data:
		var pos_str = data["camera_position"]
		if pos_str is String:
			var pos_values = pos_str.trim_prefix("(").trim_suffix(")").split(", ")
			if pos_values.size() == 2:
				StageController.camera.global_position = Vector2(pos_values[0].to_float(), pos_values[1].to_float())
			else:
				pass
		else:
			StageController.camera.global_position = data["camera_position"]
	
	# Restore Background position
	if "background_offset" in data:
		var pos_str = data["background_offset"]
		if pos_str is String:
			var pos_values = pos_str.trim_prefix("(").trim_suffix(")").split(", ")
			if pos_values.size() == 2:
				StageController.bg_2.scroll_base_offset = Vector2(pos_values[0].to_float(), pos_values[1].to_float())
		else:
			StageController.bg_2.scroll_base_offset = data["background_offset"]

func _save_game() -> void:
	var directory = DirAccess.open("user://")
	if !directory.dir_exists(dir):
		directory.make_dir_recursive(dir)

	var file = FileAccess.open(path, FileAccess.WRITE)
	if !file:
		return

	var data_dict = to_dict()
	var json_data = JSON.stringify(data_dict, "\t")  
	file.store_string(json_data)
	file.close()
	print("✅ -> Game Saved Successfully!")

func _load_game():
	if !FileAccess.file_exists(path):
		return
	
	var file = FileAccess.open(path, FileAccess.READ)
	if FileAccess.get_open_error() != OK:
		return

	var content = file.get_as_text()
	file.close()

	var data = JSON.parse_string(content)
	if typeof(data) != TYPE_DICTIONARY:
		return
	load_from_dict(data)

#endregion
