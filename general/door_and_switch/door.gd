@tool
@icon("res://general/icons/door.svg")
class_name Door
extends Node2D

const DOOR_CRASH_AUDIO = preload("res://general/door_and_switch/door_crash.wav")
@onready var animation_player: AnimationPlayer = $AnimationPlayer

func _ready() -> void:
	if Engine.is_editor_hint():
		return
		
	for c in get_children():
		if c is Switch:
			c.activated.connect(_on_switch_activated)
			if c.is_open == true:
				_on_switch_open()
	
	
func _on_switch_activated() -> void:
	#Play audio
	animation_player.play("open")

func _on_switch_open() -> void:
	animation_player.play("opened")
	
func _get_configuration_warnings() -> PackedStringArray:
	if check_for_switch() == false:
		return ["Requires a Switch node."]
	return []

func check_for_switch() -> bool:
	for c in get_children():
		if c is Switch:
			return true
	return false
