extends Control

var data : Dictionary

func load_data() -> void:
	var file = FileAccess.open("res://Game/GameData.json", FileAccess.READ)
	var content = file.get_as_text()
	var json = JSON.new()
	json.parse(content)
	data = json.data

func _ready() -> void:
	for effect in Terrain.EffectType:
		$VBoxContainer/ItemList.add_item(effect)


func _on_button_pressed() -> void:
	data[$VBoxContainer/LineEdit.text] = {}
	data[$VBoxContainer/LineEdit.text]["type"] = $VBoxContainer/ItemList.get_item_text($VBoxContainer/ItemList.get_selected_items()[0])
	data[$VBoxContainer/LineEdit.text]["atlas_coords"] = {}
	data[$VBoxContainer/LineEdit.text]["atlas_coords"]["x"] = $VBoxContainer/HBoxContainer/LineEdit.text
	data[$VBoxContainer/LineEdit.text]["atlas_coords"]["y"] = $VBoxContainer/HBoxContainer/LineEdit2.text

	var file = FileAccess.open("res://Game/GameData.json", FileAccess.WRITE)
	file.store_string(JSON.stringify(data))
