extends CharacterBody2D
class_name Player

const player_scene = preload("res://Game/Player/player.tscn")
const MAX_SPEED : int = 100

var terrain : Terrain
var previous_position : Vector2i

static func new_player():
	return player_scene.instantiate()

func get_closest_enemy(enemies : Array[Node2D]) -> Enemy:
	var closest_distance = INF
	var closest_enemy = enemies[0]
	for enemy in enemies:
		if enemy.position.distance_squared_to(position) < closest_distance:
			closest_enemy = enemy
			closest_distance = enemy.position.distance_squared_to(position)
	return closest_enemy

func try_to_catch_letter() -> String:
	if $Node2D/Timer.is_stopped():
		var letters_near_me : Array[Node2D] = $Area2D.get_overlapping_bodies()
		for letter in letters_near_me:
			if letter is not Enemy:
				letters_near_me.erase(letter)
		if letters_near_me.is_empty():
			return ""
		var enemy = get_closest_enemy(letters_near_me)
		var letter = enemy.letter
		enemy.queue_free()
		$Node2D/Timer.start()
		return letter
	return ""

func _process(delta: float) -> void:
	var map : Map = get_parent()
	var move_direction : Vector2 = Vector2(0,0)
	if Input.is_action_pressed("move_up"):
		move_direction += Vector2.UP
		$Sprite2D/AnimatedSprite2D.play("up_run")
	if Input.is_action_pressed("move_down"):
		move_direction += Vector2.DOWN
		$Sprite2D/AnimatedSprite2D.play("down_run")
	if Input.is_action_pressed("move_left"):
		move_direction += Vector2.LEFT
		$Sprite2D/AnimatedSprite2D.play("left_run")
	if Input.is_action_pressed("move_right"):
		move_direction += Vector2.RIGHT
		$Sprite2D/AnimatedSprite2D.play("right_run")
	if move_direction:
		rotation = move_direction.angle() - Vector2.UP.angle()
	previous_position = map.local_to_map(position)
	position += move_direction * MAX_SPEED * delta
	
	if previous_position != map.local_to_map(position) and terrain:
		map.update_terrain(previous_position, map.local_to_map(position), terrain)
	
	if Input.is_action_just_pressed("catch_letter"):
		var letter = try_to_catch_letter()
		if letter:
			get_node("/root/Game/Word").add_letter(letter)
	
	if Input.is_action_just_pressed("clear_word"):
		if map.is_close_to_base(position):
			get_node("/root/Game/Word").clear()
	
	if Input.is_action_just_pressed("pick_terrain"):
		if !terrain and map.terrains.has(map.local_to_map(position)):
			if map.terrains[map.local_to_map(position)].movable:
				terrain = map.terrains[map.local_to_map(position)]
				terrain.process_mode = Node.PROCESS_MODE_DISABLED
		elif terrain:
			map.update_terrain(previous_position, map.local_to_map(position), terrain)
			terrain.process_mode = Node.PROCESS_MODE_INHERIT
			terrain = null
	
	$Node2D/TextureProgressBar.value = $Node2D/Timer.time_left/$Node2D/Timer.wait_time*100
	$Node2D/TextureProgressBar.global_position = global_position + Vector2(40, -20)
	
