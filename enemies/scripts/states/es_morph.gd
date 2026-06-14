class_name ESMorph
extends EnemyState


# EnemyState class will inherit the following variables:
# @export var animation_name : String = "idle"
# var state_machine : EnemyStateMachine
# var enemy : Enemy
# var blackboard : Blackboard

var duration : float = 0
var timer : float = 0
var on_cooldown : bool = true
@export var cooldown : float = 10
@export var move_speed : float = 200

func _ready() -> void:
	run_cooldown()

func enter() -> void:
	enemy.animation.play("morph")
	enemy.animation.queue("morph_walk")
	
	var collision : CollisionShape2D = $"../../CollisionShape"
	collision.position.y = -12
	
	var shape : CapsuleShape2D = $"../../CollisionShape".shape
	shape.radius = 6
	shape.height = 24	
	
	duration = 5
	timer = 0
	blackboard.can_decide = false

func re_enter() -> void:
	pass

func exit() -> void:
	var collision : CollisionShape2D = $"../../CollisionShape"
	collision.position.y = -24
	
	var shape : CapsuleShape2D = $"../../CollisionShape".shape
	shape.radius = 10
	shape.height = 48	
	run_cooldown()

func physics_update( delta : float ) -> void:
	timer += delta
	
	if timer > duration:
		blackboard.can_decide = true
		on_cooldown = true
	else:
		var target_pos : float = behind_player()
		var dir : float = sign(target_pos - enemy.global_position.x)
		enemy.change_direction( dir )
		
		print("Target: ", behind_player(), " Direction: ", dir, " Distance: ", abs(target_pos - enemy.global_position.x)	)
		
		if abs(target_pos - enemy.global_position.x) > 12:
			enemy.velocity.x = move_speed * blackboard.dir
			#enemy.global_position.x += move_speed * blackboard.dir * delta 
		
func can_morph() -> bool:
	if not on_cooldown:
		return true
	return false

func run_cooldown() -> void:
	await get_tree().create_timer(cooldown).timeout
	on_cooldown = false

func behind_player() -> float:
	var player : Player = blackboard.target
	var target_pos : float = 0
	
	if player == null:
		return target_pos
	
	# Player facing right
	if player.direction.x > 0:
		target_pos = player.global_position.x - 16
	# Player facing left
	elif player.direction.x < 0:
		target_pos = player.global_position.x + 16 + 16
	
	print(player, " Pos: ", player.global_position.x)
	
	return target_pos
