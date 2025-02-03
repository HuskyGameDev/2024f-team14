extends CharacterBody3D

#const TURNING_SPEED = 0.0325
#const GRAVITY_CONSTANT = 100

@export var max_health = 50
var health: int

var player = null

const FORWARD_SPEED = 3
const ATTACK_RANGE = 2

@export var player_path : NodePath

@onready var nav_agent = $NavigationAgent3D

@onready var animtree = $AnimationTree
@onready var states = animtree["parameters/playback"]
@onready var groanSFX = $GroanSFX
@onready var groanTimer = $GroanTimer
@onready var hurtSFX = $HurtSFX

func _ready():
	player = get_node(player_path)
	health = max_health
	groanTimer.start(randi_range(randi_range(3,7), randi_range(15,30)))


#func _physics_process(delta: float) -> void:

func _process(delta):
	velocity = Vector3.ZERO
	
	#navigation
	nav_agent.set_target_position(player.global_transform.origin)
	var next_nav_point = nav_agent.get_next_path_position()
	velocity = (next_nav_point - global_transform.origin).normalized() * FORWARD_SPEED
	look_at(Vector3(player.global_position.x, global_position.y, player.global_position.z), Vector3.UP)
	
	#conditions
	animtree.set("parameters/conditions/attack", _target_in_range())
	move_and_slide()


func _on_test_player_player_hit() -> void:
	pass # Replace with function body.

func death():
	queue_free()
	

func playHurtSFX():
	hurtSFX.play()

func _target_in_range():
	return global_position.distance_to(player.global_position) < ATTACK_RANGE
	

func _on_groan_timer_timeout() -> void:
	groanSFX.play()
	groanTimer.start(randi_range(randi_range(9,14), randi_range(27,33)))
