class_name Player 
extends CharacterBody2D

const DEBUG_JUMP_INDICATOR = preload("uid://ypbd2v844p8k")

#region /// Onready Variables
@onready var sprite: Sprite2D = $Sprite2D
@onready var collision_stand: CollisionShape2D = $CollisionStand
@onready var collision_crouch: CollisionShape2D = $CollisionCrouch
@onready var one_way_platform_shape_cast: ShapeCast2D = $OneWayPlatformShapeCast
@onready var animation_player: AnimationPlayer = $AnimationPlayer
#endregion

#region /// Export Variables
@export var move_speed : float = 150
@export var max_fall_velocity : float = 600
#endregion

#region /// State Machine Variables
var states : Array[PlayerState]
var current_state : PlayerState :
	get : return states.front()
var previous_state : PlayerState :
	get : return states[1]
#endregion

#region /// Standard Variables
var direction : Vector2 = Vector2.ZERO
var gravity : float = 980
var gravity_multiplier : float = 1
#endregion

func _ready() -> void:
	initialize_states()

func _unhandled_input(event: InputEvent) -> void:
	change_state( current_state.handle_input(event))

# Called every frame
func _process(_delta: float) -> void:
	update_direction()
	change_state( current_state.process(_delta) )

# Called every frame locked at 60 FPS
func _physics_process( delta: float) -> void:
	velocity.y += gravity * delta * gravity_multiplier
	velocity.y = clampf(velocity.y, -1000, max_fall_velocity)
	move_and_slide()
	change_state( current_state.physics_process(delta) )
	
func initialize_states() -> void:
	states = []
	
	#gather all states
	for c in $States.get_children():
		if c is PlayerState:
			states.append(c)
			c.player = self
	
	if states.size() == 0:
		return
	
	#initialize all states
	for state in states:
		state.init()
			
	#set our first state
	change_state(current_state)
	current_state.enter()
	$Label.text = current_state.name
	pass

func change_state( new_state : PlayerState) -> void:
	#check if the new state is valid
	if new_state == null:
		return
	elif new_state == current_state:
		return
	
	# Exit current state if valid
	if current_state:
		current_state.exit()
	
	# Make new state current and start
	states.push_front(new_state)
	current_state.enter()
	
	# Keep the array short (current, previous and the one before)
	states.resize(3)
	
	$Label.text = current_state.name
	
	pass

func update_direction() -> void:
	var previous_direction : Vector2 = direction
	
	var x_axis = Input.get_axis("left", "right")
	var y_axis = Input.get_axis("up", "down")
	direction = Vector2(x_axis, y_axis)
	
	if previous_direction.x != direction.x:
		if direction.x < 0:
			sprite.flip_h = true
		elif direction.x > 0:
			sprite.flip_h = false
	
func add_debug_indicator( color : Color = Color.RED ) -> void:
	var d : Node2D = DEBUG_JUMP_INDICATOR.instantiate()
	get_tree().root.add_child(d)
	d.global_position = global_position
	d.modulate = color
	await get_tree().create_timer( 3.0 ).timeout
	
	pass
