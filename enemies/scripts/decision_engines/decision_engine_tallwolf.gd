class_name DecisionEngineTallWolf
extends DecisionEngine

@export var attack_state : ESAttack
@export var chase_state : EnemyState
@export var dash_state : EnemyState

@onready var es_walk: ESWalk = %ESWalk
@onready var es_stun: ESStun = %ESStun
@onready var es_death: ESDeath = %ESDeath

func _ready() -> void:
	await super() # Maintains important setup code & timing
	# Implement your scripts here
	pass

func decide() -> EnemyState:
	if blackboard.damage_source:
		if blackboard.health <= 0:
			return es_death
	
	if current_state is ESDeath or not blackboard.can_decide:
		return null
	
	#if blackboard.edge_detected:
		#enemy.change_direction(-blackboard.dir)
	
	if blackboard.target:
		if dash_state.can_dash():
			return dash_state
		elif attack_state.can_attack():
			return attack_state
		return chase_state
	
	if enemy.state_machine.prev_state == dash_state:
		return es_stun
	
	return es_walk # default state
