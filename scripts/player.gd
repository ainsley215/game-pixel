extends CharacterBody2D

var joystick
var attack_button

var enemy_in_attack_range = null
var enemy_attack_cooldown = true
var health = 100
var player_alive = true
var attack_ip = false

const speed = 40
var current_dir = "none"

var enemy_methods = ["skeleton", "snake", "samurai"]

var has_weapon = false
var current_weapon = null

func _ready():
	$AnimatedSprite2D.play("idle_down")
	
	if global.has_sword:
		pickup_weapon("sword")
	if global.player_health > 0:
		health = global.player_health
	update_health()
	
	#if global.player_health > 0:
		#health = global.player_health
	#update_health()
	
	joystick = get_tree().get_first_node_in_group("virtual_joystick")

	if joystick:
		joystick.connect("joystick_moved", Callable(self, "_on_joystick_move"))
	

func _physics_process(delta):
	player_movement(delta)
	enemy_attack()
	attack()
	current_camera()
	update_health()
	
	global.save_player_state(health, 100, position)
	
	if health <= 0:
		player_alive = false # add end screen
		health = 0
		print("player has been killed")
		get_tree().change_scene_to_file("res://scenes/main_menu.tscn")
		self.queue_free()

func player_movement(delta):
	
	if joystick and joystick.is_pressed:
		move_and_slide()
		return
		
	var input_vector = Vector2.ZERO
	input_vector.x = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
	input_vector.y = Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")
	
	if input_vector != Vector2.ZERO:
		input_vector = input_vector.normalized()
		velocity = input_vector * speed

		# Tentukan arah animasi
		if abs(input_vector.x) > abs(input_vector.y):
			current_dir = "right" if input_vector.x > 0 else "left"
		else:
			current_dir = "down" if input_vector.y > 0 else "up"

		play_anim(1)
	else:
		velocity = Vector2.ZERO
		play_anim(0)

	move_and_slide()
	
	#if Input.is_action_pressed("ui_right"):
		#current_dir = "right"
		#play_anim(1)
		#velocity.x = speed
		#velocity.y = 0
	#elif Input.is_action_pressed("ui_left"):
		#current_dir = "left"
		#play_anim(1)
		#velocity.x = -speed
		#velocity.y = 0
	#elif Input.is_action_pressed("ui_down"):
		#current_dir = "down"
		#play_anim(1)
		#velocity.y = speed
		#velocity.x = 0
	#elif Input.is_action_pressed("ui_up"):
		#current_dir = "up"
		#play_anim(1)
		#velocity.y = -speed
		#velocity.x = 0
	#else:
		#play_anim(0)
		#velocity.x = 0
		#velocity.y = 0
	
	move_and_slide()

func play_anim(movement):
	var dir = current_dir
	var anim = $AnimatedSprite2D
	
	if dir == "right":
		anim.flip_h = false
		if movement == 1:
			anim.play("walk_right")
		elif movement == 0:
			if attack_ip == false:
				anim.play("idle_right")
			
	if dir == "left":
		anim.flip_h = false
		if movement == 1:
			anim.play("walk_left")
		elif movement == 0:
			if attack_ip == false:
				anim.play("idle_left")
			
	if dir == "down":
		anim.flip_h = true
		if movement == 1:
			anim.play("walk_down")
		elif movement == 0:
			if attack_ip == false:
				anim.play("idle_down")
			
	if dir == "up":
		anim.flip_h = true
		if movement == 1:
			anim.play("walk_up")
		elif movement == 0:
			if attack_ip == false:
				anim.play("idle_up")

func player():
	pass

func _on_player_hitbox_body_entered(body):
	#if body.has_method("skeleton"):
		#skeleton_inattack_range = true
		
	if body.is_in_group("enemy"):
		enemy_in_attack_range = body

func _on_player_hitbox_body_exited(body):
	#if body.has_method("skeleton"):
		#skeleton_inattack_range = false
		
	if body == enemy_in_attack_range:
		enemy_in_attack_range = null

#func skeleton_attack():
	#if enemy_in_attack_range and enemy_attack_cooldown == true:
		#health = health - 10
		#enemy_attack_cooldown = false
		#$attack_cooldown.start()
		#print(health)
		#
		#global.save_player_state(health, 100, position)
		

func enemy_attack():
	if enemy_in_attack_range != null and enemy_attack_cooldown:
		var damage = 10
		if "damage" in enemy_in_attack_range:
			damage = enemy_in_attack_range.damage

		health -= damage
		print("Player kena serangan dari", enemy_in_attack_range.name, "-> -", damage, "HP")

		enemy_attack_cooldown = false
		$attack_cooldown.start()
		global.save_player_state(health, 100, position)

func _on_attack_cooldown_timeout():
	enemy_attack_cooldown = true
	
func attack():
	var dir = current_dir
	
	if Input.is_action_just_pressed("attack"):
		print("ATTACK ACTION DETECTED!")
	
	# pakai flip_h
	#if Input.is_action_just_pressed("attack"):
		#global.player_current_attack = true
		#attack_ip = true
		#if dir == "right":
			#$AnimatedSprite2D.flip_h = false
			#$AnimatedSprite2D.play("attack_right")
			#$deal_attack_timer.start()
		#if dir == "left":
			#$AnimatedSprite2D.flip_h = true
			#$AnimatedSprite2D.play("attack_left")
			#$deal_attack_timer.start()
		#if dir == "down":
			#$AnimatedSprite2D.play("attack_down")
			#$deal_attack_timer.start()
		#if dir == "up":
			#$AnimatedSprite2D.play("attack_up")
			#$deal_attack_timer.start()
	
	# gak pakai flip_h
	#if Input.is_action_just_pressed("attack"):
	if has_weapon and Input.is_action_just_pressed("attack"):
		$attack_sound.pitch_scale = randf_range(0.9, 1.1)
		$attack_sound.play()
		global.player_current_attack = true
		attack_ip = true

		var anim = $AnimatedSprite2D

		match dir:
			"right":
				anim.play("attack_right")
			"left":
				anim.play("attack_left")
			"down":
				anim.play("attack_down")
			"up":
				anim.play("attack_up")

		$deal_attack_timer.start()

func _on_deal_attack_timer_timeout():
	$deal_attack_timer.stop()
	global.player_current_attack = false
	attack_ip = false

func current_camera():
	#if global.current_scene == "world":
		#$world_camera.enabled = true
		#$cliffside_camera.enabled = false
	#elif global.current_scene == "cliff_side":
		#$world_camera.enabled = false
		#$cliffside_camera.enabled = true
		
	$world_camera.enabled = false
	$cliffside_camera.enabled = false
	$dungeon_camera.enabled = false
	$main_house_camera.enabled = false
	
	match global.current_scene:
		"world":
			$world_camera.enabled = true
		"cliff_side":
			$cliffside_camera.enabled = true
		"dungeon":
			$dungeon_camera.enabled = true
		"main_house":
			$main_house_camera.enabled = true
			
			$world_camera.enabled = true

func update_health():
	var healthbar = $healthbar
	healthbar.value = health
	
	if health >= 100:
		healthbar.visible = false
	else:
		healthbar.visible = true

func _on_regin_timer_timeout():
	if health < 100:
		health = health + 20
		if health > 100:
			health = 100
			
		global.save_player_state(health, 100, position)
			
	if health <= 0:
		health = 0
		
#func pickup_weapon(weapon_name):
	#print("Player got weapon:", weapon_name)
	#has_sword = true
	#enable_weapon()

func pickup_weapon(weapon):
	has_weapon = true
	current_weapon = weapon
	print("Player mengambil senjata:", weapon)

#func enable_weapon():
	#$weapon_pickup.monitoring = true
	#$weapon_pickup/CollisionShape2D.disabled = false
	#print("Weapon enabled!")
#
#func disable_weapon():
	#$weapon_pickup.monitoring = false
	#$weapon_pickup/CollisionShape2D.disabled = true
	#print("Weapon disabled!")

#func pickup_weapon(weapon_name):
	#print("Player got weapon:", weapon_name)
	#global.has_sword = true
	#enable_weapon()

func _on_joystick_move(dir: Vector2):
	if dir.length() > 0.1:
		velocity = dir.normalized() * (speed * 0.1)

		if abs(dir.x) > abs(dir.y):
			current_dir = "right" if dir.x > 0 else "left"
		else:
			current_dir = "down" if dir.y > 0 else "up"

		play_anim(1)
	else:
		velocity = Vector2.ZERO
		play_anim(0)
