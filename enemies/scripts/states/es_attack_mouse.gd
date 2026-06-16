class_name ESAttackMouse
extends ESAttack

var combo = 0
const MAX_COMBO = 4

func enter() -> void:
	print("Entering attack")
	super()
	enemy.animation.animation_finished.connect(_on_animation_finished)

func exit() -> void:
	print("Exiting attack")
	blackboard.can_decide = true
	if combo >= MAX_COMBO:
		combo = 0
		on_cooldown = true
		run_cooldown()
	else:
		on_cooldown = false

func physics_update( delta : float ) -> void:
	timer += delta
	if timer >= duration:
		blackboard.can_decide = true
	if move_speed_curve:
		var sample : float = move_speed_curve.sample(timer / duration)
		enemy.velocity.x = move_speed * sample * blackboard.dir

func can_attack() -> bool:
	if blackboard.distance_to_x(enemy.global_position) <= attack_range and not on_cooldown:
		return true
	return false

func _on_animation_finished(anim_name : String) -> void:
	combo += 1
	print("Combo: ", combo)
