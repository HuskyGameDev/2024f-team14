extends Control

@onready var invent1: inventory = preload("res://Items and Inventories/PlayerInventory.tres")
@onready var invSlots: Array = $NinePatchRect/GridContainer.get_children()
@onready var invButtons: Array = $NinePatchRect/GridContainer.get_children()



signal pauseSignal
signal resumeSignal

func _ready():
	update_slots()
	close()
	
func update_slots():
	for i in range(min(invent1.inven.size(), invSlots.size())):
		invSlots[i].update(invent1.inven[i])
		
		
func move_children():
	for i in range(min(invent1.inven.size(), invSlots.size())):
		invButtons[i].move_child(invButtons[i].get_children(), -10)

#func equip_items():
	

func _process(_delta):
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


func _on_button_pressed() -> void:
	print("item equipped!")


func _on_button_2_pressed() -> void:
	print("item equipped!")
