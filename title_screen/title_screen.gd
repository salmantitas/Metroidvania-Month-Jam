extends CanvasLayer

#region /// On ready variables 
@onready var main_menu: VBoxContainer = %MainMenu
@onready var new_game_menu: VBoxContainer = %NewGameMenu
@onready var load_game_menu: VBoxContainer = %LoadGameMenu2
@onready var new_game_button: Button = $MainMenu/NewGameButton
@onready var load_game_button: Button = $MainMenu/LoadGameButton
@onready var new_slot_2: Button = %NewSlot2
@onready var new_slot_3: Button = %NewSlot3
@onready var new_slot_1: Button = %NewSlot1
@onready var load_slot_1: Button = %LoadSlot1
@onready var load_slot_3: Button = %LoadSlot3
@onready var load_slot_2: Button = %LoadSlot2
@onready var new_back: Button = %NewBack
@onready var load_back: Button = %LoadBack

@onready var animation_player: AnimationPlayer = $MainMenu/Logo/AnimationPlayer
#endregion

func _ready() -> void:
	#connect to button signals
	new_game_button.pressed.connect( _show_new_game_menu )
	load_game_button.pressed.connect( _show_load_game_menu )
	
	new_slot_1.pressed.connect( _on_new_game_pressed.bind(0) )
	new_slot_2.pressed.connect( _on_new_game_pressed.bind(1) )
	new_slot_3.pressed.connect( _on_new_game_pressed.bind(2) )
	
	load_slot_1.pressed.connect( _on_load_game_pressed.bind(0) )
	load_slot_2.pressed.connect( _on_load_game_pressed.bind(1) )
	load_slot_3.pressed.connect( _on_load_game_pressed.bind(2) )
	
	new_back.pressed.connect( show_main_menu )
	load_back.pressed.connect( show_main_menu )
	
	#add audio to buttons
	show_main_menu()
	animation_player.animation_finished.connect( _on_animation_finished )
	pass	

func show_main_menu() -> void:
	main_menu.visible  = true
	new_game_menu.visible = false
	load_game_menu.visible = false
	new_game_button.grab_focus()
	
func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_cancel"):
		if main_menu.visible == false:
			#audio
			show_main_menu()

func _on_animation_finished( anim_name : String) -> void:
	if anim_name == "start":
		animation_player.play("loop")

func _show_new_game_menu():
	main_menu.visible  = false
	new_game_menu.visible = true
	load_game_menu.visible = false
	
	new_slot_1.grab_focus()
	
	if SaveManager.save_file_exists ( 0):
		new_slot_1.text = "Replace Slot 1"
	if SaveManager.save_file_exists ( 1):
		new_slot_2.text = "Replace Slot 2"
	if SaveManager.save_file_exists ( 2):
		new_slot_3.text = "Replace Slot 3"
		
func _show_load_game_menu():
	main_menu.visible  = false
	new_game_menu.visible = false
	load_game_menu.visible = true
	
	load_slot_1.grab_focus()
	
	load_slot_1.disabled = not SaveManager.save_file_exists (0)
	load_slot_2.disabled = not SaveManager.save_file_exists (1)
	load_slot_3.disabled = not SaveManager.save_file_exists (2)

func _on_new_game_pressed( slot : int):
	SaveManager.create_new_game_save( slot )
	#SceneManager.transition_scene(
		#SaveManager.new_game_scene_path,
		#"",
		#Vector2.ZERO,
		#"up"
	#)
	#SaveManager.setup_player()

func _on_load_game_pressed( slot : int):
	SaveManager.load_game( slot )
