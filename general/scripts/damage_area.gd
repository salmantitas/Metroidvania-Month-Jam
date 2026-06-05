@icon("res://general/icons/damage_area.svg")

class_name DamageArea
extends Area2D

signal damage_taken ( attack_area ) 

@export var audio : AudioStream

func _ready() -> void:
	monitorable = true
	monitoring = false

func take_damage( attack_area : AttackArea ) -> void:
	damage_taken.emit ( attack_area )
	if audio:
		Audio.play_spatial_sound( audio, global_position )

func make_invulnerable( duration : float = 1 ) -> void:
	process_mode = Node.PROCESS_MODE_DISABLED
	visible = false
	await get_tree().create_timer(1).timeout
	process_mode = Node.PROCESS_MODE_INHERIT
	visible = true

func start_invulnerable() -> void:
	process_mode = Node.PROCESS_MODE_DISABLED
	
func end_invulnerable() -> void:
	process_mode = Node.PROCESS_MODE_INHERIT
