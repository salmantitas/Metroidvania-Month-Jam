class_name Projectile extends Node2D

@export var speed : float = 300
var target : Vector2
var direction : Vector2

# Called when the node enters the scene tree for the first time.
func start() -> void:
	direction = (target - self.global_position).normalized()
	rotation = direction.angle()# + PI/2.0
	$Area2D.body_entered.connect(_on_hit_wall)
	$HazardArea.area_entered.connect(_on_hit_player)


func _physics_process(delta: float) -> void:
	translate(direction * speed * delta)
	#print(position)

func _on_hit_wall( _n : Node2D) -> void:
	VisualEffects.hit_dust(global_position)
	queue_free()

func _on_hit_player( _n : Node2D) -> void:
	queue_free()
