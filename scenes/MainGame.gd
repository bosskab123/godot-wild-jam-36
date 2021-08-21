extends Node2D

onready var row_position_map = {
	0: $Row1SpawnPosition,
	1: $Row2SpawnPosition
}

onready var background_node = {
	"primary": [$Background/PrimaryBackground1,$Background/PrimaryBackground2,$Background/PrimaryBackground3,$Background/PrimaryBackground4],
	"secondary": [$Background/SecondaryBackground1,$Background/SecondaryBackground2,$Background/SecondaryBackground3,$Background/SecondaryBackground4],
	"sky": $Background/SkyBackground
}

onready var background_detector_node = {
	"primary": $Background/PrimaryBackgroundDetector,
	"secondary": $Background/SecondaryBackgroundDetector
}

onready var score_node = $CanvasLayer/VBoxContainer/Score as Label
onready var sound_danger: AudioStreamPlayer = $Sound/SoundDanger as AudioStreamPlayer
onready var sound_normal: AudioStreamPlayer = $Sound/SoundNormal as AudioStreamPlayer
onready var sound_game_over: AudioStreamPlayer = $Sound/SoundGameOver as AudioStreamPlayer
onready var deadwall = $DeadWall
onready var player = $Player

var sound_danger_lastest_position: float
var sound_normal_lastest_position: float

var total_chunk: int = 1
var showing_chunk_number: Array = []
var available_chunks: Array = []
var total_primary_background: int = 4
var showing_primary_background_number: Array = [1,2,3,4]
var total_secondary_background: int = 4
var showing_secondary_background_number: Array = [1,2,3,4]

var PRIMARY_BACKGROUND_WIDTH: float = 535
var PRIMARY_BACKGROUND_LENGTH: float = 438
var SECONDARY_BACKGROUND_WIDTH: float = 240
var SECONDARY_BACKGROUND_LENGTH: float = 427
var BACKGROUND_POSITION_Y: float = 80

var score: int = 0
var SCORE_MULTIPLIER: float = 0.678
var PLAYER_INITIAL_POSITION = Vector2(92.466,176)

var DIFFICULTY_MOVEMENT_MULTIPLIER: float = 1.03

signal chunk_spawned()

func _ready():
	# Initialize background
	setup_background()
	# Setup SpawnPosition for each row
	row_position_map[GlobalVars.ROWS_NUMBER-1].position.y = 0
	for row in range(GlobalVars.ROWS_NUMBER-2,-1,-1):
		row_position_map[row].position.y = row_position_map[row+1].position.y + (GlobalVars.ROWS_NUMBER-1) * (GlobalVars.PADDING_WIDTH + GlobalVars.CHUNK_WIDTH)
	# Setup available_chunks to be reposition later
	for number in range(1,GlobalVars.CHUNKS_NUMBER+1):
		available_chunks.append(number)
	# Add all chunks instance into the main scene
	for row in range(GlobalVars.ROWS_NUMBER):
		for chunk in range(GlobalVars.CHUNKS_NUMBER):
			add_child(GameManager.chunk_rows[row][chunk])
	# Initialize 1 initial chunks to be the starting point
	for block in range(1):
		var initial_chunk_instance = GameManager.initial_chunk_scene.instance()
		initial_chunk_instance.position.x = block * (GlobalVars.CHUNK_LENGTH + GlobalVars.PADDING_LENGTH)
		initial_chunk_instance.position.y = row_position_map[0].position.y
		add_child(initial_chunk_instance)
	# Set up spawnline
	$SpawnLine.position.x = (GlobalVars.CHUNK_LENGTH + GlobalVars.PADDING_LENGTH) * .3
	# Play background sound
	sound_normal.play()

func _process(delta):
	score = max(score, int($Player.position.x - PLAYER_INITIAL_POSITION.x) * SCORE_MULTIPLIER)
	score_node.text = str(int(score * SCORE_MULTIPLIER))

func setup_background():
	# Setup primary and secondary background
	for i in range(4):
		background_node["primary"][i].position = Vector2((i*2+1)*(PRIMARY_BACKGROUND_LENGTH/2),BACKGROUND_POSITION_Y)
		background_node["secondary"][i].position = Vector2((i*2+1)*(SECONDARY_BACKGROUND_LENGTH/2),BACKGROUND_POSITION_Y)
	# Setup PrimaryBackgroundDetector and SecondaryBackgroundDetector position
	background_detector_node["primary"].position = Vector2(3*PRIMARY_BACKGROUND_LENGTH,240)
	background_detector_node["secondary"].position = Vector2(3*SECONDARY_BACKGROUND_LENGTH,240)
	
func add_chunk():
	# Random a chunk to be added
	available_chunks.shuffle()
	var chunk_number = available_chunks.pop_back()
	showing_chunk_number.append(chunk_number)
	# Reposition the added chunk
	for row in range(GlobalVars.ROWS_NUMBER):
		GameManager.chunk_rows[row][chunk_number-1].position.x = total_chunk * (GlobalVars.CHUNK_LENGTH + GlobalVars.PADDING_LENGTH)
		GameManager.chunk_rows[row][chunk_number-1].position.y = row_position_map[row].position.y
		emit_signal("chunk_spawned")
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
		$DeadWall.position.x = max((total_chunk-2) * (GlobalVars.CHUNK_LENGTH + GlobalVars.PADDING_LENGTH),$DeadWall.position.x)
	# Reposition a chunk for the next one
	add_chunk()
	# Move the SpawnLine
	$SpawnLine.position.x += GlobalVars.CHUNK_LENGTH + GlobalVars.PADDING_LENGTH
	# Increase MOVEMENT DIFFICULTY
	player.set_move_vector(player.get_move_vector() * DIFFICULTY_MOVEMENT_MULTIPLIER )
	deadwall.MOVE_SPEED *= DIFFICULTY_MOVEMENT_MULTIPLIER
	

func _on_DestroyLine_body_entered(body):
	if body.name != "DeadWall":
		return
	# Transfer the oldest added chunk into available group
	var chunk_number = showing_chunk_number.pop_front()
	available_chunks.append(chunk_number)
	# Move the DestroyLine
	$DestroyLine.position.x += GlobalVars.CHUNK_LENGTH + GlobalVars.PADDING_LENGTH

func _on_PrimaryBackgroundDetector_body_entered(body):
	if body.name != "Player":
		return
	# Move the most left background to the most right one
	background_node["primary"][showing_primary_background_number[0]-1].position.x += 4*PRIMARY_BACKGROUND_LENGTH
	showing_primary_background_number.append(showing_primary_background_number.pop_front())
	# Move PrimaryBackgroundDetector
	background_detector_node["primary"].position.x += PRIMARY_BACKGROUND_LENGTH

func _on_SecondaryBackgroundDetector2_body_entered(body):
	if body.name != "Player":
		return
	# Move the most left background to the most right one
	background_node["secondary"][showing_secondary_background_number[0]-1].position.x += 4*SECONDARY_BACKGROUND_LENGTH
	showing_secondary_background_number.append(showing_secondary_background_number.pop_front())
	# Move SecondaryBackgroundDetector
	background_detector_node["secondary"].position.x += SECONDARY_BACKGROUND_LENGTH

func _on_DeadWall_screen_entered():
	# Change background music
	if sound_normal.playing:
		sound_normal_lastest_position = sound_normal.get_playback_position()
		sound_normal.stop()
	sound_danger.play(sound_danger_lastest_position)
	# Start deadwall sound
	deadwall.sound_walk.play()

func _on_DeadWall_screen_exited():
	# Change background music
	sound_danger_lastest_position = sound_danger.get_playback_position()
	sound_danger.stop()
	# Stop deadwall sound
	deadwall.sound_walk.stop()
	# Resume normal sound
	sound_normal.play(sound_normal_lastest_position)
