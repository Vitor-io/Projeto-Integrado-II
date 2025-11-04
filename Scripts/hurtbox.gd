class_name Hurtbox extends Area2D

@onready var owner_stats : Stats = owner.stats

func _ready() -> void:
	monitoring = false
	
	set_collision_layer_value(10, false)
	set_collision_mask_value(10, false)
	match owner_stats.faction:
		Stats.Faction.PLAYER:
			set_collision_layer_value(10, true)
		Stats.Faction.ENEMY:
			set_collision_layer_value(11, true)
			

func receive_hit(current_attack: int) -> void:
	owner_stats.take_damage(current_attack)
	print("receive_hit")
