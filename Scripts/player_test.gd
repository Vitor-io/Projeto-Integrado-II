extends CharacterBody2D
class_name Player_test_class


@onready var sprite := $Sprite
@onready var anim_player := $AnimationPlayer
@onready var idle_sheet := load("res://Assets/characters/andando.png")
@onready var andando_sheet := load("res://Assets/characters/andando.png")
@onready var ataque1_sheet := load("res://Assets/characters/ataque1.png")
@onready var ataque2_sheet := load("res://Assets/characters/ataque2.png")
@export var stats = Resource
var current_health : float = 0
var current_damage : float = 0
var current_attack : float = 0
var current_defense : float = 0
var attacking := false
var direction : Vector2
var enemy_in_attack_range : bool = false
var enemy_attack_cooldown : bool = true
var player_alive : bool = true

var dashing : bool = false
var can_dash : bool = true

signal health_changed()
@export var bar_health : float = current_health:
	set(value):
		bar_health = value


func _ready():
	print(stats.ddd)
	print(bar_health)


func _process(_delta: float) -> void:
	player_move()
	animate()
	dash()
	handle_animation()
	enemy_attack()
	die()
	_init()


func _physics_process(_delta: float) -> void:
	
	if Input.is_action_just_pressed("attack"):
		attacking = true
		global.player_current_attacking = true
	
	if dashing:
		velocity = direction * stats.speed * 3
	else: velocity = direction * stats.speed
	move_and_slide()


func player_move() -> void:
	direction = Vector2.ZERO
	if Input.is_action_pressed("move_up"):
		direction.y += -1
	if Input.is_action_pressed("move_down"):
		direction.y += 1
	if Input.is_action_pressed("move_left"):
		direction.x += -1
	if Input.is_action_pressed("move_right"):
		direction.x += 1


func dash() -> void:
	if Input.is_action_just_pressed("dash") and can_dash:
		dashing = true
		can_dash = false
		$DashTimer.start()


func animate() -> void:
	if get_direction().x < 0:
		sprite.scale.x = -1
	elif get_direction().x > 0:
		sprite.scale.x = 1


func handle_animation():
	var anim = "idle"
	
	if direction != Vector2.ZERO:
		sprite.texture = andando_sheet
		anim = "walk"
	
	if attacking:
		sprite.texture = ataque1_sheet
		anim = "attack1"
	
	anim_player.play(anim)


func get_direction() -> Vector2: 
	return global_position.direction_to(get_global_mouse_position())


func player():
	pass


func _on_dash_timer_timeout():
	dashing = false
	can_dash = true


#Attack1
func _on_animation_player_animation_finished(anim_name):
	if anim_name == "attack1":
		attacking = false
		global.player_current_attacking = false


func _on_attack_1_hitbox_body_entered(body):
	if body.is_in_group("enemy"):
		attacking = true
		global.player_current_attacking = true


func _on_player_hitbox_body_entered(body):
	if body.is_in_group("enemy"):
		enemy_in_attack_range = true


func _on_player_hitbox_body_exited(body):
	if body.is_in_group("enemy"):
		enemy_in_attack_range = false


func enemy_attack():
	if enemy_in_attack_range and enemy_attack_cooldown:
		stats.max_health -= 20
		health_changed.emit()
		enemy_attack_cooldown = false
		$DamageCooldown.start()


func _on_damage_cooldown_timeout():
	enemy_attack_cooldown = true


func die():
	if stats.max_health <= 0.0:
		player_alive = false
		get_tree().change_scene_to_file("res://Scenes/gameover.tscn")

func setup_stats():
	current_health = stats.max_health

func _init():
	#current_health = stats.max_health
	#current_damage = stats.damage
	#current_defense = stats.defense
	pass
