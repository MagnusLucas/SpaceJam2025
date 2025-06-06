extends Control
var dir := DirAccess.open("res://Game/Objects/")

func _ready() -> void:
	pass
	

func add_letter(letter : String) -> void:
	$Label.text += letter

func clear() -> void:
	$Label.text = ""
	
func check() -> void:
	if $Label.text in dir.get_files():
		pass
		
