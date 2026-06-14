class_name ESIdle
extends EnemyState


# EnemyState class will inherit the following variables:
# @export var animation_name : String = "idle"
# var state_machine : EnemyStateMachine
# var enemy : Enemy
# var blackboard : Blackboard

func enter() -> void:
	enemy.animation.play(animation_name)
	enemy.velocity = Vector2.ZERO
	
func re_enter() -> void:
	pass

func exit() -> void:
	pass

func physics_update( _delta : float ) -> void:
	if blackboard.target == null:
		return 
	var distance : float = blackboard.target.global_position.distance_to(enemy.global_position)
	var dir : float = sign(distance)
	enemy.change_direction(dir)
