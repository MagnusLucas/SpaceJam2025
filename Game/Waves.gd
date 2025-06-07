extends Node
#funkcje pomagajæce robi¢ fale
@warning_ignore("shadowed_global_identifier")
func string_to_array(str):
	var tab : Array
	for i in str:
		tab.append(i)
	return tab

#funkcja na pierwszy drop wavea, po to zeby nie bylo 5 razy b na start XD	
func first_drop(rand_let, loc1 : Vector2i, loc2 : Vector2i, time : int = 1 ):
	for i in range(len(rand_let)):
		var let = rand_let.pick_random()
		add_child(Enemy.new_enemy(let,loc1,loc2))
		rand_let.erase(let)
		await get_tree().create_timer(time).timeout

func duplicates_check(string):
	var p = ""
	@warning_ignore("shadowed_global_identifier")
	for char in string:
		if char not in p:
			p = p+char
	return p

#----------------
#ACTUALLY WAVE
#----------------
#wave0 to bedzie turorial
func wave0():
	add_child(Enemy.new_enemy('b',Vector2i(250,250),Vector2i(250,250),10,false))
	print(get_tree().get_node_count_in_group("Enemy") == 4)
	await get_tree().get_node_count_in_group("Enemy") == 4
	add_child(Enemy.new_enemy('a',Vector2i(50,-20),Vector2i(1100,-10)))
	await get_tree().get_node_count_in_group("Enemy") == 0
	add_child(Enemy.new_enemy('s',Vector2i(50,-20),Vector2i(1100,-10)))
	await get_tree().get_node_count_in_group("Enemy") == 0
	add_child(Enemy.new_enemy('e',Vector2i(50,-20),Vector2i(1100,-10)))
	
	pass
func wave1():
	
	var rand_let = ['b','a','s','e']
	first_drop(rand_let,Vector2i(50,-20),Vector2i(1100,-10),2)
	for i in range(4):
		add_child(Enemy.new_enemy(rand_let.pick_random(),Vector2i(50,-20),Vector2i(1100,-10)))
		await get_tree().create_timer(1).timeout

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
