extends ProgressBar


@export var target : CharacterBody2D

func _ready():
	target.health_changed.connect(health_update)
	health_update()

func health_update():
	#value = target.current_health
	pass
