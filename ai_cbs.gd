extends KinematicBody

export var max_speed = 3
export var steer_force = 0.5
export var look_ahead = 4
export var num_rays = 8
onready var target_position = get_parent().get_target_position()
var stop = true

# context array
var ray_directions = []
var interest = []
var danger = []

var chosen_dir = Vector3.ZERO
var velocity = Vector3.ZERO
var acceleration = Vector3.ZERO
var raycasts = []
var last_dir = Vector3.ZERO

# Called when the node enters the scene tree for the first time.
func _ready():
	target_position = get_parent().get_target_position()
	ray_directions.resize(num_rays)
	interest.resize(num_rays)
	danger.resize(num_rays)
	var myvec = Vector3.RIGHT
	for i in num_rays:
		var angle = i * 2*PI /(num_rays)
		ray_directions[i] = myvec.rotated(Vector3.UP,angle)
	raycasts = $rayFront.get_children()
	var i = 0
	for ray in raycasts:
		ray.set_cast_to(ray_directions[i]*look_ahead)
		ray.add_exception(get_parent())
		i+=1
func _unhandled_input(event):
	if event is InputEventKey:
		if event.pressed and event.scancode == KEY_0:
			stop = false

func _physics_process(delta):
	set_interest()
	set_danger()
	choose_direction()

	chosen_dir.x = lerp(last_dir.x,chosen_dir.x,.01)
	chosen_dir.z = lerp(last_dir.z,chosen_dir.z,.01)
	look_at(Vector3(chosen_dir.x+translation.x,translation.y,chosen_dir.z+translation.z),Vector3.UP)
	if !stop:
		move_and_collide(chosen_dir * delta * max_speed)
		last_dir = chosen_dir
	
	
func set_interest():
	if target_position == null:
		set_default_interest()
	else:
			var direction = (translation - target_position).normalized()
			for i in num_rays:
				var d = ray_directions[i].dot(direction)* steer_force
				interest[i] = min(0, d)
				if(translation - target_position).length() < 1:
					stop = true

		
	
func set_default_interest():
	for i in num_rays:
		var d = ray_directions[i].dot(transform.basis.z)
		interest[i] = min(0, d)
		#print(d)
	
func set_danger():
	var i = 0
	for ray in raycasts:
		if ray.is_colliding():
			danger[i] = 1
			if i < 4:
				interest[i+4]+= -1
			elif i > 3: interest[i-4]+= -1

		else: danger[i] = 0
		i+= 1
	
func choose_direction():
	# Eliminate interest in slots with danger
	for i in num_rays:
		if danger[i] > 0.5:
			interest[i] = 0.0
	# Choose direction based on remaining interest
	chosen_dir = Vector3.ZERO
	for i in num_rays:
		chosen_dir += ray_directions[i] * abs(interest[i])
	chosen_dir = chosen_dir.normalized()
