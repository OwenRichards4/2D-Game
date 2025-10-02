extends CharacterBody2D

@export var speed = 10.0
@export var jump_power = 20.0
@export var atk_speed = 600

@onready var fireball_scene: PackedScene = preload("res://Character/Abilities/fireball.tscn")

var speed_multiplier = 25.0
var jump_multiplier = -30.0
var direction = 0
var dir = velocity.normalized()
var dash = false
var fireballY
var fireballX
var currAbility = "Fireball"
var inAir = false
var prevDir = 1

var targetBody

var testCount = 0 # DELETE ME

var onWall : bool = false
var isClimbUpPressed : bool = false
var isClimbingUp : bool = false
var isClimbDownPressed : bool = false
var isClimbingDown : bool = false
var isHoldingPosition : bool = false
var HoldingPosition : bool = false

var wallJump : bool = false
var movingLeft : bool = false
var movingRight : bool = false
var movingUp : bool = false
var wallJumpCooldown : bool = false

var doingDamage : bool = false

var count = 2
var reload_time = 1

var actions = ["fireball", "jump", "in_air", "landing", "dash", "sword_attack"]

func _ready() -> void:
	add_to_group("player")
	direction = -1
	
	Global.spawnX = position.x
	Global.spawnY = position.y

func _input(event):
	if event.is_action_pressed("jump") and is_on_floor():
		$Wizard.play("jump")
		velocity.y = jump_power * jump_multiplier
		dash = false
	elif is_on_floor():
		dash = false
		
	if event.is_action_pressed("jump") and !is_on_floor() and !dash and !onWall:
		if dir[0] < 0:
			dashFunc("left")
		else:
			dashFunc("right")
		dash = true

	if event.is_action_pressed("jump") and HoldingPosition and !is_on_floor() and onWall:
		$Wizard.play('wall_jump')
		wallJump = true
		HoldingPosition = false
		onWall = false
		resetClimbing()
		
		if movingLeft or movingRight:
			if $Right.is_colliding(): # and movingLeft:
				velocity.y = jump_power * jump_multiplier
				#velocity.x = jump_power * jump_multiplier
			elif $Left.is_colliding(): # and movingRight:
				velocity.y = jump_power * jump_multiplier
				#velocity.x = -(jump_power * jump_multiplier)
		else:
			velocity.y = jump_power * jump_multiplier * 1.25
		
		wallJumpCooldown = true
		await get_tree().create_timer(0.05).timeout
		wallJumpCooldown = false
	
	if event.is_action_pressed("jump") and ($Wizard.animation == "run" or $Wizard.animation == "idle") and !is_on_floor() and dash == false:
		if dir[0] < 0:
			dashFunc("left")
		else:
			dashFunc("right")
		dash = true
	
	if event.is_action_pressed("attack_action"):
		$Wizard.play('sword_attack')
	
	if event.is_action_pressed("power_attack") and Global.atk_progress >= 4:
		Global.atk_progress = 0
		atkFunc(currAbility)

func _physics_process(delta):
	if Global.door_open == false:
		Global.playerX = position.x
		Global.playerY = position.y
		
		if Global.player_health <= 0:
			Global.deathCheck = true
			global_position.x = Global.spawnX
			global_position.y = Global.spawnY
			Global.player_health = 20
			
		if onWall and HoldingPosition:
			velocity.y = 0
		
		if !wallJumpCooldown:
			if $Left.is_colliding() or $Right.is_colliding():
				onWall = true
				wallJump = false
			else:
				onWall = false
				resetClimbing()
		
		climbingSprite(delta)
		
		if $Wizard.animation == "dash" and $Wizard.frame == 11:
			$Wizard.play("idle")
		if $Wizard.animation == "fireball" and $Wizard.frame == 7:
			await get_tree().create_timer(.075).timeout
			$Wizard.play("idle")
		if $Wizard.animation == "sword_attack":
			if $Wizard.frame == 3:
				$Wizard.play("idle")
			elif ($Wizard.frame == 1 or $Wizard.frame == 2) and doingDamage:
				if targetBody.has_method("damage"):
					targetBody.damage()
		if not is_on_floor() and !HoldingPosition:
			if $Wizard.animation == "jump" and $Wizard.frame == 3:
				$Wizard.play("in_air")
			velocity.y += Global.gravity * delta
			inAir = true
		
		if is_on_floor() and inAir:
			$Wizard.play("landing")
			inAir = false
			wallJump = false
		
		if $Wizard.animation == "landing" and $Wizard.frame == 2:
			$Wizard.play("idle")
		
		direction = Input.get_axis("move_left", "move_right")
		if direction and !HoldingPosition:
			if $Wizard.animation != "run":
				if $Wizard.animation not in actions:
					$Wizard.play("run")
				elif $Wizard.animation == "landing" and $Wizard.frame == 2:
					$Wizard.play("run")
			if prevDir != null:
				if direction < 0:
					direction = -1
					$"Wizard".flip_h = true
					$Area2D/CollisionShape2D.position = Vector2(-50.576, 29)
					if prevDir != direction:
						$Wizard.position.x -= 180
				else:
					direction = 1
					$"Wizard".flip_h = false
					$Area2D/CollisionShape2D.position = Vector2(27.446, 29)
					if prevDir != direction:
						$Wizard.position.x += 180
			
			velocity.x = direction * speed * speed_multiplier
			dir = velocity.normalized()
			prevDir = direction
		elif direction and HoldingPosition:
			if direction == 1:
				movingRight = true
				movingLeft = false
			elif direction == -1:
				movingLeft = true
				movingRight = false
		else:
			movingRight = false
			movingLeft = false
			if $Wizard.animation not in actions:
				$Wizard.play("idle")
			if !wallJump:
				velocity.x = move_toward(velocity.x, 0, speed * speed_multiplier)
		
		move_and_slide()
	else:
		$Wizard.stop()

func dashFunc(dashDir):
	$Wizard.play("dash")
	velocity.y = 0
	if dashDir == "right":
		#move_and_collide(Vector2(-, 0))
		await get_tree().create_timer(.15).timeout
		move_and_collide(Vector2(175, 0))
	else:
		#move_and_collide(Vector2(25, 0))
		await get_tree().create_timer(.15).timeout
		move_and_collide(Vector2(-175, 0))

func atkFunc(type) -> void:
	# always moving horizontally
	if dir[1] != 0:
		dir = Vector2(dir[0], 0)
	
	# always at max sleep
	if dir[0] > 0:
		dir[0] = 1
	elif dir[0] < 0:
		dir[0] = -1
	
	# FIRE
	if count > -1:
		count -= 1
		if dir != Vector2(0,0):
			if is_on_floor():
				$Wizard.play("fireball")
			var fireball = fireball_scene.instantiate()
			get_parent().add_child(fireball)
			fireball.position.x = position.x + 350
			fireball.position.y = position.y + 120
			fireball.direction = dir
			
			reload()

func reload():
	var cooldown = (3-count) * reload_time
	await get_tree().create_timer(cooldown).timeout
	count += 1

func _on_finishAnimation(name: String):
	if name == "fireball":
		await get_tree().create_timer(2).timeout
		$Wizard.stop()

func resetClimbing():
	isClimbingUp = false
	isClimbingDown = false
	HoldingPosition = false
	isHoldingPosition = false

func climbingSprite(delta):
	# Toggle for climbing bugs:
	# print(isClimbingUp, isClimbUpPressed, isClimbingDown ,isClimbDownPressed,HoldingPosition, isHoldingPosition)
	if onWall:
		if Input.is_action_pressed("hold_position") and !isHoldingPosition:
			HoldingPosition = !HoldingPosition
			isHoldingPosition = true
		elif Input.is_action_just_released("hold_position"):
			HoldingPosition = !HoldingPosition
			isHoldingPosition = false
		if HoldingPosition:
			if Input.is_action_pressed("climb_up") and !isClimbUpPressed:
				isClimbingUp = !isClimbingUp
				isClimbUpPressed = true
			elif Input.is_action_just_released("climb_up"):
				isClimbingUp = !isClimbingUp
				isClimbUpPressed = false
			if Input.is_action_pressed("climb_down") and !isClimbDownPressed:
				isClimbingDown = !isClimbingDown
				isClimbDownPressed = true
			elif Input.is_action_just_released("climb_down"):
				isClimbingDown = !isClimbingDown
				isClimbDownPressed = false
			
		if isClimbingUp:
			velocity.y = -100
		elif isClimbingDown:
			velocity.y = 100

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.is_in_group("enemy"):
		targetBody = body
		doingDamage = true
func _on_area_2d_body_exited(body: Node2D) -> void:
	if body.is_in_group("enemy"):
		doingDamage = false
