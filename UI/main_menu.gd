extends Control


func _on_play_pressed() -> void:
	get_tree().paused = false
	get_tree().change_scene_to_file("res://Game/game.tscn")
	
