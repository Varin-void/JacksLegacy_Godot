extends Control

@onready var anim = $AnimationPlayer

func _ready():
	GameManager.is_paused = false  # Ensure pause state resets on scene load
	get_tree().paused = false
	visible = false
	GameManager.register_pause_menu(self)

func pause():
	visible = true  # Ensure visibility before playing animation
	await get_tree().process_frame  # Wait one frame to avoid flickering
	anim.play("Blurred")
	await anim.animation_finished  # Ensure animation completes before pausing game
	get_tree().paused = true  

func resume():
	anim.play_backwards("Blurred")  
	await anim.animation_finished  
	visible = false  # Hide menu after animation completes
	get_tree().paused = false

func _process(_delta: float):
	if Input.is_action_just_pressed("pause_game") and not GameManager.stat_menu.visible and not GameManager.shop_menu.visible:
		GameManager.toggle_pause()

func _on_button_resume_pressed():
	GameManager.toggle_pause()

func _on_button_restart_pressed():
	GameManager.transition_scene("uid://cjae7tcahph3m")

func _on_button_exit_pressed():
	GameManager.transition_scene("uid://cbyayktnmu7h5")
