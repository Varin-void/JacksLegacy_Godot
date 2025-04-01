extends Node2D
class_name SigilsUnlock
@onready var detect = $PickUP/CollisionShape2D

var canUnlock = true
func _ready():
	self.visible = false
	detect.disabled = true

func _on_pick_up_body_entered(body):
	if body.is_in_group("Player") and canUnlock and !GameManager.Ultimate:
		canUnlock = false
		GameManager.Ultimate = true
		body.ultimate_icon.visible = true
		await get_tree().create_timer(0.75).timeout
		queue_free()
		#_info()

#var dialog = ConfirmationDialog.new()
#
#func _info():
	#get_tree().paused = true
	#dialog.dialog_text = "Ultimate Ability Unlocked!!"
	#
	#get_tree().root.add_child(dialog)
	#dialog.process_mode = Node.PROCESS_MODE_ALWAYS
	#
	#dialog.ok_button_text = "OK"
	#dialog.get_cancel_button().hide()
	#
	#dialog.connect("confirmed", Callable(self, "_back_to_game"))
	#
	#dialog.popup_centered()
#
#func _back_to_game():
	#get_tree().paused = false
	#dialog.queue_free()
