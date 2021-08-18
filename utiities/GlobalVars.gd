extends Node

var ROWS_NUMBER: int = 2
var CHUNKS_NUMBER: int = 10
var BLOCK_SIZE: int = 16
var CHUNK_WIDTH: int = 15 * BLOCK_SIZE
var CHUNK_LENGTH: int = 30 * BLOCK_SIZE
var PADDING_WIDTH: int = 60

var GRAVITY: float = 10
enum FACING {LEFT = -1, RIGHT = 1}
