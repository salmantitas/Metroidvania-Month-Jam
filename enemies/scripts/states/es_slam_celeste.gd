class_name ESSlamCeleste
extends ESAttack


# EnemyState class will inherit the following variables:
# @export var animation_name : String = "idle"
# var state_machine : EnemyStateMachine
# var enemy : Enemy
# var blackboard : Blackboard

var pos : Vector2 = Vector2.ZERO
var vel : Vector2 = Vector2.ZERO

func enter() -> void:
	pos = Vector2.ZERO
	vel = Vector2.ZERO
	
	enemy.animation.animation_finished.connect(_on_animation_finished)
	
	super()

#func re_enter() -> void:
	#pass
#
#func exit() -> void:
	#pass
#
func physics_update( delta : float ) -> void:
	
	#tween1.chain(tween2.tween_property(enemy, "global_position", pos + Vector2(0, 32*4), 0.5))
	
	#timer += delta
	#if timer >= duration:
	#	blackboard.can_decide = true
	#if move_speed_curve:
	#	var sample : float = move_speed_curve.sample(timer / duration)
	#	enemy.velocity.x = move_speed * sample * blackboard.dir
	enemy.velocity = vel
	pass
	
func can_attack() -> bool:
	if not on_cooldown:
		return true
	return false

func move_above_player() -> void:
	var tween1 : Tween = get_tree().create_tween()
	
	if pos == Vector2.ZERO:
		pos = blackboard.target.global_position + Vector2(0, -32*4)
	
	#print(pos)

	#var tween2 : Tween = get_tree().create_tween()
	
	await tween1.tween_property(enemy, "global_position", pos, 0.5)

func slam_sword_down() -> void:
	vel = Vector2(0, move_speed)
	#blackboard.can_decide = true

func _on_animation_finished(anim_name : String) -> void:
	blackboard.can_decide = true
