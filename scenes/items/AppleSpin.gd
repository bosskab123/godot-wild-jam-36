tool
extends Spatial

func _process(delta):
	transform = transform.rotated(Vector3.UP, PI/2 * delta)
