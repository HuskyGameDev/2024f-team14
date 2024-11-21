extends Node3D

@export var damage: int = 10
@export var max_reserve_ammo: int = 128
@export var mag_size: int = 8
@export var reload_time: float = 2.0
@export var shoot_delay: float = 0.5

var current_ammo: int
var reserve_ammo: int

var can_fire: bool = true
var is_reloading: bool = false

@onready var shoot_timer: Timer = $shoot_timer
@onready var reload_timer: Timer = $reload_timer
@onready var animtree = $AnimationTree
@onready var states = animtree["parameters/playback"]

func _ready() -> void:
	current_ammo = mag_size
	reserve_ammo = max_reserve_ammo
	
	shoot_timer.wait_time = shoot_delay
	shoot_timer.one_shot = true
	
	reload_timer.wait_time = reload_time
	reload_timer.one_shot = true
	
	shoot_timer.timeout.connect(_on_shoot_delay_complete)
	reload_timer.timeout.connect(_on_reload_complete)
	
func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("attack_or_shoot") and can_fire and !is_reloading:
		shoot()
	if Input.is_action_just_pressed("reload") and !is_reloading:
		reload()

func can_shoot():
	return current_ammo > 0 && Input.is_action_pressed("aim")
func can_reload():
	current_ammo < mag_size and reserve_ammo > 0

@onready var ray_cast_3d: RayCast3D = $RayCast3D


func shoot():
	if can_shoot():
		current_ammo -= 1
		print("current ammo: ", current_ammo, " reserve ammo: ", reserve_ammo)
		can_fire = false
		shoot_timer.start()
		$pistol_model/Sphere.show() 
		states.travel("muzzle_flash")
		if ray_cast_3d.is_colliding():
			var target = ray_cast_3d.get_collider()
			if target != null and target.is_in_group("enemies"):
				target.health -= damage
		
	
func reload():
	if can_reload:
		is_reloading = true
		reload_timer.start()
	

func _on_reload_complete():
	var loaded_ammo = mag_size - current_ammo
	current_ammo += loaded_ammo
	reserve_ammo -= loaded_ammo
	is_reloading = false
	
func _on_shoot_delay_complete():
	can_fire = true
	$pistol_model/Sphere.hide()
	states.travel("idle")
