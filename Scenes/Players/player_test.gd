extends CharacterBody2D
class_name Player_test_class

# Por quê a foda você tá dando 50 de dano por hit

@export var hitbox_shape : Shape2D
@export var stats : Stats
@onready var sprite := $Sprite
@onready var anim_player := $AnimationPlayer
@onready var idle_sheet := load("res://Assets/characters/andando.png")
@onready var andando_sheet := load("res://Assets/characters/andando.png")
@onready var ataque1_sheet := load("res://Assets/characters/ataque1.png")
@onready var ataque2_sheet := load("res://Assets/characters/ataque2.png")
@export var attacking := false
const SPEED: int = 200
var direction : Vector2
#var enemy_in_attack_range : bool = false
#var enemy_attack_cooldown : bool = true
var health = 100
var player_alive : bool = true
var current_state : STATE
enum STATE {
	IDLE,
	ANDANDO,
	ATAQUE1,
	ATAQUE2,
}


func _ready():
	
	stats.base_attack = 10
	print(stats.base_attack)

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("attack") and not event.is_echo():
		var hitbox = Hitbox.new(stats, 0.5, hitbox_shape)
		add_child(hitbox)
		sprite.texture = ataque1_sheet
		anim_player.play("attack1")
#func _input(event: InputEvent) -> void:
	#if event.is_action_just and not event.is_echo():
		#var hitbox = Hitbox.new(stats, 0.5, hitbox_shape)
		#add_child(hitbox)
		#sprite.texture = ataque1_sheet
		#anim_player.play("attack1")


func _process(_delta: float) -> void:
	player_move()
	animate()
	

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
	direction = direction.normalized()
	
func ChangeState(new_state:STATE):
		if new_state == STATE.IDLE:
			sprite.texture = idle_sheet
			anim_player.play("idle")
		elif new_state == STATE.ANDANDO:
			sprite.texture = andando_sheet
			anim_player.play("walk")
		elif new_state == STATE.ATAQUE1:
			sprite.texture = ataque1_sheet
			#anim_player.play("attack1")
			pass
		elif new_state == STATE.ATAQUE2:
			sprite.texture = ataque2_sheet
		current_state = new_state

func animate() -> void:
	if get_direction().x > 0:
		sprite.flip_h = false
		
	if get_direction().x < 0:
		sprite.flip_h = true
	
	#if velocity != Vector2.ZERO:
		#anim_player.play("walk")
		#return
		
	#anim_player.play("idle")

func get_direction() -> Vector2: 
	return global_position.direction_to(get_global_mouse_position())

func _physics_process(_delta: float) -> void:
	velocity = direction * SPEED
	#print(current_state)
	#enemy_attack();
	move_and_slide()

func player():
	pass


#func enemy_attack():
	#if enemy_in_attack_range:
		#print("funcionando")
		#pass
