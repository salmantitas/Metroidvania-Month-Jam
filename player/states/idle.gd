class_name PlayerStateIdle 
extends PlayerState

func init() -> void:
	pass

func enter() -> void:
	player.animation_player.play("idle")
	player.jump_count = 0
	player.dash_count = 0
	
func exit() -> void:
	pass

# Takes an input and determines which state to change to
func handle_input( event : InputEvent ) -> PlayerState:
	if (event.is_action_pressed("dash")) and player.can_dash():
		return dash
		
	if (event.is_action_pressed("attack")):
		return attack
		
	if (event.is_action_pressed("jump")):
		return jump
		
	if (event.is_action_pressed("action")) and player.can_morph():
		return morph
	return null

func process(_delta: float) -> PlayerState:
	if player.direction.x != 0:
		return run
	elif player.direction.y > 0.5:
		return crouch
	return null

func physics_process(_delta: float) -> PlayerState:
	player.velocity.x = 0
	
	if player.is_on_floor() == false:
		return fall
		
	return next_state
