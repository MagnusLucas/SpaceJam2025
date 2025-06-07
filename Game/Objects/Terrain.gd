extends Area2D
class_name Terrain

@export var image_atlas_coords = Vector2i(-1, -1)
@export var object_names : Array[String]

const collision_scene = preload("res://Game/Objects/terrain.tscn")

var used_name : String
var affected_letters : Dictionary

@warning_ignore("shadowed_variable")
static func new_terrain(used_name : String) -> Terrain:
	var terrain = collision_scene.instantiate()
	for letter in used_name:
		terrain.affected_letters[letter] = true
	terrain.used_name = used_name
	return terrain
