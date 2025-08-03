extends CanvasLayer

func _physics_process(delta: float):
	$Coins.text = ("f" if Global.forward else "r") + ":" + str(int(Global.time*100))
