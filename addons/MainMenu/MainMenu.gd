extends CanvasLayer
func _ready():
	pass

func _input(event):
	if Input.is_action_pressed("ui_cancel"):
		get_tree().quit()
	if Input.is_key_pressed(KEY_ENTER):
		get_tree().change_scene("res://TestScene.tscn")

func _on_Button4_pressed():
	get_tree().quit()

func _on_Button_pressed():
	get_tree().change_scene("res://TestScene.tscn")
