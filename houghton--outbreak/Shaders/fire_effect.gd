extends Node3D

var sizzling = false

func _on_timer_timeout() -> void:
	var overlaps = $Hitbox.get_overlapping_bodies()
	if overlaps.size() > 0:
		for overlap in overlaps:
			if overlap.name == "Player":
				if sizzling:
					$FireSizzle.play()
					sizzling = false
				overlap.hit(1)


func _on_hitbox_body_entered(body: Node3D) -> void:
	if body.name == "Player":
		sizzling = true


func _on_hitbox_body_exited(body: Node3D) -> void:
	if body.name == "Player":
		sizzling = false
