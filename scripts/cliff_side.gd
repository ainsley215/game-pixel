extends Node2D

var current_transition_area = ""

func _ready():
	global.current_scene = "cliff_side"
	global.transition_scene = false

func _process(delta):
	change_scenes()

func _on_cliffside_exidpoint_body_entered(body):
	if body.has_method("player"):
		global.transition_scene = true
		current_transition_area = "world"

func _on_cliffside_exidpoint_body_exited(body):
	if body.has_method("player"):
		global.transition_scene = false
		current_transition_area = ""

func _on_dungeon_body_entered(body):
	if body.has_method("player"):
		global.transition_scene = true
		current_transition_area = "dungeon"

func _on_dungeon_body_exited(body):
	if body.has_method("player"):
		global.transition_scene = false
		current_transition_area = ""

func change_scenes():
	if global.transition_scene == true:
		if global.current_scene == "cliff_side":
			#get_tree().change_scene_to_file("res://scenes/world.tscn")
			#global.finish_changescenes()
			match current_transition_area:
				"world":
					get_tree().change_scene_to_file("res://scenes/world.tscn")
					global.game_first_loadin = false
				"dungeon":
					get_tree().change_scene_to_file("res://scenes/dungeon.tscn")
					return
			global.finish_changescenes()
