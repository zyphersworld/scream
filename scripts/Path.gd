extends Path
export var opponents=9
onready var opp = $PathFollow
var offsetspace=0

func _ready():
	for n in opponents:
		var newopp = opp.duplicate()
		opp.get_parent().add_child(newopp)
