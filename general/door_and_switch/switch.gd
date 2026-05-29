@icon("res://general/icons/switch.svg")

class_name Switch
extends Node2D

signal activated

const DOOR_SWITCH_AUDIO = preload("uid://bn556fhdwmhrx")

var is_open = false

@onready var sprite_2d: Sprite2D = $Sprite2D
@onready var area_2d: Area2D = $Area2D

func _ready() -> void:
	if SaveManager.persistent_data.get_or_add( unique_name() , "closed") == "open":
		is_open = true
		set_open()
	else:
		area_2d.body_entered.connect(_on_player_entered)
		area_2d.body_exited.connect(_on_player_exited)

func _on_player_entered( _n : Node2D ):
	Messages.input_hint_changed.emit("interact")
	Messages.player_interacted.connect( _on_player_interacted )
	
func _on_player_exited( _n : Node2D ) -> void:
	Messages.input_hint_changed.emit("")
	Messages.player_interacted.disconnect( _on_player_interacted )	

func _on_player_interacted( _n : Node2D ) -> void:
	SaveManager.persistent_data[unique_name()] = "open"
	activated.emit()
	set_open()
	

func set_open() -> void:
	sprite_2d.flip_h = true
	sprite_2d.modulate = Color.GRAY
	area_2d.queue_free()

func unique_name() -> String:
	var unique_name : String = ResourceUID.path_to_uid( owner.scene_file_path )
	unique_name += "/" + get_parent().name + "/" + name
	return unique_name
