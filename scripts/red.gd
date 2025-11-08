extends CharacterBody2D

var speed = 40
var player_chase = false
var player = null
var last_dir = "down"
var last_flip = false


func _physics_process(delta):
	if player_chase:
		var dir = player.position - position
		position += dir.normalized() * (speed * delta)

		var anim = $AnimatedSprite2D

		# Cek arah dominan
		if abs(dir.x) > abs(dir.y):
			anim.play("idle")  # cuma punya animasi kanan
			if dir.x < 0:
				anim.flip_h = true   # hadap kiri
				last_dir = "left"
				last_flip = true
			else:
				anim.flip_h = false  # hadap kanan
				last_dir = "right"
				last_flip = false
		else:
			if dir.y > 0:
				anim.play("idle")
				last_dir = "down"
			else:
				anim.play("idle")
				last_dir = "up"
	else:
		var anim = $AnimatedSprite2D
		match last_dir:
			"left":
				anim.play("idle")
				anim.flip_h = true
			"right":
				anim.play("idle")
				anim.flip_h = false
			"up":
				anim.play("idle")
			"down":
				anim.play("idle")	
