extends Interactable

func _on_interacted(_body: Variant) -> void:
	get_node("CollisionShape3D").disabled = true
	visible = false
	$InventoryItem.pickup_item()
