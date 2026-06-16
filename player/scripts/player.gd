class_name Player 
extends CharacterBody2D

const DEBUG_JUMP_INDICATOR = preload("uid://ypbd2v844p8k")

#region /// signals
signal damage_taken
signal death
signal moving(direction : float)
#endregion

#region /// Onready Variables
@onready var sprite: PlayerSprite = $Sprite2D
@onready var attack_sprite: Sprite2D = $Sprite2D/AttackSprite2D
@onready var collision_stand: CollisionShape2D = $CollisionStand
@onready var collision_crouch: CollisionShape2D = $CollisionCrouch
@onready var da_stand: CollisionShape2D = %DAStand
@onready var da_crouch: CollisionShape2D = %DACrouch
@onready var one_way_platform_shape_cast: ShapeCast2D = $OneWayPlatformShapeCast
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var attack_area: AttackArea = %AttackArea
@onready var damage_area: DamageArea = %DamageArea
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

#region /// Player Stack
var hp : float = 20 :
	set ( value ):
		hp = clamp(value, 0, max_hp)
		Messages.player_health_changed.emit(hp, max_hp)
var max_hp : float = 20 :
	set ( value ):
		max_hp = value
		hp = max_hp
		Messages.player_health_changed.emit(hp, max_hp)
var dash : bool = true
var dash_count : int = 0

var morph : bool = true

var double_jump : bool = true
var jump_count : int = 0

var ground_slam : bool = false

var can_interact : bool = false
#endregion

#region /// Standard Variables
var direction : Vector2 = Vector2.ZERO
var gravity : float = 980
var gravity_multiplier : float = 1
#endregion

#debug
var god_mode : bool = false

func _ready() -> void:
	if get_tree().get_first_node_in_group("Player") != self:
		self.queue_free()
	initialize_states()
	self.call_deferred( "reparent", get_tree().root)
	Messages.back_to_title_screen.connect(queue_free)
	Messages.player_healed.connect( _on_player_healed 	)
	Messages.input_hint_changed.connect( _on_input_hint_changed )
	damage_area.damage_taken.connect( _on_damage_taken )
	Messages.powerup_acquired.connect (_on_ability_acquired)
	hp = max_hp

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_released("jump") and velocity.y < 0:
		velocity.y *= 0.5
	
	if event.is_action_pressed( "action"):
		Messages.player_interacted.emit(self)
	elif event.is_action_pressed( "pause"):
		get_tree().paused = true
		var pause_menu : PauseMenu = load("res://pause_menu/pause_menu.tscn").instantiate()
		add_child(pause_menu)
		return
		
	change_state( current_state.handle_input(event))
	
	# DEBUG
	if OS.is_debug_build():
		if event is InputEventKey and event.is_pressed():
			if event.keycode == KEY_MINUS:
				hp -= 2
			elif event.keycode == KEY_EQUAL:
				hp += 2
			elif event.keycode == KEY_BACKSPACE:
				max_hp += 2
			elif event.keycode == KEY_G:
				god_mode = !god_mode
	# END DEBUG
	
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
	$StateLabel.text = current_state.name
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
	
	$StateLabel.text = current_state.name
	
	pass

func update_direction() -> void:
	var previous_direction : Vector2 = direction
	
	var x_axis : float = Input.get_axis("left", "right")
	var y_axis : float = Input.get_axis("up", "down")
	direction = Vector2(x_axis, y_axis)
	
	if previous_direction.x != direction.x:
		attack_area.flip( direction.x )
		if direction.x < 0:
			#LEFT
			sprite.flip_h = true
			attack_sprite.flip_h = true
			attack_sprite.position.x = -7
		elif direction.x > 0:
			#RIGHT
			sprite.flip_h = false
			attack_sprite.flip_h = false
			attack_sprite.position.x = 7
		
		
	moving.emit(direction.x)
	
func add_debug_indicator( color : Color = Color.RED ) -> void:
	var d : Node2D = DEBUG_JUMP_INDICATOR.instantiate()
	get_tree().root.add_child(d)
	d.global_position = global_position
	d.modulate = color
	await get_tree().create_timer( 3.0 ).timeout
	
	pass

func _on_player_healed( amount : float) -> void:
	hp += amount

func _on_damage_taken( a : AttackArea ) -> void:
	if god_mode:
		return
		
	hp -= a.damage
	damage_taken.emit()
	
	if hp <= 0:
		death.emit()
	
func _on_input_hint_changed( prompt : String):
	if prompt == "interact":
		can_interact = true
	else:
		can_interact = false

func can_dash() -> bool:
	return dash and dash_count == 0

func can_morph() -> bool:
	if morph == false or can_interact == true:
		return false
	return true

func _on_ability_acquired(ability : String) -> void:
	if (ability == "dash"):
		dash = true
	if (ability == "morph"):
		morph = true
	if (ability == "double jump"):
		double_jump = true
