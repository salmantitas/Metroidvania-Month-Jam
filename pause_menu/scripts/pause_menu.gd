class_name PauseMenu extends CanvasLayer

var player : Player

#region /// On ready variables
@onready var system_menu_button: Button = %SystemMenuButton
@onready var back_to_map_button: Button = %MapMenuButton
@onready var back_to_title_button: Button = %TitleMenuButton
@onready var controls_menu_button: Button = %ControlsMenuButton


@onready var pause_screen: Control = $Control/PauseScreen
@onready var system_screen: Control = $Control/SystemScreen
@onready var music_slider: HSlider = %MusicSlider
@onready var sfx_slider: HSlider = %SFXSlider
@onready var ui_slider: HSlider = %UISlider
#endregion

func _ready() -> void:
	show_pause_screen()
	system_menu_button.pressed.connect( show_system_menu )
	back_to_map_button.pressed.connect ( _on_back_to_map_pressed )
	back_to_title_button.pressed.connect ( _on_back_to_title_pressed )
	controls_menu_button.pressed.connect ( _on_controls_menu_pressed )
	setup_system_menu()
	
func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("pause"):
		get_viewport().set_input_as_handled()
		get_tree().paused = false
		queue_free()
		
	if pause_screen.visible == true:
		if event.is_action_pressed("right") or event.is_action_pressed("down"):
			back_to_map_button.grab_focus()

func show_pause_screen() -> void:
	pause_screen.visible = true
	system_screen.visible = false

func show_system_menu() -> void:
	pause_screen.visible = false
	system_screen.visible = true

func setup_system_menu() -> void:
	#setup sliders
	pass

func _on_back_to_map_pressed():
	pause_screen.visible = true
	system_screen.visible = false
	back_to_map_button.grab_focus()

func _on_back_to_title_pressed():
	SceneManager.transition_scene("res://title_screen/title_screen.tscn", "", Vector2.ZERO, "top")
	get_tree().paused = false
	Messages.back_to_title_screen.emit()
	queue_free()
	
func _on_controls_menu_pressed():
	var controls: Control = $Control/PauseScreen/Controls
	controls.visible = !controls.visible
