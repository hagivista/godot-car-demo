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

func _input(event):
	if player_nearby and event.is_action_pressed("ui_accept"):
		_return_to_main()

func _return_to_main():
	get_tree().change_scene_to_file("res://main.tscn")