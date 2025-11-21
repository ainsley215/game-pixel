extends Area2D

@export var weapon_name = "sword"
@export var pickup_id = "pickup_sword_1"

# Called when the node enters the scene tree for the first time.
func _ready():
	#if global.is_pickup_taken(pickup_id):
		#queue_free()
		#return
	
	if global.is_pickup_taken(pickup_id):
		queue_free()
		return

	connect("body_entered", _on_body_entered)
	# connect("body_entered", Callable(self, "_on_body_entered"))
	


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_body_entered(body):
	#print("Ada yang masuk area:", body.name)
	#if body.name == "player":
		#body.pickup_weapon(weapon_name)
		##global.has_sword = true
		#global.mark_pickup(pickup_id)
		#queue_free()
		
	if body.name == "player":
		global.has_sword = true
		global.mark_pickup(pickup_id)
		if "pickup_weapon" in body:
			body.pickup_weapon(weapon_name)
			queue_free()


func _on_entrance_trigger_body_entered(body):
	if body.name == "player" and not global.pickups_taken.get("sword_main_house", false):
		DialogueManager.show_example_dialogue_balloon(load("res://dialog/pickup_sword.dialogue"),"start")
		
		# Auto-next setiap 4 detik
		_start_auto_dialog()
		
		global.pickups_taken["sword_main_house"] = true
		
func _start_auto_dialog():
	# Timer untuk auto-next setiap 4 detik
	var timer = Timer.new()
	timer.wait_time = 4.0  # 4 detik per line
	timer.autostart = true
	add_child(timer)
	
	# Counter untuk batas maksimal
	var line_count = 0
	var max_lines = 5  # Maksimal 5 line agar tidak infinite
	
	timer.timeout.connect(func():
		if line_count < max_lines:
			print("Auto-next dialog line ", line_count + 1)
			
			# Simulate SPACE untuk next
			var space_event = InputEventAction.new()
			space_event.action = "ui_accept"
			space_event.pressed = true
			Input.parse_input_event(space_event)
			
			line_count += 1
		else:
			# Stop timer setelah max lines
			print("Auto-dialog finished")
			timer.stop()
			timer.queue_free()
	)
	
