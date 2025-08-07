extends Path3D

@export var speed: float = 0.3
@export var cycles: int = 1

func _physics_process(_delta):
	$PathFollow3D.progress_ratio = Global.time
