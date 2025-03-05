extends Button

@onready var Controls = get_tree().get_first_node_in_group("ControlsGroup")


func _on_pressed() -> void:
	Controls.visible = true
