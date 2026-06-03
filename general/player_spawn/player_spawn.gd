@icon("res://general/icons/player_spawn.svg")

class_name PlayerMVMSpawn
extends Node2D

func _ready() -> void:
	visible = false
	await get_tree().process_frame
	
	# Check if player is already there
	if get_tree().get_first_node_in_group("Player"):
		return
	# If not, instanstiate
	var player : Player = load("res://player/player_shojolita.tscn").instantiate()
	get_tree().root.add_child(player)
	# Position player in the level
	player.global_position = self.global_position
