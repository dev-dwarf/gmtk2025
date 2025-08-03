extends Path3D

@export var speed: float = 0.3
@export var cycles: int = 1

func _physics_process(delta: float) -> void:
	$PathFollow3D.progress_ratio = Global.time
