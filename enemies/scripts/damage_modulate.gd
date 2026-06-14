class_name DamageModulate
extends Node

@export var color : Color = Color(4.416, 0.0, 0.0, 1.0)

var tween : Tween

func _ready() -> void:
	if owner is Enemy:
		owner.was_hit.connect( _modulate_node )
	else:
		for c in owner.get_children():
			if c is DamageArea:
				c.damage_taken.connect(_modulate_node)
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

# Modulate node if hit
func _modulate_node( _a : AttackArea) -> void:
	if tween:
		tween.kill()
	
	var duration = 0.5
	
	owner.modulate = color
	tween = create_tween()
	tween.tween_property(owner, "modulate", Color.WHITE, duration)
