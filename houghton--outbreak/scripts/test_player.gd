extends CharacterBody3D
var DEBUG = false

@export var invenItems: inventory
@onready var animtree = $AnimationTree
@onready var states = animtree["parameters/playback"]

const FORWARD_SPEED = 4.5
const BACKWARD_SPEED = 4.5
const TURNING_SPEED = 0.035
const GRAVITY_CONSTANT = 100
@export var turning_sensitivity: float = 1.0
var input = Vector3.ZERO

var MAX_HEALTH: int = 100
var current_health:int

signal player_hit

func _ready() -> void:
	#Will initially grant max health to the player
	current_health = MAX_HEALTH

func _physics_process(delta: float) -> void:
	#Applies gravity if necissary
	if not is_on_floor():
		velocity.y -= GRAVITY_CONSTANT*delta
	
	#Gets movement inputs
	character_movement(delta)

func character_movement(delta: float):
	var current_y_velocity = velocity.y
	
	if Input.is_action_pressed("move_forwards") and Input.is_action_pressed("move_backwards"):
		velocity.x = 0
		velocity.z = 0

	elif Input.is_action_pressed("move_forwards"):
		var forwardVector = -Vector3.FORWARD.rotated(Vector3.UP, rotation.y)
		velocity = -forwardVector * FORWARD_SPEED
		if(DEBUG):
			states.travel("walkNoGun")
		else:
			states.travel("walkGun")
		
	elif Input.is_action_pressed("move_backwards"):
		var backwardVector = Vector3.FORWARD.rotated(Vector3.UP, rotation.y)
		velocity = -backwardVector * BACKWARD_SPEED
		if(DEBUG):
			states.travel("walkNoGunBackwards")
		else:
			states.travel("walkGunBackwards")
	elif Input.is_action_pressed("aim"):
		velocity.x = 0
		velocity.z = 0
		states.travel("PistolActionAim")
		if Input.is_action_pressed("attack_or_shoot"):
			states.travel("pistolActionShootTimer")
	else:
		velocity.x = 0
		velocity.z = 0
		states.travel("idlepose")
	
	velocity.y = current_y_velocity
	
	
	# If moving back while turning left, turn right
	if Input.is_action_pressed("turn_left") and Input.is_action_pressed("move_backwards"):
		rotation.y -= input.y + TURNING_SPEED *turning_sensitivity
		velocity.y -= delta*GRAVITY_CONSTANT
	
	elif Input.is_action_pressed("turn_left"):
		rotation.y += input.y + TURNING_SPEED *turning_sensitivity
		velocity.y -= delta*GRAVITY_CONSTANT

	# If moving back while turning right, turn left
	if Input.is_action_pressed("turn_right") and Input.is_action_pressed("move_backwards"):
		rotation.y += input.y + TURNING_SPEED *turning_sensitivity
		velocity.y -= delta*GRAVITY_CONSTANT
		
	elif Input.is_action_pressed("turn_right"):
		rotation.y -= input.y + TURNING_SPEED *turning_sensitivity
		velocity.y -= delta*GRAVITY_CONSTANT
	
	move_and_slide()

func hit():
	emit_signal("player_hit")
