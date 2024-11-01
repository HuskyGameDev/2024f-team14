extends Control

@onready var invent1: inventory = preload("res://Items and Inventories/PlayerInventory.tres")
@onready var invSlots: Array = $NinePatchRect/GridContainer.get_children()


var paused = false

signal pauseSignal
signal resumeSignal

func _ready():
	update_slots()
	close()
	
func update_slots():
	for i in range(min(invent1.inven.size(), invSlots.size())):
		invSlots[i].update(invent1.inven[i])

func _process(delta):
	if Input.is_action_just_pressed("P"):
		if paused:
			close()
			paused = false
			resumeSignal.emit()
		else:
			open()
			paused = true
			pauseSignal.emit()


func open():
	visible = true
	paused = true

func close():
	visible = false
	paused = false
