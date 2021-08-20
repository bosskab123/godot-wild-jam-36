extends CanvasLayer

signal pulse()

const FLASH_RATE = 0.05
const N_FLASHES = 4

export(NodePath) onready var player = get_node(player) as Player
onready var energy_bar = $EnergyBar
onready var update_tween = $UpdateTween

export(Color) var healthy_color = Color.green as Color
export(Color) var caution_color = Color.yellow as Color
export(Color) var danger_color = Color.red as Color
var caution_threshold: float = 0.7
var danger_threshold: float = 0.3

func on_energy_updated(energy):
	var change = energy - energy_bar.value
	update_tween.interpolate_property(energy_bar, "value", energy_bar.value, energy, 0.1, Tween.TRANS_SINE, Tween.EASE_IN_OUT)
	update_tween.start()
	_assign_color(energy)
	
func _assign_color(energy):
	if energy < energy_bar.max_value * danger_threshold:
		energy_bar.get("custom_styles/fg").set_bg_color(danger_color)
	elif energy < energy_bar.max_value * caution_threshold:
		energy_bar.get("custom_styles/fg").set_bg_color(caution_color)
	else:
		energy_bar.get("custom_styles/fg").set_bg_color(healthy_color)
