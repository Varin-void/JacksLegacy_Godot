extends State

func enter():
	owner.isDead = true
	
	owner.velocity = Vector2.ZERO
	owner.RCChkFront.enabled = false
	owner.RCChkGround.enabled = false
	owner.RCChkBack.enabled = false
	
	if owner.enemyClass == owner.EnemyClass.EliteGolem:
		owner.anim.play("GDeath")
	else:
		owner.anim.play("Death")
	
	await owner.anim.animation_finished
	var coin_index = GameManager.getCoinSpread()
	GameManager.current_xp += owner._exp
	if coin_index < GameManager.coinSpreadMax and GameManager.coinSpread[coin_index] != null:
		owner.coinSpread = GameManager.coinSpread[coin_index]
	else:
		print("⚠️ Warning: No valid CoinSpread instance found!")
		owner.coinSpread = null
	
	if owner.coinSpread:
		owner.coinSpread.spawn(owner.global_position)
	else:
		print("Error: CoinSpread instance is null or invalid")

	owner.queue_free()
	owner.visible = false
	owner.isInactive = true
