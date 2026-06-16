class_name ESJump
extends ESAttack

@export var jump_velocity : float = 1000

@export var forward_velocity : float = 150

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
		
	if timer >= 0.2:
		attack_area.activate(4)
		
	if enemy.is_on_floor():
		attack_area.set_active(false)
		on_cooldown = true
		blackboard.can_decide = true
	
	if enemy.global_position.y >= 500:
		print(enemy.global_position)
		enemy.velocity.x /= 4
		return
	
	var offset = 48
	
	if blackboard.target.global_position.x > enemy.global_position.x:
		enemy.change_direction(1)
		enemy.velocity.x = forward_velocity * blackboard.dir
	elif blackboard.target.global_position.x < enemy.global_position.x:
		enemy.change_direction(-1)
		enemy.velocity.x = -forward_velocity

	pass
	
func do_jump() -> void:
	enemy.velocity.y = -jump_velocity

func can_attack() -> bool:
	if not on_cooldown:
		return true
	return false

func _on_animation_finished(anim_name : String) -> void:
	if enemy.is_on_floor():
		on_cooldown = true
		blackboard.can_decide = true
