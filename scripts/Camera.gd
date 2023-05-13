extends Camera

export var lerp_speed = PI * PI *0.8
export var mouse_sens = 1.0 * 0.8
export var camera_anglev=0
export var rot_x = 0
export var rot_y = 0
export (NodePath) var target_path = null
export (Vector3) var offset = Vector3(0.0,1.5,2.2)
var target = null

func _ready():
	if target_path:
		target = get_node(target_path)

func _physics_process(delta):
	if !target:
		return

	var target_pos = target.global_transform.translated(offset)
	global_transform = global_transform.interpolate_with(target_pos, lerp_speed * delta*0.9)
	look_at(target.global_transform.origin, Vector3.UP)

func _input(event):         
	if event is InputEventMouseMotion:
		offset += Vector3(deg2rad(-event.relative.x*mouse_sens),0.0,0.0)
		var changev=-event.relative.y*mouse_sens
		if camera_anglev+changev>-80 and camera_anglev+changev<1080:
			camera_anglev+=changev
			offset += Vector3(0.0,deg2rad(changev),0.0)

	if event.is_action_pressed("cam_view_LEFT"):
		offset += Vector3(-0.5,0.0,0.0)	
	if event.is_action_pressed("cam_view_RIGHT"):
		offset += Vector3(0.5,0.0,0.0)
	if event.is_action_pressed("cam_view_UP"):
		offset += Vector3(0.0,0.5,0.0)	
	if event.is_action_pressed("cam_view_DOWN"):
		offset += Vector3(0.0,-0.5,0.0)

func _on_HSlider_value_changed(value):
	print(value)
	if value > 0:
		offset += Vector3(-0.5,0.0,0.0)	
	if value < 0:
		offset += Vector3(0.5,0.0,0.0)	


func _on_HSlider2_value_changed(value):
	print(value)
	if value > 0:
		offset += Vector3(0.0,0.5,0.0)	
	if value < 0:
		offset += Vector3(0.0,-0.5,0.0)	
