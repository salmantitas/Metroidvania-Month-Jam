class_name ESFlyShoot
extends ESAttack

@onready var projectile_spawn_point: Node2D = %ProjectileSpawnPoint
@onready var pivot: Node2D = $"../../Pivot"

@export var projectile_spawn_offset : float = 15

# EnemyState class will inherit the following variables:
# @export var animation_name : String = "idle"
# var state_machine : EnemyStateMachine
# var enemy : Enemy
# var blackboard : Blackboard

@export_file("*.tscn") var projectile_scene : String

func enter() -> void:
	super()
	var projectile : Projectile = load(projectile_scene).instantiate()
	
	if projectile_spawn_point:
		if blackboard.dir > 0:
			projectile_spawn_point.position.x = projectile_spawn_offset
		elif blackboard.dir < 0:
			projectile_spawn_point.position.x = -projectile_spawn_offset
	
	projectile.global_position = projectile_spawn_point.global_position
	projectile.target = enemy.blackboard.target.global_position + Vector2(0, -36)
	projectile.start()
	enemy.add_sibling(projectile)
	
