class_name Boss extends Enemy

@export var ability : String = ""
@export var title : String = ""

func _ready() -> void:
	super()
	$Sprite2D/EffectsSprite.visible = false
	var player : Player = get_tree().get_first_node_in_group("Player")
	player.death.connect( _on_player_death )
	
func _on_player_death() -> void:
	print("Player dead")
	queue_free()
