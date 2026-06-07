class_name DustEffect
extends Sprite2D

enum TYPE {JUMP, LAND, HIT}
@onready var animation_player: AnimationPlayer = $AnimationPlayer

func start( type : TYPE	) -> void:
	var anim_name : String = "jump"
	var jump_offset = 6
	
	match type:
		TYPE.JUMP:
			position.y -= jump_offset	
		TYPE.LAND:
			anim_name = "land"
			position.y -= jump_offset
		TYPE.HIT:
			anim_name = "hit"
			rotation_degrees = randi_range(0, 3) * 90
	animation_player.play(anim_name)
	await animation_player.animation_finished
	queue_free()
