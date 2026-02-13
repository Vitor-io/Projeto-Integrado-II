extends ProgressBar


func _ready():
	update_exp_bar()

func _physics_process(delta):
	update_exp_bar()
	check_level_up()


func update_exp_bar():
	$".".max_value = global.exp_threshold[global.player_level]
	$".".value = global.player_exp

func check_level_up():
	while global.player_exp >= global.exp_threshold[global.player_level]:
		global.player_exp -= global.exp_threshold[global.player_level]
		global.player_level += 1
