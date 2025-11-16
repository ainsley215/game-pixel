#extends CharacterBody2D
#
#
#var speed = 40
#var player_chase = false
#var player = null
#var last_dir = "down"
#var last_flip = false
#
#
#func _physics_process(delta):
	#if player_chase:
		#var dir = player.position - position
		#position += dir.normalized() * (speed * delta)
#
		#var anim = $AnimatedSprite2D
#
		## Cek arah dominan
		#if abs(dir.x) > abs(dir.y):
			#anim.play("idle")  # cuma punya animasi kanan
			#if dir.x < 0:
				#anim.flip_h = true   # hadap kiri
				#last_dir = "left"
				#last_flip = true
			#else:
				#anim.flip_h = false  # hadap kanan
				#last_dir = "right"
				#last_flip = false
		#else:
			#if dir.y > 0:
				#anim.play("idle")
				#last_dir = "down"
			#else:
				#anim.play("idle")
				#last_dir = "up"
	#else:
		#var anim = $AnimatedSprite2D
		#match last_dir:
			#"left":
				#anim.play("idle")
				#anim.flip_h = true
			#"right":
				#anim.play("idle")
				#anim.flip_h = false
			#"up":
				#anim.play("idle")
			#"down":
				#anim.play("idle")	
#
#
#func _on_detection_area_body_entered(body):
	#if body.name != "player" and body.name != "Player":
		#return
#
	## --- DIALOG 1: sebelum dungeon ---
	#if not global.npc_dialog_1_played:
		#DialogueManager.show_example_dialogue_balloon(
			#load("res://dialog/npc1.dialogue"),
			#"start"
		#)
		#global.npc_dialog_1_played = true
		#return
#
#
	## --- DIALOG 2: setelah semua enemy mati ---
	#if global.npc_dialog_2_played:
		#return
#
	#if global.enemy_defeated["main_house"] \
	#and global.enemy_defeated["dungeon"]:
		#DialogueManager.show_example_dialogue_balloon(
			#load("res://dialog/npc2.dialogue"),
			#"start"
		#)
		#global.npc_dialog_2_played = true
		#return


extends CharacterBody2D

var speed = 40
var player_chase = false
var can_attack = false
var player = null
var last_dir = "down"
var last_flip = false

enum STATE { IDLE, CHASE, ATTACK }
var state = STATE.IDLE


func _physics_process(delta):
	match state:
		STATE.IDLE:
			play_idle_animation()

		STATE.CHASE:
			if player:
				chase_player(delta)

		STATE.ATTACK:
			play_attack_animation()


func chase_player(delta):
	var dir = player.position - position
	position += dir.normalized() * (speed * delta)

	var anim = $AnimatedSprite2D

	# Animasi jalan
	anim.play("walk")

	# arah
	if dir.x < 0:
		anim.flip_h = true
	elif dir.x > 0:
		anim.flip_h = false


func play_idle_animation():
	var anim = $AnimatedSprite2D
	anim.play("idle")


func play_attack_animation():
	var anim = $AnimatedSprite2D
	anim.play("attack")

func _on_detection_area_body_entered(body):
	if body.name not in ["player", "Player"]:
		return

	player = body

	# --- DIALOG 1: sebelum dungeon ---
	if not global.npc_dialog_1_played:
		DialogueManager.show_example_dialogue_balloon(
			load("res://dialog/npc1.dialogue"), "start"
		)
		global.npc_dialog_1_played = true
		return


	# --- DIALOG 2: setelah semua enemy mati ---
	if not global.npc_dialog_2_played:
		if global.enemy_defeated.get("main_house", false) \
		and global.enemy_defeated.get("dungeon", false):

			DialogueManager.show_example_dialogue_balloon(
				load("res://dialog/npc2.dialogue"), "start"
			)

			global.npc_dialog_2_played = true

			# ============ NPC mulai menyerang ============
			await get_tree().create_timer(0.5).timeout
			state = STATE.CHASE
			player_chase = true
			can_attack = true

			return



func _on_detection_area_2_body_entered(body: Node2D) -> void:
	if body.name in ["Player", "player"] and can_attack:
		state = STATE.ATTACK
		$AnimatedSprite2D.play("attack")

		# contoh damage
		body.take_damage(10)

		# kembali chase setelah attack
		await get_tree().create_timer(0.8).timeout
		state = STATE.CHASE


func _on_red_hitbox_body_entered(body: Node2D) -> void:
	pass # Replace with function body.
