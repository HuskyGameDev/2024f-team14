extends Node

enum {PLAY = 0, PAUSE = 1, MENU = -1}
var STATE = PLAY
@export var debugLog = true

var maxEnemies = 5
var totalEnemies = 0
var spawns = true

var waveCount = 1
var waveLock = 0 #false by default
var waveMax = 1
var wave = 1 #based on each number of waves there are

var pauseReason = ""

func _ready() -> void:
	totalEnemies = get_tree().get_node_count_in_group("enemies")
	

func _process(_delta: float) -> void:
	totalEnemies = 0
	for enemy in get_tree().get_nodes_in_group("enemies"):
		if !enemy.dead:
			totalEnemies += 1
			
			
	if waveLock == 0 and waveCount <= 0:
			print("Wave complete")
			
			waveLock = 1
			
			spawns = false
			
			if wave == 2:
				await get_tree().create_timer(8).timeout
			elif wave == 3:
				await get_tree().create_timer(6).timeout
			elif wave == 4:
				await get_tree().create_timer(4).timeout
			elif wave == 5:
				await get_tree().create_timer(2).timeout
			elif wave == 6:
				await get_tree().create_timer(1).timeout #final time between waves
			else:
				await get_tree().create_timer(10).timeout
			
			print("continuing...")
			
			waveCheck()
			
			
func waveCheck():
	print("resetting...")
	spawns = true
	waveLock = 0
	
	waveMax += 1
	waveCount = waveMax
	
	wave += 1
	
	print(waveMax)


func pause(reason: String = ""):
	STATE = PAUSE
	pauseReason = reason
	get_tree().paused = true


func resume():
	STATE = PLAY
	get_tree().paused = false
