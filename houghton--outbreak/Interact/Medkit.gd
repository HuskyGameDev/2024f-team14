extends Interactable

func _on_interacted(body: Variant) -> void:
	get_node("CollisionShape3D").disabled = true
	body.increment_health(50)
	$"%AudioStreamPlayer3D".play()
	visible = false
