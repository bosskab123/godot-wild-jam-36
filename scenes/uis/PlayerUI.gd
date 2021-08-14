extends CanvasLayer

export(NodePath) onready var player = get_node(player) as Player

func _process(delta):
	$EnergyProgressBar.value = player.energy
