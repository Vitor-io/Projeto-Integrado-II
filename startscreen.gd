extends CanvasLayer
@onready var start = $start


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	start.grab_focus()


func _on_start_pressed():
	get_tree().change_scene_to_file("res://Scenes/nível_teste.tscn")


func _on_quit_pressed():
	get_tree().quit()
