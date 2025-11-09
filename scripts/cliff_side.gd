extends Node2D

var current_transition_area = ""

func _ready():
	#if global.game_first_loadin:
		#$player.position = Vector2(global.player_start_posx, global.player_start_posy)
	#else:
		#$player.position = Vector2(global.player_exit_cliffside_posx, global.player_exit_cliffside_posy)
	
	if global.game_first_loadin:
		# posisi awal pertama kali main
		$player.position = global.player_positions["cliff_side"]["entry_from_world"]
	else:
		# posisi tergantung dari mana datangnya
		match global.previous_scene:
			"world":
				$player.position = global.player_positions["cliff_side"]["entry_from_world"]
			"dungeon":
				$player.position = global.player_positions["cliff_side"]["exit_to_dungeon"]
	
	global.current_scene = "cliff_side"
	global.transition_scene = false
	global.next_scene = ""

func _process(delta):
	#change_scenes()
	if global.transition_scene:
		change_scenes()

func _on_cliffside_exidpoint_body_entered(body):
	#if body.has_method("player"):
	if body.name == "player":
		global.transition_scene = true
		current_transition_area = "world"

func _on_cliffside_exidpoint_body_exited(body):
	#if body.has_method("player"):
	if body.name == "player":
		global.transition_scene = false
		current_transition_area = ""

func _on_dungeon_body_entered(body):
	#if body.has_method("player"):
	if body.name == "player":
		global.transition_scene = true
		current_transition_area = "dungeon"

func _on_dungeon_body_exited(body):
	#if body.has_method("player"):
	if body.name == "player":
		global.transition_scene = false
		current_transition_area = ""

func change_scenes():
	#if global.transition_scene == true:
		#if global.current_scene == "cliff_side":
			##get_tree().change_scene_to_file("res://scenes/world.tscn")
			##global.finish_changescenes()
			#match current_transition_area:
				#"world":
					#get_tree().change_scene_to_file("res://scenes/world.tscn")
					#global.game_first_loadin = false
				#"dungeon":
					#get_tree().change_scene_to_file("res://scenes/dungeon.tscn")
					#return
			#global.finish_changescenes()
			
	global.transition_scene = false  # cegah pemanggilan ganda

	match current_transition_area:
		"world":
			global.previous_scene = global.current_scene
			get_tree().change_scene_to_file("res://scenes/world.tscn")
			global.finish_changescenes("world")
			global.game_first_loadin = false

		"dungeon":
			global.previous_scene = global.current_scene
			get_tree().change_scene_to_file("res://scenes/dungeon.tscn")
			global.finish_changescenes("dungeon")
			global.game_first_loadin = false
