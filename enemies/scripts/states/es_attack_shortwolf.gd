class_name ESAttackShortwolf
extends ESAttack

@export var jump_velocity = 10

func physics_update( delta : float ) -> void:
	timer += delta
	if timer >= duration:
		blackboard.can_decide = true
	if move_speed_curve:
		var sample : float = move_speed_curve.sample(timer / duration)
		enemy.velocity.x = move_speed * sample * blackboard.dir
	
	
	
func do_jump() -> void:
	enemy.velocity.y = -jump_velocity

func can_attack() -> bool:
	if blackboard.distance_to_x(enemy.global_position) <= attack_range and not on_cooldown:
		return true
	return false
