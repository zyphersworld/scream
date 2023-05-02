extends TextureRect
var drivers = Globals.drivers
var index =0

func _ready():
	updateColors(index)

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func _input(ev):
	if Input.is_key_pressed(KEY_RIGHT):
		index = index+1
	if Input.is_key_pressed(KEY_LEFT):	
		index = index-1
	if index >= drivers.size():index=0
	if index < 0:index=drivers.size()-1
	updateColors(index)

func updateColors(index):
	texture = Globals.updateColors(index)

func _on_settings_pressed():
	index = index+1
	if index >= drivers.size():index=0
	updateColors(index)	
