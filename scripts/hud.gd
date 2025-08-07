extends CanvasLayer

func _physics_process(_delta):
	$Coins.text = ("f" if Global.forward else "r") + ":" + str(int(Global.time*100))
