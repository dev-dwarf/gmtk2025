extends Node3D

@export_group("Properties")
@export var target: Node

@export_group("Zoom")
@export var zoom_minimum = 16
@export var zoom_maximum = 4
@export var zoom_speed = 10

@export_group("Rotation")
@export var rotation_speed = 200

var camera_rotation:Vector3
var zoom = 14
var mouse_sensitivity = 0.0505

@onready var camera = $Camera

func _ready():
	camera_rotation = rotation_degrees # Initial rotation
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	pass

func _physics_process(delta):
	self.position = self.position.lerp(target.position, delta * 4)
	rotation_degrees = rotation_degrees.lerp(camera_rotation, delta * 6)
	
	camera.position = Vector3(0, 0, zoom)
	
	var input := Vector3.ZERO
	
	input.y = Input.get_axis("camera_right", "camera_left")
	input.x = Input.get_axis("camera_up", "camera_down")
	
	camera_rotation += input.limit_length(1.0) * rotation_speed * delta
	camera_rotation.x = clamp(camera_rotation.x, -80, -10)
	
	zoom += Input.get_axis("zoom_in", "zoom_out") * zoom_speed * delta
	zoom = clamp(zoom, zoom_maximum, zoom_minimum)

# mouse look
func _input(event):
	if event is InputEventMouseMotion:
		var input := -Vector3(event.relative.y, event.relative.x, 0.0)
		camera_rotation += input*mouse_sensitivity
	
