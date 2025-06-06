extends TileMapLayer
class_name Map

const map = preload("res://Game/Map/map.tscn")

static func new_map() -> Map:
	return map.instantiate()

func is_close_to_base(player_position : Vector2) -> bool:
	var surrounding : Array[Vector2i] = get_surrounding_cells(Vector2i.ZERO)
	surrounding.append(Vector2i.ZERO)
	return surrounding.has(local_to_map(player_position))

func _ready() -> void:
	position -= Vector2(-8, -7) #centering the center hex
	var player = Player.new_player()
	add_child(player)
