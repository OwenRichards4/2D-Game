extends Control

var count = 2
var reload_time = 1
var currtext = ""
var active = false
var currHealth
var currAtkProgress

var text : String

func _input(event: InputEvent) -> void:
	pass

func _ready() -> void:
	currHealth = Global.player_health + 1
	currAtkProgress = Global.atk_progress

func abilityUsed():
	var cooldown = (3-count) * reload_time
	await get_tree().create_timer(cooldown).timeout
	count += 1
	var icon = $HBoxContainer.get_child(count) as TextureRect  
	icon.texture = preload("res://Character/Abilities/FB00_nyknck/FB001.png")

func _process(delta: float) -> void:
	if !active:
		if currtext != Global.text:
			active = true
			read(Global.text)
			currtext = Global.text
	if Global.door_open == true:
		$"End Game".visible = true
	
	$Label.text = str(Global.spawnX) + ", " + str(Global.spawnY)
	$Label2.text = str(Global.playerX) + ", " + str(Global.playerY)
	
	if currAtkProgress != Global.atk_progress:
		currAtkProgress = Global.atk_progress
		if currAtkProgress == 1:
			$Control/HBoxContainer2/Atk_Progress.texture = load("res://assets/PG_2.png")
		elif currAtkProgress == 2:
			$Control/HBoxContainer2/Atk_Progress.texture = load("res://assets/PG_3.png")
		elif currAtkProgress == 3:
			$Control/HBoxContainer2/Atk_Progress.texture = load("res://assets/PG_4.png")
		elif currAtkProgress == 4:
			$Control/HBoxContainer2/Atk_Progress.texture = load("res://assets/PG_5.png")

	if currHealth != Global.player_health:
		currHealth = Global.player_health
		if currHealth >= 20:
			$Control/HBoxContainer2/Heart1.texture = load("res://assets/full-heart.png")
			$Control/HBoxContainer2/Heart2.texture = load("res://assets/full-heart.png")
			$Control/HBoxContainer2/Heart3.texture = load("res://assets/full-heart.png")
			$Control/HBoxContainer2/Heart4.texture = load("res://assets/full-heart.png")
		elif currHealth < 20 and currHealth >= 17.5:
			$Control/HBoxContainer2/Heart1.texture = load("res://assets/half-heart.png")
			$Control/HBoxContainer2/Heart2.texture = load("res://assets/full-heart.png")
			$Control/HBoxContainer2/Heart3.texture = load("res://assets/full-heart.png")
			$Control/HBoxContainer2/Heart4.texture = load("res://assets/full-heart.png")
		elif currHealth < 17.5 and currHealth >= 15:
			$Control/HBoxContainer2/Heart1.texture = load("res://assets/empty-heart.png")
			$Control/HBoxContainer2/Heart2.texture = load("res://assets/full-heart.png")
			$Control/HBoxContainer2/Heart3.texture = load("res://assets/full-heart.png")
			$Control/HBoxContainer2/Heart4.texture = load("res://assets/full-heart.png")
		elif currHealth < 15 and currHealth >= 12.5:
			$Control/HBoxContainer2/Heart1.texture = load("res://assets/empty-heart.png")
			$Control/HBoxContainer2/Heart2.texture = load("res://assets/half-heart.png")
			$Control/HBoxContainer2/Heart3.texture = load("res://assets/full-heart.png")
			$Control/HBoxContainer2/Heart4.texture = load("res://assets/full-heart.png")
		elif currHealth < 12.5 and currHealth >= 10:
			$Control/HBoxContainer2/Heart1.texture = load("res://assets/empty-heart.png")
			$Control/HBoxContainer2/Heart2.texture = load("res://assets/empty-heart.png")
			$Control/HBoxContainer2/Heart3.texture = load("res://assets/full-heart.png")
			$Control/HBoxContainer2/Heart4.texture = load("res://assets/full-heart.png")
		elif currHealth < 10 and currHealth >= 7.5:
			$Control/HBoxContainer2/Heart1.texture = load("res://assets/empty-heart.png")
			$Control/HBoxContainer2/Heart2.texture = load("res://assets/empty-heart.png")
			$Control/HBoxContainer2/Heart3.texture = load("res://assets/half-heart.png")
			$Control/HBoxContainer2/Heart4.texture = load("res://assets/full-heart.png")
		elif currHealth < 7.5 and currHealth >= 5:
			$Control/HBoxContainer2/Heart1.texture = load("res://assets/empty-heart.png")
			$Control/HBoxContainer2/Heart2.texture = load("res://assets/empty-heart.png")
			$Control/HBoxContainer2/Heart3.texture = load("res://assets/empty-heart.png")
			$Control/HBoxContainer2/Heart4.texture = load("res://assets/full-heart.png")
		elif currHealth < 5 and currHealth >= 2.5:
			$Control/HBoxContainer2/Heart1.texture = load("res://assets/empty-heart.png")
			$Control/HBoxContainer2/Heart2.texture = load("res://assets/empty-heart.png")
			$Control/HBoxContainer2/Heart3.texture = load("res://assets/empty-heart.png")
			$Control/HBoxContainer2/Heart4.texture = load("res://assets/half-heart.png")
		elif currHealth <= 0:
			$Control/HBoxContainer2/Heart1.texture = load("res://assets/empty-heart.png")
			$Control/HBoxContainer2/Heart2.texture = load("res://assets/empty-heart.png")
			$Control/HBoxContainer2/Heart3.texture = load("res://assets/empty-heart.png")
			$Control/HBoxContainer2/Heart4.texture = load("res://assets/empty-heart.png")
		
func read(text):
	$TextureRect/Label.text = ""
	$TextureRect.visible = true
	for i in text:
		$TextureRect/Label.text += i
		await get_tree().create_timer(0.045).timeout
		
	await get_tree().create_timer(3).timeout
	$TextureRect.visible = false
	active = false
