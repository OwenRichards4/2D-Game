extends Area2D

@export var speed: float = 2000
var direction: Vector2 = Vector2.RIGHT

func _process(delta):
	direction[1] = 0.0
	if direction[0] > 0:
		direction[0] = 1
	else:
		direction[0] = -1
	
	if direction[0] < 0 :
		$FireballAnimation.flip_h = true
	
	$FireballAnimation.play("default")
	position += direction * speed * delta

func _on_area_entered(area: Area2D) -> void:
	if area.is_in_group("enemy"):
		if area.has_method("damage"):
			area.damage()
			queue_free()

func _on_body_entered(body: Node2D) -> void:
	if body.has_method("destroy"):
		body.destroy()
		$FireballAnimation.stop()
		queue_free()
	if body.has_method("damage"):
		body.damage()
		$FireballAnimation.stop()
		queue_free()

func death():
	position.x = Global.spawnX
	position.y = Global.spawnY
