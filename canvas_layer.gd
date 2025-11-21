extends CanvasLayer

func _ready():
	create_touch_areas()

func create_touch_areas():
	# Hapus yang lama
	for child in $Control.get_children():
		child.queue_free()
	
	var screen_size = get_viewport().get_visible_rect().size
	
	# Area untuk START
	var start_area = ColorRect.new()
	start_area.name = "StartArea"
	start_area.size = Vector2(350, 120)
	start_area.position = Vector2((screen_size.x - 350) / 2, screen_size.y * 0.3)
	start_area.color = Color(0, 1, 0, 0.5)  # Hijau
	start_area.mouse_filter = Control.MOUSE_FILTER_STOP
	$Control.add_child(start_area)
	
	# Label START
	var start_label = Label.new()
	start_label.text = "START GAME"
	start_label.position = Vector2(80, 40)
	start_label.add_theme_font_size_override("font_size", 32)
	start_area.add_child(start_label)
	
	# Area untuk EXIT
	var exit_area = ColorRect.new()
	exit_area.name = "ExitArea"
	exit_area.size = Vector2(350, 120)
	exit_area.position = Vector2((screen_size.x - 350) / 2, screen_size.y * 0.6)
	exit_area.color = Color(1, 0, 0, 0.5)  # Merah
	exit_area.mouse_filter = Control.MOUSE_FILTER_STOP
	$Control.add_child(exit_area)
	
	# Label EXIT
	var exit_label = Label.new()
	exit_label.text = "EXIT"
	exit_label.position = Vector2(130, 40)
	exit_label.add_theme_font_size_override("font_size", 32)
	exit_area.add_child(exit_label)
	
	# Connect touch events
	start_area.gui_input.connect(_on_start_input)
	exit_area.gui_input.connect(_on_exit_input)
	
	print("📱 Touch Areas Ready!")

func _on_start_input(event):
	if event is InputEventScreenTouch and event.pressed:
		print("🎮 START TOUCHED!")
		get_tree().change_scene_to_file("res://scenes/world.tscn")

func _on_exit_input(event):
	if event is InputEventScreenTouch and event.pressed:
		print("🎮 EXIT TOUCHED!")
		get_tree().quit()
