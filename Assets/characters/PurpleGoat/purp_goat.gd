extends CharacterBody2D

class_name  Purple_Goat_Class

var player_chase = false
var player = null



func _ready():
	pass


func _physics_process(delta):
	
	die()
	
	if player_chase:
		position += (player.position - position)/SPEED
		$"Animações".play("goatwalk")
		
		if(player.position.x - position.x) < 0:
			$"Animações".flip_h = false
		else:
			$"Animações".flip_h = true
	else:
		$"Animações".play("goatidle")

func _on_detection_area_body_entered(body):
	player = body
	player_chase = true


func _on_detection_area_body_exited(body):
	player = null
	player_chase = false

func hit():
	$PlayerDetector.monitoring = true

func end_of_hit():
	$PlayerDetector.monitoring = false

func start_idle():
	$"Animações".play("goatidle")

func attack():
	pass

func die():
	pass

func enemy():
	pass
