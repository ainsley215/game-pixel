extends Node2D

var current_transition_area = ""


func _ready():
	global.current_scene = "dungeon"
	global.transition_scene = false


func _process(delta):
	change_scenes()

func _on_dungeon_exidpoint_body_entered(body):
	if body.has_method("player"):
		global.transition_scene = true
		current_transition_area = "dungeon"

func _on_dungeon_exidpoint_body_exited(body):
	if body.has_method("player"):
		global.transition_scene = false
		current_transition_area = ""

func change_scenes():
	if global.transition_scene == true:
		if global.current_scene == "dungeon":
			match current_transition_area:
				"cliff_side":
					get_tree().change_scene_to_file("res://scenes/cliff_side.tscn")
					global.game_first_loadin = false
			global.finish_changescenes()
