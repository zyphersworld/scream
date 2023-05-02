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
	changeNumber(index)
# Called when the node enters the scene tree for the first time.
func _ready():
	changeNumber(index)
func changeNumber(index):
	text = str(drivers[index].prefix) + str(drivers[index].number)
	var numberCol = Color(drivers[index].colors[1])
	var outline = Color(drivers[index].colors[0])
	set("custom_colors/font_color", numberCol)
	set("custom_colors/font_outline_modulate", outline)
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func _on_settings_pressed():
	index = index+1
	if index >= drivers.size():index=0
	changeNumber(index)
