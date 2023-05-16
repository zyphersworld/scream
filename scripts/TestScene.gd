extends Spatial

func get_path_direction(position):
#	var offset = $Track/Path.curve.get_closest_offset(position)
#	$Track/Path/PathFollow.offset = offset
#	return $Track/Path/PathFollow.transform.x
	pass
#func _ready():
#	print($track_2["transform"])

func _input(event):
	if Input.is_action_pressed("ui_cancel"):
		get_tree().change_scene("res://addons/MainMenu/MainMenu3d.tscn")
	if Input.is_action_pressed("cam_switch"):
		var camView = $CarSUV/cam/h/v/PlayerView_1.current
		if(camView):
			$CarSUV/CarMesh/tmpParent/sprintcar/PlayerView_2.current=true
		else:
			$CarSUV/cam/h/v/PlayerView_1.current=true
				
	if Input.is_key_pressed(KEY_P):
		$CarSUV/CarMesh/tmpParent/sprintcar/PlayerView_2.current=true
	if Input.is_key_pressed(KEY_O):
		$CarSUV/cam/h/v/PlayerView_1.current=true
