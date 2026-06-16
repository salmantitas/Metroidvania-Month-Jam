class_name ESChaseToAttack
extends ESChase

@export var attack_state : ESAttack

func physics_update( _delta : float ) -> void:
	var dir : float = sign( blackboard.target.global_position.x - enemy.global_position.x )
	enemy.change_direction(dir)
	if blackboard.distance_to_x(enemy.global_position) >= attack_state.attack_range:
		enemy.velocity.x = chase_speed * dir
		enemy.animation.play(animation_name)
	else:
		enemy.velocity.x = 0
		enemy.animation.play("attack")
		enemy.animation.seek(0, false)
