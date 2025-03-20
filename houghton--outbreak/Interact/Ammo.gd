extends Interactable


func _on_interacted(body: Variant) -> void:
	get_node("CollisionShape3D").disabled = true
	body.increment_ammo()
	$"%AudioStreamPlayer3D".play()
	visible = false
	$InventoryItem.pickup_item()
