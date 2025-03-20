extends Node
var camera_controller:CameraController
@export var cam_so:CameraSO
func _ready():
	camera_controller=get_tree().get_nodes_in_group("Camera")[0] as CameraController

func _on_body_entered(_body):
	camera_controller.update_camera_attribute(cam_so)
