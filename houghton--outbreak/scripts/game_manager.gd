extends Node

enum {PLAY = 0, PAUSE = 1, MENU = -1}
var STATE = PLAY
@export var debugLog = true




func _on_inventory_ui_pause_signal() -> void:
	STATE = PAUSE
	get_tree().paused = true;


func _on_inventory_ui_resume_signal() -> void:
	STATE = PLAY
	get_tree().paused = false;
