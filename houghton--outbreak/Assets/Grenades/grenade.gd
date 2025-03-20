extends RigidBody3D

var damage = 50

func _on_body_entered(_body: Node) -> void:
	linear_damp = 0.3
	angular_damp = 1.5

func _on_timer_timeout() -> void:
	$ExplosionEffect.explode()
	$ExplosionSFX.play()
	$CollisionShape3D.disabled = true
	$grenade_lowpoly.visible = false
	
	var bodies = $BlastRadius.get_overlapping_bodies()
	for obj in bodies:
		if obj.is_in_group("enemies") or obj.is_in_group("player"):
			
			var rayParams = PhysicsRayQueryParameters3D.create(global_transform.origin, obj.global_transform.origin)
			rayParams.set_hit_from_inside(true)
			var result = get_world_3d().direct_space_state.intersect_ray(rayParams)
			
			if result.collider.is_in_group("enemies") or result.collider.is_in_group("player"):
				obj.hit(damage)
	
	await get_tree().create_timer(3).timeout
	queue_free()
