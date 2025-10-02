extends Area2D

var target: Node2D = null
var follow_speed: float = 3.0
var vertical_offset: float = -50  # distance above the player's head

@onready var respawnPOS = position

func _ready() -> void:
	$AnimatedSprite2D.play("default")
	

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		target = body
		self.add_to_group("star")

func _process(delta):
	if target:
		# Position directly above the player's head
		var target_position = target.global_position + Vector2(5, vertical_offset)
		
		# Smoothly move the star
		global_position = global_position.lerp(target_position, delta * follow_speed)
		
		if Global.starCheck == get_tree().get_nodes_in_group("star"):
			queue_free()
		print(Global.player_health)
		if Global.deathCheck:
			Global.deathCheck = false
			position = respawnPOS
			target = null
