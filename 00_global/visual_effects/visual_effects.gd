extends Node

const DUST_EFFECT = preload("uid://7yjhkalishx4")
const HIT_PARTICLES = preload("uid://c3ahjcp2ok10s")

signal camera_shook ( strength )

func _create_dust_effects( pos : Vector2 ) -> DustEffect:
	var dust : DustEffect = DUST_EFFECT.instantiate()
	add_child(dust)
	dust.global_position = pos
	return dust

func jump_dust( pos : Vector2) -> void:
	var dust = _create_dust_effects( pos )
	dust.start (dust.TYPE.JUMP)
	
func land_dust( pos : Vector2) -> void:
	var dust = _create_dust_effects( pos )
	dust.start (dust.TYPE.LAND)
	
func hit_dust( pos : Vector2) -> void:
	var dust = _create_dust_effects( pos )
	dust.start (dust.TYPE.HIT)

func hit_particles( pos : Vector2, dir : Vector2, settings : HitParticleSettings ) -> void:
	var p : HitParticles = HIT_PARTICLES.instantiate()
	add_child(p)
	p.global_position = pos
	p.start(dir, settings)

func camera_shake(strength : float = 1.0) -> void:
	camera_shook.emit ( strength )
