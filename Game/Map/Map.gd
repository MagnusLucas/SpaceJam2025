extends TileMapLayer
class_name Map
 

const map = preload("res://Game/Map/map.tscn")

var player : Player

var terrains : Dictionary

var max_health : int 
var health : int = max_health

static func new_map() -> Map:
	return map.instantiate()

func is_close_to_base(player_position : Vector2) -> bool:
	var surrounding : Array[Vector2i] = get_surrounding_cells(Vector2i.ZERO)
	surrounding.append(Vector2i.ZERO)
	return surrounding.has(local_to_map(player_position))

func _ready() -> void:
	$"../../LoseOverlay".hide()
	position -= Vector2(-8, -7) #centering the center hex
	player = Player.new_player()
	add_child(player)
	add_child(Terrain.new_terrain("abcdefghijklmnoprstqwxyz", Terrain.EffectType.STOP))
	Waves.wave0()
	while get_tree().get_node_count_in_group("Enemy") != 0:
		await get_tree().create_timer(0.2).timeout
	Waves.wave1()
	

func add_terrain(terrain_name : String, info : Dictionary) -> void:
	print(terrain_name)
	var terrain_position = local_to_map(player.position)
	var terrain = Terrain.new_terrain(terrain_name, Terrain.EffectType[info["type"]])
	terrains[terrain_position] = terrain
	add_child(terrain)
	terrain.position = map_to_local(terrain_position)
	set_cell(terrain_position, 0, Vector2i(int(info["atlas_coords"]["x"]), int(info["atlas_coords"]["y"])))
	
func update_health():
	if health <= 0:
		lose()
	@warning_ignore("integer_division")
	get_node("root/Game/TextureProgressBar").value = health / max_health * 100

func _process(delta):
	if Input.is_key_label_pressed(KEY_L):
		lose()
func lose():
	get_tree().paused = true
	$"../../LoseOverlay".show()
	pass
