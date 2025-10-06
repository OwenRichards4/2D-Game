extends CharacterBody2D

var player = null
var health = 20
var can_see : bool = false
var can_attack = false
var cooldown = true
var cooldown2 = false
var swordPosition : Vector2
var animations = ["attack", "damage", "death"]
var count = 0
var just_hit = false
var just_hurt = false
var dead = false
var currBody = null

var rng = RandomNumberGenerator.new()

func _ready():
	player = get_tree().get_first_node_in_group("player")
	add_to_group("enemy")
	$AnimatedSprite2D.play("idle")

func _process(delta: float) -> void:
	player =  get_tree().get_first_node_in_group("player")
	if !dead:
		if player and can_see:
			if $AnimatedSprite2D.animation not in animations or $AnimatedSprite2D.animation == "idle":
				$AnimatedSprite2D.play('walk')
			
			var direction = global_position.direction_to(Vector2(player.global_position.x + 60, player.global_position.y))
			
			if direction[0] > 0:
				if can_attack:# and direction[0] < 0.65:
					attack()
				$AnimatedSprite2D.flip_h = false
				swordPosition = Vector2(541.25, 116.25)
			else:
				if can_attack:# and direction[0] > -0.65:
					attack()
				$AnimatedSprite2D.flip_h = true
				swordPosition = Vector2(61, 116.25)
			$Area2D/CollisionShape2D.position = swordPosition
			velocity = direction * Global.mob_speed
			
			if $AnimatedSprite2D.animation == "attack" and $AnimatedSprite2D.frame == 9:
				$AnimatedSprite2D.stop()
				$AnimatedSprite2D.play('walk')
			if $AnimatedSprite2D.animation == "attack" and $AnimatedSprite2D.frame == 5 and !just_hit and can_attack:
				cooldown = true
				hit()
				if currBody != null and currBody.has_method("hurt"):
					currBody.hurt()
				Global.player_health -= 2.5
				#Global.atk_progress += 1
			if $AnimatedSprite2D.animation == "damage" and $AnimatedSprite2D.frame == 4:
				$AnimatedSprite2D.play('idle')
			
			if !is_on_floor():
				velocity.y = Global.gravity * delta
		elif !can_see and !cooldown2:
			var rng_time = round(rng.randf_range(2, 5))
			var rng_direction = rng.randf_range(-1, 1)
			if rng_direction > 0: 
				$AnimatedSprite2D.flip_h = false
				rng_direction = 1
			else:
				$AnimatedSprite2D.flip_h = true
				rng_direction = -1
			cooldown2 = true
			$AnimatedSprite2D.play('walk')
			for i in rng_time:
				if is_on_wall():
					break
				velocity = Vector2(rng_direction * Global.mob_speed, 0)
				await get_tree().create_timer(1).timeout
			velocity = Vector2(0, 0)
			$AnimatedSprite2D.play('idle')
			await get_tree().create_timer(1).timeout
			cooldown2 = false
		
		if health <= 0:
			dead = true
			$AnimatedSprite2D.play('death')
			velocity = Vector2(0,0)
			$CollisionShape2D.disabled = true
			await get_tree().create_timer(8).timeout
			
			queue_free()
	
	move_and_slide()

func attack():
	if cooldown and can_attack:
		$AnimatedSprite2D.play("attack")
		$Timer.start(2.0)
		cooldown = false

func hit():
	just_hit = true

func _on_timer_timeout() -> void:
	cooldown = true
	just_hit = false

# Attack Check
func _on_area_2d_body_entered(body: Node2D) -> void:
	currBody = body
	can_attack = true
func _on_area_2d_body_exited(body: Node2D) -> void:
	currBody = null
	can_attack = false

# Tracking Check
func _on_area_2d_2_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		can_see = true
func _on_area_2d_2_body_exited(body: Node2D) -> void:
	if body.is_in_group("player"):
		can_see = false

func damage():
	if !just_hurt:
		$AnimatedSprite2D.play('damage')
		health -= 5
		Global.atk_progress += 1
		timeout()

func timeout():
	just_hurt = true
	await get_tree().create_timer(1).timeout
	just_hurt = false
