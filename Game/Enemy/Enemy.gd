extends Area2D
class_name Enemy

const enemy_scene = preload("res://Game/Enemy/enemy.tscn")

var letter : String

static func new_enemy(letter : String) -> Enemy:
	var enemy = enemy_scene.instantiate()
	enemy.letter = letter
	return enemy
