extends Node3D

var random_number = RandomNumberGenerator.new()
var random_velocity:float
var random_time:float

var init_y
var phase

func _ready():
	init_y = position.y
	phase = 101*position.x + 404*position.z + 505*position.y

func _process(_delta):
	position.y = init_y + cos(phase + (Global.time * TAU * 4)/scale.y)/scale.x
