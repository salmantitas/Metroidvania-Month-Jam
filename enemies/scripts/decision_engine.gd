class_name DecisionEngine
extends Node

var enemy : Enemy
var current_state : EnemyState
var blackboard : Blackboard

func _ready() -> void:
	while not enemy:
		await get_tree().process_frame
	enemy.change_direction(-1 if enemy.face_left_on_start else 1)

func decide() -> EnemyState:
	return null
