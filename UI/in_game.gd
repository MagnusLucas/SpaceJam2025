extends Control

var data : Dictionary

func _ready() -> void:
	load_data()

func load_data() -> void:
	var file = FileAccess.open("res://Game/GameData.json", FileAccess.READ)
	var content = file.get_as_text()
	var json = JSON.new()
	json.parse(content)
	data = json.data

func add_letter(letter : String) -> void:
	$Label.text += letter
	check()

func clear() -> void:
	$Label.text = ""
	
func check() -> void:
	for key in data:
		if key == $Label.text:
			print("!word: ", key)
			return
	
