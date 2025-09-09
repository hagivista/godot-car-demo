extends Node

@export var respawn_position: Vector3 = Vector3(0, 3, -150)
@export var respawn_rotation: Vector3 = Vector3(0, 0, 0)

var car_node: VehicleBody3D

func _ready():
	# Find the car in the scene
	car_node = get_tree().get_first_node_in_group("car")
	if not car_node:
		car_node = get_node("../car")

func _input(event):
	if event.is_action_pressed("ui_cancel") or Input.is_key_pressed(KEY_R):
		_respawn_car()

func _respawn_car():
	if car_node:
		# Stop the car's movement
		car_node.linear_velocity = Vector3.ZERO
		car_node.angular_velocity = Vector3.ZERO
		
		# Reset position and rotation
		car_node.global_position = respawn_position
		car_node.global_rotation_degrees = respawn_rotation
		
		print("Manual respawn activated! Press R to respawn anytime.")