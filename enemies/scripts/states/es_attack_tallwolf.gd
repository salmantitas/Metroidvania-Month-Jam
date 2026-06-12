class_name ESAttackTallWolf
extends ESAttack


# EnemyState class will inherit the following variables:
# @export var animation_name : String = "idle"
# var state_machine : EnemyStateMachine
# var enemy : Enemy
# var blackboard : Blackboard

func enter() -> void:
	var effect_sprite : Sprite2D = $"../../Sprite2D/EffectsSprite"
	var flip : bool = blackboard.dir < 0
	if effect_sprite:
		effect_sprite.flip_h = flip
	super()

#func re_enter() -> void:
	#pass
#
#func exit() -> void:
	#pass
#
#func physics_update( _delta : float ) -> void:
	#pass
