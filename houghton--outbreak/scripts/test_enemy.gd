extends CharacterBody3D

#const TURNING_SPEED = 0.0325
#const GRAVITY_CONSTANT = 100
const ATTACK_RANGE = 2.0

@export var max_health = 50
var health: int

var player = null
var state_machine

const FORWARD_SPEED = 3

@export var player_path : NodePath

@onready var nav_agent = $NavigationAgent3D

func _ready():
	player = get_node(player_path)
	health = max_health
	state_machine = animtree.get("parameters/playback")
#func _physics_process(delta: float) -> void:

func _process(delta):
	velocity = Vector3.ZERO
	
	match state_machine.get_current_node():
		"walk":
			#navigation
			nav_agent.set_target_position(player.global_transform.origin)
			var next_nav_point = nav_agent.get_next_path_position()
			velocity = (next_nav_point - global_transform.origin).normalized() * FORWARD_SPEED
			look_at(Vector3(global_position.x + velocity.x, global_position.y, global_position.z + velocity.z), Vector3.UP)
		"attack":
			look_at(Vector3(player.global_position.x, global_position.y, player.global_position.z), Vector3.UP)
	
<<<<<<< Updated upstream
	look_at(Vector3(player.global_position.x, global_position.y, player.global_position.z), Vector3.UP)
=======
	#conditions
	animtree.set("parameters/conditions/attack_player", _target_in_range())
	animtree.set("parameters/conditions/run", !_target_in_range())
	
	animtree.get("parameters/playback")
>>>>>>> Stashed changes
	
	move_and_slide()
	
	death()

func _target_in_range():
	return global_position.distance_to(player.global_position) < ATTACK_RANGE

func _on_test_player_player_hit() -> void:
	pass # Replace with function body.

func death():
	if health <= 0:
		queue_free()
