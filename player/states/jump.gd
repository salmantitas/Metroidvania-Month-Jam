class_name PlayerStateJump
extends PlayerState

@export var jump_velocity : float = 450
const AUDIO_JUMP = preload("uid://dbrjtobxxoni2")

func init() -> void:
	pass

func enter() -> void:
	if player.is_on_floor():	
		VisualEffects.jump_dust( player.global_position )
	else:
		VisualEffects.hit_dust( player.global_position )
	player.animation_player.play("jump")
	player.animation_player.pause()
	
	do_jump()
	#player.add_debug_indicator(Color.LIME_GREEN)
	
	if player.previous_state == fall and not Input.is_action_pressed("jump"):
		await get_tree().physics_frame
		player.velocity.y *= 0.5
		player.change_state(fall)
	
func exit() -> void:
	#player.add_debug_indicator(Color.YELLOW)
	pass

# Takes an input and determines which state to change to
func handle_input( event : InputEvent ) -> PlayerState:
	if (event.is_action_pressed("dash")) and player.can_dash():
		return dash
		
	if (event.is_action_pressed("attack")):
		if player.ground_slam and Input.is_action_pressed("down"):
			return ground_slam
		return attack
		
	if event.is_action_released("jump"):
		return fall
	
	if (event.is_action_pressed("action")) and player.can_morph():
		return morph
	return next_state

func process(_delta: float) -> PlayerState:
	set_jump_frame();
	return next_state

func physics_process(_delta: float) -> PlayerState:
	if player.is_on_floor():
		return idle
	elif player.velocity.y >= 0:
		return fall
	player.velocity.x = player.direction.x * player.move_speed
	
	return next_state
	
func do_jump() -> void:
	if player.jump_count > 0:
		if player.double_jump == false:
			return
		elif player.jump_count > 1:
			return
	
	player.jump_count += 1
	player.velocity.y = -jump_velocity
	Audio.play_spatial_sound(AUDIO_JUMP, player.global_position,  false, true, 0.25)

func set_jump_frame() -> void:
	var frame : float = remap(player.velocity.y, -jump_velocity, 0.0, 0.0, 0.5)
	player.animation_player.seek(frame, true)
