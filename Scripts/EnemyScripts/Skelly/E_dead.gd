extends State

func enter():
	owner.isDead = true
	owner.isInactive = true
	if owner.enemyClass == owner.EnemyClass.Golem:
		owner.anim.play("GDeath")
		GameManager.hit_stop(0.5)
		
	else:
		owner.anim.play("Death")
		GameManager.hit_stop(0.5)
	await owner.anim.animation_finished
	
	var coin_index = GameManager.getCoinSpread()
	if coin_index < GameManager.coinSpreadMax and GameManager.coinSpread[coin_index] != null:
		owner.coinSpread = GameManager.coinSpread[coin_index]
	else:
		print("⚠️ Warning: No valid CoinSpread instance found!")
		owner.coinSpread = null
	
	if owner.coinSpread:
		owner.coinSpread.spawn(owner.global_position)
	else:
		print("Error: CoinSpread instance is null or invalid")

	
	owner.visible = false
	owner.queue_free()
	owner.isInactive = true
