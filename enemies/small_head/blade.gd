extends Node2D

@export var speed : float = 300
var target : Vector2
var direction : Vector2

# Called when the node enters the scene tree for the first time.
func start() -> void:
	direction = (target - self.global_position).normalized()


func _physics_process(delta: float) -> void:
	translate(direction * speed * delta)
	#print(position)
