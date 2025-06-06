extends CharacterBody2D
class_name Enemy

const enemy_scene = preload("res://Game/Enemy/enemy.tscn")
var letter : String
var loc1 : Vector2i
var loc2 : Vector2i
var start_pos : Vector2i
var destination : Vector2
var speed : int = 10
#direction to destination, basically the angle to the base
var dir_to_des : Vector2
func _ready() -> void:
	$Label.text = letter
	position = start_pos
	destination = $Marker2D.position


@warning_ignore("shadowed_variable")
static func new_enemy(letter : String, loc1 : Vector2i, loc2 : Vector2i) -> Enemy:
	var enemy = enemy_scene.instantiate()
	enemy.letter = letter
	enemy.start_pos = Vector2i( randi_range(loc1[0],loc2[0]), randi_range(loc1[1],loc2[1]))
	return enemy


func _physics_process(_delta) -> void:
	dir_to_des = Vector2((destination - position).normalized())
	velocity = dir_to_des * speed
	move_and_slide()
	if Input.is_key_label_pressed(KEY_D):
		death()
	
func death():
	$"../../../Word".add_letter(letter)
	#miejsce na dodanie liter
	queue_free()
