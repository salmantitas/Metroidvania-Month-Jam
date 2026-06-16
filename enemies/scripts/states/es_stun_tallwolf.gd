class_name ESStunTallWolf
extends ESStun


# EnemyState class will inherit the following variables:
# @export var animation_name : String = "idle"
# var state_machine : EnemyStateMachine
# var enemy : Enemy
# var blackboard : Blackboard

#func enter() -> void:
	#pass
#
func re_enter() -> void:
	super()
	duration /= 2
	print(duration)
#
#func exit() -> void:
	#pass
#
#func physics_update( _delta : float ) -> void:
	#pass
#
