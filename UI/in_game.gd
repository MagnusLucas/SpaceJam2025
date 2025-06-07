extends Control

var data : Dictionary

func _ready() -> void:
	load_data()
	$"../PauseOverlay".hide()
	$"../Control/Map/Player/Node2D/TextureProgressBar".show()
	get_tree().paused = false

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
			get_node("/root/Game/Control/Map").add_terrain(key, data[key])
			$Label.text = ""
	

func _unhandled_input(event : InputEvent) -> void:
	if event is InputEventKey:
		if event.pressed and event.keycode == KEY_ESCAPE:
			get_tree().paused = true
			$"../PauseOverlay".show()
			$"../Control/Map/Player/Node2D/TextureProgressBar".hide()
