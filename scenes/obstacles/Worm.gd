extends KinematicBody2D

export(float) var TIME_TO_REACH_APPLE = 2 # sec
export(NodePath) onready var apple = get_node(apple) as Node2D

var move_vector: Vector2 = Vector2.ZERO
var is_eating: bool = false
var is_jumping: bool = false

func _ready():
	if apple.position.x <= position.x:
		$AnimatedSprite.flip_h = true

func _physics_process(delta):
	if is_eating:
		queue_free()
	move_vector += Vector2.DOWN * GlobalVars.GRAVITY
	move_vector = move_and_slide(move_vector, Vector2.UP)
	
	if is_jumping:
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
	
func calculate_jump_to_apple_vector() -> Vector2:
	var t  = TIME_TO_REACH_APPLE
	var dest_x = apple.position.x
	var dest_y = apple.position.y
	
	# u = s/t - 1/2at
	var init_x = (dest_x - position.x) / t
	var init_y = ((dest_y - position.y)/t) - ((Engine.iterations_per_second * GlobalVars.GRAVITY * t)/2)
	
	return Vector2(init_x, init_y) 
