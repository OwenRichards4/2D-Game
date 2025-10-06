extends Node

var count = 2
var reload_time = 1
var spawnX
var spawnY
var text : String
var arr = [
	"Use WASD to move around and spacebar to jump!", 
	"Press 'E' to use your ability, fireball!", 
	"Press spacebar while in the air to preform a dash.",
	"Collect the star to unlock the door to the next area!"
	]
var itter = 0
var door_open = false
var mob_speed = 50
var player_health = 20
var playerX
var playerY
var atk_progress = 0
var charge_ready : bool = false
var deathCheck : bool = false

@onready var grip_strength = 4
@onready var slipCheck : bool = true

var gravity = ProjectSettings.get_setting("physics/2d/default_gravity") * 2

var starCheck

@warning_ignore("unused_parameter")
func _input(event: InputEvent) -> void:
	if Input.is_action_pressed("attack_action"):
		count -= 1

func reload():
	var cooldown = (3-count) * reload_time
	await get_tree().create_timer(cooldown).timeout
	count += 1
