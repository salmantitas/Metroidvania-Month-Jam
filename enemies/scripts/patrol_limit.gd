@tool
@icon("res://general/icons/patrol_limit.svg")

class_name PatrolLimit
extends Node2D

const PATROL_LIMIT = preload("uid://buoy6fxsahqwg")

@export var side = Side.SIDE_LEFT :
	set ( value ) :
		side = value
		_add_sprite()

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if Engine.is_editor_hint():
		_add_sprite()
		return
	queue_free()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _add_sprite() -> void:
	if get_child_count() > 0:
		for c in get_children():
			c.queue_free()
	
	var sprite : Sprite2D = Sprite2D.new()
	add_child(sprite)
	sprite.texture = PATROL_LIMIT
	sprite.position = Vector2(0, -16)
	
	var label : Label = Label.new()
	add_child(label)
	label.size.x = 32
	label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	label.position = Vector2( -16, -24)	
	
	if side == SIDE_LEFT:
		sprite.modulate = Color.WHITE
		label.text = "L"
		label.modulate = Color.BLACK
	
	else:
		sprite.modulate = Color.INDIAN_RED
		label.text = "R"
		label.modulate = Color.WHITE
