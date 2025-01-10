extends Label

var health = 100
var dmgTaken = 20
var healthHealed = 35

#var player_hit = test_area.

func _process(delta):
	var hp = "%d hp" % [health]
	text = hp

func hit(health, dmgTaken):
	health -= dmgTaken

func _on_test_player_player_hit() -> void:
	health += healthHealed
