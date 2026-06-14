class_name DecisionEngineBasicRanged
extends DecisionEngine


# Included in DecisionEngine
# var enemy : Enemy
# var current_state : EnemyState
# var blackboard : Blackboard

@export var chase_state : EnemyState

@onready var es_walk: ESWalk = %ESWalk
@onready var es_stun: ESStun = %ESStun
@onready var es_death: ESDeath = %ESDeath
@onready var es_shoot: ESShoot = %ESShoot
@onready var es_attack: ESAttack = %ESAttack

func _ready() -> void:
	await super() # Maintains important setup code & timing
	# Implement your scripts here
	pass

func decide() -> EnemyState:
	# Example decision
	if blackboard.damage_source:
		if blackboard.health <= 0:
			return es_death
		else:
			return es_stun
	
	if current_state is ESDeath or not blackboard.can_decide:
		return null
	
	if blackboard.edge_detected:
		enemy.change_direction(-blackboard.dir)
	
	if blackboard.target:
		if es_attack.can_attack():
			return es_attack
		elif es_shoot.can_attack():
			return es_shoot
		return chase_state
	return es_walk # default state
