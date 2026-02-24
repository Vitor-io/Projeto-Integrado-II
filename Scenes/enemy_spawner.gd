extends Node2D

@export var enemy_prefab : PackedScene
@export var target : Node2D

	#if (player.position.x - position.x) > 0:
		#$AnimatedSprite2D.flip_h = true
	#else:
		#$AnimatedSprite2D.flip_h = false

func _on_timer_timeout():
	var enemy = enemy_prefab.instantiate()
	if target:
		enemy.player_ref = target
		add_child(enemy)
