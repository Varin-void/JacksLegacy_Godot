extends Resource
class_name _PlayerStats

@export var _char : String = "Jack"

@export var hp : int
@export var max_hp : int

@export var mp : int
@export var max_mp : int

@export var _str : int
@export var def : int
@export var vit : int
@export var agi : int


@export var crit_chance : int
@export var crit_dmg : int

var isdead:bool = false
var coin:int
var kill:int
var xp:float

func modifyHp(_HP:float):
	hp += _HP
	hp = clamp(hp,0,max_hp)
	if hp <= 0:
		isdead = true
		
	#controller.get_parent().hp_mp_bar(hp,maxhp,0)

func modifymp(_mp:float):
	mp += _mp
	mp = clamp(mp,0,max_mp)
	#controller.get_parent().hp_mp_bar(mp,maxmp,1)
	
func regenerate_mp(_delta):
	if mp < max_mp:
		mp += 0.2 * _delta
		mp = clamp(mp,0,max_mp)
		#controller.get_parent().hp_mp_bar(mp,maxmp,1)

func modify_coin(_value:int):
	coin += _value

func modify_kill(_value:int):
	kill += _value

func modify_xp(_value:float):
	xp += _value
