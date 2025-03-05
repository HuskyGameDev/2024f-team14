extends Node

enum {PLAY = 0, PAUSE = 1, MENU = -1}
var STATE = PLAY
@export var debugLog = true

var maxEnemies = 5
var totalEnemies = 0
var spawns = true


func _ready() -> void:
	totalEnemies = get_tree().get_node_count_in_group("enemies")


func _process(_delta: float) -> void:
	totalEnemies = 0
	for enemy in get_tree().get_nodes_in_group("enemies"):
		if !enemy.dead:
			totalEnemies += 1


func _on_inventory_ui_pause_signal() -> void:
	STATE = PAUSE
	get_tree().paused = true;


func _on_inventory_ui_resume_signal() -> void:
	STATE = PLAY
	get_tree().paused = false;
