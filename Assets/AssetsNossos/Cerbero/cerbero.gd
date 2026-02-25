extends Node2D
@onready var cerbero =  "res://Assets/characters/Cerbero/Cerberoanim-Sheet.png"



func _on_animcerbero_frame_changed() -> void:
	if $animcerbero.animation == "attack":
		if $animcerbero.frame == 1:
			var anima = get_tree().create_tween()
			anima.tween_property($animcerbero,"scale", Vector2(1,1.1), 0.2)
			anima.parallel().tween_property($animcerbero,"position:y",(-5),0.4).from_current()
			anima.tween_property($animcerbero,"scale", Vector2(1,0.9), 0.1)
			anima.parallel().tween_property($animcerbero,"position:y",(5),0.3).from_current()
			anima.tween_property($animcerbero,"scale", Vector2(1,1), 0.1)
			anima.parallel().tween_property($animcerbero,"position:y",(0),0.1).from_current()
