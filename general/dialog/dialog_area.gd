extends Area2D

@export var dialog_key : String = ""
var area_active : bool = false

func _input(event: InputEvent) -> void:
	if area_active and event.is_action_pressed("action"):
		Messages.display_dialog.emit(dialog_key)
		pass

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	#area_entered.connect(_on_area_entered)
	#area_exited.connect(_on_area_exited)
	Messages.input_hint_changed.connect(_on_area_entered)
	print("ready")

func _on_area_entered(_area : Area2D) -> void:
	print("in")
	area_active = true
	Messages.input_hint_changed.emit("interact")
	
func _on_area_exited(_area : Area2D) -> void:
	print("out")
	area_active = false
	Messages.input_hint_changed.emit("")
