extends Node2D

func _ready():
	var mob_types = Array($AnimatedSprite2D.sprite_frames.get_animation_names())
	$AnimatedSprite2D.play("attack2")

func _on_visible_on_screen_notifier_2d_screen_exited():
	queue_free()
