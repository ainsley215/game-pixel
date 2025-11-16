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
		DialogueManager.show_example_dialogue_balloon(load("res://dialog/pickup_seord.dialogue"),"start")
