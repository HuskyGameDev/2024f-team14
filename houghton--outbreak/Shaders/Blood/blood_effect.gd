extends Node3D


func explode(type):
	if type == "Bullet":
		$BulletBlood.emitting = true
	elif type == "Explosion":
		$ExplosionBlood.emitting = true
	

func _on_timer_timeout() -> void:
	queue_free()
