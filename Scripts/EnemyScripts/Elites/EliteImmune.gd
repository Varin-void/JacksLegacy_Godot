extends State
var connected = false

func enter():
	owner.isImmune = true
	owner.velocity.x = 0
	
	owner.anim.play("Buffer")
	
	if not connected:
		connected = true
		owner.anim.animation_finished.connect(on_animation_finish)

func exit():
	if connected:
		owner.anim.animation_finished.disconnect(on_animation_finish)
	connected = false
	$"../../prop/AttackBox/CollisionShape2D".disabled = true

	owner.isImmune = false
	owner.hit_taken = 0

func on_animation_finish(_animName):
	changeState("Combat")
