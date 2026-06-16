extends CanvasLayer

@onready var hp_margin_container: MarginContainer = %HPMarginContainer
@onready var hp_bar: TextureProgressBar = %HPBar

@onready var game_over: Control = %GameOver
@onready var load_button: Button = %LoadButton
@onready var quit_button: Button = %QuitButton


func _ready() -> void:
	Messages.player_health_changed.connect( update_health_bar )
	%GameOver.visible = false
	load_button.pressed.connect( _on_load_pressed )
	quit_button.pressed.connect( _on_quit_pressed )
	
	SceneManager.scene_entered.connect( _on_scene_entered )
	
	if SceneManager.is_running_on_mobile():
		$Control/Sprite2D.queue_free()
	elif SceneManager.is_running_on_web():
		$Control/Sprite2D.frame = 15
	else:
		$Control/Sprite2D.frame = 14

func update_health_bar( hp : float, max_hp : float) -> void:
	var value : float = (hp/max_hp) * 100
	hp_bar.value = value
	hp_margin_container.size.x = max_hp + 22

func show_game_over() -> void:
	load_button.visible = false
	quit_button.visible = false
	
	game_over.modulate.a = 0
	game_over.visible = true
	
	var tween : Tween = create_tween()
	tween.tween_property(game_over, "modulate", Color.WHITE, 3.0)
	
	await tween.finished
	
	load_button.visible = true
	quit_button.visible = true
	
	load_button.grab_focus()
	
func clear_game_over() -> void:
	load_button.visible = false
	quit_button.visible = false
	await SceneManager.scene_entered
	game_over.visible = false 
	var player = get_tree().get_first_node_in_group("Player")
	player.queue_free()

func _on_load_pressed() -> void:
	SaveManager.load_game(SaveManager.current_slot)
	clear_game_over()
	
func _on_quit_pressed() -> void:
	SceneManager.transition_scene("uid://c2iu2rqjvhsko", "", Vector2.ZERO, "top")
	clear_game_over()
#	get_tree().paused = false
#	Messages.back_to_title_screen.emit()

func hide_hud() -> void:
	%HPMarginContainer.visible = false
	$Control/Sprite2D.visible = false
	print("hidden")

func show_hud() -> void:
	%HPMarginContainer.visible = true
	$Control/Sprite2D.visible = true
	print("shown")

func hud_visible() -> bool:
	return %HPMarginContainer.visible or $Control/Sprite2D.visible

func _on_scene_entered( scene_uid : String ) -> void:
	if scene_uid == "uid://c2iu2rqjvhsko" or scene_uid == "uid://b8p7td8dgl6im" or scene_uid == "uid://di08nmr3pvih2":
		hide_hud()
	else:
		show_hud()
