extends Node

enum PLAYBACK_MODE { NORMAL, REWIND }
enum INPUTS { MOVE_VECTOR_CHANGED }

onready var player = $".."

var playback_mode = PLAYBACK_MODE.NORMAL
var effective_frame = 0
var inputs = []

var move_vector = Vector2.ZERO

func _ready():
	inputs.append([0, INPUTS.MOVE_VECTOR_CHANGED, move_vector])

func _physics_process(delta):
	if playback_mode == PLAYBACK_MODE.NORMAL:
		effective_frame += 1
		player.move(move_vector, delta)
	elif playback_mode == PLAYBACK_MODE.REWIND:
		effective_frame = max(0, effective_frame - 1)
		move_vector = get_move_vector_at_frame(effective_frame)
		player.move(move_vector, -delta)

func update_move_vector():
	var old_move_vector = move_vector
	
	move_vector.x = int(Input.is_action_pressed("move_right")) - int(Input.is_action_pressed("move_left"))
	move_vector.y = int(Input.is_action_pressed("move_down")) - int(Input.is_action_pressed("move_up"))
	
	if move_vector != old_move_vector:
		inputs.append([effective_frame, INPUTS.MOVE_VECTOR_CHANGED, move_vector])

func begin_rewind():
	playback_mode = PLAYBACK_MODE.REWIND

func end_rewind():
	playback_mode = PLAYBACK_MODE.NORMAL
		
	for i in range(len(inputs) - 1, 0, -1):
		if inputs[i][0] > effective_frame:
			inputs.remove(i)
	
	update_move_vector()

func _unhandled_input(event):
	if playback_mode == PLAYBACK_MODE.REWIND:
		return
	
	if event.is_action("move_right") or event.is_action("move_left") or event.is_action("move_down") or event.is_action("move_up"):
		update_move_vector()

func get_move_vector_at_frame(frame):
	var result
	for i in range(len(inputs)):
		if inputs[i][0] > frame:
			break
		
		if inputs[i][1] == INPUTS.MOVE_VECTOR_CHANGED:
			result = inputs[i][2]
	
	return result
