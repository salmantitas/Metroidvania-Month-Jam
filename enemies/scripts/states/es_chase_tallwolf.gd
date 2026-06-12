class_name ESChaseTallWolf
extends ESChase

func physics_update( _delta : float ) -> void:
	var dir : float = sign( blackboard.target.global_position.x - enemy.global_position.x )
	enemy.change_direction(dir)
	if blackboard.distance_to_x(enemy.global_position) >= 40:
		enemy.velocity.x = chase_speed * dir
	else:
		enemy.velocity.x = 0
