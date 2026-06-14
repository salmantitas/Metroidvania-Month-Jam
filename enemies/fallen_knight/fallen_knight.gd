class_name FallenKnight
extends Boss

@onready var collision_shape_stand: CollisionShape2D = $CollisionShapeStand
@onready var collision_shape_morph: CollisionShape2D = $CollisionShapeMorph
@onready var damage_area_stand: DamageArea = $DamageAreaStand
@onready var damage_area_morph: DamageArea = $DamageAreaMorph
@onready var hazard_area_stand: HazardArea = $HazardAreaStand
@onready var hazard_area_morph: HazardArea = $HazardAreaMorph

func _ready() -> void:
	super()

func stand() -> void:
	collision_shape_stand.disabled = false
	collision_shape_morph.disabled = true
	damage_area_stand.disabled = false
	damage_area_morph
	hazard_area_stand
	hazard_area_morph
