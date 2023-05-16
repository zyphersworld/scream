extends Label
var drivers = Globals.drivers
var index =0

func _input(ev):
	if Input.is_key_pressed(KEY_RIGHT):
		index = index+1
	if Input.is_key_pressed(KEY_LEFT):	
		index = index-1
	if index >= drivers.size():index=0
	if index < 0:index=drivers.size()-1
	changeName(index)

# Called when the node enters the scene tree for the first time.
func _ready():
	changeName(index)

func changeName(index):
	text = str(drivers[index].driverName)
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_settings_pressed():
	index = index+1
	if index >= drivers.size():index=0
	changeName(index)
