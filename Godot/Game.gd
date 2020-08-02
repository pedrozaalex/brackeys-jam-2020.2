extends Node

var world
var ui

func _ready():
	load_main_menu()

func clear_current_scenes():
	if world:
		world.queue_free()
		world = null
	
	if ui:
		ui.queue_free()
		ui = null

func load_main_menu():
	clear_current_scenes()
	ui = load("res://MainMenu.tscn").instance()
	add_child(ui)
	ui.start_game_func = funcref(self, "load_game")

func load_game():
	clear_current_scenes()
	world = load("res://TestLevel.tscn").instance()
	add_child(world)
	ui = load("res://HUD.tscn").instance()
	add_child(ui)
	world.main_menu_func = funcref(self, "load_main_menu")
