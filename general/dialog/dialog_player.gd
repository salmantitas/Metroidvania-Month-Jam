extends CanvasLayer

@export_file("*json") var scene_text_file : String

var scene_text : Dictionary = {}
var selected_text = []
var in_progress : bool = false

@onready var background: TextureRect = $Background
@onready var text_label: Label = $TextLabel

func _ready() -> void:
	background.visible = false
	text_label.text = ""
	scene_text = load_scene_text()
	Messages.display_dialog.connect(_on_display_dialog)
	
func load_scene_text() -> Dictionary:
	if not FileAccess.file_exists(scene_text_file):
		return {}
		
	var file = FileAccess.open(scene_text_file, FileAccess.READ)
	return JSON.parse_string( file.get_as_text())
	
	#var file = FileAccess.open(get_file_name( current_slot ), FileAccess.READ)
	
func _on_display_dialog(text_key : String) -> void:
	if in_progress:
		next_line()
	else:
		get_tree().paused = true
		background.visible = true
		in_progress = true
		selected_text = scene_text[text_key].duplicate()
		show_text()

func next_line() -> void:
	if selected_text.size() > 0:
		show_text()
	else:
		finish()

func show_text() -> void:
	text_label.text = selected_text.pop_front() 

func finish() -> void:
	text_label.text = ""
	background.visible = false
	in_progress = false
	get_tree().paused = false
	
