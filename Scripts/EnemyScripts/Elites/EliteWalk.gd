extends State

var rand_generate = RandomNumberGenerator.new()
var isHittingWall = false
var connected = false
var tmpSpeed = 0.0

func enter():
	if not connected:
		connected = true
		owner.timer.timeout.connect(on_timeout)

	isHittingWall = false
	owner.anim.play("Walk")
	owner.speed = owner.orgChaseSpeed
	tmpSpeed = owner.speed

	owner.flip()

func physicsUpdate(_delta):
	if owner.player and owner.isImmune:
		owner.player = null  # Ignore player during immune phase
		return
		
	if owner.player and !owner.isDead:
		changeState("Combat")
		return

	owner.velocity.x = owner.direction * owner.speed

	if owner.RCChkGround and not owner.RCChkGround.is_colliding() and owner.is_on_floor():
		if not isHittingWall:
			isHittingWall = true
			move(1)
		return

	elif owner.RCChkFront and owner.RCChkFront.is_colliding():
		if not owner.RCChkFront.get_collider().is_in_group("Player"):
			if not isHittingWall:
				isHittingWall = true
				move(2)  
		else:
			changeState("Patrol")
		return

	elif owner.RCChkBack and owner.RCChkBack.is_colliding():
		if not owner.RCChkBack.get_collider().is_in_group("Player"):
			if not isHittingWall:
				isHittingWall = true
				move(2)  
		else:
			owner.turnBack()
			await get_tree().create_timer(0.25).timeout
			changeState("Attack")
			return

	if abs(owner.global_position.x - owner.lastPost.x) >= owner.patrol_range:
		isHittingWall = false
		move(3)

func exit():
	isHittingWall = false
	owner.timer.stop()
	if connected:
		owner.timer.timeout.disconnect(on_timeout)
		connected = false

func move(_i):
	owner.lastPost = owner.global_position
	owner.anim.play("Idle")
	owner.speed = 0
	owner.timer.stop()
	owner.timer.one_shot = true
	var rand_float = rand_generate.randf_range(owner.actionPauseDuration, owner.actionPauseDuration + 0.5)
	owner.timer.wait_time = rand_float
	owner.timer.start()

func on_timeout():
	owner.turnBack()
	owner.speed = tmpSpeed if owner.player else owner.orgChaseSpeed
	owner.anim.play("Walk")
