extends Control

@onready var invent1: inventory = preload("res://Items and Inventories/PlayerInventory.tres")
@onready var invSlots: Array = $NinePatchRect/GridContainer.get_children()



signal pauseSignal
signal resumeSignal

func _ready():
	update_slots()
	close()
	
func update_slots():
	for i in range(min(invent1.inven.size(), invSlots.size())):
		invSlots[i].update(invent1.inven[i])

func _process(delta):
	if Input.is_action_just_released("P"):
		if GameManager.debugLog:
			if GameManager.STATE==GameManager.PAUSE:
				close()
				if GameManager.debugLog: print("emitting resume")
				GameManager.STATE = GameManager.PLAY
				resumeSignal.emit()
			elif GameManager.STATE==GameManager.PLAY:
				open()
				if GameManager.debugLog: print("emitting pause")
				GameManager.STATE = GameManager.PAUSE
				pauseSignal.emit()


func open():
	visible = true

func close():
	visible = false
