extends Spatial

#GLOBALS
var index = Globals.index
var drivers = Globals.drivers
var sphere_offset = Vector3(0, -0.5, 0)
onready var ball = $Ball_opp
onready var car_mesh = $CarMesh
onready var ground_ray = $CarMesh/RayCast
onready var right_wheel = $CarMesh/tmpParent/sprintcar/wheels/wheel_front_left_tire
onready var right_rim = $CarMesh/tmpParent/sprintcar/wheels/wheel_front_right_rim
onready var left_wheel = $CarMesh/tmpParent/sprintcar/wheels/wheel_front_right_tire
onready var left_rim = $CarMesh/tmpParent/sprintcar/wheels/wheel_front_left_rim
onready var steering_wheel = $CarMesh/tmpParent/sprintcar/body1/steering_wheel
onready var body_mesh = $CarMesh/tmpParent/sprintcar/body1

#TRANSPONDER VARS
var laps=0
var laptime=0
var time=0
var timer_on=true
var time_passed=0

#CAR VARS
var acceleration = 68
var steering = 21
var turn_speed = 4.4
var turn_stop_limit = 0.75
var body_tilt = 99.8
var speed_input = 20
var rotate_input = 0


func align_with_y(xform, new_y):
	xform.basis.y = new_y
	xform.basis.x = -xform.basis.z.cross(new_y)
	xform.basis = xform.basis.orthonormalized()
	return xform
	
func _ready():
	ground_ray.add_exception(ball)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
# align mesh with ground normal
	var n = ground_ray.get_collision_normal()
	var xform = align_with_y(car_mesh.global_transform, n)
	car_mesh.global_transform = car_mesh.global_transform.orthonormalized().interpolate_with(xform, 10 * delta)
	
	#Engine sound and speed
#	$engine.pitch_scale = ball.linear_velocity.length()/50 +0.3
	#move to UI CODE
#	get_parent().get_node("UI/speedo").text = "%003d" % [ball.linear_velocity.length()*2]

func _physics_process(delta):
#	car_mesh.transform.origin = ball.transform.origin + sphere_offset
	# just lerp the y due to trimesh bouncing
	car_mesh.transform.origin.x = ball.transform.origin.x + sphere_offset.x
	car_mesh.transform.origin.z = ball.transform.origin.z + sphere_offset.z
	car_mesh.transform.origin.y = lerp(car_mesh.transform.origin.y, ball.transform.origin.y + sphere_offset.y, 10 * delta)
#	ball.add_central_force(-car_mesh.global_transform.basis.z * speed_input)



func _on_checkpoint_body_entered(body):
	pass # Replace with function body.
