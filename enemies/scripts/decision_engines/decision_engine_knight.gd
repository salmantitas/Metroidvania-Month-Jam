class_name DecisionEngineKnight
extends DecisionEngine

@export var attack_state : ESAttack
@export var chase_state : EnemyState
@export var morph_state : ESMorph
@export var shoot_state : ESAttack

@onready var es_walk: ESWalk = %ESWalk
@onready var es_stun: ESStun = %ESStun
@onready var es_death: ESDeath = %ESDeath

#func _ready() -> void:
#	await super() # Maintains important setup code & timing
	# Implement your scripts here
#	pass

func decide() -> EnemyState:
	if blackboard.damage_source:
		if blackboard.health <= 0:
			return es_death
		else:
			return es_stun
	
	if current_state is ESDeath or not blackboard.can_decide:
		return null
	
	#if blackboard.edge_detected:
		#enemy.change_direction(-blackboard.dir)
		
	if blackboard.target:
		if morph_condition_met():
			return morph_state
		elif attack_state.can_attack():
			return attack_state
		elif shoot_state.can_attack():
			return shoot_state
		return chase_state
	
	#if enemy.state_machine.prev_state == dash_state:
		#return es_stun
	
	return es_walk # default state

func morph_condition_met() -> bool:
	return morph_state.can_morph()
	return true
