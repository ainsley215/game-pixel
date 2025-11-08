extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready():
	global.current_scene = "main_house"
	global.transition_scene = false

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	change_scenes()

func _on_mainhouse_exidpoint_body_entered(body):
	if body.has_method("player"):
		global.transition_scene = true

func _on_mainhouse_exidpoint_body_exited(body):
	if body.has_method("player"):
		global.transition_scene = false

func change_scenes():
	if global.transition_scene == true:
		if global.current_scene == "main_house":
			get_tree().change_scene_to_file("res://scenes/world.tscn")
			global.finish_changescenes()
