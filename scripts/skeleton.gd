extends CharacterBody2D

var speed = 40
var player_chase = false
var player = null
var last_dir = "down"

var last_flip = false

func _physics_process(delta):
	#if player_chase:
		#position += (player.position - position)/speed
		#
		#$AnimatedSprite2D.play("")
		#
		#if(player.position.x - position.x) < 0:
			#$AnimatedSprite2D.flip_h = true
		#else:
			#$AnimatedSprite2D.flip_h = false
	#else:
		#$AnimatedSprite2D.play("")
		
	# ini pakai flip_h	
	#if player_chase:
		#var dir = player.position - position
		#position += dir.normalized() * (speed * delta)
#
		#var anim = $AnimatedSprite2D
#
		## Cek arah dominan
		#if abs(dir.x) > abs(dir.y):
			#anim.play("walk_right")  # cuma punya animasi kanan
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
				#anim.play("walk_down")
				#last_dir = "down"
			#else:
				#anim.play("walk_up")
				#last_dir = "up"
	#else:
		#var anim = $AnimatedSprite2D
		#match last_dir:
			#"left":
				#anim.play("idle_right")
				#anim.flip_h = true
			#"right":
				#anim.play("idle_right")
				#anim.flip_h = false
			#"up":
				#anim.play("idle_up")
			#"down":
				#anim.play("idle_down")	
		
	# gak pakai flip_h
	if player_chase:
		var dir = player.position - position
		position += dir.normalized() * (speed * delta)

		var anim = $AnimatedSprite2D
		
		if abs(dir.x) > abs(dir.y):
			if dir.x > 0:
				anim.play("walk_right")
				last_dir = "right"
			else:
				anim.play("walk_left")
				last_dir = "left"
		else:
			if dir.y > 0:
				anim.play("walk_down")
				last_dir = "down"
			else:
				anim.play("walk_up")
				last_dir = "up"
	else:
		match last_dir:
			"right":
				$AnimatedSprite2D.play("idle_right")
			"left":
				$AnimatedSprite2D.play("idle_left")
			"down":
				$AnimatedSprite2D.play("idle_down")
			"up":
				$AnimatedSprite2D.play("idle_up")
		
func _on_detection_area_body_entered(body):
	player = body
	player_chase = true

func _on_detection_area_body_exited(body):
	player = null
	player_chase = false
