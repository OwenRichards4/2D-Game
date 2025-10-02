extends Node2D

func _on_area_2d_body_entered(body: Node2D) -> void:
	Global.starCheck = get_tree().get_nodes_in_group("star")
	if Global.starCheck:
		queue_free()
