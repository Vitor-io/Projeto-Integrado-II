extends CharacterBody2D
class_name Player_test_class


@onready var sprite := $Sprite
@onready var anim_player := $AnimationPlayer
@onready var idle_sheet := load("res://Assets/characters/andando.png")
@onready var andando_sheet := load("res://Assets/characters/andando.png")
@onready var ataque1_sheet := load("res://Assets/characters/ataque1.png")
@onready var ataque2_sheet := load("res://Assets/characters/ataque2.png")
@export var stats = player_stats
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

# UILayer
@onready var ShopTexture = get_node("%ShopTexture")
@onready var ShopPanel = get_node("%ShopPanel")
@onready var ItemOpts = get_node("%ItemOptions")
@onready var Shop = $UILayer/Shop
@onready var UILayer = $UILayer
@onready var ItemOptions = preload("res://Scenes/item_option.tscn")

var available_items = ["Cruz", "Biblia","Habito","Coroa","Pe de Cabra","Pentagrama"]

signal health_changed()
@export var bar_health : float = current_health:
	set(value):
		bar_health = value

var item_data = {
	"Cruz": {
		"icon": preload("res://AssetsLoja/loja.cruz.png"),
		"description": "Aumenta regeneração de vida em +5"
	},
	"Biblia": {
		"icon": preload("res://AssetsLoja/loja.biblia.png"),
		"description": "Aumenta dano em +5"
	},
	"Habito": {
		"icon": preload("res://AssetsLoja/loja.veu.png"),
		"description": "Aumenta defesa em +5"
	},
	"Coroa": {
		"icon": preload("res://AssetsLoja/loja.coroaespinhos.png"),
		"description": "Aumenta dano e defesa em +2"
	},
	"Pe de Cabra": {
		"icon": preload("res://AssetsLoja/loja.pentagrama.png"),
		"description": "Aumenta velocidade em +50"
	},
	"Pentagrama": {
		"icon": preload("res://AssetsLoja/loja.pentagrama.png"),
		"description": "Aumenta multiplicador de EXP em +1"
	}
}

func _ready():
	global.level_changed.connect(_on_level_changed)
	_init()
	#stats = stats.duplicate()
	setup_stats()
	#print(stats.ddd)
	print(bar_health)


func _process(delta: float) -> void:
	player_move()
	animate()
	dash()
	handle_animation()
	enemy_attack()
	regenerate_health(delta)
	die()


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
		#current_health -= 20
		#health_changed.emit()
		#enemy_attack_cooldown = false
		#$DamageCooldown.start()
		var base_damage = 20
		
		var final_damage = max(base_damage - stats.defense, 1)
		
		current_health -= final_damage
		
		health_changed.emit()
		enemy_attack_cooldown = false
		$DamageCooldown.start()


func _on_damage_cooldown_timeout():
	enemy_attack_cooldown = true

func regenerate_health(delta: float) -> void:
	if current_health <= 0:
		return
	
	if stats.hp_regen > 0:
		current_health += stats.hp_regen * delta
		current_health = min(current_health, stats.max_health)
		health_changed.emit()

func die():
	if current_health <= 0.0:
		player_alive = false
		get_tree().change_scene_to_file("res://Scenes/gameover.tscn")

func setup_stats():
	current_health = stats.max_health

func _init():
	#current_health = stats.max_health
	#current_damage = stats.damage
	#current_defense = stats.defense
	pass

func _on_level_changed(new_level : int):
	for child in ItemOpts.get_children():
		child.queue_free()
	ShopPanel.visible = true
	ShopTexture.show()
	var tween = ShopPanel.create_tween().set_parallel(true)
	tween.tween_property(ShopPanel,"position", Vector2(580,80),0.2).set_trans(Tween.TRANS_QUINT).set_ease(Tween.EASE_IN)
	tween.tween_property(ShopTexture,"position", Vector2(30,10),0.2).set_trans(Tween.TRANS_QUINT).set_ease(Tween.EASE_IN)
	#tween.play()
	#await tween.finished
	
	ShopPanel.visible = true
	#var options = 0
	#var optionsmax = 3
	#while options < optionsmax:
		#var option_choice = ItemOptions.instantiate()
		#ItemOpts.add_child(option_choice)
		#options += 1
	#get_tree().paused = true
	var choices = []
	while choices.size() < 3:
		var item_name = available_items[randi() % available_items.size()]
		if item_name in choices:
			continue
		choices.append(item_name)
		var option_instance = ItemOptions.instantiate()
		option_instance.name = item_name
		option_instance.get_node("Label").text = item_name
		# Define ícone
		option_instance.get_node("ItemIcon").texture = item_data[item_name]["icon"]

# Define tooltip padrão do Godot
		option_instance.tooltip_text = item_data[item_name]["description"]
		#ItemOpts.add_child(option_instance)
		option_instance.select_item.connect(upgrade_character)

		ItemOpts.add_child(option_instance)

	get_tree().paused = true

func upgrade_character(Item):
	match Item.name:
		"Cruz":
			stats.hp_regen += 5
		"Biblia":
			stats.damage += 5
		"Habito":
			stats.defense += 5
		"Coroa":
			stats.damage +=2
			stats.defense += 2
		"Pe de Cabra":
			stats.speed += 50
		"Pentagrama":
			stats.exp_multiplier += 1.0
	#var option_children = ItemOpts.get_children()
	#for i in option_children:
		#i.queue_free()
		#ShopPanel.visible = false
		#get_tree().paused = false
	for child in ItemOpts.get_children():
		child.queue_free()
		ShopPanel.visible = false
		get_tree().paused = false
		ShopTexture.hide()
	get_tree().paused = false
