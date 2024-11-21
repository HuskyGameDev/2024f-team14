extends Label

var time = 0
var time_start = true

func _process(delta):
		if(time_start):
			time += delta
			
			var ms = fmod(time, 1)*1000 # 1000th of a second
			var s = fmod(time, 60) # 60 sec in a min
			var m = time / 60 # 60 sec in a min, 60 sec in an hour
			
			var timer = "%02d : %02d : %03d" % [m, s, ms]
			text = timer
