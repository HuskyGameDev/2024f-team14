extends Node3D

@export var enemy: PackedScene
@onready var player = get_tree().get_first_node_in_group("player")
@onready var timer = $Timer

func _on_timer_timeout() -> void:
	if GameManager.totalEnemies < GameManager.maxEnemies and GameManager.spawns:
		var spawn = enemy.instantiate()
		spawn.player = player
		spawn.position = position
		spawn.rotation = rotation
		get_parent().add_child(spawn)
		spawn.walkForward = true
		spawn.walkTimer.start()
		spawn.add_to_group("enemies")
			
			
