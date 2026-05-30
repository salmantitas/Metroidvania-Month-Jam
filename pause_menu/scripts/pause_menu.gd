class_name PauseMenu extends CanvasLayer

var player : Player

#region /// On ready variables
@onready var system_menu_button: Button = %SystemMenuButton
@onready var back_to_map_button: Button = %MapMenuButton
@onready var back_to_title_button: Button = %TitleMenuButton
@onready var controls_menu_button: Button = %ControlsMenuButton

@onready var pause_screen: Control = $Control/PauseScreen
@onready var system_screen: Control = $Control/SystemScreen
@onready var controls_screen: Control = $Control/ControlsScreen
@onready var music_slider: HSlider = %MusicSlider
@onready var sfx_slider: HSlider = %SFXSlider
@onready var ui_slider: HSlider = %UISlider
#endregion

var player_position : Vector2

func _ready() -> void:
	show_pause_screen()
	system_menu_button.pressed.connect( show_system_menu )
	back_to_map_button.pressed.connect ( _on_back_to_map_pressed )
	back_to_title_button.pressed.connect ( _on_back_to_title_pressed )
	controls_menu_button.pressed.connect ( _on_controls_menu_pressed )
	Audio.setup_button_audio(self)
	setup_system_menu()
	var player : Player = get_tree().get_first_node_in_group("Player")
	if player:
		player_position = player.global_position
	
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
	controls_screen.visible = false

func show_system_menu() -> void:
	pause_screen.visible = false
	controls_screen.visible = false
	system_screen.visible = true

func setup_system_menu() -> void:
	music_slider.value = AudioServer.get_bus_volume_linear(2)
	sfx_slider.value = AudioServer.get_bus_volume_linear(3)
	ui_slider.value = AudioServer.get_bus_volume_linear(4)

	music_slider.value_changed.connect( _on_music_slider_changed )
	sfx_slider.value_changed.connect( _on_sfx_slider_changed )
	ui_slider.value_changed.connect( _on_ui_slider_changed )

func _on_back_to_map_pressed():
	pause_screen.visible = true
	system_screen.visible = false
	controls_screen.visible = false
	back_to_map_button.grab_focus()

func _on_back_to_title_pressed():
	SceneManager.transition_scene("res://title_screen/title_screen.tscn", "", Vector2.ZERO, "top")
	get_tree().paused = false
	Messages.back_to_title_screen.emit()
	queue_free()
	
func _on_controls_menu_pressed():
	controls_screen.visible = true
	pause_screen.visible = false
	system_screen.visible = false

func _on_music_slider_changed(value : float) -> void:
	AudioServer.set_bus_volume_linear(2, value)
	SaveManager.save_configuration()

func _on_sfx_slider_changed(value : float) -> void:
	AudioServer.set_bus_volume_linear(3, value)
	Audio.play_spatial_sound(Audio.ui_focus_audio, player_position)
	SaveManager.save_configuration()

func _on_ui_slider_changed(value : float) -> void:
	AudioServer.set_bus_volume_linear(4, value)
	Audio.ui_focus_change()
	SaveManager.save_configuration()
