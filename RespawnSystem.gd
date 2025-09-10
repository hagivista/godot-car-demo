extends Area3D

@export var respawn_position: Vector3 = Vector3(0, 3, -150)
@export var respawn_rotation: Vector3 = Vector3(0, 0, 0)


func _ready():
	body_entered.connect(_on_body_entered)


func _on_body_entered(body):
	if body.name == "car":
		_respawn_car(body)


func _respawn_car(car_body):
	# Stop the car's movement
	car_body.linear_velocity = Vector3.ZERO
	car_body.angular_velocity = Vector3.ZERO

	# Reset position and rotation
	car_body.global_position = respawn_position
	car_body.global_rotation_degrees = respawn_rotation

	# Optional: Add a brief pause or effect
	print("Car respawned at start line!")
