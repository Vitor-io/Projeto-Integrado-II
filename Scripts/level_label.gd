extends Label


# Called when the node enters the scene tree for the first time.
func _ready():
	update_level()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	update_level()

func update_level():
	text= "Level " +str(global.player_level)
