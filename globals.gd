extends Node

var index =0

var drivers =[
	{"name":"The Gillin Boys Foundation","prefix":"G","number":0,"colors":["282","000"],"wing":"res://assets/scream_gillin_boys.png"},
	{"name":"Tim Van Ginneken","prefix":"V","number":44,"colors":["537","a03"],"wing":"res://assets/scream_tvg_yougotthis.png"},
	{"name":"Koby O'shannassy","prefix":"V","number":60,"colors":["eee","00f"],"wing":"res://assets/scream_koby.png"},
	{"name":"David Donegan","prefix":"VA","number":75,"colors":["ddd","f0a"],"wing":"res://assets/scream_sprint_pig.png"},
	{"name":"Johnny Vogles","prefix":"V","number":70,"colors":["fa0","008"],"wing":"res://assets/scream_johnny_vogles.png"},
	{"name":"The Piggs","prefix":"V","number":0,"colors":["000","333"],"wing":"res://assets/scream.png"},
	{"name":"Alex's Pizza","prefix":"K","number":0,"colors":["000","333"],"wing":"res://assets/scream_alexs_pizza.png"}
]

func change(index):
	index = index+1
	if index >= drivers.size():index=0

func updateColors(index):

	var gradient_data := {
	0.0: Color(drivers[index].colors[0]),
	0.5: Color(drivers[index].colors[1]),
	0.75: Color(drivers[index].colors[0]),
	1.0: Color(drivers[index].colors[1]),
	}

	var gradient := Gradient.new()
	gradient.offsets = gradient_data.keys()
	gradient.colors = gradient_data.values()

	var gradient_texture := GradientTexture2D.new()
	gradient_texture.gradient = gradient
	return gradient_texture
