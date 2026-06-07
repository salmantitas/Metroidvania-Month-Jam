extends Node2D

@onready var area_2d: Area2D = $Area2D
@export var boss_track : AudioStream
@export var enemy : PackedScene

var visited : bool = false
var spawn_location : Vector2

func _ready() -> void:
	if Engine.is_editor_hint():
		return
	
	if SaveManager.persistent_data.get_or_add( unique_name() , false) == true:
		visited = true
		queue_free()
	else:
		area_2d.body_entered.connect( _on_body_entered)
	
	for c in get_children():
		if c.name == "SpawnLocation":
			spawn_location = c.global_position
			
func _on_body_entered( _b : Node2D) -> void:
	visited = true
	SaveManager.persistent_data[unique_name()] = visited
	spawn_boss()
	change_track()
	queue_free()

func change_track() -> void:
	Audio.play_music(boss_track)
	
func spawn_boss() -> void:
	var boss : Enemy = enemy.instantiate()
	#boss.position = Vector2(0,0)
	#boss.set_process(false)
	get_tree().root.add_child(boss)
	boss.position = spawn_location
	boss.face_left_on_start = true
	boss.scale = Vector2(2,2)

func unique_name() -> String:
	var unique_name : String = ResourceUID.path_to_uid( owner.scene_file_path )
	unique_name += "/" + get_parent().name + "/" + name
	return unique_name
