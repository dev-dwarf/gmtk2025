extends CharacterBody3D

signal coin_collected

@export_subgroup("Components")
@export var view: Node3D

const SPEED = 5
const JUMP_ACCEL = 8
const ACCEL = 22
const FLOOR_FRIC = 25
const AIR_FRIC = 5
const GRAVITY_ACCEL = 25
const COYOTE_TIME = 7
const JUMP_BUFFER = 6

var movement_velocity: Vector3
var rotation_direction: float
var gravity = 0
var coins = 0

var on_floor = 1
var jump_double = true
var jump_buffer = 0

@onready var particles_trail = $ParticlesTrail
@onready var sound_footsteps = $SoundFootsteps
@onready var model = $Character
@onready var animation = $Character/AnimationPlayer

func approach(x, t, s):
	return min(x+s, t) if x < t else max(x-s, t) 

func _physics_process(delta):
	var input := Vector3.ZERO

	input.x = Input.get_axis("move_left", "move_right")
	input.z = Input.get_axis("move_forward", "move_back")

	input = input.rotated(Vector3.UP, view.rotation.y).normalized() * SPEED
	
	# Check input facing opposite way of current movement
	if input == Vector3.ZERO or movement_velocity.dot(input) < 0:
		var fric = FLOOR_FRIC if on_floor > 0 else AIR_FRIC
		movement_velocity = movement_velocity.move_toward(Vector3.ZERO, fric * delta)
	movement_velocity = movement_velocity.move_toward(input, ACCEL * delta)

	jump_buffer -= 1
	if Input.is_action_just_pressed("jump"):
		jump_buffer = JUMP_BUFFER
		
	if jump_buffer > 0:
		var can_jump = on_floor > -COYOTE_TIME
		if jump_double:
			can_jump = true;
			jump_double = false;
		if can_jump:
			gravity = -JUMP_ACCEL
			on_floor = -COYOTE_TIME
			model.scale = Vector3(0.5, 1.5, 0.5)
			Audio.play("res://sounds/jump.ogg")
				
	if is_on_floor():
		if gravity > 0:
			on_floor = max(1, on_floor+1)
			if gravity > 2:
				model.scale = Vector3(1.25, 0.75, 1.25)
				Audio.play("res://sounds/land.ogg")
			gravity = 0
			jump_double = true
	else:
		on_floor = min(-1, on_floor-1)
		gravity += GRAVITY_ACCEL * delta
		
	# Input.is_action_just_pressed("flip")
	# Die
	if Input.is_action_just_pressed("restart") or position.y < -10:
		get_tree().reload_current_scene()
	
	# Move
	var applied_velocity: Vector3
	applied_velocity = movement_velocity
	applied_velocity.y = -gravity
	velocity = applied_velocity
	move_and_slide()
	
	# Animation
	particles_trail.emitting = false
	sound_footsteps.stream_paused = true
	if is_on_floor():
		var horizontal_velocity = Vector2(velocity.x, velocity.z)
		var speed_factor = horizontal_velocity.length() / SPEED
		if speed_factor > 0.05:
			if animation.current_animation != "walk":
				animation.play("walk", 0.1)

			if speed_factor > 0.3:
				sound_footsteps.stream_paused = false
				sound_footsteps.pitch_scale = speed_factor

			if speed_factor > 0.75:
				particles_trail.emitting = true
		elif animation.current_animation != "idle":
			animation.play("idle", 0.1)
	elif animation.current_animation != "jump":
		animation.play("jump", 0.1)
	model.scale = model.scale.lerp(Vector3(1, 1, 1), delta * 10)
	
	# Tilt in movement dir
	if Vector2(velocity.z, velocity.x).length() > 0:
		rotation_direction = Vector2(velocity.z, velocity.x).angle()
	rotation.y = lerp_angle(rotation.y, rotation_direction, delta * 10)
	
		
func collect_coin():
	coins += 1
	coin_collected.emit(coins)
