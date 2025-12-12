extends CharacterBody2D
class_name Swordsman


@onready var animated_sprite = $AnimatedSprite2D
@onready var nav_agent := $NavigationAgent2D
@onready var health_bar := $ProgressBar
var player_ref : Player_test_class
const SPEED := 100
@export var stats : Stats
@onready var direction := true
enum STATE {
	RUN,
	ATTACK,
	IDLE
}


func _ready() -> void:
	player_ref = get_tree().get_first_node_in_group("Player")
	health_bar.max_value = stats.base_max_health

func _physics_process(delta: float) -> void:
	nav_agent.target_position = player_ref.position
	velocity = position.direction_to(nav_agent.get_next_path_position()) * SPEED
	health_bar.value = stats.health
	move_and_slide()
	animate()
	die()

func animate() -> void:
	
	
	if velocity != Vector2.ZERO:
		animated_sprite.play("walkanim")
		return
		
	else:
		animated_sprite.play("idleanim")
func enemy():
	pass

func ChangeState(new_state:STATE):
	if new_state == STATE.RUN:
		pass

func update_UI():
	pass

func die():
	if stats.health <= 0:
		queue_free()
