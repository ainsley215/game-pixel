extends Node

var player_current_attack = false

var current_scene = "world" # world cliftt_side
var transition_scene = false
var has_sword: bool = false
var previous_scene = ""
var next_scene = ""
#var player_exit_cliffside_posx = 127
#var player_exit_cliffside_posy = 15
#var player_start_posx = 229
#var player_start_posy = 104

var enemy_defeated = {}
var pickups_taken := {}

var player_positions = {
	"world": {
		"entry": Vector2(129, 90),
		"exit_to_cliff_side": Vector2(128, 23),
		"exit_to_main_house": Vector2(229, 104)
	},
	"cliff_side": {
		"entry_from_world": Vector2(128, 192),
		"exit_to_dungeon": Vector2(167, 60)
	},
	"main_house": {
		"entry_from_world": Vector2(161, 177)
	},
	"dungeon": {
		"entry_from_cliff_side": Vector2(442, 1004)
	}
}

var game_first_loadin = true

var player_health = 100
var player_max_health = 100
var player_position = Vector2.ZERO

#func finish_changescenes():
	#if transition_scene == true:
		#transition_scene = false
		#if current_scene == "world":
			#current_scene = "cliff_side"
		#else:
			#current_scene = "world"


#func finish_changescenes():
	## Reset transisi biar siap dipakai lagi
	#transition_scene = false
	#
	### Toggle antara world dan cliff_side
	##if current_scene == "world":
		##current_scene = "cliff_side"
	##else:
		##current_scene = "world"
		#
	#match current_scene:
		#"world":
			#current_scene = "cliff_side"
		#"cliff_side":
			#current_scene = "world"
		#"dungeon":
			#current_scene = "cliff_side"
		#"main_house":
			#current_scene = "world"

func finish_changescenes(new_scene_name: String):
	previous_scene = current_scene
	current_scene = new_scene_name
	print("Scene change registered. From:", previous_scene, "to:", current_scene)
	transition_scene = false

func save_player_state(health, max_health, position):
	player_health = health
	player_max_health = max_health
	player_position = position

func get_player_state():
	return {
		"health": player_health,
		"max_health": player_max_health,
		"position": player_position
	}

func mark_pickup(id):
	pickups_taken[id] = true

func is_pickup_taken(id):
	return pickups_taken.get(id, false)
