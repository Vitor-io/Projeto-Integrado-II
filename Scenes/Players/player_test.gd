extends CharacterBody2D
class_name Player_test_class

@export var hitbox_shape : Shape2D
@export var stats : Stats
const SPEED: int = 200
var direction : Vector2
var enemy_in_attack_range : bool = false
var enemy_attack_cooldown : bool = true
var health = 100
var player_alive : bool = true

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("attack") and not event.is_echo():
		var hitbox = Hitbox.new(stats, 0.5, hitbox_shape)
		add_child(hitbox)

func _process(_delta: float) -> void:
	direction = Vector2.ZERO
	if Input.is_action_pressed("move_up"):
		direction.y += -1
	if Input.is_action_pressed("move_down"):
		direction.y += 1
	if Input.is_action_pressed("move_left"):
		direction.x += -1
	if Input.is_action_pressed("move_right"):
		direction.x += 1
	direction = direction.normalized()

func _physics_process(_delta: float) -> void:
	velocity = direction * SPEED
	enemy_attack();
	#AnimatePlayer()
	move_and_slide()

func player():
	pass

func _on_player_hitbox_body_entered(body):
	if body.has_method("enemy"):
		enemy_in_attack_range = true

func _on_player_hitbox_body_exited(body):
	if body.has_method("enemy"):
		enemy_in_attack_range = false

func enemy_attack():
	if enemy_in_attack_range:
		print("funcionando")
