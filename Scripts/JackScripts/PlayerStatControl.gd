extends Control

@onready var anim = $AnimationPlayer

func _ready() -> void:
	GameManager.is_paused = false  # Ensure pause state resets on scene load
	get_tree().paused = false
	visible = false
	anim.play("RESET")
	GameManager.register_stat_menu(self)

func toggle_stat_screen():
	if GameManager.is_paused and GameManager.pause_menu.visible:
		GameManager.toggle_pause()

	if visible:
		resume()
	else:
		pause()

func pause():
	visible = true  # Ensure the UI is visible first
	await get_tree().process_frame  # Allow UI update before animation starts
	anim.play("Open")
	await anim.animation_finished  # Wait for animation to finish
	$bg/ColorRect.visible = true
	$bg/AnimatedSprite2D.visible = true  
	anim.play("blurred")
	await anim.animation_finished  # Wait for blurred animation
	GameManager.toggle_stat()

func resume():
	await get_tree().process_frame  # Ensure smooth transition before animation starts
	anim.play_backwards("blurred")
	await anim.animation_finished  # Wait for blurred animation to play backwards
	$bg/ColorRect.visible = false
	$bg/AnimatedSprite2D.visible = false
	anim.play_backwards("Open")
	await anim.animation_finished  # Wait for close animation to finish
	visible = false
	GameManager.toggle_stat()


func _process(_delta: float) -> void:
	updateVal()
	if Input.is_action_just_pressed("player_stat") and not GameManager.pause_menu.visible:
		toggle_stat_screen()
	#if Input.is_action_just_pressed("add_exp"):
		#GameManager.current_xp += 100
	#if Input.is_action_just_pressed("save_game"):
		#GameManager._save_game()

func updateVal():
	%Label2.text = str(GameManager.lvl)
	%TotalXp.text = str(GameManager.total_xp)
	%ProgressBar.max_value = GameManager.get_max_xp_at(GameManager.lvl)
	%ProgressBar.value = GameManager.current_xp
	%HP.text = str(GameManager.HP)
	%Str.text = str(GameManager.Strength)
	%Vit.text = str(GameManager.Vitality)
	%Agi.text = str(GameManager.Agility)
	%Def.text = str(GameManager.Defense)
