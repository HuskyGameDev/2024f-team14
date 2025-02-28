extends CharacterBody3D

#const TURNING_SPEED = 0.0325
#const GRAVITY_CONSTANT = 100

var bloodEffect = preload("res://Shaders/Blood/Blood_Effect.tscn")

@export var max_health = 50
@export var spawn_pos = Vector3(100, 100, 100)
var health: int

const FORWARD_SPEED = 3
const ATTACK_RANGE = 2.2

@onready var nav_agent = $NavigationAgent3D

@onready var animtree = $AnimationTree
@onready var states = animtree["parameters/playback"]
@onready var groanSFX = $GroanSFX
@onready var groanTimer = $GroanTimer
@onready var hurtSFX = $HurtSFX
@onready var deathSFX = $DeathSFX
@onready var walkTimer = $WalkTimer

var chasing = false
var keepChasing = false
var hasPast = false
var walkForward = false
var playerOriginalPosition = null

var dead = false

@export var player = null


func _ready():
	player = get_tree().get_first_node_in_group("player")
	health = max_health
	groanTimer.start(randi_range(randi_range(3,7), randi_range(15,30)))


#func _physics_process(delta: float) -> void:

func _process(_delta):
	
	if dead:
		return
	
	update_animation_parameters()
	
	if chasing:
	
		$VisionRaycast.debug_shape_custom_color = Color(0,255,0)
		velocity = Vector3.ZERO
		#navigation
		#nav_agent.set_target_position(player.global_transform.origin)
		#var next_nav_point = nav_agent.get_next_path_position()
		#velocity = (next_nav_point - global_transform.origin).normalized() * FORWARD_SPEED
		look_at(Vector3(player.global_position.x, global_position.y, player.global_position.z), Vector3.UP)
		var move_direction = -global_transform.basis.z.normalized()
		velocity = move_direction * FORWARD_SPEED
		move_and_slide()
		
	elif keepChasing:
		
		$VisionRaycast.debug_shape_custom_color = Color(0,255,0)
		#velocity = Vector3.ZERO
		#navigation
		var distance_vector = global_position - playerOriginalPosition
		if distance_vector.length() > 0.5 and !hasPast:
			#nav_agent.set_target_position(playerOriginalPosition)
			#var next_nav_point = nav_agent.get_next_path_position()
			#velocity = (next_nav_point - global_transform.origin).normalized() * FORWARD_SPEED
			look_at(Vector3(playerOriginalPosition.x, playerOriginalPosition.y, playerOriginalPosition.z), Vector3.UP)
			var move_direction = -global_transform.basis.z.normalized()
			velocity = move_direction * FORWARD_SPEED
			distance_vector = global_position - playerOriginalPosition
			if distance_vector.length() > 0.5:
				look_at(Vector3(global_position.x + velocity.x, playerOriginalPosition.y, global_position.z + velocity.z), Vector3.UP)
		
		else:
			hasPast = true
			velocity = Vector3(velocity.x, velocity.y, velocity.z).normalized() * FORWARD_SPEED
			if velocity != Vector3.ZERO:
				look_at(Vector3(global_position.x + velocity.x, playerOriginalPosition.y, global_position.z + velocity.z), Vector3.UP)
			
		move_and_slide()
		
	elif walkForward:
		
		$VisionRaycast.debug_shape_custom_color = Color(0,255,0)
		var move_direction = -global_transform.basis.z.normalized()
		velocity = move_direction * FORWARD_SPEED
		move_and_slide()
		
	else:
		velocity = Vector3.ZERO
		$VisionRaycast.debug_shape_custom_color = Color(174,0,0)
		move_and_slide()


func update_animation_parameters():
	if chasing:
		animtree["parameters/conditions/chasing"] = true
		animtree["parameters/conditions/idle"] = false
		
		if _target_in_range():
			animtree["parameters/conditions/attack"] = true
		else:
			animtree["parameters/conditions/attack"] = false

		
	elif keepChasing or walkForward:
		animtree["parameters/conditions/chasing"] = true
		animtree["parameters/conditions/idle"] = false
		
		if _target_in_range():
			animtree["parameters/conditions/attack"] = true
		else:
			animtree["parameters/conditions/attack"] = false
			
	else:
		animtree["parameters/conditions/chasing"] = false
		animtree["parameters/conditions/idle"] = true
	

func hitPlayer():
	if _target_in_range() and !dead:
		player.hit(10)

func _on_test_player_player_hit() -> void:
	pass # Replace with function body.

func death():
	dead = true
	var bloodInstance = bloodEffect.instantiate()
	bloodInstance.position = $BloodPos.global_position
	get_tree().current_scene.add_child(bloodInstance)
	bloodInstance.explode("Explosion")
	$Hurtbox.disabled = true
	$EnemyModel1.visible = false
	await get_tree().create_timer(3).timeout
	queue_free()

func hit(damage):
	health -= damage
	if health <= 0:
		death()
		deathSFX.play()
	else:
		var bloodInstance = bloodEffect.instantiate()
		bloodInstance.position = $BloodPos.global_position
		bloodInstance.rotation = rotation
		get_tree().current_scene.add_child(bloodInstance)
		
		bloodInstance.explode("Bullet")
		hurtSFX.play()


func _target_in_range():
	return global_position.distance_to(player.global_position) < ATTACK_RANGE
	


func setChasing(boolean):
	var original = chasing
	chasing = boolean
	if original != chasing:
		$WalkTimer.start()
		playerOriginalPosition = player.global_position
		keepChasing = true
		

func _on_groan_timer_timeout() -> void:
	if !dead:
		groanSFX.play()
		groanTimer.start(randi_range(randi_range(9,14), randi_range(27,33)))

func _on_vision_timer_timeout() -> void:
	chasing = false
	var overlaps = $VisionArea.get_overlapping_bodies()
	if overlaps.size() > 0:
		for overlap in overlaps:
			if overlap.name == "Player":
				var playerPosition = overlap.global_transform.origin
				$VisionRaycast.look_at(playerPosition + Vector3(0, 3.2, 0), Vector3.UP)
				$VisionRaycast.force_raycast_update()
				
				if $VisionRaycast.is_colliding():
					var collider = $VisionRaycast.get_collider()
					
					if collider.name == "Player":
						setChasing(true)
					
					else:
						setChasing(false)


func _on_keep_chasing_timer_timeout() -> void:
	keepChasing = false
	hasPast = false
	walkForward = false
