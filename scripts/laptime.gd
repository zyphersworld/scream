extends Label

# Declare member variables here. Examples:
var time = 0
var timer_on = true

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func resetLap():
	print(time)
	time = 0;
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if(timer_on):
		time += delta
		var mils = fmod(time,1)*1000
		var secs = fmod(time,60)
		var mins = fmod(time, 60*60) / 60
		var hr = fmod(fmod(time,3600 * 60) / 3600,24)
		var dy = fmod(time,12960000) / 86400
		
		var time_passed = "%02d : %03d" % [secs,mils]
		text = time_passed
		
	else:
		time=0

func _on_checkpoint_body_entered(body):
	resetLap()
