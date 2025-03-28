extends Node2D
@onready var pooling = $Pooling
var rand_generate = RandomNumberGenerator.new()
var ind = 0
func _ready():
	for coin in pooling.get_children():
		coin.global_position = Vector2(-1000, -1000)

func spawn(pos: Vector2):
	var rnd = rand_generate.randi_range(2, 4)
	for i in range(rnd):
		if ind >= pooling.get_child_count():
			ind = 0

		var coin = pooling.get_child(ind)
		coin.visible = true
		coin.global_position = pos
		coin.velocity = Vector2.ZERO
		coin.player = null
		coin.isConsuming = false
		coin.set_physics_process(true)

		var rndY = rand_generate.randi_range(40, 70)
		var rndX = rand_generate.randi_range(-30, 30)
		var target_pos = Vector2(pos.x + rndX, pos.y - rndY)
		coin.launch(target_pos, 0.7)
		ind += 1
