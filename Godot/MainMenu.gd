extends Control

var start_game_func : FuncRef

func _on_QuitButton_pressed():
	get_tree().quit()

func _on_Play_pressed():
	start_game_func.call_func()
