class_name PlayerStateDeath 
extends PlayerState

const AUDIO_DEATH = preload("uid://bonphniwprq0u")

func enter() -> void:
	player.animation_player.play("death")
	Audio.play_spatial_sound(AUDIO_DEATH, player.global_position, true)
	Audio.play_music(null)
	await player.animation_player.animation_finished
	PlayerHud.show_game_over()
	
func exit() -> void:
	pass

# Takes an input and determines which state to change to
func handle_input( _event : InputEvent ) -> PlayerState:
	return null

func process(_delta: float) -> PlayerState:
	return null

func physics_process(_delta: float) -> PlayerState:
	player.velocity.x = 0
	return null
