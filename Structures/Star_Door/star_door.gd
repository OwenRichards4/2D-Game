extends Area2D

func _on_body_entered(body: Node2D) -> void:
	Global.starCheck = get_tree().get_nodes_in_group("star")
	if Global.starCheck:
		Global.door_open = true
		queue_free()
		Global.starCheck = null
