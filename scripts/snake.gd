extends CharacterBody2D

@export var enemy_id : String = ""

var speed = 40
var player_chase = false
var player = null
var last_dir = "down"
var last_flip = false
var health = 100
var player_inattack_zone = false
var can_take_damage = true
var damage = 5

func _ready():
	if global.enemy_defeated.has(enemy_id):
		if global.enemy_defeated[enemy_id] == true:
			queue_free()

func _physics_process(delta):
	
	deal_with_damage()
	update_health()
	
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
				
			move_and_slide() # untuk hindari tilemap
			
		
func _on_detection_area_body_entered(body):
	player = body
	player_chase = true

func _on_detection_area_body_exited(body):
	player = null
	player_chase = false

func snake():
	pass

func _on_snake_hitbox_body_entered(body):
	if body.has_method("player"):
		player_inattack_zone = true

func _on_snake_hitbox_body_exited(body):
	if body.has_method("player"):
		player_inattack_zone = false

func deal_with_damage():
	if player_inattack_zone and global.player_current_attack == true:
		if can_take_damage == true:
			health = health - 20
			$take_damage_cooldown.start()
			can_take_damage = false
			print("skeleton health = ", health)
			#if health <= 0:
				#self.queue_free()
				
			if health <= 0:
				global.enemy_defeated[enemy_id] = true
				self.queue_free()

func _on_take_damage_cooldown_timeout():
	can_take_damage = true
	

func update_health():
	var healthbar = $healthbar
	healthbar.value = health
	if health >= 100:
		healthbar.visible = false
	else:
		healthbar.visible = true

func die():
	# Hapus enemy dari scene
	queue_free()

	# Cek kelompoknya
	if is_in_group("main_house_enemy"):
		_check_all_enemies_dead("main_house", "main_house_enemy")

	if is_in_group("dungeon_enemy"):
		_check_all_enemies_dead("dungeon", "dungeon_enemy")
		
func _check_all_enemies_dead(area_key: String, group_name: String):
	var enemies = get_tree().get_nodes_in_group(group_name)

	# Jika size = 1 berarti musuh yg tersisa cuma yang sedang mati ini.
	if enemies.size() <= 1:
		global.enemy_defeated[area_key] = true
		print("Semua musuh di", area_key, "telah mati!")
