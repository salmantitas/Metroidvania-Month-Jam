class_name ESFlyChase
extends EnemyState

@export var chase_speed : float = 100

func enter() -> void:
	var anim : String = animation_name if animation_name else "chase"
	enemy.play_animation( anim )

func re_enter() -> void:
	pass

func exit() -> void:
	pass

func physics_update( _delta : float ) -> void:
	var dir : Vector2 = enemy.global_position.direction_to( blackboard.target.global_position)
	enemy.change_direction( sign(dir.x))
	enemy.velocity = chase_speed * dir
