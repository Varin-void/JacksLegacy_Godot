extends Node

class_name State
#@export var playercontroller:PlayerController
var controller
@export var fsm: FSM

func enter():
	pass

func update(_delta):
	pass
	
func physicsUpdate(_delta):
	pass

func exit():
	pass

func changeState(nextState):
	fsm.changeState(nextState);

func changeToStateRoot():
	pass
