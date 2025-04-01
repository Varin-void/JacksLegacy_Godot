extends State

@export var ult_duration: float = 2.5  # Ultimate lasts for 2.5 seconds
@export var ult_cooldown: float = 30.0  # Cooldown is 30 seconds

var ult_timer

func enter():
	owner.velocity.x = 0
	owner.resetSpeed(0)

	if not owner.is_on_floor():
		changeState("Idle")
		return

	owner.setAbilty("Ultimate", true)
	owner.anim.play("Ultimate")
	
	ult_timer = get_tree().create_timer(ult_duration)
	ult_timer.timeout.connect(_on_ult_timer_timeout)

func _on_ult_timer_timeout():
	resetUltimate()
	changeState("Idle")
	start_cooldown()

func resetUltimate():
	if ult_timer:
		ult_timer.timeout.disconnect(_on_ult_timer_timeout)

func start_cooldown():
	owner.canUseUltimate = false
	await get_tree().create_timer(ult_cooldown).timeout
	owner.canUseUltimate = true

func exit():
	owner.blockflip = false
	owner.setAbilty("Ultimate", false )
	owner.resetSpeed(owner.original_speed)
	
