extends Control

func add_letter(letter : String) -> void:
	$Label.text += letter

func clear() -> void:
	$Label.text = ""
