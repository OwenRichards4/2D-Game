extends Node2D

@onready var prevX = Global.spawnX
@onready var prevY = Global.spawnY

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		if abs(prevX - body.global_position[0]) > 300 and abs(prevY - body.global_position[0]) > 300:
			prevX = Global.spawnX
			prevY = Global.spawnY
			Global.spawnX = body.global_position[0]
			Global.spawnY = body.global_position[1]
