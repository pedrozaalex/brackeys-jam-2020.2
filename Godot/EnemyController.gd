extends Node

enum PLAYBACK_MODE { NORMAL, REWIND }
enum INPUTS { MOVE_VECTOR_CHANGED }

onready var enemy = $".."

var playback_mode = PLAYBACK_MODE.NORMAL
var effective_frame = 0
var inputs = []

var move_vector = Vector2.ZERO

var move_dirs = [Vector2.ZERO, Vector2.RIGHT, Vector2.DOWN, Vector2.LEFT, Vector2.UP]
var frames_per_move = 30
var move_starting_frame = 0
var current_move = 0

func _ready():
	inputs.append([0, INPUTS.MOVE_VECTOR_CHANGED, move_vector])

func _physics_process(delta):
	if playback_mode == PLAYBACK_MODE.NORMAL:
		effective_frame += 1
		
		if (effective_frame - move_starting_frame) > frames_per_move:
			move_starting_frame = effective_frame
			current_move = (current_move + 1) % len(move_dirs)
			update_move_vector(move_dirs[current_move])
		
		enemy.move(move_vector, delta)
	elif playback_mode == PLAYBACK_MODE.REWIND:
		effective_frame = max(0, effective_frame - 1)
		move_vector = get_move_vector_at_frame(effective_frame)
		enemy.move(move_vector, -delta)

func update_move_vector(new_vector):
	var old_move_vector = move_vector
	
	move_vector = new_vector
	
	if move_vector != old_move_vector:
		inputs.append([effective_frame, INPUTS.MOVE_VECTOR_CHANGED, move_vector])

func get_move_vector_at_frame(frame):
	var result
	for i in range(len(inputs)):
		if inputs[i][0] > frame:
			break
		
		if inputs[i][1] == INPUTS.MOVE_VECTOR_CHANGED:
			result = inputs[i][2]
	
	return result

func begin_rewind():
	playback_mode = PLAYBACK_MODE.REWIND

func end_rewind():
	playback_mode = PLAYBACK_MODE.NORMAL
	
	move_starting_frame = effective_frame
	
	for i in range(len(inputs) - 1, 0, -1):
		if inputs[i][0] > effective_frame:
			inputs.remove(i)
