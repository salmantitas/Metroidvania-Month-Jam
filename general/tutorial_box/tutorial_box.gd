class_name TutorialBox
extends Node2D

@export var hint : String = ""
@onready var area_2d: Area2D = $Area2D

var visited : bool = false

func _ready() -> void:
	apply_changes()
	
	if Engine.is_editor_hint():
		return
	
	if SaveManager.persistent_data.get_or_add( unique_name() , false) == true:
		visited = true
		queue_free()
	else:
		area_2d.area_entered.connect(_on_player_entered)
		area_2d.area_exited.connect(_on_player_exited)

func _on_player_entered( _n : Node2D):
	print (_n.name)
	Messages.tutorial_hint_changed.emit(hint)
	Messages.input_hint_changed.emit(hint)
	visited = true

func _on_player_exited( _n : Node2D):
	print (_n.name)
	Messages.tutorial_hint_changed.emit("")
	Messages.input_hint_changed.emit("")
	SaveManager.persistent_data[unique_name()] = visited
	queue_free()

func apply_changes() -> void:
	var width = 1
	var height = 1
	area_2d = get_node_or_null("Area2D")
	
	area_2d.scale.x = width
	area_2d.scale.y = height

func unique_name() -> String:
	var unique_name : String = ResourceUID.path_to_uid( owner.scene_file_path )
	unique_name += "/" + get_parent().name + "/" + name
	return unique_name
