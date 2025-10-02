extends Node2D

var curr = 1

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("change_ability"):
		if curr == 1:
			curr += 1
			$Ability_Wheel.texture = load("res://Scene/Ability Wheel/Ability-Wheel-Fireball.png")
		elif curr == 2:
			curr +=1 
			$Ability_Wheel.texture = load("res://Scene/Ability Wheel/Ability-Wheel-Lightning.png")
		elif curr == 3:
			curr = 1
			$Ability_Wheel.texture = load("res://Scene/Ability Wheel/Ability-Wheel-Sword.png")
