#extends State
#
#@export var ult_duration: float = 2.5  # Ultimate lasts for 2.5 seconds
#@export var ult_cooldown: float = 30.0  # Cooldown is 30 seconds
#
#var ult_timer
#
#func enter():
	#owner.velocity.x = 0
	#owner.resetSpeed(0)
#
	#if not owner.is_on_floor():
		#changeState("Idle")
		#return
#
	#owner.setAbilty("Ultimate", true)
	#owner.anim.play("Ultimate")
	#
	#ult_timer = get_tree().create_timer(ult_duration)
	#ult_timer.timeout.connect(_on_ult_timer_timeout)
#
#func exit():
	#owner.blockflip = false
	#owner.setAbilty("Ultimate", false )
	#owner.resetSpeed(owner.original_speed)
	#owner.ult_timer.start()
#
#func _on_ult_timer_timeout():
	#resetUltimate()
	#changeState("Idle")
	#start_cooldown()
#
#func resetUltimate():
	#if ult_timer:
		#ult_timer.timeout.disconnect(_on_ult_timer_timeout)
#
#func start_cooldown():
	#owner.canUseUltimate = false
	#await get_tree().create_timer(ult_cooldown).timeout
	#owner.canUseUltimate = true

extends State

var ult_on_cooldown = false  # Tracks cooldown status

func enter():
	if ult_on_cooldown:
		changeState("Idle")
		return  # Prevent ultimate if it's on cooldown

	owner.velocity.x = 0
	owner.resetSpeed(0)

	if not owner.is_on_floor():
		changeState("Idle")
		return

	ult_on_cooldown = true  # Start cooldown
	owner.setAbilty("Ultimate", true)
	owner.anim.play("Ultimate")
	await owner.anim.animation_finished
	%UltimateIcon.modulate = Color("5a5a5a46")
	
	# Start cooldown timer
	owner.ult_timer.start()
	changeState("Idle")

func exit():
	owner.blockflip = false
	owner.setAbilty("Ultimate", false)
	owner.resetSpeed(owner.original_speed)
	owner.isImmune = false
	# Connect timer timeout event if not already connected
	if not owner.ult_timer.is_connected("timeout", Callable(self, "_reset_ultimate")):
		owner.ult_timer.connect("timeout", Callable(self, "_reset_ultimate"))

func _reset_ultimate():
	ult_on_cooldown = false  # Allow ultimate again%UltimateIcon
	%UltimateIcon.modulate = Color("ffffff")
	owner.ult_timer.stop()  # Ensure timer is stopped
