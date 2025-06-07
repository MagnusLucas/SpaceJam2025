extends TileMapLayer
class_name Map
 

const map = preload("res://Game/Map/map.tscn")

var player : Player

var terrains : Dictionary

var max_health : int = 1000
var health : int = max_health

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
	$"../../LoseOverlay".hide()
	$"Player/Node2D/TextureProgressBar".show()
	#$"../../TextureProgressBar".value = 100
	update_health()
	wave0()
	while get_tree().get_node_count_in_group("Enemy") != 0:
		await get_tree().create_timer(0.2).timeout
	for i in range(50):
		expo_wave(i, Vector2(-400,-320),Vector2i(400,-310))
		while get_tree().get_node_count_in_group("Enemy") != 0:
			await get_tree().create_timer(0.2).timeout
	
func update_terrain(prev_pos : Vector2i, curr_pos : Vector2i, terrain : Terrain) -> void:
	var atlas_coords = get_cell_atlas_coords(prev_pos)
	set_cell(prev_pos)
	set_cell(curr_pos, 0, atlas_coords)
	terrains.erase(prev_pos)
	terrains[curr_pos] = terrain
	terrain.position = map_to_local(curr_pos)

#func _physics_process( _delta) -> void:
	#await get_tree().create_timer(3).timeout
	#wave_check_if_stop()

func add_terrain(terrain_name : String, info : Dictionary) -> void:
	var terrain_position = local_to_map(player.position)
	if terrains.has(local_to_map(position)) and terrain_name == "base":
		return
	if terrain_name == "base":
		terrain_position = local_to_map(position)
	var terrain = Terrain.new_terrain(terrain_name, Terrain.EffectType[info["type"]])
	if terrain_name == "base":
		terrain.movable = false
	terrains[terrain_position] = terrain
	add_child(terrain)
	terrain.position = map_to_local(terrain_position)
	set_cell(terrain_position, 0, Vector2i(int(info["atlas_coords"]["x"]), int(info["atlas_coords"]["y"])))

func update_health():
	if health <= 0:
		lose()
	@warning_ignore("integer_division")
	$"../../TextureProgressBar".value = int(float(health) / float(max_health)*100)


func lose():
	get_tree().paused = true
	$Player/Node2D/TextureProgressBar.hide()
	$"../../LoseOverlay".show()

func get_intensity() -> int:
	return get_child_count() * 5

func has_x() -> bool:
	for child in get_children():
		if child is Enemy:
			if child.letter == "x":
				return true
	return false

#--------------------------------------------------------------------------------------------------------
#----------------------------------------waves part------------------------------------------------------
#--------------------------------------------------------------------------------------------------------
#funkcje pomagajæce robi¢ fale
@warning_ignore("shadowed_global_identifier")
func string_to_array(str):
	var tab : Array
	for i in str:
		tab.append(i)
	return tab

#funkcja na pierwszy drop wavea, po to zeby nie bylo 5 razy b na start XD	
func first_drop(rand_let, loc1 : Vector2i, loc2 : Vector2i, time : int = 1 ):
	var rand_let_par = rand_let.duplicate()
	for i in range(len(rand_let_par)):
		var let = rand_let_par.pick_random()
		var new_enemy = Enemy.new_enemy(let,loc1,loc2,100)
		add_child(new_enemy)
		rand_let_par.erase(let)
		await get_tree().create_timer(time).timeout

func duplicates_check(string):
	var p = ""
	@warning_ignore("shadowed_global_identifier")
	for char in string:
		if char not in p:
			p = p+char
	return p

func wave_dead():
	while get_tree().get_node_count_in_group("Enemy") != 0:
		await get_tree().create_timer(0.2).timeout

func random_word():
	var word : String
	#print($"../../Word") 
	var a = $"../../Word".load_data()
	var tab = []
	for i in a:
		tab.append(i)
	word = tab.pick_random()
	return word

#----------------
#ACTUALLY WAVE
#----------------
#wave0 to bedzie turorial

func wave_check_if_stop():
	var check : bool = true
	for i in get_tree().get_nodes_in_group('Enemy'):
		if i.velocity != Vector2(0,0):
			check = false
			break
		else:
			print(i, i.name,i.velocity)
	if check == true:
		await get_tree().create_timer(5).timeout
		for i in get_tree().get_nodes_in_group('Enemy'):
			i.queue_free()
			
			
			

func wave0():
	add_child(Enemy.new_enemy('b',Vector2i(-250,-250),Vector2i(-250,-250),10,false))
	while get_tree().get_node_count_in_group("Enemy") != 0:
		await get_tree().create_timer(0.2).timeout
	add_child(Enemy.new_enemy('a',Vector2i(-400,-320),Vector2i(400,-310)))
	while get_tree().get_node_count_in_group("Enemy") != 0:
		await get_tree().create_timer(0.2).timeout
	add_child(Enemy.new_enemy('s',Vector2i(-400,-320),Vector2i(400,-310)))
	while get_tree().get_node_count_in_group("Enemy") != 0:
		await get_tree().create_timer(0.2).timeout
	add_child(Enemy.new_enemy('e',Vector2i(-400,-320),Vector2i(400,-310)))
	while get_tree().get_node_count_in_group("Enemy") != 0:
		await get_tree().create_timer(0.2).timeout
	
func wave1():
	var rand_let = ['b','a','s','e']
	first_drop(rand_let,Vector2i(-400,-320),Vector2i(400,-310),2)
	for i in range(20):
		add_child(Enemy.new_enemy(rand_let.pick_random(),Vector2i(-400,-320),Vector2i(400,-310),50))
		await get_tree().create_timer(1).timeout
	

func wave2():
	random_word()
	var rand_word = random_word() #tu kiedyß bedzie czytac z listy slow destruktywnych
	var rand_let = string_to_array(rand_word)
	first_drop(rand_let,Vector2i(50,-20),Vector2i(1100,-10),2)
	for i in range(4):
		add_child(Enemy.new_enemy(rand_let.pick_random(),Vector2i(50,-20),Vector2i(1100,-10)))
		await get_tree().create_timer(1).timeout

func wave6():
	var rand_let : Array
	for i in range(2):
		var rand_word = random_word() #tu kiedyß bedzie czytac z listy slow destruktywnych
		rand_let = rand_let + string_to_array(rand_word)
	first_drop(rand_let,Vector2i(50,-20),Vector2i(1100,-10),10)
	for i in range(4):
		add_child(Enemy.new_enemy(rand_let.pick_random(),Vector2i(50,-20),Vector2i(1100,-10)))
		await get_tree().create_timer(1).timeout
		
func wave11():
	var rand_let : Array
	for i in range(3):
		var rand_word = random_word() #tu kiedyß bedzie czytac z listy slow destruktywnych
		rand_let = rand_let + string_to_array(rand_word)
	while len(rand_let) < 10:
		var rand_word = random_word() #tu kiedyß bedzie czytac z listy slow destruktywnych
		rand_let = rand_let + string_to_array(rand_word)
	first_drop(rand_let,Vector2i(50,-20),Vector2i(1100,-10),2)
	#for i in range(4):
		#add_child(Enemy.new_enemy(rand_let.pick_random(),Vector2i(50,-20),Vector2i(1100,-10)))
		#await get_tree().create_timer(1).timeout
		
func expo_wave(lvl : int, loc1 : Vector2i, loc2 : Vector2i):
	var rand_let : Array
	for i in range(lvl):
		var rand_word = random_word() #tu kiedyß bedzie czytac z listy slow destruktywnych
		rand_let = rand_let + string_to_array(rand_word)
	while len(rand_let) < lvl/5:
		var rand_word = random_word() #tu kiedyß bedzie czytac z listy slow destruktywnych
		rand_let = rand_let + string_to_array(rand_word)
	first_drop(rand_let,loc1,loc2,2)
	while get_tree().get_node_count_in_group("Enemy") != 0:
		await get_tree().create_timer(0.2).timeout
	for i in range(lvl*5):
		add_child(Enemy.new_enemy(rand_let.pick_random(),loc1,loc2))
		await get_tree().create_timer(1).timeout
	print(rand_let)
