extends CharacterBody2D
class_name Swordsman

@onready var nav_agent := $NavigationAgent2D
var player_ref : Player_test_class
const SPEED := 100
@export var stats : Stats

func _ready() -> void:
	player_ref = get_tree().get_first_node_in_group("Player")
	

func _physics_process(delta: float) -> void:
	nav_agent.target_position = player_ref.position
	velocity = position.direction_to(nav_agent.get_next_path_position()) * SPEED
	move_and_slide()

func enemy():
	pass
