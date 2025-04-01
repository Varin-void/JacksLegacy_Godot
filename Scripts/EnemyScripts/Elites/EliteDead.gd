extends State

var sigil = Node2D

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
	
	instantiate_sigil()
	
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

func instantiate_sigil():
		# Instantiate the sigil node, make it visible, and enable its collision box
	sigil = preload("uid://d2sjt0jil1l0i").instantiate() as SigilsUnlock
	
	# Find the level node by checking the group
	var level_node = get_tree().get_nodes_in_group("Level").front()
	if level_node:
		level_node.add_child(sigil)  # Add sigil to the level node
	else:
		print("⚠️ Warning: No node found in 'level' group!")

	sigil.global_position = owner.global_position
	sigil.visible = true
	
	var pickup_node = sigil.get_node_or_null("PickUP")
	if pickup_node:
		var collision_shape = pickup_node.get_node_or_null("CollisionShape2D")
		if collision_shape:
			collision_shape.disabled = false
	else:
		print("⚠️ Warning: 'PickUP' node not found in sigil!")
