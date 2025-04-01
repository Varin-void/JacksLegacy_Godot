extends Control

class_name ShopUpgrade

@onready var anim = $AnimationPlayer
@export var player_area : Area2D
var is_in_shop_area : bool = false
@onready var buy_stat_up = $StatUp

func _ready() -> void:
	GameManager.is_paused = false
	get_tree().paused = false
	visible = false
	anim.play("RESET")
	buy_stat_up.visible = false
	GameManager.shop_menu = self

func toggle_stat_screen():
	if GameManager.is_paused and GameManager.pause_menu.visible and not GameManager.pause_menu.visible and not GameManager.stat_menu.visible and is_in_shop_area:
		GameManager.toggle_shop()

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
	GameManager.toggle_shop()

func resume():
	await get_tree().process_frame
	anim.play_backwards("blurred")
	await anim.animation_finished
	$bg/ColorRect.visible = false
	$bg/AnimatedSprite2D.visible = false
	anim.play_backwards("Open")
	await anim.animation_finished
	visible = false
	GameManager.toggle_shop()


func _process(_delta: float) -> void:
	updateVal()
	if Input.is_action_just_pressed("interact") and not GameManager.pause_menu.visible and not GameManager.stat_menu.visible and is_in_shop_area:
		toggle_stat_screen()

func updateVal():
	%GoldAmount.text = str(GameManager.VCoins)

func _on_shop_area_body_entered(body):
	if body.is_in_group("Player"):
		is_in_shop_area = true
	else:
		is_in_shop_area = false

func _on_shop_area_body_exited(body):
	if body.is_in_group("Player"):
		is_in_shop_area = false
		resume()
		GameManager.setPlayerStatCalc()

func toggle_buy_stat(amount, attri):
	$StatUp/StatBought.text = ("+" + str(amount) + " " + attri)
	buy_stat_up.visible = true
	await get_tree().create_timer(.75).timeout
	buy_stat_up.visible = false

func _on_buy_1_pressed():
	if GameManager.VCoins >= 25:
		GameManager.Strength += 10
		GameManager.VCoins -= 25
		GameManager.setPlayerStatCalc()
		toggle_buy_stat(10,"STR")

func _on_buy_2_pressed():
	if GameManager.VCoins >= 30:
		GameManager.Vitality += 12
		GameManager.VCoins -= 30
		GameManager.setPlayerStatCalc()
		toggle_buy_stat(12,"VIT")

func _on_buy_3_pressed():
	if GameManager.VCoins >= 15:
		GameManager.Agility += 8
		GameManager.VCoins -= 15
		GameManager.setPlayerStatCalc()
		toggle_buy_stat(8,"AGI")
