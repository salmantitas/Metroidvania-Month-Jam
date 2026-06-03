class_name PlayerStateAttack 
extends PlayerState

const AUDIO_ATTACK = preload("uid://b51f2fbn4a7kl")

@export var combo_time_window : float = 0.2
@export var speed : float = 75
var timer : float = 0
var combo : int = 0

@onready var attack_sprite_2d: Sprite2D = $"../../Sprite2D/AttackSprite2D"


func init() -> void:
	attack_sprite_2d.visible = false

func enter() -> void:
	do_attack()
	player.animation_player.animation_finished.connect( _on_animation_finished )
	
func exit() -> void:
	timer = 0
	combo = 0
	player.animation_player.animation_finished.disconnect( _on_animation_finished )
	next_state = null
	attack_sprite_2d.visible = false

# Takes an input and determines which state to change to
func handle_input( event : InputEvent ) -> PlayerState:
	if (event.is_action_pressed("attack")):
		timer = combo_time_window
	return null

func process(delta: float) -> PlayerState:
	timer -= delta
	return next_state

func physics_process(_delta: float) -> PlayerState:
	player.velocity.x = player.direction.x * speed
	return null

func do_attack() -> void:
	var anim_name : String = "attack"
	if combo > 0:
		anim_name = "attack_2"
	attack_sprite_2d.visible = true
	player.animation_player.play(anim_name)
	player.attack_area.activate()
	Audio.play_spatial_sound(AUDIO_ATTACK, player.global_position)
	
func _on_animation_finished( _anim_name : String ) -> void:
	_end_attack()

func _end_attack():
	if timer > 0:
		combo = wrapi( combo + 1, 0, 2)
		do_attack()
	else:
		next_state = idle
