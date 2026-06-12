@tool
class_name BossTrigger
extends Node2D

@export_range(2, 12, 1, "or greater") var width : int = 2 : 
	set( value ) :
		width = value
		apply_area_settings()

@export_range(2, 12, 1, "or greater") var height : int = 2 : 
	set( value ) :
		height = value
		apply_area_settings()

@onready var area_2d: Area2D = $Area2D
@export var boss_track : AudioStream
@export var boss_scene : PackedScene

var visited : bool = false
var spawn_location : Vector2
var tileset : TileMapLayer
var boss : Boss
@export var boss_ability : String # temp

func _ready() -> void:
	if Engine.is_editor_hint():
		return
	apply_area_settings()
	
	if SaveManager.persistent_data.get_or_add( unique_name() , false) == true:
		visited = true
		queue_free()
	else:
		area_2d.body_entered.connect( _on_body_entered)
		area_2d.body_exited.connect( _on_body_exited)
	
	for c in get_children():
		if c.name == "SpawnLocation":
			spawn_location = c.global_position
		if c is TileMapLayer:
			tileset = c
	
	enable_tileset(false)
		
func _on_body_entered( _b : Node2D) -> void:
	print("Entered")
	visited = true
	area_2d.queue_free()
	SaveManager.persistent_data[unique_name()] = visited
	enable_tileset()
	spawn_boss()
	change_track()

func _on_body_exited( _b : Node2D) -> void:
	print("Exited")

func change_track(track : AudioStream = boss_track) -> void:
	Audio.play_music(track)
	
func spawn_boss() -> void:
	boss = boss_scene.instantiate()
	#boss.position = Vector2(0,0)
	#boss.set_process(false)
	get_tree().root.add_child(boss)
	boss.position = spawn_location
	boss.face_left_on_start = true
	boss.was_killed.connect(_on_boss_killed)

func unique_name() -> String:
	var unique_name : String = ResourceUID.path_to_uid( owner.scene_file_path )
	unique_name += "/" + get_parent().name + "/" + name
	return unique_name

func enable_tileset( value : bool = true) -> void:
	if tileset:	
		tileset.collision_enabled = value
		tileset.visible = value

func _on_boss_killed() -> void:
	change_track(null)
	enable_tileset(false)
	#Messages.powerup_acquired.emit(boss.ability)
	#Messages.tutorial_hint_changed.emit(boss.ability)
	#Messages.input_hint_changed.emit(boss.ability)
	
	Messages.powerup_acquired.emit(boss_ability)
	Messages.tutorial_hint_changed.emit(boss_ability)
	Messages.input_hint_changed.emit(boss_ability)
	
	await get_tree().create_timer(2).timeout
	Messages.powerup_acquired.emit("")
	Messages.tutorial_hint_changed.emit("")
	Messages.input_hint_changed.emit("")
	
func apply_area_settings() -> void:
	area_2d = get_node_or_null("Area2D")
	if not area_2d:
		return
		
	area_2d.scale.x = width
	area_2d.scale.y = height
