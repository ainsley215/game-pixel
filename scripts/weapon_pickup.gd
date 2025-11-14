extends Area2D

@export var weapon_name = "sword"

# Called when the node enters the scene tree for the first time.
func _ready():
	connect("body_entered", Callable(self, "_on_body_entered"))


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_body_entered(body):
	print("Ada yang masuk area:", body.name)
	if body.name == "player":
		body.pickup_weapon(weapon_name)
		queue_free()
