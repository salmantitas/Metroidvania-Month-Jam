class_name ESWalk
extends EnemyState

@export var move_speed : float = 50

var left_limit : float
var right_limit : float

func _ready() -> void:
	_set_limits()

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
	elif enemy.global_position.x <= left_limit and blackboard.dir < 0:
		enemy.change_direction(1.0)
	elif enemy.global_position.x >= right_limit and blackboard.dir > 0:
		enemy.change_direction(-1.0)	
	enemy.velocity.x = move_speed * blackboard.dir

func _set_limits() -> void:
	left_limit = owner.global_position.x - 5000
	right_limit = owner.global_position.x + 5000
	
	
	
	for c in owner.get_children():
		if c is PatrolLimit:
			if c.side == Side.SIDE_LEFT:
				left_limit = c.global_position.x
			else:
				right_limit = c.global_position.x
