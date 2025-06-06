extends TileMapLayer
class_name Map

const map = preload("res://Game/Map/map.tscn")

static func new_map() -> Map:
	return map.instantiate()


func _ready() -> void:
	position -= Vector2(-8, -7) #centering the center hex
	var player = Player.new_player()
	add_child(player)
	add_child(Enemy.new_enemy('e',Vector2i(250,250),Vector2i(500,500)))
