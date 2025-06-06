extends CharacterBody2D
class_name Player

const player_scene = preload("res://Game/Player/player.tscn")
const MAX_SPEED : int = 100

static func new_player():
	return player_scene.instantiate()

func try_to_catch_letter() -> String:
	return ""

func _process(delta: float) -> void:
	var move_direction : Vector2 = Vector2(0,0)
	if Input.is_action_pressed("move_up"):
		move_direction += Vector2.UP
	if Input.is_action_pressed("move_down"):
		move_direction += Vector2.DOWN
	if Input.is_action_pressed("move_left"):
		move_direction += Vector2.LEFT
	if Input.is_action_pressed("move_right"):
		move_direction += Vector2.RIGHT
	position += move_direction * MAX_SPEED * delta
	
	if Input.is_action_just_pressed("catch_letter"):
		var letter = try_to_catch_letter()
		if letter:
			get_node("root/Game/Word").get_letter(letter)
