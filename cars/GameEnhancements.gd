extends Node

# Game enhancements for car demo
# This script adds various improvements to make the game more fun


func _ready():
	# Enable mobile-friendly settings
	DisplayServer.screen_set_keep_on(true)  # Keep screen on

	# Set target FPS for mobile optimization
	Engine.max_fps = 60


func add_particle_effects_to_wheels(car_node):
	# Add dust/smoke particle effects to wheels for visual feedback
	for wheel in car_node.get_children():
		if wheel is VehicleWheel3D:
			var particles = GPUParticles3D.new()
			var material = ParticleProcessMaterial.new()

			# Configure dust particles
			material.direction = Vector3(0, 1, 0)
			material.initial_velocity_min = 2.0
			material.initial_velocity_max = 5.0
			material.gravity = Vector3(0, -9.8, 0)
			material.scale_min = 0.1
			material.scale_max = 0.3

			particles.process_material = material
			particles.emitting = false

			wheel.add_child(particles)


func create_speedometer(car_node):
	# Create a more visual speedometer
	var speedometer = Control.new()
	speedometer.set_anchors_and_offsets_preset(Control.PRESET_BOTTOM_LEFT)
	speedometer.size = Vector2(200, 200)

	var speed_arc = ColorRect.new()
	speed_arc.color = Color(1, 1, 1, 0.3)
	speedometer.add_child(speed_arc)

	return speedometer
