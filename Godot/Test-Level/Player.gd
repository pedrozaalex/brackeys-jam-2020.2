extends Node2D

export (float) var SPEED = 200
export (float) var MAX_CAM_DISTANCE = 150
export (float) var SCREEN_DRAG_BORDER_MIN = 256
export (float) var SCREEN_DRAG_BORDER_MAX = 128

onready var camera = $Camera2D
onready var viewport = get_viewport()

var move_vector = Vector2.ZERO

func _unhandled_input(event):
	if event.is_action("move_right") or event.is_action("move_left"):
		move_vector.x = int(Input.is_action_pressed("move_right")) - int(Input.is_action_pressed("move_left"))
	elif event.is_action("move_down") or event.is_action("move_up"):
		move_vector.y = int(Input.is_action_pressed("move_down")) - int(Input.is_action_pressed("move_up"))

func _physics_process(delta):
	adjust_camera()

func move(vector, delta):
	position += vector * SPEED * delta

# WARNING THIS WONT WORK AT OTHER RESOLUTIONS!
# OH MY GOLLY GEE THAT IS SOME GOREY CODE CRIMENY
func adjust_camera_horizontal(mouse_x):
	if mouse_x >= 1280 - SCREEN_DRAG_BORDER_MIN:
		camera.position.x = lerp(0, MAX_CAM_DISTANCE, min((mouse_x - (1280 - SCREEN_DRAG_BORDER_MIN)) / SCREEN_DRAG_BORDER_MAX, 1))
	elif mouse_x < SCREEN_DRAG_BORDER_MIN:
		camera.position.x = lerp(0, -MAX_CAM_DISTANCE, min(1, (1.0 - ((mouse_x - SCREEN_DRAG_BORDER_MAX) / (SCREEN_DRAG_BORDER_MIN - SCREEN_DRAG_BORDER_MAX)))))
	else:
		camera.position.x = 0

func adjust_camera_vertical(mouse_y):
	if mouse_y >= 720 - SCREEN_DRAG_BORDER_MIN:
		camera.position.y = lerp(0, MAX_CAM_DISTANCE, min((mouse_y - (720 - SCREEN_DRAG_BORDER_MIN)) / SCREEN_DRAG_BORDER_MAX, 1))
	elif mouse_y < SCREEN_DRAG_BORDER_MIN:
		camera.position.y = lerp(0, -MAX_CAM_DISTANCE, min(1, (1.0 - ((mouse_y - SCREEN_DRAG_BORDER_MAX) / (SCREEN_DRAG_BORDER_MIN - SCREEN_DRAG_BORDER_MAX)))))
	else:
		camera.position.y = 0

func adjust_camera():
	var mouse_pos = viewport.get_mouse_position()
	adjust_camera_horizontal(mouse_pos.x)
	adjust_camera_vertical(mouse_pos.y)
