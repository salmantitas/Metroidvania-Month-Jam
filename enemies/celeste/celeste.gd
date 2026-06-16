class_name Celeste 
extends Boss

func _ready() -> void:
	super()
	was_killed.connect(_on_boss_killed)

func _on_boss_killed() -> void:
	SceneManager.transition_scene("res://end_screen.tscn", "", Vector2.ZERO, "top")
	await SceneManager.scene_entered
	var player = get_tree().get_first_node_in_group("Player")
	player.queue_free()
	PlayerHud.hide_hud()
