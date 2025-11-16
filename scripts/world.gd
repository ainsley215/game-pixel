extends Node2D

var current_transition_area = ""

# Called when the node enters the scene tree for the first time.
func _ready():
	#if global.game_first_loadin == true:
		#$player.position.x = global.player_start_posx
		#$player.position.y = global.player_start_posy
	#else:
		#$player.position.x = global.player_exit_cliffside_posx
		#$player.position.y = global.player_exit_cliffside_posy
	print("Scene ready:", global.current_scene, "| Previous:", global.previous_scene)

	if global.game_first_loadin:
		# posisi awal pertama kali main
		$player.position = global.player_positions["world"]["entry"]
		global.game_first_loadin = false
	else:
		# posisi tergantung dari mana datangnya
		match global.previous_scene:
			"cliff_side":
				$player.position = global.player_positions["world"]["exit_to_cliff_side"]
			"main_house":
				$player.position = global.player_positions["world"]["exit_to_main_house"]

	
	global.current_scene = "world"
	global.transition_scene = false
	global.next_scene = ""


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	#change_scene()
	if global.transition_scene:
		change_scene()
	


func _on_cliffside_transition_point_body_entered(body):
	#if body.has_method("player"):
	if body.name == "player":
		global.transition_scene = true
		current_transition_area = "cliffside"

func _on_cliffside_transition_point_body_exited(body):
	#if body.has_method("player"):
	if body.name == "player":
		global.transition_scene = false
		current_transition_area = ""

func _on_main_house_body_entered(body):
	#if body.has_method("player"):
	if body.name == "player":
		global.transition_scene = true
		current_transition_area = "main_house"

func _on_main_house_body_exited(body):
	#if body.has_method("player"):
	if body.name == "player":
		global.transition_scene = false
		current_transition_area = ""

func change_scene():
	#if global.transition_scene == true:
		#if global.current_scene == "world":
			##get_tree().change_scene_to_file("res://scenes/cliff_side.tscn")
			##global.game_first_loadin = false
			##global.finish_changescenes()
			##match current_transition_area:
				##"cliffside":
					##get_tree().change_scene_to_file("res://scenes/cliff_side.tscn")
					##global.game_first_loadin = false
				##"mainhouse":
					##get_tree().change_scene_to_file("res://scenes/main_house.tscn")
					##return
			##global.finish_changescenes()
			#
			#match current_transition_area:
				#"cliffside":
					#get_tree().change_scene_to_file("res://scenes/cliff_side.tscn")
					#global.game_first_loadin = false
				#"mainhouse":
					#get_tree().change_scene_to_file("res://scenes/main_house.tscn")
			#
			#global.finish_changescenes()

	global.transition_scene = false  # cegah panggilan ganda
	match current_transition_area:
		"cliffside":
			global.previous_scene = global.current_scene
			global.next_scene = "cliff_side"
			global.game_first_loadin = false
			get_tree().change_scene_to_file("res://scenes/cliff_side.tscn")

			
		"main_house":
			global.previous_scene = global.current_scene
			global.finish_changescenes("main_house")
			global.game_first_loadin = false
			get_tree().change_scene_to_file("res://scenes/main_house.tscn")
			

func _on_entrance_trigger_body_entered(body):
	if body.name == "player" and global.main_house_dialog_played == false:
		DialogueManager.show_example_dialogue_balloon(
			load("res://dialog/main_house.dialogue"),"start")
		global.main_house_dialog_played = true
