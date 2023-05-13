extends Spatial

var drivers = Globals.drivers
	
func _ready():
	var index = randi()%drivers.size()-1
	if index > drivers.size()-1:index=0		
	
	var wingMaterial = SpatialMaterial.new()
	var bodyMaterial = SpatialMaterial.new()
	var chasisMaterial = SpatialMaterial.new()
	
	wingMaterial.CULL_DISABLED
	bodyMaterial.CULL_DISABLED
	chasisMaterial.CULL_DISABLED
	
	var image = drivers[index].wing
	wingMaterial.albedo_texture = load(image)
	$body1/wings/wing_top.material_override =wingMaterial
	$body1/wings/wing_top_left_sideboard.material_override = wingMaterial
	$body1/wings/wing_top_left.material_override = wingMaterial
	$body1/wings/wing_top_right.material_override = wingMaterial
	$body1/wings/wing_top_right_sideboard.material_override = wingMaterial
	bodyMaterial.albedo_color = drivers[index].colors[0]
	chasisMaterial.albedo_color = drivers[index].colors[1]
	$body1/body.material_override = bodyMaterial
	$body1/chasis.material_override = chasisMaterial
	$body1/tailtank.material_override = bodyMaterial
	$wheels/wheel_rear_right_rim.material_override = bodyMaterial
	$wheels/wheel_rear_left_rim.material_override = bodyMaterial
	$wheels/wheel_front_right_rim.material_override = bodyMaterial
	$wheels/wheel_front_right_rim.material_override = bodyMaterial
	$wheels/wheel_rear_right_hub.material_override = chasisMaterial
	$wheels/wheel_rear_left_hub.material_override = chasisMaterial
	$wheels/wheel_front_right_hub.material_override = chasisMaterial
	$wheels/wheel_front_right_hub.material_override = chasisMaterial
