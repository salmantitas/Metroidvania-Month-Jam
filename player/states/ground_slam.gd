class_name PlayerStateGroundSlam
extends PlayerState

@export var velocity : float = 400
@export var effect_delay : float = 0.075

const AUDIO_SLAM = preload("uid://dek104fyaacpk")
const AUDIO_LAND = preload("uid://bfb81cpq7kkkq")
const AUDIO_BREAK_WOOD = preload("uid://d3iua3acq8eum")


const HIT_WOOD_LARGE = preload("uid://b150qvid6eary")
const HIT_WOOD_MEDIUM = preload("uid://7gt0tdvsrbyc")
const HIT_WOOD_SMALL = preload("uid://b02xao2u88hcc")

var effect_timer : float = 0.0

@onready var ground_slam_attack_area: AttackArea = %GroundSlamAttackArea

@onready var damage_area: DamageArea = %DamageArea
@onready var ground_slam_shape_cast: ShapeCast2D = $"../../GroundSlamShapeCast"

func init() -> void:
	pass

func enter() -> void:
	player.animation_player.play("ground_slam")
	player.sprite.tween_color()
	Audio.play_spatial_sound(AUDIO_SLAM, player.global_position, false, true, 0.75)
	damage_area.start_invulnerable()
	ground_slam_attack_area.set_active()
	
func exit() -> void:
	VisualEffects.camera_shake(10)
	
	var pos : Vector2 = player.global_position
	
	VisualEffects.land_dust(pos)
	VisualEffects.hit_dust(pos)
	Audio.play_spatial_sound(AUDIO_LAND, pos, false, true, 1)
	
	damage_area.end_invulnerable()
	ground_slam_attack_area.set_active(false)

# Takes an input and determines which state to change to
func handle_input( _event : InputEvent ) -> PlayerState:
	return null

func process(delta: float) -> PlayerState:
	check_collisions(delta)
	
	effect_timer -= delta
	if effect_timer <= 0:
		effect_timer = effect_delay
		player.sprite.ghost()
	return null

func physics_process(delta: float) -> PlayerState:
	player.velocity.x = 0
	player.velocity.y = velocity
	
	if player.is_on_floor():
		if not check_collisions( delta ):
			return idle
	
	return next_state

func check_collisions( delta : float) -> bool:
	ground_slam_shape_cast.target_position.y = velocity * delta
	ground_slam_shape_cast.force_shapecast_update()
	
	if ground_slam_shape_cast.is_colliding():
		for i in ground_slam_shape_cast.get_collision_count():
			var c : Node2D = ground_slam_shape_cast.get_collider(i)
			var pos : Vector2 = ground_slam_shape_cast.get_collision_point(i)
			
			VisualEffects.hit_dust(pos)
			VisualEffects.camera_shake(10)
			
			if c.get_parent() is Breakable:
				var b : Breakable = c.get_parent()
				b.queue_free()
				Audio.play_spatial_sound(b.destroy_audio, pos, false, true, 0.75)
				for p in b.destroyed_particles:
					VisualEffects.hit_particles( pos, Vector2.DOWN, p)
			else:
				c.queue_free()
				VisualEffects.hit_particles( pos, Vector2.DOWN, HIT_WOOD_LARGE )
				VisualEffects.hit_particles( pos, Vector2.DOWN, HIT_WOOD_MEDIUM )
				VisualEffects.hit_particles( pos, Vector2.DOWN, HIT_WOOD_SMALL )
				Audio.play_spatial_sound(AUDIO_BREAK_WOOD, pos, false, true, 0.75)
		return true
	
	return false
