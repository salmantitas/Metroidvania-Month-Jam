class_name ESRetreat
extends EnemyState

@export var chase_state : ESChase
@export var cooldown : float = 1

var timer : float = 0
var duration : float = 2
var on_cooldown : bool = false

func enter() -> void:
	blackboard.can_decide = false
	print("Enter Retreat")
	timer = 0
	var anim : String = animation_name if animation_name else "chase"
	enemy.play_animation( anim )

func re_enter() -> void:
	pass

func exit() -> void:
	blackboard.can_decide = true
	print("Exit Retreat")
	#enemy.change_direction( -blackboard.dir)

func physics_update( delta : float ) -> void:
	timer += delta
	if timer >= duration:
		blackboard.can_decide = true
		
	var dir : Vector2 = enemy.global_position.direction_to( blackboard.target.global_position)
	enemy.change_direction( -sign(dir.x))
	enemy.velocity.x = chase_state.chase_speed * -dir.x
	print(enemy.velocity.x)
