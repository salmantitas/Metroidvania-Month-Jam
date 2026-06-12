class_name DoomScribeCurse
extends Node2D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$AnimationPlayer.animation_finished.connect( _on_animation_finished )

func _enter_tree() -> void:
	await get_tree().process_frame
	var p : Node2D = get_tree().get_first_node_in_group("Player")
	reparent(p)
	position = Vector2(0, -32)

func damage_player() -> void:
	$AttackArea.activate()

func _on_animation_finished() -> void:
	queue_free()

func set_enemy( e : Enemy ) -> void:
	e.was_killed.connect( _on_enemy_killed )

func _on_enemy_killed() -> void:
	queue_free()
