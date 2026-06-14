class_name Celeste 
extends Boss

func _ready() -> void:
	super()
	$CanvasLayer2.visible = false
	was_killed.connect(_on_boss_killed)

func _on_boss_killed() -> void:
	$CanvasLayer2.visible = true
