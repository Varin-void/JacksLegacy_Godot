extends CharacterBody2D

#region variable
@export var health : float = 50
@export var damage : int = 10
@export var _exp : float = 100 

@export var enemyType : EnemyType
@export var enemyClass : EnemyClass
@export var isInactive = false
@export var actionPauseDuration := 2.0
@export var patrol_range : float = 200

@export var orgChaseSpeed = 40
@export var attackRadius = 30
@export var attackHeight = 70
@export var closestRange = 0
@export var id = 0

@onready var timer = $Timer as Timer 
@onready var anim = $AnimationPlayer
@onready var fsm: FSM = $FSM
@onready var sprite: AnimatedSprite2D
@onready var prop: Node2D = $prop
@onready var player : JackController
@onready var hurtBox = $CollisionShape2D as CollisionShape2D
@onready var hitBox = $prop/hitbox as Area2D
#@onready var Sprite = $Sprite2D as Sprite2D
@onready var RCChkFront = $prop/RCChkPlayer as RayCast2D
@onready var RCChkGround = $prop/RCChkGround as RayCast2D
@onready var RCChkBack = $prop/RCChkBack as RayCast2D
@onready var screenSize  = get_viewport_rect()
@onready var rhino_sprite: AnimatedSprite2D = $RhinoSprite

@onready var immune_timer = $ImmuneTimer
@onready var enemy_audio = $prop/AudioStreamPlayer2D
@onready var Health_bar: TextureProgressBar = $CanvasLayer/BossHP/TextureProgressBar

var coinSpread : Node

enum EnemyType {
	Ground,
	Fixed,
	Fly
}

enum EnemyClass{
	EliteRhino,
	EliteGolem
}

var distance
var direction : int = -1
var isAirbone : bool = false
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var isPushup : bool = false
var orgPos :Vector2
var RCChkSpace : RayCast2D
var speed = 40
var lastPost = Vector2.ZERO

var isDead = false
var isHurt = false
var isBlock = false

var bullet_time_factor = 1.0
#endregion

func set_bullet_time(factor):
	bullet_time_factor = factor
	if factor == 1:
		anim.speed_scale = factor
	else:
		anim.speed_scale = factor * 18

func _ready():
	set_enemy_properties()
	$CanvasLayer/BossHP.visible = false
	orgPos = global_position
	orgChaseSpeed = speed
	RCChkFront.enabled = true
	RCChkGround.enabled = true
	RCChkBack.enabled = true
	lastPost = global_position
	
	if isInactive:
		fsm.changeState("Idle")
	else:
		fsm.changeState("Patrol")

func _physics_process(delta):
	#$Label.text = str(fsm.currentState, " anim - ", anim.current_animation)
	delta *= bullet_time_factor 
	if isImmune:
		pass
	if !is_on_floor() && enemyType != EnemyType.Fly:
		if isAirbone:
			velocity.y = 0
		else:
			velocity.y += gravity * delta / (2 if isPushup && velocity.y > 0 else 1)
	
	if !isInactive and !isDead:
		fsm.physicsUpdate(delta)
		$CanvasLayer/BossHP.visible = true
		
	
	if isInactive and !isDead:
		$CanvasLayer/BossHP.visible = false
	
	Health_bar.value = health
	move_and_slide()

func rotateToPlayer(val:bool = true):
	if(player):
		var dirToPlayer = (1 if val else -1) *  global_position.direction_to(player.global_position).normalized()
		if dirToPlayer.x >=0:
			sprite.flip_h = false
		else:
			sprite.flip_h = true
		flip()

func turnBack():
	sprite.flip_h = ! sprite.flip_h
	flip()
	
func flip():
	direction = -1 if sprite.flip_h else 1
	prop.scale.x = -1 if sprite.flip_h else 1

func isFacingRight()->bool:
	return false if sprite.flip_h else true

func canMove()->bool:
	if(player):
		var _dist = (player.global_position - (global_position))
	return true

func getDist()->Vector2:
	var dist := (player.global_position - (global_position))
	return dist

func canAttack()->bool:
	if enemyType != EnemyType.Fly:
		if(player):
			var dist = (player.global_position - (global_position))
			if abs(dist.x) <= attackRadius:
				return true
	return false

func on_detection_area_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player"):
		player = body
		speed = orgChaseSpeed
		if enemyType != EnemyType.Fly:
			speed = orgChaseSpeed * 2
		fsm.getState("Patrol").tmpSpeed = speed

func on_detection_area_body_exited(body: Node2D) -> void:
	if body.is_in_group("Player"):
		player = null
		speed = orgChaseSpeed
		fsm.getState("Patrol").tmpSpeed = speed

var hit_taken = 0
var isImmune = false

#func take_dmg(attack_name, attacker_pos):
	#if isDead or isHurt:
		#return
		#
	#if isImmune:
		#return
	#
	#if hit_taken > 3:
		#isImmune = true
		#if player:
			#fsm.changeState("Attack")
			#hit_taken = 0
			#isImmune = false
			#return
		#else:
			#fsm.changeState("Patrol")
	#
	#var attack_data = GameManager.get_attack_by_name(attack_name)
	#if attack_data.size() > 0:
		#
		#GameManager.frame_freeze(0.1, 0.098)
		#health -= attack_data.dmg
		#hit_taken += 1
		#health = max(health, 0)
		#
		#$Hit_Vfx/AnimationPlayer.play("hit_vfx")
		#
		#if health <= 0:
			#isDead = true
			#fsm.changeState("Dead")  
			#return
		#
		#var knockback_dir = -1 if attacker_pos.x > global_position.x else 1
		#global_position.x += (attack_data.knockback / 2) * knockback_dir
		#
		#
		#isHurt = true
		#fsm.changeState("Hurt")

#func take_dmg(attack_name, attacker_pos):
	#if isDead or isHurt:
		#return
	#
	#var attack_data = GameManager.get_attack_by_name(attack_name)
	#if attack_data.size() > 0:
		#
		#GameManager.frame_freeze(0.1, 0.098)
		#health -= attack_data.dmg
		#health = max(health, 0)
		#
		#$Hit_Vfx/AnimationPlayer.play("hit_vfx")
		#
		#if health <= 0:
			#isDead = true
			#fsm.changeState("Dead")  
			#return
		#
		#var knockback_dir = -1 if attacker_pos.x > global_position.x else 1
		#global_position.x += attack_data.knockback * knockback_dir
		#
		#isHurt = true
		#fsm.changeState("Hurt")

func take_dmg(attack_name, attacker_pos):
	if isDead or isHurt or isImmune:  # Ignore damage if in immune phase
		return
	
	var attack_data = GameManager.get_attack_by_name(attack_name)
	if attack_data.size() > 0:
		
		GameManager.frame_freeze(0.1, 0.098)
		health -= attack_data.dmg
		health = max(health, 0)
		
		$Hit_Vfx/AnimationPlayer.play("hit_vfx")
		
		if health <= 0:
			isDead = true
			fsm.changeState("Dead")  
			return
		
		var knockback_dir = -1 if attacker_pos.x > global_position.x else 1
		global_position.x += attack_data.knockback * knockback_dir
		
		#isHurt = true
		hit_taken += 1  # Increase hit counter
		
		if hit_taken >= 3:
			activate_immunity()
		
		fsm.changeState("Hurt")

func activate_immunity():
	isImmune = true
	hit_taken = 0  # Reset hit count
	
	# Disable RayCast detection temporarily
	RCChkFront.enabled = false
	RCChkGround.enabled = false
	RCChkBack.enabled = false

	# Start immunity timer
	immune_timer.start()
	$CanvasLayer/BossHP/TextureProgressBar/Label.visible = true
	immune_timer.timeout.connect(_end_immunity, CONNECT_ONE_SHOT)

func _end_immunity():
	isImmune = false

	RCChkFront.enabled = true
	RCChkGround.enabled = true
	RCChkBack.enabled = true
	$CanvasLayer/BossHP/TextureProgressBar/Label.visible = false
	
	fsm.changeState("Attack")

func _on_player_timer_timeout():
	player = null

func _on_detection_area_body_entered(body: Node2D) -> void:
	on_detection_area_body_entered(body)

func _on_detection_area_body_exited(_body: Node2D) -> void:
	on_detection_area_body_exited(_body)

func set_enemy_properties():
	match enemyClass:
		EnemyClass.EliteRhino:
			sprite = rhino_sprite
			speed = 75
			damage = 20
			health = 800
			_exp = 300
			attackRadius = 120
			rhino_sprite.visible = true
			Health_bar.max_value = health

func _on_attack_box_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player") and body.has_method("_take_damage"):
		if body.is_dead:
			isInactive = true
			return
		body._take_damage(damage,global_position,10)

func shrink_Damage_box(amount):
	if amount != 0.0:
		if isFacingRight():
			$prop/AttackBox/CollisionShape2D.position.x += amount
		else:
			$prop/AttackBox/CollisionShape2D.position.x -= amount
	else:
		$prop/AttackBox/CollisionShape2D.position.x = 55.5

func audio_random_pitch():
	enemy_audio.pitch_scale = randf_range(0.5, 1.2)
