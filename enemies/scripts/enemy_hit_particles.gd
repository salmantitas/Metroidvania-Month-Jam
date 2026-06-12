class_name EnemyHitParticles 
extends Node2D

@export var hit_particles : Array[HitParticleSettings]
@export var death_particles : Array[HitParticleSettings]

var enemy_was_killed : bool = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if owner is Enemy:
		owner.was_hit.connect(_on_enemy_hit)
		owner.was_killed.connect(_on_enemy_killed)
	else:
		for c in get_parent().get_children():
			if c is DamageArea:
				c.damage_taken.connect(_on_enemy_hit)

func _on_enemy_hit( a : AttackArea) -> void:
	var dir : Vector2 = global_position.direction_to(a.global_position)
	dir.x *= -1
	var particles = hit_particles
	
	if enemy_was_killed:
		particles = death_particles
		
	for p in particles:
		VisualEffects.hit_particles(global_position, dir, p)

func _on_enemy_killed() -> void:
	enemy_was_killed = true
