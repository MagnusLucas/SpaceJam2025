extends TileMapLayer
class_name Map

const map = preload("res://Game/Map/map.tscn")

static func new_map() -> Map:
	return map.instantiate()
