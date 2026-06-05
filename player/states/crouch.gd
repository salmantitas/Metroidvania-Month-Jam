class_name PlayerStateCrouch
extends PlayerState

@export var decelartion_rate : float = 10

func init() -> void:
	pass

func enter() -> void:
	player.animation_player.play("crouch")
	
	player.collision_stand.disabled = true
	player.collision_crouch.disabled = false
	
	player.da_stand.disabled = true
	player.da_crouch.disabled = false
	
func exit() -> void:
	player.collision_stand.set_deferred("disabled", false)
	player.collision_crouch.set_deferred("disabled", true)
	
	player.da_stand.set_deferred("disabled", false)
	player.da_crouch.set_deferred("disabled", true)

# Takes an input and determines which state to change to
func handle_input( event : InputEvent ) -> PlayerState:
	if (event.is_action_pressed("dash")) and player.can_dash():
		return dash
		
	if (event.is_action_pressed("attack")):
		return attack
		
	if event.is_action_pressed("jump"):
		player.one_way_platform_shape_cast.force_shapecast_update()
		if player.one_way_platform_shape_cast.is_colliding() == true:
			player.position.y += 4
			return fall
	
	if (event.is_action_pressed("action")) and player.can_morph():
		return morph
	return next_state

func process(_delta: float) -> PlayerState:
	if player.direction.y <= 0.5:
		return idle
	return next_state

func physics_process(delta: float) -> PlayerState:
	player.velocity.x -= player.velocity.x * decelartion_rate * delta
	return next_state
