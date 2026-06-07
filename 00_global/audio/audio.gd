extends Node

enum REVERB_TYPE {NONE, SMALL, MEDIUM, LARGE}

@export var ui_focus_audio : AudioStream
@export var ui_select_audio : AudioStream
@export var ui_cancel_audio : AudioStream
@export var ui_success_audio : AudioStream
@export var ui_error_audio : AudioStream

var current_track : int = 0
var music_tweens : Array[ Tween ]
var ui_audio_player : AudioStreamPlaybackPolyphonic
var audio_pool : Array[AudioStreamPlayer2D]
var audio_index : int = 0
var max_audio_streams : int = 32

@onready var music_1: AudioStreamPlayer = %Music1 
@onready var music_2: AudioStreamPlayer = %Music2
@onready var ui: AudioStreamPlayer = %UI

func _ready() -> void:
	ui.play()
	ui_audio_player = ui.get_stream_playback()
	
	
	for i in max_audio_streams:
		var audio_player : AudioStreamPlayer2D = AudioStreamPlayer2D.new()
		add_child(audio_player)
		audio_player.bus = "SFX"
		audio_pool.append(audio_player)

func setup_button_audio ( node : Node ) -> void:
	for c in node.find_children( "*", "Button"):
		c.pressed.connect(ui_select)
		c.pressed.connect(ui_focus_change )

func play_music (audio : AudioStream) -> void:
	var current_player : AudioStreamPlayer = get_music_player(current_track)
	
	if current_player.stream == audio:
		return
	
	var next_track : int = wrapi( current_track + 1, 0, 2 )
	var next_player : AudioStreamPlayer = get_music_player(next_track)
	
	next_player.stream = audio
	next_player.play()

	for t in music_tweens:
		t.kill()
	music_tweens.clear()
		
	fade_track_out(current_player)
	fade_track_in(next_player)
	
	current_track = next_track

func get_music_player(index : int ) -> AudioStreamPlayer:
	if index == 0:
		return music_1
	else:
		return music_2

func fade_track_out( player : AudioStreamPlayer) -> void:
	var tween = create_tween()
	music_tweens.append(tween)
	tween.tween_property(player, "volume_linear", 0.0, 1.5)
	tween.tween_callback( player.stop )

func fade_track_in( player : AudioStreamPlayer) -> void:
	var tween = create_tween()
	music_tweens.append(tween)
	tween.tween_property(player, "volume_linear", 1.0, 1)

func set_reverb ( type : REVERB_TYPE ) -> void:
	var reverb_fx : AudioEffectReverb = AudioServer.get_bus_effect(1, 0)
	if not reverb_fx:
		return
	AudioServer.set_bus_effect_enabled(1, 0, true)
	match type:
		REVERB_TYPE.NONE:
			AudioServer.set_bus_effect_enabled(1, 0, false)
		REVERB_TYPE.SMALL:
			reverb_fx.room_size = 0.2
		REVERB_TYPE.MEDIUM:
			reverb_fx.room_size = 0.5
		REVERB_TYPE.LARGE:
			reverb_fx.room_size = 0.8
	

func play_spatial_sound( audio : AudioStream, pos : Vector2, ignore_pool : bool = false) -> void:
	if ignore_pool:
		var audio_player_2d : AudioStreamPlayer2D = AudioStreamPlayer2D.new()
		add_child(audio_player_2d)
		audio_player_2d.bus = "SFX"
		audio_player_2d.global_position = pos
		audio_player_2d.stream = audio
		audio_player_2d.finished.connect( audio_player_2d.queue_free)
		audio_player_2d.play()
	else:
		var audio_player_2d : AudioStreamPlayer2D = audio_pool[audio_index]
		audio_player_2d.global_position = pos
		audio_player_2d.stream = audio
		audio_player_2d.play()
		audio_index = wrapi( audio_index + 1, 0, 32)

func play_ui_audio (audio : AudioStream) -> void:
	if ui_audio_player:
		ui_audio_player.play_stream(audio)
		

#region /// UI Functions	
func ui_focus_change() -> void:
	play_ui_audio( ui_focus_audio )

func ui_select() -> void:
	play_ui_audio( ui_select_audio )

func ui_cancel() -> void:
	play_ui_audio( ui_cancel_audio )
	
func ui_success() -> void:
	play_ui_audio( ui_success_audio )
	
func ui_error() -> void:
	play_ui_audio( ui_error_audio )
#endregion
