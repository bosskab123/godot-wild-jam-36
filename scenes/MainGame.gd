extends Node2D

onready var row_position_map = {
	0: $Row1SpawnPosition,
	1: $Row2SpawnPosition
}

var total_chunk: int = 3
var showing_chunk_number: Array = []
var available_chunks: Array = []

func _ready():
	# Setup SpawnPosition for each row
	row_position_map[GlobalVars.ROWS_NUMBER-1].position.y = 0
	for row in range(GlobalVars.ROWS_NUMBER-2,0):
		row_position_map[row].position.y = row_position_map[row+1].position.y + GlobalVars.PADDING_WIDTH + GlobalVars.CHUNK_WIDTH
	# Setup available_chunks to be reposition later
	for number in range(1,GlobalVars.CHUNKS_NUMBER+1):
		available_chunks.append(number)
	# Add all chunks instance into the main scene
	for row in range(GlobalVars.ROWS_NUMBER):
		for chunk in range(GlobalVars.CHUNKS_NUMBER):
			add_child(GameManager.chunk_rows[row][chunk])
	# Initialize 3 initial chunks to be the starting point
	for block in range(3):
		var initial_chunk_instance = GameManager.initial_chunk_scene.instance()
		initial_chunk_instance.position.x = block * GlobalVars.CHUNK_LENGTH
		initial_chunk_instance.position.y = row_position_map[0].position.y
		add_child(initial_chunk_instance)
	# Add Deadwall at the origin
	
	# Set up spawnline
	$SpawnLine.position.x = GlobalVars.CHUNK_LENGTH * 2
		
func add_chunk():
	# Random a chunk to be added
	randomize()
	available_chunks.shuffle()
	var chunk_number = available_chunks.pop_back()
	showing_chunk_number.append(chunk_number)
	# Reposition the added chunk
	for row in range(GlobalVars.ROWS_NUMBER):
		GameManager.chunk_rows[row][chunk_number-1].position.x = total_chunk * GlobalVars.CHUNK_LENGTH
		GameManager.chunk_rows[row][chunk_number-1].position.y = row_position_map[row].position.y
	# Increase the number of total chunk
	total_chunk += 1

func _on_SpawnLine_body_entered(body):
	if body.name != "Player":
		return
	# Adjust the showing_chunk_number to be size less than 4
	if len(showing_chunk_number) > 4:
		var chunk_number = showing_chunk_number.pop_front()
		available_chunks.append(chunk_number)
		# Adjust Deadwall position
		$DeadWall.position.x = (total_chunk-2) * GlobalVars.CHUNK_LENGTH
	# Reposition a chunk for the next one
	add_chunk()	
	# Move the SpawnLine
	$SpawnLine.position.x += GlobalVars.CHUNK_LENGTH


func _on_DestroyLine_body_entered(body):
	if body.name != "DeadWall":
		return
	# Transfer the oldest added chunk into available group
	var chunk_number = showing_chunk_number.pop_front()
	available_chunks.append(chunk_number)
	# Move the DestroyLine
	$DestroyLine.position.x += GlobalVars.CHUNK_LENGTH
