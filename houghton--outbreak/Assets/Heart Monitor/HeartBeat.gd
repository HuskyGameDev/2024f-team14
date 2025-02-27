extends Line2D
class_name Heartbeat

@export var spacing = 0.001
@export var speed = 5.0
@export var amp = 100.0
@export var change_speed = 1.0

@onready var r_amp = amp
@onready var point = get_tree().get_first_node_in_group("Point")

var time = 0.0


func _process(delta: float) -> void:
	var position1 = global_position + Vector2(points[74].x, points[74].y) + Vector2(845, 0)
	point.position = position1


func _physics_process(delta):
	time += delta
	r_amp = move_toward(r_amp, amp, change_speed * delta)
	for i in points.size():
		var sin_time = time * speed + i
		var t_amp = r_amp + cos(sin_time / 10) * 1.2 + sin(sin_time / 25) * 2
		points[i].y = sin(sin_time) * r_amp / 2 + cos(sin_time / 2) * t_amp
		points[i].x = i * spacing
		if i == points.size() - 1:
			sin_time -= 1
			points[i].y = sin(sin_time) * r_amp / 2 + cos(sin_time / 2) * r_amp
			points[i].x = (i - 0.999) * spacing
		if i == 0:
			sin_time = time * speed + 1
			points[i].y = sin(sin_time) * r_amp / 2 + cos(sin_time / 2 + 1) * r_amp
			points[i].x = 0.999 * spacing

func set_params(new_spacing = spacing, new_speed = speed, new_amp = amp):
	spacing = new_spacing
	speed = new_speed
	amp = new_amp
