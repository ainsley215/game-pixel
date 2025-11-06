extends Node

var player_current_attack = false

var current_scene = "world" # world cliftt_side
var transition_scene = false

var player_exit_cliffside_posx = 127
var player_exit_cliffside_posy = 15
var player_start_posx = 229
var player_start_posy = 104

var game_first_loadin = true

#func finish_changescenes():
	#if transition_scene == true:
		#transition_scene = false
		#if current_scene == "world":
			#current_scene = "cliff_side"
		#else:
			#current_scene = "world"


func finish_changescenes():
	# Reset transisi biar siap dipakai lagi
	transition_scene = false
	
	# Toggle antara world dan cliff_side
	if current_scene == "world":
		current_scene = "cliff_side"
	else:
		current_scene = "world"
