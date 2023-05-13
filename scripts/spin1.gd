extends Spatial
onready var index = Globals.index

var drivers = Globals.drivers
func changeSkin(index):
		$body1/wings/wing_top.get_surface_material(0).set("albedo_texture",load(drivers[index].wing))
		$body1/body.get_surface_material(0).set("albedo_color",drivers[index].colors[0])
		$body1/chasis.get_surface_material(0).set("albedo_color",drivers[index].colors[1])
		$body1/tailtank.get_surface_material(0).set("albedo_color",drivers[index].colors[0])
		$wheels/wheel_rear_right_rim.get_surface_material(0).set("albedo_color",drivers[index].colors[0])
		$wheels/wheel_rear_left_rim.get_surface_material(0).set("albedo_color",drivers[index].colors[0])
		$wheels/wheel_front_right_rim.get_surface_material(0).set("albedo_color",drivers[index].colors[0])
		$wheels/wheel_front_right_rim.get_surface_material(0).set("albedo_color",drivers[index].colors[0])
		$wheels/wheel_rear_right_hub.get_surface_material(0).set("albedo_color",drivers[index].colors[1])
		$wheels/wheel_rear_left_hub.get_surface_material(0).set("albedo_color",drivers[index].colors[1])
		$wheels/wheel_front_right_hub.get_surface_material(0).set("albedo_color",drivers[index].colors[1])
		$wheels/wheel_front_right_hub.get_surface_material(0).set("albedo_color",drivers[index].colors[1])
func _input(ev):
	if Input.is_key_pressed(KEY_RIGHT):
		index = index+1
	if Input.is_key_pressed(KEY_LEFT):	
		index = index-1
	if index >= drivers.size():index=0
	if index < 0:index=drivers.size()-1
	changeSkin(index)
	
# Called when the node enters the scene tree for the first time.
func _ready():
	changeSkin(index)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	rotate_y(PI/4*delta)


func _on_driver_pressed():
	index = index+1
	if index >= drivers.size():index=0
	changeSkin(index)
