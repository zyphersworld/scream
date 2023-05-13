extends Resource

class_name DriverData

export(String) var driverName
export(String) var prefix
export(int) var number
export(Array, String) var colors = ["000", "000"]
export(String, FILE) var wing

func getGradients() -> GradientTexture2D:
	
	var gradient_data := {
		0.0: Color(colors[0]),
		0.5: Color(colors[1]),
		0.75: Color(colors[0]),
		1.0: Color(colors[1]),
	}

	var gradient := Gradient.new()
	gradient.offsets = gradient_data.keys()
	gradient.colors = gradient_data.values()

	var gradient_texture := GradientTexture2D.new()
	gradient_texture.gradient = gradient
	
	return gradient_texture
