extends Area2D

onready var player: Player = get_tree().get_root().find_node("Player",true,false) as Player

var GOOD_APPLE_ENERGY: float = 40
var BAD_APPLE_ENERGY: float = -40
var energy: float = GOOD_APPLE_ENERGY
var REDUCED_SIZE_FACTOR: float = 0.75

func _on_Apple_body_entered(body: Node2D):
	match body.name:
		"Player":
			player_eat_Apple()
		"Worm":
			worm_eat_Apple(body)
		_:
			print("Unexpected body enter apple:" + body.name)		
			
func player_eat_Apple():
	if player:
		player.energy += energy
	self.queue_free()
		
func worm_eat_Apple(worm: Node2D):
	energy = BAD_APPLE_ENERGY
	self.scale *= REDUCED_SIZE_FACTOR
	worm.eating = true
	# Change sprite
	
