extends Area3D

var in_trigger = false

func enter_trigger(body):
	if body.name == "Player":
		in_trigger = true

func exit_trigger(body):
	if body.name == "Player":
		in_trigger = false

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	if in_trigger and get_parent().current != true:
		get_parent().current = true
