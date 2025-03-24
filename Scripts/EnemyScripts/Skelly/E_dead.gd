extends State

func enter():
	owner.isDead = true
	if owner.enemyClass == owner.EnemyClass.Golem:
		owner.anim.play("GDeath")
		owner.coinSpread = GameManager.coinSpread[GameManager.getCoinSpread()]
		owner.coinSpread.spawn(owner.global_position)
	else:
		owner.anim.play("Death")
		owner.coinSpread = GameManager.coinSpread[GameManager.getCoinSpread()]
		owner.coinSpread.spawn(owner.global_position)
	await owner.anim.animation_finished
	owner.visible = false
	owner.queue_free()
	owner.isInactive = true
	
	#owner.reparent($DeadEnemies)
