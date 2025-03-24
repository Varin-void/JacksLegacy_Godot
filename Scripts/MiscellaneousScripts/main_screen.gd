extends Control

var fade_control = preload("uid://dp4kp15ct53tw")
var audio_control = preload("uid://cyjix7ve8f03c")

func _ready():
	GameManager.fade_panel = fade_control.instantiate()
	get_tree().root.call_deferred("add_child",GameManager.fade_panel)
	var audio = audio_control.instantiate()
	get_tree().root.call_deferred("add_child",audio)
	
func _on_play_pressed():
	#GameManager.transition_scene("uid://cjae7tcahph3m")
	on_play_pressed()

func _on_exit_button_pressed() -> void:
	exit_game()

func exit_game() -> void:
	get_tree().quit()


func on_play_pressed():
	if FileAccess.file_exists(GameManager.path):
		var dialog = ConfirmationDialog.new()
		dialog.dialog_text = "A saved game was found. Do you want to continue from your last save?"
		add_child(dialog)
		
		dialog.connect("confirmed", Callable(self, "_load_game"))
		dialog.connect("canceled", Callable(self, "_start_new_game"))
		
		dialog.popup_centered()
	else:
		_start_new_game()

func _start_new_game():
	GameManager.transition_scene("uid://cjae7tcahph3m")

func _load_game():
	GameManager.isLoad = true
	GameManager.transition_scene("uid://cjae7tcahph3m")
