extends State

var animName = "Walk"
func enter():
	
	owner.velocity.x = 0
	if owner.player :
		owner.rotateToPlayer()
	if owner.enemyType == owner.EnemyType.Fixed:
		owner.anim.play(animName)
	else:
		owner.anim.play("Idle")

func physicsUpdate(delta):
	if !owner.player:
		changeState("Patrol")
		return
		
	var dist = owner.getDist()
	if abs(dist.x) >= owner.attackRadius * 3:
		animName = "Walk"
		owner.velocity.x = 0
		owner.speed = owner.orgChaseSpeed * 1.5
	else:
		owner.velocity.x = 0
		owner.speed = owner.orgChaseSpeed
		animName = "Walk"
	if owner.enemyType != owner.EnemyType.Fixed:
		owner.rotateToPlayer()
		if !owner.player:
			changeState("Patrol")
		else:
			if owner.enemyType == owner.EnemyType.Fly:
				var target = owner.player.global_position
				if owner.isHeight():
					target.y = owner.global_position.y
				
				if(floor(abs(dist.x))<owner.attackRadius && owner.attackRadius>0):
					#target.x = owner.player.global_position.x + 120
					#print("state Locationg")
					
					#changeState("Locating")
					return
				
				owner.global_position = owner.global_position.move_toward(target,owner.speed * delta)
			else:
				if (!owner.RCChkGround.is_colliding() && owner.is_on_floor()) || \
					(owner.RCChkFront.is_colliding() && !owner.RCChkFront.get_collider().is_in_group("Player")):
					owner.player = null
					changeState("Patrol")
					return
					
				if owner.canMove():
					if owner.player.is_on_floor() && abs(dist.y)>=owner.attackHeight && abs(dist.x)<=50:
						#print("Jump")
						pass
					owner.anim.play(animName)
					owner.global_position = owner.global_position.move_toward(
						Vector2(owner.player.global_position.x,owner.global_position.y) ,owner.speed * delta)
				else:
					#changeState("idle")
					owner.anim.play("Idle")
					return
			if owner.canAttack():
				if owner.player.is_on_floor() && abs(dist.y)>=owner.attackHeight:
					#print("state routing")
					#changeState("Routing")
					pass
				else:
					#print("state attack")
					changeState("Attack")
			else:
				owner.anim.play("Idle" if owner.enemyType == owner.EnemyType.Fly else animName)

func exit():
	animName = "Walk"
