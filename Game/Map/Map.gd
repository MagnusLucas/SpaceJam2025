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
	$"../../TextureProgressBar".value = 100
	wave0()
	while get_tree().get_node_count_in_group("Enemy") != 0:
		await get_tree().create_timer(0.2).timeout
	wave1()
	print(health)
	

func add_terrain(terrain_name : String, info : Dictionary) -> void:
	var terrain_position = local_to_map(player.position)
	if terrain_name == "base":
		terrain_position = local_to_map(position)
	var terrain = Terrain.new_terrain(terrain_name, Terrain.EffectType[info["type"]])
	terrains[terrain_position] = terrain
	add_child(terrain)
	terrain.position = map_to_local(terrain_position)
	set_cell(terrain_position, 0, Vector2i(int(info["atlas_coords"]["x"]), int(info["atlas_coords"]["y"])))

func update_health():
	print(health)
	if health <= 0:
		lose()
	@warning_ignore("integer_division")
	$"../../TextureProgressBar".value = health / max_health * 100

func _process(_delta):
	if Input.is_key_label_pressed(KEY_L):
		lose()
func lose():
	get_tree().paused = true
	$Player/Node2D/TextureProgressBar.hide()
	$"../../LoseOverlay".show()
	pass


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
		add_child(Enemy.new_enemy(let,loc1,loc2))
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

#----------------
#ACTUALLY WAVE
#----------------
#wave0 to bedzie turorial
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
	#for i in range(20):
		#add_child(Enemy.new_enemy(rand_let.pick_random(),Vector2i(-400,-320),Vector2i(400,-310),50))
		#await get_tree().create_timer(1).timeout
	

func wave2():
	var rand_word = 'placeholder' #tu kiedyß bedzie czytac z listy slow destruktywnych
	var rand_let = string_to_array(rand_word)
	first_drop(rand_let,Vector2i(50,-20),Vector2i(1100,-10),2)
	for i in range(4):
		add_child(Enemy.new_enemy(rand_let.pick_random(),Vector2i(50,-20),Vector2i(1100,-10)))
		await get_tree().create_timer(1).timeout

func wave6():
	var rand_let : Array
	for i in range(2):
		var rand_word = 'placeholder' #tu kiedyß bedzie czytac z listy slow destruktywnych
		rand_let = rand_let + string_to_array(rand_word)
	first_drop(rand_let,Vector2i(50,-20),Vector2i(1100,-10),2)
	for i in range(4):
		add_child(Enemy.new_enemy(rand_let.pick_random(),Vector2i(50,-20),Vector2i(1100,-10)))
		await get_tree().create_timer(1).timeout
		
func wave11():
	var rand_let : Array
	for i in range(3):
		var rand_word = 'placeholder' #tu kiedyß bedzie czytac z listy slow destruktywnych
		rand_let = rand_let + string_to_array(rand_word)
	while len(rand_let) < 10:
		var rand_word = 'placeholder' #tu kiedyß bedzie czytac z listy slow destruktywnych
		rand_let = rand_let + string_to_array(rand_word)
	first_drop(rand_let,Vector2i(50,-20),Vector2i(1100,-10),2)
	#for i in range(4):
		#add_child(Enemy.new_enemy(rand_let.pick_random(),Vector2i(50,-20),Vector2i(1100,-10)))
		#await get_tree().create_timer(1).timeout
		
func expo_wave(lvl : int, loc1 : Vector2i, loc2 : Vector2i):
	var rand_let : Array
	for i in range(lvl):
		var rand_word = 'placeholder' #tu kiedyß bedzie czytac z listy slow destruktywnych
		rand_let = rand_let + string_to_array(rand_word)
	while len(rand_let) < lvl*5:
		var rand_word = 'placeholder' #tu kiedyß bedzie czytac z listy slow destruktywnych
		rand_let = rand_let + string_to_array(rand_word)
	first_drop(rand_let,loc1,loc2,2)
	for i in range(lvl*5):
		add_child(Enemy.new_enemy(rand_let.pick_random(),loc1,loc2))
		await get_tree().create_timer(1).timeout
