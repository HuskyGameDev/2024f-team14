extends CharacterBody3D
 
@export var invenItems: inventory


const FORWARD_SPEED = 7.5
const BACKWARD_SPEED = 5
const TURNING_SPEED = 0.035
const GRAVITY_CONSTANT = 100
@export var turning_sensitivity: float = 1.0

var input = Vector3.ZERO

signal player_hit

func _ready() -> void:
	pass

func _physics_process(delta: float) -> void:
	character_movement(delta)

func character_movement(delta: float):
	# Apply gravity to y-component of velocity
	velocity.y -= delta * GRAVITY_CONSTANT
	
	# If the forward input is pressed and the backwards one isn't
	if Input.is_action_pressed("move_forwards") and !Input.is_action_pressed("move_backwards"):
		var forwardVector = Vector3.FORWARD.rotated(Vector3.UP, rotation.y)
		velocity.x = forwardVector.x * FORWARD_SPEED
		velocity.z = forwardVector.z * FORWARD_SPEED
	
	#If the forward input is pressed and the backwards one isn't
	elif Input.is_action_pressed("move_backwards") and !Input.is_action_pressed("move_forwards"):
		var backwardVector = -Vector3.FORWARD.rotated(Vector3.UP, rotation.y)
		velocity.x = backwardVector.x * BACKWARD_SPEED
		velocity.z = backwardVector.z * BACKWARD_SPEED
	
	#If niether or both inputs are hit, set velocity to zero
	else:
		velocity.x = 0
		velocity.z = 0
	
	#Handles turning
	if Input.is_action_pressed("turn_left"):
		rotation.y += input.y + TURNING_SPEED * turning_sensitivity
		
	if Input.is_action_pressed("turn_right"):
		rotation.y -= input.y + TURNING_SPEED * turning_sensitivity
		
	move_and_slide()

func hit():
	emit_signal("player_hit")
