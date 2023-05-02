extends Spatial

onready var ball = $Ball
onready var car_mesh = $CarMesh
onready var ground_ray = $CarMesh/RayCast
#onready var checkpoint = get_parent().get_parent().get_parent().get_parent().get_node("checkpoint")
# mesh references
onready var right_wheel = $CarMesh/tmpParent/sprintcar/wheels/right_front2
onready var left_wheel = $CarMesh/tmpParent/sprintcar/wheels/wheel_frontLeft002
onready var body_mesh = $CarMesh/tmpParent/sprintcar/body


#PHI = (1 + sqrt(5))/2
#n = id * PHI - floor(id * PHI)
#hue = floor(n * 256)

export (bool) var show_debug = false
var sphere_offset = Vector3(0, -0.4, 0)
var acceleration = 68
var steering = 21
var turn_speed = 4.4
var turn_stop_limit = 0.0
var body_tilt = 65

var speed_input = 0
var rotate_input = 0
var rotate_target=0
# ai
var num_rays = 32
var look_ahead = 20
var brake_distance = 0.5
var interest = []
var danger = []
var chosen_dir = Vector3.ZERO
var forward_ray

func _ready():
	$engine.volume_db = -30.0
	$Ball/DebugMesh.visible = show_debug
#	DebugOverlay.stats.add_property(ball, "linear_velocity", "length")
#	DebugOverlay.draw.add_vector(ball, "linear_velocity", 1, 4, Color(0, 1, 0, 0.5))
#	DebugOverlay.draw.add_vector(car_mesh, "transform:basis:z", -4, 4, Color(1, 0, 0, 0.5))

	ground_ray.add_exception(ball)
#	ground_ray.add_exception(checkpoint)
	
	randomize()
	acceleration *= rand_range(0.8, 1.2)
	interest.resize(num_rays)
	danger.resize(num_rays)
	add_rays()
	setColors()	

func setColors():
#		randomize()
		var wingMaterial = $CarMesh/tmpParent/sprintcar/body/wing.mesh.surface_get_material(0)
		wingMaterial.albedo_color = Color(rand_range(0,1), rand_range(0,1), rand_range(0,1.0),1.0)
		$CarMesh/tmpParent/sprintcar/body/wing.set_surface_material(0, wingMaterial)
		var bodyMaterial = $CarMesh/tmpParent/sprintcar/body/body_gaurd.mesh.surface_get_material(0)
		bodyMaterial.albedo_color = Color(rand_range(0,1), rand_range(0,1), rand_range(0,1.0),1.0)
		$CarMesh/tmpParent/sprintcar/body/body_gaurd.set_surface_material(0, bodyMaterial)

func add_rays():
	var angle = 2 * PI / num_rays
	for i in num_rays:
		var r = RayCast.new()
		$CarMesh/ContextRays.add_child(r)
		r.cast_to = Vector3.FORWARD * look_ahead
		r.rotation.y = -angle * i
		r.enabled = true
	forward_ray = $CarMesh/ContextRays.get_child(0)

func set_interest():
	var path_direction = -car_mesh.transform.basis.z
	if owner and owner.has_method("get_path_direction"):
		path_direction = owner.get_path_direction(ball.global_transform.origin)
	for i in num_rays:
		var d = -$CarMesh/ContextRays.get_child(i).global_transform.basis.z
		d = d.dot(path_direction)
		interest[i] = max(0, d)

func set_danger():
	for i in num_rays:
		var ray = $CarMesh/ContextRays.get_child(i)
		danger[i] = 1.0 if ray.is_colliding() else 0.0
		
func choose_direction():
	for i in num_rays:
		if danger[i] > 0.0:
			interest[i] = 0.0
	chosen_dir = Vector3.ZERO
	for i in num_rays:
		chosen_dir += -$CarMesh/ContextRays.get_child(i).global_transform.basis.z * interest[i]
	chosen_dir = chosen_dir.normalized()

func angle_dir(fwd, target, up):
	# Returns how far "target" vector is to the left (negative)
	# or right (positive) of "fwd" vector.
	var p = fwd.cross(target)
	var dir = p.dot(up)
	return dir


func _process(delta):
	# Can't steer/accelerate when in the air
	if not ground_ray.is_colliding():
		return

	speed_input +=1
	speed_input *= acceleration

	# steer input
#	rotate_target = lerp(rotate_target, rotate_input, 5 * delta)
	rotate_input *= deg2rad(steering)
	
	# rotate wheels for effect
	right_wheel.rotation.y = rotate_input
	left_wheel.rotation.y = rotate_input

	# brakes
	if forward_ray.is_colliding():
		var d = ball.global_transform.origin.distance_to(forward_ray.get_collision_point())
		if d < brake_distance:
			speed_input -=  10 * acceleration * (1 - d/brake_distance)
	
# smoke?
#	var d = ball.linear_velocity.normalized().dot(-car_mesh.transform.basis.z)
#	if ball.linear_velocity.length() > 49.0 and d < 0.9:
#		$CarMesh/Smoke.emitting = true
#		$CarMesh/Smoke2.emitting = true
#	else:
#		$CarMesh/Smoke.emitting = false
#		$CarMesh/Smoke2.emitting = false
		
	# rotate car mesh
	if ball.linear_velocity.length() > turn_stop_limit:
		var new_basis = car_mesh.global_transform.basis.rotated(car_mesh.global_transform.basis.y, rotate_input)
		car_mesh.global_transform.basis = car_mesh.global_transform.basis.slerp(new_basis, turn_speed * delta)
		car_mesh.global_transform = car_mesh.global_transform.orthonormalized()
		
		# tilt body for effect
		var t = -rotate_input * ball.linear_velocity.length() / body_tilt
		body_mesh.rotation.z = lerp(body_mesh.rotation.z, t, 10 * delta)
		
	# align mesh with ground normal
	var n = ground_ray.get_collision_normal()
	var xform = align_with_y(car_mesh.global_transform, n.normalized())
	car_mesh.global_transform = car_mesh.global_transform.interpolate_with(xform, 10 * delta)

	$engine.pitch_scale = ball.linear_velocity.length()/50 +0.3
	
func _physics_process(delta):
	# just lerp the y due to trimesh bouncing
	car_mesh.transform.origin.x = ball.transform.origin.x + sphere_offset.x
	car_mesh.transform.origin.z = ball.transform.origin.z + sphere_offset.z
	car_mesh.transform.origin.y = lerp(car_mesh.transform.origin.y, ball.transform.origin.y + sphere_offset.y, 10 * delta)
	ball.add_central_force(-car_mesh.global_transform.basis.z * speed_input)
	
func align_with_y(xform, new_y):
	xform.basis.y = new_y
	xform.basis.x = -xform.basis.z.cross(new_y)
#	xform.basis.z = xform.basis.z
	xform.basis = xform.basis.orthonormalized()
	return xform

func _on_checkpoint_body_entered(body):
	print("Lap!")
