extends Node2D
class_name LoadingScene

var progress = []
var sceneName : String
var sceneLoadStatus = 0
@onready var txt_percent = $CanvasLayer/LoadingPanel/txtPercent #$CanvasLayer/ColorRect/txtPercent
@onready var exit_timer = $ExitTimer
var sceneLoaded
func _ready():
	self.process_mode = Node.PROCESS_MODE_ALWAYS

	get_tree().paused = false
	GameManager.re_parent_global_object($CanvasLayer)
	sceneName = GameManager.nextScene
	ResourceLoader.load_threaded_request(sceneName)
	
func _process(_delta):
	sceneLoadStatus = ResourceLoader.load_threaded_get_status(sceneName,progress)
	txt_percent.text ="Loading... " + str((int)(progress[0]*100)) + "%";
	if sceneLoadStatus == ResourceLoader.THREAD_LOAD_LOADED:
		sceneLoaded = ResourceLoader.load_threaded_get(sceneName)
		if sceneLoaded:	
			set_process(false)
			exit_timer.start()

func _on_exit_timer_timeout():
	if sceneLoaded:
		#GameManager.fade_out(GameManager.fade_panel.get_node("ColorRect"),0.5)
		GameManager.remove_fade_panel_root()
		get_tree().change_scene_to_packed(sceneLoaded)
