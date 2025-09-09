extends Area3D

var player_nearby = false
var door_label: Label3D

func _ready():
	body_entered.connect(_on_body_entered)
	body_exited.connect(_on_body_exited)
	door_label = $DoorLabel

func _on_body_entered(body):
	if body.name == "car":
		player_nearby = true
		if door_label:
			door_label.modulate = Color.YELLOW

func _on_body_exited(body):
	if body.name == "car":
		player_nearby = false
		if door_label:
			door_label.modulate = Color.WHITE

func _physics_process(_delta):
	if player_nearby and (Input.is_action_just_pressed("ui_accept") or Input.is_key_pressed(KEY_E)):
		_enter_race_course()

func _enter_race_course():
	get_tree().change_scene_to_file("res://RaceCourse.tscn")