extends CharacterBody3D

#const TURNING_SPEED = 0.0325
#const GRAVITY_CONSTANT = 100

@export var max_health = 50
var health: int

var player = null

const FORWARD_SPEED = 3

@export var player_path : NodePath

@onready var nav_agent = $NavigationAgent3D

@onready var animtree = $AnimationTree
@onready var states = animtree["parameters/playback"]

func _ready():
	player = get_node(player_path)
	health = max_health
#func _physics_process(delta: float) -> void:



func _process(delta):
	velocity = Vector3.ZERO
	
	#navigation
	nav_agent.set_target_position(player.global_transform.origin)
	var next_nav_point = nav_agent.get_next_path_position()
	velocity = (next_nav_point - global_transform.origin).normalized() * FORWARD_SPEED
	
	#look_at(Vector3(player.global_position.x, global_position.y, player.global_position.z), Vector3.UP)
	
	move_and_slide()
	
	death()

func _on_test_player_player_hit() -> void:
	pass # Replace with function body.

func death():
	if health <= 0:
		queue_free()
