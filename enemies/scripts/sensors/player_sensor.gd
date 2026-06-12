@icon("res://general/icons/player_sensor.svg")
class_name PlayerSensor extends Area2D

signal player_entered
signal player_exited
signal started_searching

@export var search_duration : float = 2
@export var use_audio_sensor : bool = true
@export var audio_detect_distance : float = 512
@export var min_audio_sense : float = 0.25

var can_see_player : bool = false
var enemy : Enemy
var search_timer : float 


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	set_collision_layer_value(1, false)
	set_collision_mask_value(1, false)
	
	if owner is Enemy:
		enemy = owner
		body_entered.connect( _on_body_entered )
		body_exited.connect( _on_body_exited )
		set_collision_mask_value(5, true)
		if use_audio_sensor:
			Audio.player_made_sound.connect( _on_player_sound )
		enemy.direction_changed.connect( _on_direction_changed )
		monitoring = true
		monitorable = false


func _physics_process( delta: float ) -> void:
	if search_timer > 0 and not can_see_player:
		search_timer -= delta
	
		if search_timer <= 0:
			player_exited.emit()
			enemy.blackboard.target = null

func _on_body_entered (node : Node2D) -> void:
	player_entered.emit()
	can_see_player = true
	enemy.blackboard.target = node
	
func _on_body_exited (_node : Node2D) -> void:
	started_searching.emit()
	can_see_player = false
	search_timer = search_duration

func _on_direction_changed (new_dir : float) -> void:
	if new_dir > 0:
		scale.x = 1
	elif new_dir < 1:
		scale.x = -1

func _on_player_sound (pos : Vector2, volume : float) -> void:
	#print("Player made sound at ", pos, " at volume ", volume)
	var sound_distance :float = global_position.distance_to(pos)
	var sound_ratio : float = clampf(1 - sound_distance/ audio_detect_distance, 0, 1) * 2.5
	var perceived_volume : float = volume * sound_ratio
	if perceived_volume >= min_audio_sense:
		search_timer = search_duration
		enemy.blackboard.target = get_tree().get_first_node_in_group("Player")
