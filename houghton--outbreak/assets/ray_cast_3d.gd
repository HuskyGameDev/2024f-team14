extends RayCast3D
@onready var laser = $"Laser Dot"


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	var contactPoint
	force_raycast_update()
	if is_colliding():
		$"Laser Dot".visible = true
		contactPoint = to_local(get_collision_point())
		laser.position.z = contactPoint.z
		laser.position.x = contactPoint.x
		laser.position.y = contactPoint.y
	else:
		$"Laser Dot".visible = false
