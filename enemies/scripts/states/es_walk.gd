class_name ESWalk
extends EnemyState

@export var move_speed : float = 50

func enter() -> void:
	var anim : String = animation_name if animation_name else "walk"
	enemy.play_animation( anim )

func re_enter() -> void:
	pass

func exit() -> void:
	pass

func physics_update( _delta : float ) -> void:
	if enemy.is_on_wall():
		enemy.change_direction(-blackboard.dir)
	enemy.velocity.x = move_speed * blackboard.dir
