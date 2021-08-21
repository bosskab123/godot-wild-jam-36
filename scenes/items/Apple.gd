extends Area2D

var GOOD_APPLE_ENERGY: float = 30
var BAD_APPLE_ENERGY: float = -40
var energy: float = GOOD_APPLE_ENERGY
var FADEOUT_TIME: float = 0.3
var shader_weight: float = 0

var is_ate_by_player: bool = false setget set_is_ate_by_player 
var is_spawnable: bool = false

func _ready():
	var scene = get_tree().current_scene
	get_tree().current_scene.connect("chunk_spawned", self, "on_chunk_spawned")

func on_chunk_spawned() -> void:
	if is_spawnable and randi() % 10 == 0:
		set_is_ate_by_player(false)

func _process(delta):
	$Sprite.material.set_shader_param("weight", shader_weight)

func _on_Apple_body_entered(body: Node2D):
	match body.name:
		"Player":
			player_eat_Apple(body)
		"Worm":
			worm_eat_Apple(body)
		_:
			printerr("Unexpected body enter apple:" + body.name)		

func set_is_ate_by_player(val):
	if val:
		# fake dequeue apple
		$RespawnTimer.start()
		is_spawnable = false
		set_deferred("monitoring", false)
		self.hide()
	else:
		# respawn apple
		shader_weight = 0
		energy = GOOD_APPLE_ENERGY
		set_deferred("monitoring", true)
		self.show()
	is_ate_by_player = val

func player_eat_Apple(player):
	if player:
		player.energy_set(energy+player.energy)
		if energy < 0:
			player.sound_eat_bad_apple.play()
		else:
			player.sound_eat_good_apple.play()
		set_is_ate_by_player(true)

func worm_eat_Apple(worm: Node2D):
	energy = BAD_APPLE_ENERGY
	worm.set_is_eating(true)
	# Change sprite
	$Tween.interpolate_property(self, "shader_weight", 0, 1,
		FADEOUT_TIME, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	$Tween.start()
	$RottenTimer.start()
	yield($Tween, "tween_all_completed")
	$Particles2D.emitting = true

func _on_RespawnTimer_timeout():
	is_spawnable = true

func _on_RottenTimer_timeout():
	energy = GOOD_APPLE_ENERGY
	$Tween.interpolate_property(self, "shader_weight", 1, 0,
		FADEOUT_TIME, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	$Tween.start()
	$Particles2D.emitting = false
