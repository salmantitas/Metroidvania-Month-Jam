class_name Morph 
extends PlayerState

const AUDIO_MORPH = preload("uid://ct8g0mthueh4t")
const AUDIO_MORPH_OUT = preload("uid://c3k71o1rwcfqu")

@export var jump_velocity : float = 400
var on_floor : bool = true
var morphed = false

# Raycast References
@onready var morph_ray_up: RayCast2D = %MorphRayUp
@onready var morph_ray_down: RayCast2D = %MorphRayDown

func init() -> void:
	pass

func enter() -> void:
	
	player.animation_player.play("morph_in")
	player.animation_player.queue("morph_run")
	
	var shape : CapsuleShape2D = player.collision_stand.get_shape() as CapsuleShape2D
	shape.radius = 3
	shape.height = 22
	
	player.collision_stand.position.y = -11
	player.da_stand.position.y = -11
	
	player.velocity.y -= 100
	
	Audio.play_spatial_sound(AUDIO_MORPH, player.position)
	
	await player.animation_player.animation_finished
	morphed = true
	
func exit() -> void:
	morphed = false
	
	player.animation_player.play("morph_in")
	#await player.animation_player.animation_finished
	
	var shape : CapsuleShape2D = player.collision_stand.get_shape() as CapsuleShape2D
	shape.radius = 8
	shape.height = 46
	
	player.collision_stand.position.y = -23
	player.da_stand.position.y = -23
	player.velocity.y -= 100
	Audio.play_spatial_sound(AUDIO_MORPH_OUT, player.position)
	

# Takes an input and determines which state to change to
func handle_input( event : InputEvent ) -> PlayerState:
	#if not player.animation_player.animation_finished("morph-in"):
	#	return
	
	#if morphed == false:
	#	return null
	
	if (event.is_action_pressed("action")):
		if can_unmorph():
			if player.is_on_floor():
				return idle
			return fall
	
	if (event.is_action_pressed("jump")):
		if player.is_on_floor():
			if Input.is_action_pressed("down"):
				player.one_way_platform_shape_cast.force_shapecast_update()
				if player.one_way_platform_shape_cast.is_colliding():
					player.position.x += 4
					return null
			player.velocity.y -= jump_velocity
			Audio.play_spatial_sound(preload("uid://dbrjtobxxoni2"), player.global_position)
			VisualEffects.jump_dust(player.global_position)
	return null

func process(_delta: float) -> PlayerState:
	
	if morphed == false:
		return null
	
	if player.direction.x == 0:
		player.animation_player.play("morph_idle")
	else:
		player.animation_player.play("morph_run")
	return null

func physics_process(_delta: float) -> PlayerState:
	player.velocity.x = player.direction.x * player.move_speed
	
	if on_floor:
		if not player.is_on_floor():
			on_floor = false
	else:
		if player.is_on_floor():
			on_floor = true
			VisualEffects.land_dust(player.global_position)
			Audio.play_spatial_sound(preload("uid://cg4l8ntp265vl"), player.global_position)
	return next_state

func can_unmorph() -> bool:
	morph_ray_up.force_raycast_update()
	morph_ray_down.force_raycast_update()
	
	if morph_ray_down.is_colliding() and morph_ray_up.is_colliding():
		return false
	
	return true
