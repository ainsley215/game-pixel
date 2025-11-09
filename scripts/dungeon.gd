extends Node2D

var current_transition_area = ""


func _ready():
	#if global.game_first_loadin:
		#$player.position = Vector2(global.player_start_posx, global.player_start_posy)
	#else:
		#$player.position = Vector2(global.player_exit_cliffside_posx, global.player_exit_cliffside_posy)
		
	if global.game_first_loadin:
		# posisi awal pertama kali main
		$player.position = global.player_positions["dungeon"]["entry_from_cliff_side"]
	else:
		# posisi tergantung dari mana datangnya
		match global.previous_scene:
			"cliff_side":
				$player.position = global.player_positions["dungeon"]["entry_from_cliff_side"]
	
	global.current_scene = "dungeon"
	global.transition_scene = false


func _process(delta):
	#change_scenes()
	if global.transition_scene:
		change_scenes()

func _on_dungeon_exidpoint_body_entered(body):
	#if body.has_method("player"):
	if body.name == "player":
		global.transition_scene = true
		current_transition_area = "cliff_side"

func _on_dungeon_exidpoint_body_exited(body):
	#if body.has_method("player"):
	if body.name == "player":
		global.transition_scene = false
		current_transition_area = ""

func change_scenes():
	#if global.transition_scene == true:
		#if global.current_scene == "dungeon":
			#match current_transition_area:
				#"cliff_side":
					#get_tree().change_scene_to_file("res://scenes/cliff_side.tscn")
					#global.game_first_loadin = false
			#global.finish_changescenes()
			
	global.transition_scene = false  # Cegah eksekusi berulang

	match current_transition_area:
		"cliff_side":
			global.previous_scene = global.current_scene
			get_tree().change_scene_to_file("res://scenes/cliff_side.tscn")
			global.finish_changescenes("cliff_side")
			global.game_first_loadin = false
