extends ColorRect

func _ready():
	print("🚀 1. Touch area _ready() called")
	
	# Setup touch area
	size = get_viewport().get_visible_rect().size
	color = Color(1, 0, 0, 0.3)
	mouse_filter = Control.MOUSE_FILTER_STOP
	z_index = 9999
	
	print("🚀 2. Size set to: ", size)
	print("🚀 3. Position: ", position)
	
	# Process even when paused
	process_mode = Node.PROCESS_MODE_ALWAYS
	
	# Auto remove timeout
	get_tree().create_timer(10.0).timeout.connect(_on_timeout)
	
	print("🚀 4. DIALOG TOUCH AREA READY!")

func _gui_input(event):
	print("🚀 5. _gui_input received: ", event)
	
	if event is InputEventScreenTouch and event.pressed:
		print("🎯 6. TOUCH DETECTED at: ", event.position)
		
		# Multiple space simulation
		for i in range(2):
			print("🚀 7. Simulating SPACE #", i+1)
			var space_event = InputEventAction.new()
			space_event.action = "ui_accept"
			space_event.pressed = true
			Input.parse_input_event(space_event)
			await get_tree().create_timer(0.1).timeout
		
		get_viewport().set_input_as_handled()
		print("🚀 8. Input handled")

func _on_timeout():
	print("🚀 9. Timeout - Removing touch area")
	queue_free()
