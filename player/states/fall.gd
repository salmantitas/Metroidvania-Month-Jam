class_name PlayerStateFall
extends PlayerState

@export var fall_gravity_multiplier : float = 1.165
@export var coyote_time : float = 0.125
@export var jump_buffer_time : float = 0.2

var coyote_timer : float = 0
var buffer_timer : float = 0

const AUDIO_LAND = preload("uid://cg4l8ntp265vl")

func init() -> void:
	pass

func enter() -> void:
	player.animation_player.play("jump")
	player.animation_player.pause()
	player.gravity_multiplier = fall_gravity_multiplier
	
	if player.jump_count == 0:
		player.jump_count = 1
		
	var previous : PlayerState = player.previous_state
	if previous == jump or previous == attack or previous == dash:
		coyote_timer = 0
	elif player.previous_state == crouch:
		coyote_timer = 0
		player.jump_count = 1
	else:
		coyote_timer = coyote_time
	pass
	
func exit() -> void:
	player.gravity_multiplier = 1.0
	buffer_timer = 0

# Takes an input and determines which state to change to
func handle_input( event : InputEvent ) -> PlayerState:
	if event.is_action_pressed("dash") and player.can_dash():
		return dash
		
	if event.is_action_pressed("attack"):
		if player.ground_slam and Input.is_action_pressed("down"):
			return ground_slam
		return attack
		
	if event.is_action_pressed("jump"):
		if coyote_timer >  0:
			player.jump_count = 0
			return jump
		elif player.jump_count <= 1 and player.double_jump:
			return jump
		else:
			buffer_timer = jump_buffer_time
	if (event.is_action_pressed("action")) and player.can_morph():
		return morph
		
	return next_state

func process(delta: float) -> PlayerState:
	coyote_timer -= delta
	buffer_timer -= delta
	set_jump_frame()
	return next_state

func physics_process(_delta: float) -> PlayerState:
	if player.is_on_floor():
		VisualEffects.land_dust(player.global_position)
		Audio.play_spatial_sound(AUDIO_LAND, player.global_position)
				
		#player.add_debug_indicator(Color.RED)
		if buffer_timer > 0:
			player.jump_count = 0
			return jump
		return idle
	
	player.velocity.x = player.direction.x * player.move_speed
	return next_state

func set_jump_frame() -> void:
	var frame : float = remap(player.velocity.y, 0.0, player.max_fall_velocity, 0.5, 1)
	player.animation_player.seek(frame, true)
