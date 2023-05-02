extends PathFollow
onready var opp = $Spatial
var runspeed = rand_range(22, 48)

func _ready():
	offset=rand_range(0.0,358.0)
	v_offset=0.0
	h_offset=rand_range(-0.5,12.0)

func _process(delta:float) -> void:
	set_offset(get_offset() + runspeed * delta)
