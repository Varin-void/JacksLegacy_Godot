extends Node
class_name FSM
var states : Dictionary = {}
var currentStateNode:State
var currentState:String
var previousState:String
enum state_machine_Type{Player,Enemy}
@export var fsm_type: state_machine_Type
# Called when the node enters the scene tree for the first time.
func _ready():
	var controller = get_parent();
	for child in get_children():
		if child is State:
			states[child.name]=child
			child.fsm=self
			child.controller = controller

func update(delta):
	if not currentStateNode : return;
	currentStateNode.update(delta);
	
func physicsUpdate(delta):
	if not currentStateNode : return;
	currentStateNode.physicsUpdate(delta);
	
func changeState(nextState):
	if currentStateNode:
		currentStateNode.exit();
	previousState = currentState;
	currentState = nextState;
	currentStateNode = states[currentState];
	currentStateNode.enter();

func getState(state):
	return states[state]

func getCurrentState():
	return currentState;
