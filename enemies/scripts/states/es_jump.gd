class_name ESJump
extends ESAttack

@export var jump_velocity : float = 600

var forward_velocity : float = 0

func _ready() -> void:
	run_cooldown()

func enter() -> void:
	var dir : float = sign( blackboard.target.global_position.x - enemy.global_position.x )
	enemy.change_direction(dir)
	enemy.play_animation(animation_name if animation_name else "attack")
	#duration = enemy.animation.current_animation_length
	timer = 0
	blackboard.can_decide = false
	on_cooldown = true

func re_enter() -> void:
	pass

func exit() -> void:
	run_cooldown()

func physics_update( _delta : float ) -> void:
	timer += _delta
	if enemy.animation.current_animation_position < 0.5:
		return
			
	print("anim fin")
	if enemy.is_on_floor():
		on_cooldown = true
		blackboard.can_decide = true
	#print(enemy.velocity, enemy.global_position)
	#enemy.move_and_slide()
	#if enemy.is_on_floor():
		#on_cooldown = true
	pass
	
func do_jump() -> void:
	var distance = blackboard.distance_to_x(enemy.global_position)
	forward_velocity = distance / 1.35
	enemy.velocity.x = forward_velocity * blackboard.dir
	enemy.velocity.y = -jump_velocity
	
	attack_area.activate(1.35)

func can_attack() -> bool:
	if not on_cooldown:
		return true
	return false

func _on_animation_finished(anim_name : String) -> void:
	if enemy.is_on_floor():
		on_cooldown = true
		blackboard.can_decide = true
