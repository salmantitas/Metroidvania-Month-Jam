class_name PlayerStateDash 
extends PlayerState

const AUDIO_DASH = preload("uid://dek104fyaacpk")

@export var speed : float = 300
@export var duration : float = 0.25
@export var effect_delay : float = 0.05

var dir : float = 1.0
var time : float = 0.0
var effect_timer : float = 0.0

@onready var damage_area: DamageArea = %DamageArea

func init() -> void:
	pass

func enter() -> void:
	player.animation_player.play("dash")
	time = duration
	effect_timer = 0
	get_dash_direction()
	damage_area.make_invulnerable(duration)
	Audio.play_spatial_sound(AUDIO_DASH, player.global_position)
	
	player.gravity_multiplier = 0
	player.velocity.y = 0
	
	player.dash_count += 1
	
	player.sprite.tween_color()
	
func exit() -> void:
	player.gravity_multiplier = 1.0

# Takes an input and determines which state to change to
func handle_input( event : InputEvent ) -> PlayerState:
	if (event.is_action_pressed("action")) and player.can_morph():
		return morph
	return null

func process(delta: float) -> PlayerState:
	time -= delta
	
	if time <= 0:
		if player.is_on_floor():
			return idle
		else:
			return fall
	
	effect_timer -= delta
	if effect_timer <= 0:
		effect_timer = effect_delay
		player.sprite.ghost()
	return null

func physics_process(_delta: float) -> PlayerState:
	player.velocity.x = (speed * time/duration + speed ) * dir
	#
	#if player.is_on_floor() == false:
		#return fall
		
	return next_state

func get_dash_direction() -> void:
	dir = 1.0
	
	if player.sprite.flip_h == true:
		dir = -1.0
