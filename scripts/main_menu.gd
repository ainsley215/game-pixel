#extends Control
#
#
## Called when the node enters the scene tree for the first time.
#func _ready():
	#pass # Replace with function body.
#
#
## Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
	#pass
#
#
#func start_pressed():
	#get_tree().change_scene_to_file("res://scenes/world.tscn")
#
#
#func exit_pressed():
	#get_tree().quit()


extends Control

func _ready():
	# Cara paling simple - connect manually di editor
	pass

func _on_start_button_pressed():
	print("START!")
	get_tree().change_scene_to_file("res://scenes/world.tscn")

func _on_exit_button_pressed():
	print("EXIT!")
	get_tree().quit()
