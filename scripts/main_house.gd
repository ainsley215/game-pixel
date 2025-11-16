extends Node2D

var current_transition_area = ""

# Called when the node enters the scene tree for the first time.
func _ready():
	#if global.game_first_loadin:
		#$player.position = Vector2(global.player_start_posx, global.player_start_posy)
	#else:
		#$player.position = Vector2(global.player_exit_cliffside_posx, global.player_exit_cliffside_posy)
	
	if global.game_first_loadin:
		# posisi awal pertama kali main
		$player.position = global.player_positions["main_house"]["entry_from_world"]
	else:
		# posisi tergantung dari mana datangnya
		match global.previous_scene:
			"world":
				$player.position = global.player_positions["main_house"]["entry_from_world"]
	
	global.current_scene = "main_house"
	global.transition_scene = false

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	change_scenes()

func _on_mainhouse_exidpoint_body_entered(body):
	#if body.has_method("player"):
	if body.name == "player":
		global.transition_scene = true
		current_transition_area = "world"

func _on_mainhouse_exidpoint_body_exited(body):
	#if body.has_method("player"):
	if body.name == "player":
		global.transition_scene = false
		current_transition_area = ""

func change_scenes():
	#if global.transition_scene == true:
		#if global.current_scene == "mainhouse":
			#get_tree().change_scene_to_file("res://scenes/world.tscn")
			#global.finish_changescenes()
			
	global.transition_scene = false  # Cegah eksekusi berulang

	match current_transition_area:
		"world":
			global.previous_scene = global.current_scene
			get_tree().change_scene_to_file("res://scenes/world.tscn")
			global.finish_changescenes("world")
			global.game_first_loadin = false


func _on_entrance_trigger_body_entered(body):
	if body.name == "player" and global.main_house_dialog_played == false:
		DialogueManager.show_example_dialogue_balloon(
			load("res://dialog/summon.dialogue"),"start")
		global.main_house_dialog_played = true
