@tool
@icon("res://general/icons/ability_pickup.svg")

class_name AbilityPickup
extends Node2D

enum Type { DOUBLE_JUMP, DASH, GROUND_SLAM, MORPH}
@export var type : Type = Type.DOUBLE_JUMP :
	set(value):
		type = value
		_set_animation()

@onready var ability_anim: AnimationPlayer = %AbilityAnim
@onready var orb_anim: AnimationPlayer = %OrbAnim
@onready var ability_sprite: Sprite2D = %AbilitySprite
@onready var orb_sprite: Sprite2D = %OrbSprite
@onready var breakable: Breakable = $Breakable

func _ready() -> void:
	_set_animation()
	
	if Engine.is_editor_hint():
		return
	
	if SaveManager.persistent_data.get_or_add(get_ability_name(), "") == "acquired":
		queue_free()
		return	
	
	breakable.damage_taken.connect( _on_damage_taken )
	breakable.destroyed.connect( _on_destroyed )

func _on_damage_taken() -> void:
	orb_sprite.frame += 1
	
func _on_destroyed() -> void:
	SaveManager.persistent_data[get_ability_name()] = "acquired"
	_reward_ability()
	orb_anim.play("destroy")
	await orb_anim.animation_finished
	queue_free()

func _reward_ability() -> void:
	var player = get_tree().get_first_node_in_group("Player")
	match type:
		Type.DOUBLE_JUMP:
			player.double_jump = true
		Type.DASH:
			player.dash = true
		Type.MORPH:
			player.morph = true
		Type.GROUND_SLAM:
			player.ground_slam = true
	
func _set_animation():
	if not ability_anim:
		ability_anim = %AbilityAnim
	ability_anim.play(get_ability_name())

func get_ability_name() -> String :
	match type:
		Type.DOUBLE_JUMP:
			return "double_jump"
		Type.DASH:
			return "dash"
		Type.MORPH:
			return "morph"
		Type.GROUND_SLAM:
			return "ground_slam"
	return ""
