extends State

func enter():
	owner.velocity.x=0
	
	owner.velocity = Vector2.ZERO  # Ensure it stops moving
	owner.RCChkFront.enabled = false
	owner.RCChkGround.enabled = false
	owner.RCChkBack.enabled = false
	
	if owner.enemyClass == owner.EnemyClass.Golem:
		owner.anim.play("GDeath")
	else:
		owner.anim.play("Death")
	
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
	if not owner.anim.animation_finished.is_connected(on_animation_finished):
		owner.anim.animation_finished.connect(on_animation_finished)

func on_animation_finished(anim_name):
	owner.anim.animation_finished.disconnect(on_animation_finished)

	owner.visible = false
	await get_tree().create_timer(1.0).timeout  # Delay before freeing
	owner.queue_free()
	owner.set_process(false)
