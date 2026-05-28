class_name TutorialHints
extends Node2D

const HINT_MAP : Dictionary = {
	"movement" : "Move",
	"jump" : "Jump",
	"long jump" : "Long Jump",
	"crouch" : "Crouch",
	"drop down" : "Drop Down",
	"attack" : "Attack",
	"save" : "Save your progress at the flower"
}

@onready var label: Label = $Label

func _ready() -> void:
	visible = false
	Messages.tutorial_hint_changed.connect( _on_hint_changed )
	
func _on_hint_changed( hint : String):
	if hint == "":
		visible = false
	else:
		visible = true
		label.text = HINT_MAP.get(hint.to_lower(), "")
