extends Node2D

var coinSpread : Node
@onready var anim: AnimationPlayer = $AnimationPlayer
var activated = false

func _ready() -> void:
	anim.play("Close")

func _on_detect_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player") and !activated:
		anim.play("Open")
		await anim.animation_finished
		activated = true
		var coin_index = GameManager.getCoinSpread()
		if coin_index < GameManager.coinSpreadMax and GameManager.coinSpread[coin_index] != null:
			coinSpread = GameManager.coinSpread[coin_index]
		else:
			print("⚠️ Warning: No valid CoinSpread instance found!")
			coinSpread = null
		
		if coinSpread:
			coinSpread.spawn(global_position)
			await get_tree().create_timer(0.5).timeout
			coinSpread.spawn(global_position)
			
		else:
			print("Error: CoinSpread instance is null or invalid")
