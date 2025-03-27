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

#func physicsUpdate(_delta):
	#if owner.player: #&& !owner.playerTrigger
		#changeState("Combat")
		#return
	##elif owner.player && owner.enemyType == owner.EnemyType.Fly:
		##changeState("Combat")
		##return
#
	#owner.velocity.x = owner.direction * owner.speed
#
	## Check if there's no ground ahead
	#if owner.RCChkGround and not owner.RCChkGround.is_colliding() and owner.is_on_floor():
		#if not isHittingWall:
			#isHittingWall = true
			#move(1)
		#return
#
	## Check if hitting a wall
	#elif owner.RCChkFront and owner.RCChkFront.is_colliding():
		#if not owner.RCChkFront.get_collider().is_in_group("Player"):
			#if not isHittingWall:
				#isHittingWall = true
				#move(2)
		#return
	##elif owner.RCChkBack and owner.RCChkGround.is_colliding():
			###if back raycast collide with player change to combatstate if hit back nth
			##changeState("Combat")
			##return
	## Change direction if enemy has walked too far
	#if abs(owner.global_position.x - owner.lastPost.x) >= owner.patrol_range : #and not owner.playerTrigger
		#isHittingWall = false
		#move(3)
	#else:
		#isHittingWall = false

func physicsUpdate(_delta):
	# If player is detected, switch to Combat state
	if owner.player:
		changeState("Combat")
		return

	owner.velocity.x = owner.direction * owner.speed

	# Check if there's no ground ahead
	if owner.RCChkGround and not owner.RCChkGround.is_colliding() and owner.is_on_floor():
		if not isHittingWall:
			isHittingWall = true
			move(1)  # Move away from the edge
		return

	# Check if hitting a wall
	elif owner.RCChkFront and owner.RCChkFront.is_colliding():
		if not owner.RCChkFront.get_collider().is_in_group("Player"):
			if not isHittingWall:
				isHittingWall = true
				move(2)  # Turn around if a wall is hit
		return

	# Check if enemy gets hit from behind (RCChkBack)
	elif owner.RCChkBack and owner.RCChkBack.is_colliding():
		changeState("Combat")
		return

	# Change direction if enemy has walked too far
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
