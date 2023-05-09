extends Spatial

#GLOBALS
var index = Globals.index
var drivers = Globals.drivers
var sphere_offset = Vector3(0, -1.0, 0)

#TRANSPONDER VARS
var laps=0
var laptime=0
var time=0
var timer_on=true
var time_passed=0

#CAR VARS
var acceleration = 64
var steering = 21
var turn_speed = 4.4
var turn_stop_limit = 0.75
var body_tilt = 99.8
var speed_input = 60
var rotate_input = 0

onready var ball = $Ball
onready var car_mesh = $CarMesh
onready var ground_ray = $CarMesh/RayCast
onready var right_wheel = $CarMesh/tmpParent/sprintcar/wheels/wheel_front_left_tire
onready var right_rim = $CarMesh/tmpParent/sprintcar/wheels/wheel_front_right_rim
onready var left_wheel = $CarMesh/tmpParent/sprintcar/wheels/wheel_front_right_tire
onready var left_rim = $CarMesh/tmpParent/sprintcar/wheels/wheel_front_left_rim
onready var steering_wheel = $CarMesh/tmpParent/sprintcar/body1/steering_wheel
onready var body_mesh = $CarMesh/tmpParent/sprintcar/body1

func _ready():
	ground_ray.add_exception(ball)
	var mat = $CarMesh/tmpParent/sprintcar/body1/wings/wing_top.get_active_material(0)
	var matchasis = $CarMesh/tmpParent/sprintcar/body1/chasis.get_active_material(0)
	$CarMesh/tmpParent/sprintcar/body1/wings/wing_top.material_override=mat
	$CarMesh/tmpParent/sprintcar/body1/chasis.material_override = matchasis
	mat.next_pass=null
	matchasis.next_pass=null
func _process(delta):

	#TRANSPONDER CODE
	if(timer_on):
		time += delta
		var mils = fmod(time,1)*1000
		var secs = fmod(time,60)
		var mins = fmod(time, 60*60) / 60
		var hr = fmod(fmod(time,3600 * 60) / 3600,24)
		var dy = fmod(time,12960000) / 86400
		time_passed = "%02d : %03d" % [secs,mils]
	else:
		time=0
	get_parent().get_node("UI/Laptime").text= time_passed
	
	# Can't steer/accelerate when in the air
	if not ground_ray.is_colliding():
		return

	#acceleration input
	speed_input = 0
	speed_input += Input.get_action_strength("accelerate")
	speed_input -= Input.get_action_strength("brake") 
	speed_input *= acceleration

	# steer input
#	rotate_target = lerp(rotate_target, rotate_input, 5 * delta)
	rotate_input = 0.1
	rotate_input += Input.get_action_strength("steer_left")
	rotate_input -= Input.get_action_strength("steer_right")
	rotate_input *= deg2rad(steering)

	# rotate wheels for effect
	right_wheel.rotation.y = rotate_input
	left_wheel.rotation.y = rotate_input
#	right_rim.rotation.y = rotate_input
#	left_rim.rotation.y = rotate_input

	# smoke?
	var d = ball.linear_velocity.normalized().dot(-car_mesh.transform.basis.z)
	if ball.linear_velocity.length() > 35.0 and d < 0.1:
		$CarMesh/Smoke.emitting = true
		$CarMesh/Smoke2.emitting = true
	else:
		$CarMesh/Smoke.emitting = false
		$CarMesh/Smoke2.emitting = false
	# rotate car mesh
	if ball.linear_velocity.length() > turn_stop_limit:
		var new_basis = car_mesh.global_transform.basis.rotated(car_mesh.global_transform.basis.y, rotate_input)
		car_mesh.global_transform.basis = car_mesh.global_transform.basis.slerp(new_basis, turn_speed * delta)
		car_mesh.global_transform = car_mesh.global_transform.orthonormalized()
		# tilt body for effect
		var t = -rotate_input * ball.linear_velocity.length() / body_tilt
		body_mesh.rotation.x = lerp(body_mesh.rotation.x, -t, 1.0 * delta)
		body_mesh.rotation.y = lerp(body_mesh.rotation.y, t, 1.0* delta)
		body_mesh.rotation.z = lerp(body_mesh.rotation.z, t, PI/2 * delta)
		
	
	# align mesh with ground normal
	var n = ground_ray.get_collision_normal()
	var xform = align_with_y(car_mesh.global_transform, n.normalized())
	car_mesh.global_transform = car_mesh.global_transform.interpolate_with(xform, 10 * delta)
	
	#Engine sound and speed
	$engine.pitch_scale = ball.linear_velocity.length()/50 +0.3
	#move to UI CODE
	get_parent().get_node("UI/speedo").text = "%003d" % [ball.linear_velocity.length()*2]

func align_with_y(xform, new_y):
	xform.basis.y = new_y
	xform.basis.x = -xform.basis.z.cross(new_y)
	xform.basis = xform.basis.orthonormalized()
	return xform

func _physics_process(delta):
#	car_mesh.transform.origin = ball.transform.origin + sphere_offset
	# just lerp the y due to trimesh bouncing
	car_mesh.transform.origin.x = ball.transform.origin.x + sphere_offset.x
	car_mesh.transform.origin.z = ball.transform.origin.z + sphere_offset.z
	car_mesh.transform.origin.y = lerp(car_mesh.transform.origin.y, ball.transform.origin.y + sphere_offset.y, 10 * delta)
	ball.add_central_force(-car_mesh.global_transform.basis.z * speed_input)

func _on_checkpoint_body_entered(body):
	if body.name == "Ball":
		resetLap()

func resetLap():
	laps +=1
	get_parent().get_node("UI/laps").text=str(laps)
	if time > 0:
		var newLabel = get_parent().get_node("UI/lapTimes/Label").duplicate()#text=str(laps-2)
		newLabel.text="%000.3f" % time
		get_parent().get_node("UI/lapTimes").add_child(newLabel)
		time = 0
	
func changeSkin(index):
	index = index+1
	if index > drivers.size()-1:
		index=0	
	var wingMaterial = SpatialMaterial.new()
	var bodyMaterial = SpatialMaterial.new()
	var chasisMaterial = SpatialMaterial.new()
	
	wingMaterial.CULL_DISABLED
	bodyMaterial.CULL_DISABLED
	chasisMaterial.CULL_DISABLED
	var image = drivers[index].wing
	wingMaterial.albedo_texture = load(image)
	
	$CarMesh/tmpParent/sprintcar/body1/wings/wing_top.get_surface_material(0).set("albedo_texture",load(drivers[index].wing))
	$CarMesh/tmpParent/sprintcar/body1/body.get_surface_material(0).set("albedo_color",drivers[index].colors[0])
	$CarMesh/tmpParent/sprintcar/body1/chasis.get_surface_material(0).set("albedo_color",drivers[index].colors[1])
	$CarMesh/tmpParent/sprintcar/body1/tailtank.get_surface_material(0).set("albedo_color",drivers[index].colors[0])
	$CarMesh/tmpParent/sprintcar/wheels/wheel_rear_right_rim.get_surface_material(0).set("albedo_color",drivers[index].colors[0])
	$CarMesh/tmpParent/sprintcar/wheels/wheel_rear_left_rim.get_surface_material(0).set("albedo_color",drivers[index].colors[0])
	$CarMesh/tmpParent/sprintcar/wheels/wheel_front_right_rim.get_surface_material(0).set("albedo_color",drivers[index].colors[0])
	$CarMesh/tmpParent/sprintcar/wheels/wheel_front_right_rim.get_surface_material(0).set("albedo_color",drivers[index].colors[0])
	$CarMesh/tmpParent/sprintcar/wheels/wheel_rear_right_hub.get_surface_material(0).set("albedo_color",drivers[index].colors[1])
	$CarMesh/tmpParent/sprintcar/wheels/wheel_rear_left_hub.get_surface_material(0).set("albedo_color",drivers[index].colors[1])
	$CarMesh/tmpParent/sprintcar/wheels/wheel_front_right_hub.get_surface_material(0).set("albedo_color",drivers[index].colors[1])
	$CarMesh/tmpParent/sprintcar/wheels/wheel_front_right_hub.get_surface_material(0).set("albedo_color",drivers[index].colors[1])
	
	
func _input(ev):
	if Input.is_key_pressed(KEY_K):
		index = index+1
		if index >= drivers.size():index=0
		changeSkin(index)
