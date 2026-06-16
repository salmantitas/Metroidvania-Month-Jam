class_name ESAttackTallWolf
extends ESAttack

var attack_speed : float = 0

func enter() -> void:
	super()
	blackboard.target.moving.connect(_target_moved)
	var effect_sprite : Sprite2D = $"../../Sprite2D/EffectsSprite"
	var flip : bool = blackboard.dir < 0
	if effect_sprite:
		effect_sprite.flip_h = flip

#func re_enter() -> void:
	#pass
#
func exit() -> void:
	super()
	var effect_sprite : Sprite2D = $"../../Sprite2D/EffectsSprite"
	if effect_sprite:
		effect_sprite.visible = false

func physics_update( delta : float ) -> void:
	timer += delta
	if timer >= duration:
		blackboard.can_decide = true
	
	if move_speed_curve:
		var sample : float = move_speed_curve.sample(timer / duration)
		enemy.velocity.x = attack_speed * sample * blackboard.dir

func _target_moved(direction : float) -> void:
	if direction == 0:
		attack_speed = 0
	else:
		attack_speed = move_speed

func can_attack() -> bool:
	if blackboard.distance_to_x(enemy.global_position) <= attack_range and not on_cooldown:
		return true
	return false
