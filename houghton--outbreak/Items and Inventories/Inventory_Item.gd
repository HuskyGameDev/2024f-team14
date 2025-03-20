@tool
extends Node2D


@export var item_type = ""
@export var item_name = ""
@export var item_texture: Texture
@export var item_effect = ""
@export var item_quantity = 0
var scene_path = "res://Items and Inventories/Inventory_Item.tscn"

@onready var icon_sprite = $Sprite2D


func _ready():
	if not Engine.is_editor_hint():
		icon_sprite.texture = item_texture

func _process(delta: float) -> void:
	if Engine.is_editor_hint():
		icon_sprite.texture = item_texture

func pickup_item():
	var item = {
		"quantity": item_quantity,
		"type": item_type,
		"name": item_name,
		"effect": item_effect,
		"texture": item_texture,
		"scene_path": scene_path
	}
	
	if InventoryManager.player_node:
		InventoryManager.add_item(item)
		
