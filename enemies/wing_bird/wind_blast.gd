class_name Wind_Blast 
extends Projectile

@export var spin : float = 1

# Called when the node enters the scene tree for the first time.
func start() -> void:
	direction = (target - self.global_position).normalized()
	$Area2D.body_entered.connect(_on_hit_wall)
	$HazardArea.area_entered.connect(_on_hit_player)

func _physics_process(delta: float) -> void:
	translate(direction * speed * delta)
	$Sprite2D.rotation += spin
