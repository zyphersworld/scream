extends Spatial

onready var wing = $wing
onready var body = $body_gaurd
var wings = [
	"res://assets/scream_tvg_yougotthis.png",
	"res://assets/scream_koby.png",
	"res://assets/scream_johnny_vogles.png",
	"res://assets/scream_sprint_pig.png",
	"res://assets/scream.png"
	]

# Called when the node enters the scene tree for the first time.
func _ready():
	var wingMaterial = SpatialMaterial.new()
	var bodyMaterial = SpatialMaterial.new()
#	wingMaterial.albedo_color = Color(randf()*0.8, randf()*0.8, randf()*0.8)
	var texture = ImageTexture.new()
	var image = Image.new()
	var index =randi()%wings.size()-1
	image.load(wings[index])
	texture.create_from_image(image)
	
	#wing
#	$wing_top.material_override = wingMaterial
#	wingMaterial.albedo_color = Color(randf()*0.8, randf()*0.8, randf()*0.8)
#	wing.material_override = wingMaterial	
#	bodyMaterial.albedo_color = Color(randf()*0.8, randf()*0.8, randf()*0.8)
#	body.material_override = bodyMaterial


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
