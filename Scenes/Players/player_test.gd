extends CharacterBody2D
class_name Player_test_class

const SPEED: int = 200
var direction : Vector2

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
	#AnimatePlayer()
	move_and_slide()
