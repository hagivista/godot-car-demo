extends VehicleBody3D


@export var STEER_SPEED = 1.5
@export var STEER_LIMIT = 0.6
var steer_target = 0
@export var engine_force_value = 40

# Mobile controls
var mobile_controls: Control
var is_accelerating = false
var is_braking = false
var is_drifting = false
var mobile_steer_value = 0.0

func _ready():
	# Always add mobile controls for testing (can be toggled with a key)
	# In production, you would only show on mobile: if _is_mobile_platform():
	_setup_mobile_controls()

func _is_mobile_platform() -> bool:
	return OS.get_name() == "Android" or OS.get_name() == "iOS" or OS.has_feature("mobile") or OS.has_feature("web")

func _setup_mobile_controls():
	var mobile_scene = preload("res://cars/MobileControls.tscn")
	mobile_controls = mobile_scene.instantiate()
	get_tree().current_scene.add_child(mobile_controls)
	
	# Connect mobile control signals
	mobile_controls.accelerate_pressed.connect(_on_mobile_accelerate_pressed)
	mobile_controls.accelerate_released.connect(_on_mobile_accelerate_released)
	mobile_controls.brake_pressed.connect(_on_mobile_brake_pressed)
	mobile_controls.brake_released.connect(_on_mobile_brake_released)
	mobile_controls.drift_pressed.connect(_on_mobile_drift_pressed)
	mobile_controls.drift_released.connect(_on_mobile_drift_released)
	mobile_controls.steer_input.connect(_on_mobile_steer_input)

func _on_mobile_accelerate_pressed():
	is_accelerating = true

func _on_mobile_accelerate_released():
	is_accelerating = false

func _on_mobile_brake_pressed():
	is_braking = true

func _on_mobile_brake_released():
	is_braking = false

func _on_mobile_drift_pressed():
	is_drifting = true

func _on_mobile_drift_released():
	is_drifting = false

func _on_mobile_steer_input(value: float):
	mobile_steer_value = value

func _physics_process(delta):
	var speed = linear_velocity.length()*Engine.get_frames_per_second()*delta
	traction(speed)
	$Hud/speed.text=str(round(speed*3.8))+"  KMPH"

	var fwd_mps = transform.basis.x.x
	
	# Handle steering (mobile takes priority if active, otherwise use keyboard)
	if mobile_controls and (abs(mobile_steer_value) > 0.1 or is_accelerating or is_braking or is_drifting):
		steer_target = mobile_steer_value * STEER_LIMIT
	else:
		steer_target = Input.get_action_strength("ui_left") - Input.get_action_strength("ui_right")
		steer_target *= STEER_LIMIT
	
	# Handle acceleration/braking (mobile takes priority if active)
	var should_reverse = false
	var should_accelerate = false
	
	if mobile_controls and (is_braking or is_accelerating):
		should_reverse = is_braking
		should_accelerate = is_accelerating
	else:
		should_reverse = Input.is_action_pressed("ui_down")
		should_accelerate = Input.is_action_pressed("ui_up")
	
	if should_reverse:
	# Increase engine force at low speeds to make the initial acceleration faster.

		if speed < 20 and speed != 0:
			engine_force = clamp(engine_force_value * 3 / speed, 0, 300)
		else:
			engine_force = engine_force_value
	else:
		engine_force = 0
		
	if should_accelerate:
		# Increase engine force at low speeds to make the initial acceleration faster.
		if fwd_mps >= -1:
			if speed < 30 and speed != 0:
				engine_force = -clamp(engine_force_value * 10 / speed, 0, 300)
			else:
				engine_force = -engine_force_value
		else:
			brake = 1
	else:
		brake = 0.0
	
	# Handle drift (mobile takes priority if active)
	var should_drift = false
	if mobile_controls and is_drifting:
		should_drift = is_drifting
	else:
		should_drift = Input.is_action_pressed("ui_select")
		
	if should_drift:
		brake=3
		$wheal2.wheel_friction_slip=0.8
		$wheal3.wheel_friction_slip=0.8
	else:
		$wheal2.wheel_friction_slip=3
		$wheal3.wheel_friction_slip=3
	steering = move_toward(steering, steer_target, STEER_SPEED * delta)



func traction(speed):
	apply_central_force(Vector3.DOWN*speed)




