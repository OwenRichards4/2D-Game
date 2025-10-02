extends Node2D

var active = false

func textChange():
	Global.text = Global.arr[Global.itter]
	Global.itter += 1

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.is_in_group("player") and !active:
		active = true
		textChange()
