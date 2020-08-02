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
	ui = load("res://MainMenu.tscn").instance()
	add_child(ui)
