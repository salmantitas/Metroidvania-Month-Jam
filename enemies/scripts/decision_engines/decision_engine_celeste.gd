class_name DecisionEngineCeleste
extends DecisionEngine


# Included in DecisionEngine
# var enemy : Enemy
# var current_state : EnemyState
# var blackboard : Blackboard

@export var descend_state : ESDescend
@export var fly_state : EnemyState
@export var slash_state : ESAttack
@export var slam_state : ESAttack
@export var magic_state : ESAttack

@onready var es_death: ESDeath = %ESDeath
@onready var es_stun: ESStunTallWolf = %ESStun

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
	
	if descend_state.can_descend:
		return descend_state
	
	if blackboard.target: 
		if slam_state.can_attack():
			return slam_state
		if slash_state.can_attack():
			return slash_state
		#return idle_state
		pass
	
	return fly_state
