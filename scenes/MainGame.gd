extends Node2D

onready var row_position_map = {
	0: $Row1SpawnPosition,
	1: $Row2SpawnPosition
}

func _ready():
	instance_chunks(3)

# instance first [num_chunks] chunks to the game
func instance_chunks(num_chunks: int):
	for chunk in num_chunks:
		for row in GlobalVars.ROWS_NUMBER:
			instance_chunk_row(row)
	
	$SpawnLine.position.x += num_chunks * GlobalVars.CHUNK_LENGTH
	
func instance_chunk_row(row_num: int):
	randomize()
	var row_spawn_position: Position2D = row_position_map[row_num]
	var chunk_rows = GameManager.chunk_rows[row_num]
	var random_chunk_row: Node2D = chunk_rows[randi() % chunk_rows.size()].instance()
	
	random_chunk_row.position = row_spawn_position.position
	add_child(random_chunk_row)
	
	row_spawn_position.position.x += GlobalVars.CHUNK_LENGTH

func _on_SpawnLine_body_entered(body):
	if body.name != "Player":
		return
	instance_chunks(3)
	
