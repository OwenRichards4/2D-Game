extends Area2D

var target: Node2D = null

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		target = body
		death()

func death():
	target.global_position = Vector2(Global.spawnX, Global.spawnY)
