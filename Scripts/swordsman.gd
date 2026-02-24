extends CharacterBody2D
class_name Swordsman


@onready var animated_sprite = $AnimatedSprite2D
@onready var nav_agent := $NavigationAgent2D
@onready var health_bar := $ProgressBar
@export var stats : Resource
var normal_color = Color(1.0, 1.0, 1.0, 1.0)
var damage_color = Color(1.0, 0.259, 0.188, 0.769)
var player_ref : Player_test_class
var player : Node2D
var being_attacked = false
var can_take_damage = true


@onready var direction := true
enum STATE {
	RUN,
	ATTACK,
	IDLE
}


func _ready() -> void:
	#player_ref = get_tree().get_first_node_in_group("Player")
	player = get_tree().get_first_node_in_group("Player")
	health_bar.max_value = stats.health

func _physics_process(delta: float) -> void:
	#nav_agent.target_position = player_ref.position
	#velocity = position.direction_to(nav_agent.get_next_path_position()) * stats.speed
	if player:
		var direction = (player.global_position - global_position).normalized()
		velocity = direction * stats.speed
		if (player.position.x - position.x) > 0:
			$AnimatedSprite2D.flip_h = true
		else:
			$AnimatedSprite2D.flip_h = false
	move_and_slide()
	animate()
	take_damage()


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


func attack():
	pass


func die():
	pass


func take_damage():
	if being_attacked and global.player_current_attacking:
		if can_take_damage == true:
			stats.health -= player.stats.damage * global.player_level
			$DamageCooldown.start()
			can_take_damage = false
			print(stats.health)
			if stats.health <= 0:
				global.player_exp += 500
				self.queue_free()


func _on_swordsman_hitbox_area_entered(area):
	if area.is_in_group("Player"):
		being_attacked = true


func _on_swordsman_hitbox_area_exited(area):
	if area.is_in_group("Player"):
		being_attacked = false


func _on_damage_cooldown_timeout():
		can_take_damage = true
