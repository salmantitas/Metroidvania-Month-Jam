@icon("res://general/icons/state.svg")

class_name PlayerState 
extends Node

var player : Player
var next_state : PlayerState

#region /// state references
# references to all states
@onready var idle: PlayerStateIdle = %Idle
@onready var run: PlayerStateRun = %Run
@onready var jump: PlayerStateJump = %Jump
@onready var fall: PlayerStateFall = %Fall
@onready var crouch: PlayerStateCrouch = %Crouch
@onready var attack: PlayerStateAttack = %Attack
@onready var take_damage: PlayerStateTakeDamage = %TakeDamage
@onready var death: PlayerStateDeath = %Death
@onready var dash: PlayerStateDash = %Dash
@onready var ground_slam: PlayerStateGroundSlam = %GroundSlam
@onready var morph: Morph = %Morph

#endregion

func init() -> void:
	pass

func enter() -> void:
	print ("Enter: " + name)
	pass
	
func exit() -> void:
	pass

# Takes an input and determines which state to change to
func handle_input( _event : InputEvent ) -> PlayerState:
	return next_state

func process(_delta: float) -> PlayerState:
	return next_state

func physics_process(_delta: float) -> PlayerState:
	return next_state
