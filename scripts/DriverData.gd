extends Resource

class_name DriverData

export(String) var driverName
export(String) var prefix
export(int) var number
export(Array, String) var colors = ["000", "000"]
export(String, FILE) var wing

var gradientTexture:GradientTexture2D setget , getGradientTexture

func getGradientTexture() -> GradientTexture2D:
	
	if (gradientTexture == null):
		
		var gradient_data := {
			0.0: Color(colors[0]),
			0.5: Color(colors[1]),
			0.75: Color(colors[0]),
			1.0: Color(colors[1]),
		}

		var gradient := Gradient.new()
		gradient.offsets = gradient_data.keys()
		gradient.colors = gradient_data.values()

		gradientTexture = GradientTexture2D.new()
		gradientTexture.gradient = gradient
	
	return gradientTexture
