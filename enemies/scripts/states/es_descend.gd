class_name ESDescend
extends EnemyState

@export var move_speed : float = 50
@export var descent_y : float = 600

var can_descend : bool = true


func enter() -> void:
	var anim : String = animation_name if animation_name else "walk"
	enemy.play_animation( anim )

func re_enter() -> void:
	pass

func exit() -> void:
	pass

func physics_update( _delta : float ) -> void:
	if enemy.global_position.y < descent_y:
		enemy.velocity = Vector2(0, move_speed)
	else:
		can_descend = false
