extends TileMapLayer
class_name Map
 

const map = preload("res://Game/Map/map.tscn")

var player : Player

var terrains : Dictionary

static func new_map() -> Map:
	return map.instantiate()

func is_close_to_base(player_position : Vector2) -> bool:
	var surrounding : Array[Vector2i] = get_surrounding_cells(Vector2i.ZERO)
	surrounding.append(Vector2i.ZERO)
	return surrounding.has(local_to_map(player_position))

func _ready() -> void:
	position -= Vector2(-8, -7) #centering the center hex
	player = Player.new_player()
	add_child(player)
	add_child(Terrain.new_terrain("abcdefghijklmnoprstqwxyz", Terrain.EffectType.STOP))
	Waves.wave0()
	

func add_terrain(terrain_name : String, info : Dictionary) -> void:
	print(terrain_name)
	var terrain_position = local_to_map(player.position)
	var terrain = Terrain.new_terrain(terrain_name, Terrain.EffectType[info["type"]])
	terrains[terrain_position] = terrain
	terrain.position = map_to_local(terrain_position)
	set_cell(terrain_position, 0, Vector2i(int(info["atlas_coords"]["x"]), int(info["atlas_coords"]["y"])))
