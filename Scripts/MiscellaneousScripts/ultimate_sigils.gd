extends Node2D
@onready var detect = $PickUP/CollisionShape2D

var canUnlock = true
func _ready():
	self.visible = false
	detect.disabled = true

func _on_pick_up_body_entered(body):
	if body.is_in_group("Player") and canUnlock:
		canUnlock = false
		_info()

var dialog = ConfirmationDialog.new()

func _info():
	get_tree().paused = true
	dialog.dialog_text = "Ulimate Abilty Unlocked!!"
	
	get_tree().root.add_child(dialog)
	dialog.process_mode = Node.PROCESS_MODE_ALWAYS
	
	dialog.ok_button_text = "Ok"
	
	dialog.connect("confirmed", Callable(self, "_back_to_game"))
	
	dialog.popup_centered()

func _back_to_game():
	get_tree().paused = false
	GameManager.Ultimate = true
	dialog.queue_free()
