extends Node

@warning_ignore("unused_signal")
signal player_interacted( player : Player)

@warning_ignore("unused_signal")
signal player_healed ( amount : float)

@warning_ignore("unused_signal")
signal player_health_changed ( amount : float)

@warning_ignore("unused_signal")
signal input_hint_changed ( hint : String)

@warning_ignore("unused_signal")
signal tutorial_hint_changed ( hint : String)

@warning_ignore("unused_signal")
signal back_to_title_screen()

@warning_ignore("unused_signal")
signal powerup_acquired( powerup : String)

@warning_ignore("unused_signal")
signal display_dialog(text_key)
