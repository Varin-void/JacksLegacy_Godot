extends Node2D

var isSelected : bool = false
var customClick : bool = true
var click : bool = true

var tween_rot: Tween
var tween_hover: Tween
var tween_destroy: Tween
var tween_handle: Tween
var random_offset = 0.0
var curve_rotation_offset = 2
var tilt_speed = 3

func _process(delta):
	pass

func idle_card_tilt(delta,_isActive: bool):
	if _isActive: return
	var sine = sin(Time.get_ticks_msec() / 1000.0 + random_offset)
	var _cosine = cos(Time.get_ticks_msec() / 1000.0 + random_offset)
	var tilt_z = curve_rotation_offset * sine

	rotation_degrees = lerp_angle(rotation_degrees, tilt_z, tilt_speed * delta)
	
func _input(event):
	if (event is InputEventMouseButton && event.button_index == 1 && event.is_pressed()):
		isSelected = !isSelected
		if customClick:
			if isSelected:
				tweenSelected()
			else:
				tweenDeselected()

func setSelected(val:bool):
	isSelected = val

func tweenSelected():
	if tween_hover:
		tween_hover.kill()
	tween_hover = create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_ELASTIC)
	tween_hover.tween_property(self, "scale", Vector2(1.2, 1.2), 0.5)
			
func tweenDeselected():
	if tween_rot and tween_rot.is_running():
		tween_rot.kill()
	if tween_hover and tween_hover.is_running():
		tween_hover.kill()

	tween_rot = create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_BACK).set_parallel(true)
	tween_hover = create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_ELASTIC)
	tween_hover.tween_property(self, "scale", Vector2.ONE, 0.55)


func resetCardTween():
	if isSelected:
		isSelected = false
		if tween_hover and tween_hover.is_running():
			tween_hover.kill()
		if tween_rot and tween_rot.is_running():
			tween_rot.kill()

		self.scale = Vector2.ONE
	else:
		return
