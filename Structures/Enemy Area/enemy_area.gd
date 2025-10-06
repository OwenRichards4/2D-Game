extends Node2D

var body2
var obj

func _process(delta: float) -> void:
	#if obj:
		#for i in obj:
			#if i == "enemy":
				#pushback()
	pass

func pushback():
	body2.velocity.x *= -1

func _on_area_2d_body_entered(body: Node2D) -> void:
	body2 = body
	obj = body.get_groups()

func _on_area_2d_body_exited(body: Node2D) -> void:
	body2 = null
	obj = null
