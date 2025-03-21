extends Node

enum {PLAY = 0, PAUSE = 1, MENU = -1}
var STATE = PLAY
@export var debugLog = true

var maxEnemies = 5
var totalEnemies = 0
var spawns = true

var pauseReason = ""

func _ready() -> void:
	totalEnemies = get_tree().get_node_count_in_group("enemies")
	

func _process(_delta: float) -> void:
	totalEnemies = 0
	for enemy in get_tree().get_nodes_in_group("enemies"):
		if !enemy.dead:
			totalEnemies += 1


func pause(reason: String = ""):
	STATE = PAUSE
	pauseReason = reason
	get_tree().paused = true


func resume():
	STATE = PLAY
	get_tree().paused = false
