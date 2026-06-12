class_name ESDash
extends EnemyState

@export var dash_range : float = 300
@export var dash_speed : float = 500
@export var cooldown : float = 3
@export var attack_area : AttackArea
@export var move_speed_curve : Curve

const AUDIO_DASH = preload("uid://dek104fyaacpk")

var timer : float = -1
var duration : float = 0
var on_cooldown : bool = false
var move_speed : float = 0

var effect_timer : float = 0
@export var effect_delay : float = 0.01

@onready var sprite_2d: PlayerSprite = $"../../Sprite2D"

func enter() -> void:
	var dir : float = sign( blackboard.target.global_position.x - enemy.global_position.x )
	enemy.change_direction(dir)
	enemy.animation.animation_finished.connect(_on_animation_finish)
	enemy.play_animation(animation_name if animation_name else "pre_dash")
	
	effect_timer = 0
	timer = -1
	duration = 1
	blackboard.can_decide = false
	on_cooldown = true
	
	tween_color()
	
	if attack_area:
		attack_area.flip(blackboard.dir)

func re_enter() -> void:
	pass

func exit() -> void:
	enemy.animation.animation_finished.disconnect(_on_animation_finish)
	blackboard.can_decide = true
	run_cooldown()

func physics_update( delta : float ) -> void:
	if timer < 0:
		move_speed = 0
	
	timer += delta
	if timer >= duration:
		blackboard.can_decide = true
	
	enemy.velocity.x = move_speed * blackboard.dir # (speed * time/duration + speed ) * dir
	
	effect_timer -= delta
	if effect_timer <= 0:
		effect_timer = effect_delay
		sprite_ghost()
	
func run_cooldown() -> void:
	await get_tree().create_timer(cooldown).timeout
	on_cooldown = false

func can_dash() -> bool:
	if blackboard.distance_to_target <= dash_range and not on_cooldown and blackboard.distance_to_y(enemy.global_position) <= 32:
		return true
	return false

func _on_animation_finish( anim_name : String) -> void:
	if anim_name == "pre_dash":
		Audio.play_spatial_sound(AUDIO_DASH, enemy.global_position)
		enemy.animation.play("dash")
		move_speed = dash_speed
		timer = 0
		attack_area.activate(duration)

func tween_color() -> void:
	sprite_2d.tween_color(duration, Color.RED)

func sprite_ghost() -> void:
	sprite_2d.ghost()
