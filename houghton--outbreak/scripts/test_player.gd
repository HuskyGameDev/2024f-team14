extends CharacterBody3D
 
const FORWARD_SPEED = 7.5
const BACKWARD_SPEED = 5
const TURNING_SPEED = 0.035

var input = Vector3.ZERO

func _ready() -> void:
	pass

func _physics_process(delta: float) -> void:
	if Input.is_action_pressed("move_forwards") and Input.is_action_pressed("move_backards"):
		velocity.x = 0
		velocity.z = 0

	elif Input.is_action_pressed("move_forwards"):
		var forwardVector = -Vector3.FORWARD.rotated(Vector3.UP, rotation.y)
		velocity = -forwardVector * FORWARD_SPEED
		
	elif Input.is_action_pressed("move_backwards"):
		var backwardVector = Vector3.FORWARD.rotated(Vector3.UP, rotation.y)
		velocity = -backwardVector * BACKWARD_SPEED
	
	else:
		velocity.x = 0
		velocity.z = 0
	
	# If moving back while turning left, turn right
	if Input.is_action_pressed("turn_left") and Input.is_action_pressed("move_backwards"):
		rotation.y -= input.y + TURNING_SPEED 
	
	elif Input.is_action_pressed("turn_left"):
		rotation.y += input.y + TURNING_SPEED 

	# If moving back while turning right, turn left
	if Input.is_action_pressed("turn_right") and Input.is_action_pressed("move_backwards"):
		rotation.y += input.y + TURNING_SPEED 
		
	elif Input.is_action_pressed("turn_right"):
		rotation.y -= input.y + TURNING_SPEED 
	
	move_and_slide()
