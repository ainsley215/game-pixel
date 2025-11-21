extends Control

@export var action_name := "attack"

func _ready():
	#custom_minimum_size = Vector2(200, 200)
	#size = Vector2(200, 200)
	#
	## Background debug
	#var bg = ColorRect.new()
	#bg.size = size
	#bg.color = Color(1, 0, 0, 0.5)
	#add_child(bg)
	#
	#print("🔴 Red Area = Attack Button")
	if get_tree().current_scene.name == "main_menu":
		visible = false
		process_mode = Node.PROCESS_MODE_DISABLED
		return

func _gui_input(event):
	if event is InputEventScreenTouch:
		if event.pressed:
			print("ATTACK!")
			Input.action_press(action_name)
		else:
			print("ATTACK STOP!")
			Input.action_release(action_name)
		get_viewport().set_input_as_handled()
