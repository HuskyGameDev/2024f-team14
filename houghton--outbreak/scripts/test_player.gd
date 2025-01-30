extends CharacterBody3D
var DEBUG = false

@export var invenItems: inventory
@onready var animtree = $AnimationTree
@onready var states = animtree["parameters/playback"]

@onready var pistol = $"PM 10-31-24/Armature/Skeleton3D/BoneAttachment3D/pistol"
var current_ammo: int
var reserve_ammo: int

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
	var current_ammo = pistol.current_ammo
	var reserve_ammo = pistol.reserve_ammo
	
	if Input.is_action_pressed("move_forwards") and Input.is_action_pressed("move_backwards"):
		velocity.x = 0
		velocity.z = 0

	elif Input.is_action_pressed("move_forwards"):
		var forwardVector = -Vector3.FORWARD.rotated(Vector3.UP, rotation.y)
		velocity = -forwardVector * FORWARD_SPEED
		
		if (Input.is_action_pressed("Sprint")):
			velocity *= 1.5
		
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
		if Input.is_action_pressed("attack_or_shoot") && current_ammo != 0:
			states.travel("pistolActionShootTimer")
		
		if Input.is_action_just_pressed("Target"):
			var nearest = get_nearest_enemy()
			
			#rotate_to(delta, nearest, 0.5)
			
			#await get_tree().create_timer(1).timeout
			look_at(nearest.global_position)
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

#Returns enemy closest to the player when called.
func get_nearest_enemy():
	var enemies = get_tree().get_nodes_in_group("enemies")
	var nearest = enemies[0]
	
	for enemy in enemies:
		if enemy.global_position.distance_to(global_position) < nearest.global_position.distance_to(global_position):
			nearest = enemy
	
	return nearest

func rotate_to(delta, object, time):
	var pos = Vector2(global_position.x, global_position.z)
	var objectPos = Vector2(object.global_position.x, object.global_position.z)
	var direction = (pos - objectPos)
	rotation.y = lerp_angle(rotation.y, atan2(direction.x, direction.y), delta / time)

func increment_ammo():
	pistol.reserve_ammo += 12

func hit():
	emit_signal("player_hit")
