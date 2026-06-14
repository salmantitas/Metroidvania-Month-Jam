class_name ESFlyRetreat
extends EnemyState

@export var chase_speed : float = 100
@export var shoot_state : ESAttack

func enter() -> void:
	print("Enter Retreat")
	var anim : String = animation_name if animation_name else "chase"
	enemy.play_animation( anim )

func re_enter() -> void:
	pass

func exit() -> void:
	print("Exit Retreat")
	enemy.change_direction( -blackboard.dir)

func physics_update( _delta : float ) -> void:
	var dir : Vector2 = enemy.global_position.direction_to( blackboard.target.global_position)
	enemy.change_direction( -sign(dir.x))
	enemy.velocity = chase_speed * -dir

func can_retreat() -> bool:
	var distance = blackboard.distance_to_target
	print(distance)
	return distance < shoot_state.attack_range
