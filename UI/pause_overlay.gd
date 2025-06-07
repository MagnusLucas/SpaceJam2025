extends Control
func _on_button_pressed() -> void:	
	get_tree().paused = false
	get_tree().change_scene_to_file("res://Game/game.tscn")
func _on_button_2_pressed() -> void:
	get_tree().change_scene_to_file("res://UI/main_menu.tscn")
