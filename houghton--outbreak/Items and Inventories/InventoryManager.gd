extends Node

var inventory = []
var inventorySize = 6
var player_node = null

@onready var inventory_slot_scene = preload("res://Items and Inventories/Inventory_Slot.tscn")

signal inventory_updated

func _ready():
	inventory.resize(inventorySize)


func add_item(item):
	for i in range(inventory.size()):
		if inventory[i] != null and inventory[i]["type"]  == item["type"] and inventory[i]["name"] == item["name"]:
			inventory[i]["quantity"] = str(int(inventory[i]["quantity"]) + int(item["quantity"]))
			inventory_updated.emit()
			return true
		elif inventory[i] == null:
			inventory[i] = item
			inventory_updated.emit()
			return true
		
	


func remove_item(item_type, item_name, quantity):
	for i in range(inventory.size()):
		if inventory[i] != null and inventory[i]["type"]  == item_type and inventory[i]["name"] == item_name:
			inventory[i]["quantity"] = str(int(inventory[i]["quantity"]) - quantity)
			if int(inventory[i]["quantity"]) < 0:
				inventory[i] = null
			inventory_updated.emit()
			return true
	return false


func increase_inventory_size():
	inventory_updated.emit()


func set_player_reference(player):
	player_node = player
