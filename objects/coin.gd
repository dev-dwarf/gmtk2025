extends Area3D

var grabbed := false

var init_y;

func _ready():
	init_y = position.y

# Collecting coins
func _on_body_entered(body):
	if body.has_method("collect_coin") and !grabbed:
		
		body.collect_coin()
		
		Audio.play("res://sounds/coin.ogg") # Play sound
		
		$Mesh.queue_free() # Make invisible
		$Particles.emitting = false # Stop emitting stars
		
		grabbed = true

# Rotating, animating up and down
func _process(_delta):
	rotation.y = fmod(45 * Global.time, 360.)
	position.y = init_y + 0.25 * cos(8 * TAU * Global.time)
