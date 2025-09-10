extends Control

# Mobile touch controls for car game
signal accelerate_pressed
signal accelerate_released
signal brake_pressed
signal brake_released
signal drift_pressed
signal drift_released
signal steer_input(value: float)

@onready var joystick_area = $VirtualJoystick/TouchArea
@onready var joystick_knob = $VirtualJoystick/Knob
@onready var accelerate_button = $AccelerateButton
@onready var brake_button = $BrakeButton
@onready var drift_button = $DriftButton

var joystick_center: Vector2
var joystick_radius: float = 100.0
var is_joystick_pressed = false
var current_steer_value = 0.0


func _ready():
	# Setup joystick
	joystick_center = joystick_area.global_position + joystick_area.size / 2

	# Connect button signals
	accelerate_button.pressed.connect(_on_accelerate_pressed)
	accelerate_button.released.connect(_on_accelerate_released)
	brake_button.pressed.connect(_on_brake_pressed)
	brake_button.released.connect(_on_brake_released)
	drift_button.pressed.connect(_on_drift_pressed)
	drift_button.released.connect(_on_drift_released)

	# Connect joystick touch events
	joystick_area.gui_input.connect(_on_joystick_input)


func _on_joystick_input(event: InputEvent):
	if event is InputEventScreenTouch:
		if event.pressed:
			is_joystick_pressed = true
			joystick_center = joystick_area.global_position + joystick_area.size / 2
		else:
			is_joystick_pressed = false
			_reset_joystick()

	elif event is InputEventScreenDrag and is_joystick_pressed:
		_update_joystick(event.position)


func _update_joystick(touch_position: Vector2):
	var local_pos = touch_position - joystick_center
	var distance = local_pos.length()

	if distance > joystick_radius:
		local_pos = local_pos.normalized() * joystick_radius
		distance = joystick_radius

	# Update knob position
	joystick_knob.position = joystick_area.size / 2 + local_pos

	# Calculate steering value (-1 to 1)
	current_steer_value = local_pos.x / joystick_radius
	steer_input.emit(current_steer_value)


func _reset_joystick():
	# Reset knob to center
	joystick_knob.position = joystick_area.size / 2
	current_steer_value = 0.0
	steer_input.emit(0.0)


func _on_accelerate_pressed():
	accelerate_pressed.emit()


func _on_accelerate_released():
	accelerate_released.emit()


func _on_brake_pressed():
	brake_pressed.emit()


func _on_brake_released():
	brake_released.emit()


func _on_drift_pressed():
	drift_pressed.emit()


func _on_drift_released():
	drift_released.emit()


# Helper function to check if we're on mobile
func is_mobile_platform() -> bool:
	return OS.get_name() == "Android" or OS.get_name() == "iOS"
