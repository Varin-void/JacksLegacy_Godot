extends Node2D

@export var val:= 1

var isCollected = false

func _ready() -> void:
	pass

func _process(delta: float) -> void:
	pass

func _on_collect_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player") and !isCollected:
		isCollected = true
		GameManager.add_coin(val)
		$Sprite.visible = false
		$collect.visible = true
		$collect/CollisionShape2D.disabled = true
