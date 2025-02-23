extends Node3D

@export var enemy: PackedScene
@onready var player = get_tree().get_first_node_in_group("player")
@onready var timer = $Timer

func _on_timer_timeout() -> void:
	var spawn = enemy.instantiate()
	spawn.player = player
	get_parent().add_child(spawn)
	spawn.position = position
	spawn.rotation = rotation
	spawn.walkForward = true
	spawn.walkTimer.start()
	spawn.add_to_group("enemies")
