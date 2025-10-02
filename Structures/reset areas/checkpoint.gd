extends Node2D

func _on_area_2d_body_entered(body: Node2D) -> void:
	Global.spawnX = body.global_position[0]
	Global.spawnY = body.global_position[1]
	
