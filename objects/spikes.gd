extends Node3D
@onready var animation = $AnimationPlayer
@export var cycles: int = 2

var spikes_up = false

func _ready():
	animation.play("show")

func _process(_delta):
	animation.seek(Global.time * animation.current_animation_length * cycles, false)
	var pos = fmod(animation.current_animation_position,animation.current_animation_length)
	spikes_up = (pos > 1.95) and (pos < 3.23)
	print(pos, spikes_up)
	$Area3D.monitoring = spikes_up
	

func _on_body_entered(body):
	if body.has_method("die"):
		body.die()
