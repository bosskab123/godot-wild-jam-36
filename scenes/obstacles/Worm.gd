extends KinematicBody2D

export(float) var TIME_TO_REACH_APPLE = 1 # sec
export(NodePath) onready var apple = get_node(apple) as Node2D

onready var sound_eat_apple: AudioStreamPlayer2D = $SoundEatApple as AudioStreamPlayer2D

onready var initial_transform: Transform2D = self.transform
var move_vector: Vector2 = Vector2.ZERO
var is_eating: bool = false setget set_is_eating
var is_jumping: bool = false
var is_spawnable: bool = false

func on_chunk_spawned() -> void:
	if is_spawnable and randi() % 10 == 0:
		set_is_eating(false)

func _ready():
	get_tree().current_scene.connect("chunk_spawned", self, "on_chunk_spawned")
	if apple.position.x <= position.x:
		$AnimatedSprite.flip_h = true

func _physics_process(delta):
	if is_jumping:
		move_vector += Vector2.DOWN * GlobalVars.GRAVITY
		move_vector = move_and_slide(move_vector, Vector2.UP)
		check_animation()

func check_animation():
	if move_vector.y >= 50 and $AnimatedSprite.animation != "fall":
		$AnimatedSprite.play("fall")
	if move_vector.y <= -50 and $AnimatedSprite.animation != "jump":
		$AnimatedSprite.play("jump")
	if move_vector.y >= -50 and move_vector.y <= 10 and $AnimatedSprite.animation != "fly":
		$AnimatedSprite.play("fly")
		
func _on_Area2D_body_entered(body):
	if body.name == "Player" and !is_jumping:
		move_vector = calculate_jump_to_apple_vector()
		is_jumping = true
		$DeadTimer.start()
		rotation = 0
		z_index = 0
	
func calculate_jump_to_apple_vector() -> Vector2:
	var t  = TIME_TO_REACH_APPLE
	var dest_x = apple.position.x
	var dest_y = apple.position.y
	
	# u = s/t - 1/2at
	var init_x = (dest_x - position.x) / t
	var init_y = ((dest_y - position.y)/t) - ((Engine.iterations_per_second * GlobalVars.GRAVITY * t)/2)
	
	return Vector2(init_x, init_y) 

func set_is_eating(val):
	if val == false:
		# respawn worm to original position
		move_vector = Vector2.ZERO
		set_deferred("monitorable", true)
		$Area2D.set_deferred("monitoring", true)
		$AnimatedSprite.play("idle")
		transform = initial_transform
		is_spawnable = false
		is_jumping = false
		self.show()
	else:
		# fake queue_free worm
		set_deferred("monitorable", false)
		$Area2D.set_deferred("monitoring", false)
		self.hide()
		$RespawnTimer.start()
	is_eating = val

func _on_RespawnTimer_timeout():
	is_spawnable = true

func _on_DeadTimer_timeout():
	set_is_eating(true)
