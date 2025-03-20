extends Area2D


func _on_body_entered(body):
	if body.is_in_group("Player"):
		GameManager.fade_panel.visible = true
		GameManager.fade_panel.global_position = Vector2(0,0)
		GameManager.fade_in(GameManager.fade_panel.get_node("ColorRect"),1,"")
