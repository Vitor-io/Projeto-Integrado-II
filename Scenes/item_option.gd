extends ColorRect

var mouse_over = false
var item = null
@onready var player = get_tree().get_first_node_in_group("player")
@onready var label = $Label

signal select_item(Item)

func _ready():
	process_mode = Node.PROCESS_MODE_WHEN_PAUSED
	mouse_filter = Control.MOUSE_FILTER_STOP
	#connect("select_item", Callable(player, "upgrade_character"))
	
	print("Player encontrado:", player)
	
	if player:
		connect("select_item", Callable(player, "upgrade_character"))
		print("Conectado!")
	else:
		print("Player NÃO encontrado!")



func _gui_input(event):
	if event.is_action_pressed("click"):
		print("Input")
		emit_signal("select_item", self)

func _on_mouse_entered():
	mouse_over = true


func _on_mouse_exited():
	mouse_over = false
