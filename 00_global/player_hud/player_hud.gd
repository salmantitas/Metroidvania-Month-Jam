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
	
	if SceneManager.is_running_on_mobile():
		$Control/Sprite2D.queue_free()

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
