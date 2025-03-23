extends Control


@onready var icon = $InnerBorder/ItemIcon
@onready var quantity_label = $InnerBorder/ItemQuantity

@onready var details_panel = $DetailsPanel
@onready var item_name = $DetailsPanel/ItemName
@onready var item_type = $DetailsPanel/ItemType
@onready var item_effect = $DetailsPanel/ItemEffect

@onready var usage_panel = $UsagePanel

@onready var item_button = $ItemButton

#Slot Item
var item = null

func _process(delta: float) -> void:
	mouse_distance()


func _on_item_button_pressed() -> void:
	if item != null:
		if item["name"] == InventoryManager.player_node.equipped:
			usage_panel.get_node("UseButton").text = "Unequip"
		elif item["type"] == "Weapons":
			usage_panel.get_node("UseButton").text = "Equip"
		else:
			usage_panel.get_node("UseButton").text = "Use"
		usage_panel.visible = !usage_panel.visible


func _on_item_button_mouse_entered() -> void:
	if item != null:
		usage_panel.visible = false
		details_panel.visible = true


func _on_item_button_mouse_exited() -> void:
	details_panel.visible = false

func set_empty():
	icon.texture = null
	quantity_label.text = ""
	item_button.disabled = true

func set_item(new_item):
	item_button.disabled = false
	item = new_item
	icon.texture = new_item["texture"]
	quantity_label.text = str(item["quantity"])
	item_name.text = str(item["name"])
	item_type.text = str(item["type"])
	if item["effect"] != "":
		item_effect.text = str(" + ", item["effect"])
	else:
		item_effect.text = ""
	

func _on_use_button_pressed() -> void:
	usage_panel.visible = false
	details_panel.visible = false
	
	if item["name"] == "Medkit":
		InventoryManager.player_node.increment_health(50)
		InventoryManager.remove_item("Consumable", "Medkit", 1)
	
	if item["name"] == "Pistol":
		if InventoryManager.player_node.equipped == "Pistol":
			InventoryManager.player_node.unequip("Pistol")
		else:
			InventoryManager.player_node.unequip("Pistol")
			InventoryManager.player_node.equip("Pistol")
	
	if item["name"] == "Grenade":
		if InventoryManager.player_node.equipped == "Grenade":
			InventoryManager.player_node.unequip("Grenade")
		else:
			InventoryManager.player_node.unequip("Grenade")
			InventoryManager.player_node.equip("Grenade")
	
	if item["name"] == "Knife":
		if InventoryManager.player_node.equipped == "Knife":
			InventoryManager.player_node.unequip("Knife")
		else:
			InventoryManager.player_node.unequip("Knife")
			InventoryManager.player_node.equip("Knife")


func _on_discard_button_pressed() -> void:
	usage_panel.visible = false
	details_panel.visible = false
	if item["name"] != "Pistol" and item["name"] != "Knife":
		InventoryManager.remove_item(item["type"], item["name"], item["quantity"])


func mouse_distance():
	var mouse_position = get_global_mouse_position()
	var node_position = $PanelMarker.global_position
	var icon_position = $IconMarker.global_position
	
	var distance1 = mouse_position.distance_to(node_position)
	var distance2 = mouse_position.distance_to(icon_position)
	
	if distance1 > 155 && distance2 > 200:
		usage_panel.visible = false
	
