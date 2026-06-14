class_name Boss extends Enemy

@export var ability : String = ""
@export var title : String = ""

func _ready() -> void:
	super()
	$Sprite2D/EffectsSprite.visible = false
