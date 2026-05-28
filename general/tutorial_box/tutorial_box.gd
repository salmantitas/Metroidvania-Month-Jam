class_name TutorialBox
extends Node2D

@export var hint : String = ""
@onready var area_2d: Area2D = $Area2D

var visited : bool = false

func _ready() -> void:
	if Engine.is_editor_hint():
		return
		
	apply_changes()
	area_2d.body_entered.connect(_on_player_entered)
	area_2d.body_exited.connect(_on_player_exited)

func _on_player_entered( _n : Node2D):
	#Messages.player_interacted.connect( _on_player_interacted)
	if visited:
		return
	Messages.tutorial_hint_changed.emit(hint)
	Messages.input_hint_changed.emit(hint)
	visited = true

func _on_player_exited( _n : Node2D):
	#Messages.player_interacted.disconnect( _on_player_interacted)	
	Messages.tutorial_hint_changed.emit("")
	Messages.input_hint_changed.emit("")
	#area_2d.monitoring = false
	#queue_free()

func _on_player_interacted( player : Player):
	print("Player interacted")

func apply_changes() -> void:
	var width = 1
	var height = 1
	area_2d = get_node_or_null("Area2D")
	
	area_2d.scale.x = width
	area_2d.scale.y = height
