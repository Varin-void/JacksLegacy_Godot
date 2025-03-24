extends StaticBody2D
@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var animation_player: AnimationPlayer = $AnimationPlayer

var has_saved: bool = false
var default_material: ShaderMaterial
var save_material: ShaderMaterial

func _ready() -> void:
	default_material = sprite.material as ShaderMaterial
	save_material = ShaderMaterial.new()
	save_material.shader = load("uid://dlgpseqakkaha") as Shader
	save_material.set_shader_parameter("palette", load("uid://6sl8g8jbennq"))
	save_material.set_shader_parameter("fps", 6.0)
	save_material.set_shader_parameter("use_palette_alpha", true)
	
func _on_save_area_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player") and not has_saved:
		has_saved = true
		animation_player.play("Saving")
		sprite.material = save_material
		
		GameManager._save_game()
		
		await animation_player.animation_finished
		animation_player.play("default")
