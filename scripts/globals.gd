extends Node

const DRIVER_DIR = "res://assets/drivers/"

var index =0

var drivers = []

func _ready():
	var dir = Directory.new()
	
	if dir.open(DRIVER_DIR) == OK:
		dir.list_dir_begin()
		var file = dir.get_next()
		
		while file != "":
			if !dir.current_is_dir():
				drivers.append(load(DRIVER_DIR + file) as DriverData)
			
			file = dir.get_next()

func change(index):
	index = index+1
	if index >= drivers.size():index=0

func updateColors(index):

	var gradient_data := {
	0.0: Color(drivers[index].colors[0]),
	0.5: Color(drivers[index].colors[1]),
	0.75: Color(drivers[index].colors[0]),
	1.0: Color(drivers[index].colors[1]),
	}

	var gradient := Gradient.new()
	gradient.offsets = gradient_data.keys()
	gradient.colors = gradient_data.values()

	var gradient_texture := GradientTexture2D.new()
	gradient_texture.gradient = gradient
	return gradient_texture
