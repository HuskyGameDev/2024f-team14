extends RayCast3D
@onready var laser = $LaserSight


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var contactPoint
	force_raycast_update()
	if is_colliding():
		contactPoint = to_global(get_collision_point())
		
		laser.mesh.height = contactPoint.z
		laser.position.z = -contactPoint.z/2
