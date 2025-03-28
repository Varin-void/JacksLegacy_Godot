extends State

var animName = "Walk"
var randomAttack
func enter():
	
	owner.velocity.x = 0
	if owner.player :
		owner.rotateToPlayer()
	if owner.enemyType == owner.EnemyType.Fixed:
		owner.anim.play(animName)
	else:
		owner.anim.play("Idle")

func physicsUpdate(delta):
	if owner.player and owner.isImmune:
		owner.player = null  # Ignore player during immune phase
		return
		
	if !owner.player and !owner.isDead:
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
			if owner.enemyType == owner.EnemyType.Ground:
				if (!owner.RCChkGround.is_colliding() && owner.is_on_floor()) || \
					(owner.RCChkFront.is_colliding() && !owner.RCChkFront.get_collider().is_in_group("Player")):
					owner.player = null
					changeState("Patrol")
					return
					
				if owner.canMove():
					owner.anim.play(animName)
					owner.global_position = owner.global_position.move_toward(
						Vector2(owner.player.global_position.x,owner.global_position.y) ,owner.speed * delta)
				else:
					owner.anim.play("Idle")
					return
			if owner.canAttack() and !owner.isDead:
				if owner.player.is_on_floor() && abs(dist.y) >= owner.attackHeight:
					pass
				else:
					owner.rotateToPlayer()
					randomAttack = "Attack" + str(randi_range(1, 3))
					changeState("Attack")
			else:
				owner.anim.play("Idle" if owner.enemyType == owner.EnemyType.Fly else animName)

func exit():
	animName = "Walk"
