class_name ESAttackCeleste
extends ESAttack

var attack_speed : float = 0

var pos : Vector2 = Vector2.ZERO
var vel : Vector2 = Vector2.ZERO

func enter() -> void:
	super()
	
	pos = Vector2.ZERO
	vel = Vector2.ZERO
	
	var effect_sprite : Sprite2D = $"../../Sprite2D/EffectsSprite"
	var flip : bool = blackboard.dir < 0
	if effect_sprite:
		effect_sprite.flip_h = flip

func exit() -> void:
	super()
	var effect_sprite : Sprite2D = $"../../Sprite2D/EffectsSprite"
	if effect_sprite:
		effect_sprite.visible = false

func physics_update( delta : float ) -> void:
	timer += delta
	if timer >= duration:
		blackboard.can_decide = true

func move_to_player() -> void:		
	var tween1 : Tween = get_tree().create_tween()
	
	var distance : float = blackboard.target.global_position.x - enemy.global_position.x
	
	
	
	if blackboard.target.global_position.x > enemy.global_position.x:
		# Player is to the right
		pos = blackboard.target.global_position# - Vector2(50, 0)
	elif blackboard.target.global_position.x < enemy.global_position.x:
		# Player is to the left
		pos = blackboard.target.global_position# + Vector2(attack_range/3, 0)
		pass
	
	print(pos)
	tween1.tween_property(enemy, "global_position", pos, 0.5)
	
	#enemy.change_direction(sign(distance))
	#if attack_area:
	#	attack_area.flip(sign(distance))
