extends CharacterBody2D
class_name coin_pool

@onready var screenSize  = get_viewport_rect()
@onready var timerLaunch: Timer = $TimerLaunch
@onready var timer: Timer = $Timer
@onready var timerLifeSpan: Timer = $TimerLifeSpan
@onready var colCollector: CollisionShape2D = $collectZone/CollisionShape2D
@onready var col: CollisionShape2D = $pickup/CollisionShape2D
@onready var sprite: AnimatedSprite2D = $Sprite

@export var isPooling := false
@export var value = 10

var orgRot := 0.0
var orgPos := Vector2.ZERO
var gravity : float = 1000.0
var isConsuming : = false
var player : JackController
var lifeSpan := 5
var lifeSpanInd := 0
var isBlock = false

var type = "Coin"

func _ready() -> void:
	orgPos = global_position
	colCollector.set_deferred("disabled",true)
	top_level = true
	setType()
	if isPooling:
		set_physics_process(false)
		col.set_deferred("disabled",true)
	if isBlock :
		col.set_deferred("disabled",true)
		timer.start()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if player:
		var playerPos = player.global_position
		var targetPos = (playerPos - global_position).normalized()
		if global_position.distance_to(playerPos)>10:
			velocity = targetPos * 400
		else:
			poolReturn()
	else:
		velocity.y += gravity * delta
	move_and_slide()
	
	if isConsuming && is_on_floor() && !isPooling:
		queue_free()

func setType():
	scale.x = 0.4
	scale.y = 0.4

func poolReturn():
	timerLifeSpan.stop()
	player = null
	velocity = Vector2.ZERO
	colCollector.set_deferred("disabled", true)
	col.set_deferred("disabled", true)
	visible = false
	isConsuming = false
	set_physics_process(false)

	# Move off-screen (adjust based on your game resolution)
	global_position = Vector2(-1000, -1000)  # Ensure it’s far from the player

func launch(target:Vector2,duration:float = 0):
	set_physics_process(true)
	var distance = abs(target.x - global_position.x)
	var maxHeight = (distance/screenSize.size.x) * screenSize.size.y  * 0.5
	var arcHeight = target.y - global_position.y - maxHeight
	arcHeight = min(arcHeight,-maxHeight)
	velocity = calcArcVelocity(position,target,arcHeight,gravity)
	if duration>0:
		colCollector.set_deferred("disabled",true)
		timerLaunch.wait_time = duration
		timerLaunch.start()

func calcArcVelocity(sPosition,tPosition,arcHeight,gravity):
	var vel : Vector2
	var displacement = tPosition - sPosition
	if displacement.y > arcHeight:
		var timeUp = sqrt(-2 * arcHeight / float(gravity))
		var timeDown = sqrt(2 * (displacement.y - arcHeight) / float(gravity))
		vel.y = -sqrt(-2 * gravity * arcHeight)
		vel.x = displacement.x / float(timeUp + timeDown)
	
	return vel


func _on_pickup_body_entered(body) -> void:
	if body.is_in_group("Player") && !isConsuming:
		#body.pickUps(value,type)
		GameManager.add_coin(value)
		timer.stop()
		timerLaunch.stop()
		if isPooling:
			velocity = Vector2.ZERO
		else:
			launch(Vector2(global_position.x + 1,global_position.y - 100))
		isConsuming = true

func _on_collect_zone_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player"):
		player = body


func _on_timer_timeout() -> void:
	isBlock = false
	col.set_deferred("disabled",false)

func _on_timer_launch_timeout() -> void:
	velocity.x = 0
	col.set_deferred("disabled",false)
	colCollector.set_deferred("disabled",false)


func _on_timer_life_span_timeout() -> void:
	lifeSpanInd +=1
	if lifeSpan - lifeSpanInd<=3:
		var tween = create_tween()
		tween.tween_property(sprite,"modulate:a",0.2,0.9)
		await tween.finished
		sprite.modulate = Color(1,1,1,1)
		
	if lifeSpanInd>=lifeSpan:
		if isPooling:
			poolReturn()
		else:
			pass
