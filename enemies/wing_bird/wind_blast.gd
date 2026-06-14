extends Node2D

@export var speed : float = 400
@export var spin : float = 1
var target : Vector2
var direction : Vector2

# Called when the node enters the scene tree for the first time.
func start() -> void:
	direction = (target - self.global_position).normalized()
	$Area2D.area_entered.connect(_on_body_entered)

func _physics_process(delta: float) -> void:
	translate(direction * speed * delta)
	$Sprite2D.rotation += spin

func _on_body_entered( _n : Node2D) -> void:
	queue_free()
